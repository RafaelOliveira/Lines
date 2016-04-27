package;

import kha.System;
import micro.Engine;
import micro.Micro.*;

#if sys_windows
import kha.Display;
import kha.WindowOptions.Mode;
#end

#if sys_html5
import kha.math.Vector2i;
import js.Browser;
import js.html.CanvasElement;
#end

class Main 
{
	public static function main() 
	{
		var desktopWidth:Int;
		var desktopHeight:Int;
		
		#if (sys_windows || sys_linux || sys_osx)
		desktopWidth = Display.width(0);
		desktopHeight = Display.height(0);
		#elseif sys_html5
		var size = setupCanvas();
		desktopWidth = size.x;
		desktopHeight = size.y;
		#else
		desktopWidth = System.windowWidth();
		desktopHeight = System.windowHeight();
		#end
		
		#if (sys_windows || sys_linux || sys_osx)
		System.initEx('Lines', [{ width: desktopWidth, height: desktopHeight, mode: Mode.BorderlessWindow }], windowCallback, function() 		
		{
			var game = new Game();
			var engine = new Engine(game.init, game.update, game.draw, int(desktopWidth / 4), int(desktopHeight / 4), 30);
		});
		#else
		System.init({ title: 'Lines', width: desktopWidth, height: desktopHeight }, function()
		{
			var game = new Game();
			var engine = new Engine(game.init, game.update, game.draw, int(desktopWidth / 4), int(desktopHeight / 4), 30);
		});
		#end
	}
	
	static function windowCallback(id:Int):Void {}
	
	#if sys_html5
	static function setupCanvas():Vector2i
	{
		var body = Browser.document.body;
		body.style.margin = '0';
		body.style.padding = '0';
		body.style.height = '100%';
		body.style.overflow = 'hidden';
		
		var canvas:CanvasElement = cast Browser.document.getElementById('khanvas');
		var w:Int = Browser.window.innerWidth;
		var h:Int = Browser.window.innerHeight;
		
		canvas.style.width = '${w}px';
		canvas.style.height = '${h}px';
		canvas.width = w;
		canvas.height = h;
		
		return new Vector2i(w, h);
	}
	#end
}