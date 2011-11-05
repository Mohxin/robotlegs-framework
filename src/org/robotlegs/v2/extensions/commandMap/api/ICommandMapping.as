//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.api
{

	public interface ICommandMapping
	{
		function get commandClass():Class;
		
		function unmap():ICommandUnmapper;
		
		// function get guards();
		// function get hooks();
	}
}
