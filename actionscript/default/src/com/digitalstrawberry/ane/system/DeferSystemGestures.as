/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2018 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.digitalstrawberry.ane.system
{

	public class DeferSystemGestures implements IDeferSystemGestures
	{

		// Singleton stuff
		private static var _canInitialize:Boolean;
		private static var _instance:IDeferSystemGestures;


		/**
		 * @private
		 */
		public function DeferSystemGestures()
		{
			if(!_canInitialize)
			{
				throw new Error("DeferSystemGestures is a singleton, use instance getter.");
			}
		}


		public static function get instance():IDeferSystemGestures
		{
			if(!_instance)
			{
				_canInitialize = true;
				_instance = new DeferSystemGestures();
				_canInitialize = false;
			}
			return _instance;
		}


		public static function get VERSION():String
		{
			return DEFER_SYSTEM_GESTURES_VERSION;
		}


		public function setScreenEdges(edges:int):void
		{
		}


		public function dispose():void
		{
		}


		public function get isSupported():Boolean
		{
			return false;
		}
	}
}
