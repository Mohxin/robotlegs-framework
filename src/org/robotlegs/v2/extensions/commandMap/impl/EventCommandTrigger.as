//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.swiftsuspenders.Injector;

	public class EventCommandTrigger implements ICommandTrigger
	{
		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _oneshot:Boolean;

		private var _mapping:ICommandMapping;

		private var _listening:Boolean;

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class,
			oneshot:Boolean)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_oneshot = oneshot;
		}

		public function register(mapping:ICommandMapping):void
		{
			_mapping = mapping;
			verifyCommandClass();
			addListener();
		}

		public function unregister():void
		{
			removeListener();
		}

		private function verifyCommandClass():void
		{
			if (describeType(_mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addListener():void
		{
			_listening = true;
			_dispatcher.addEventListener(_type, handleEvent);
		}

		private function removeListener():void
		{
			_listening = false;
			_dispatcher.removeEventListener(_type, handleEvent);
		}

		private function handleEvent(event:Event):void
		{
			if (_eventClass != Event && _eventClass != event["constructor"])
				return;

			_injector.map(_eventClass).toValue(event);
			_injector.getInstance(_mapping.commandClass).execute();
			_injector.unmap(_eventClass);

			// question: should we unmap().fromAll()?
			if (_oneshot)
				_mapping.unmap().fromTrigger(this);
		}
	}
}
