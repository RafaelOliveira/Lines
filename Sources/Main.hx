package;

import kha.System;
import micro.Engine;
import micro.Micro.*;

#if sys_windows
import kha.Display;
import kha.WindowOptions.Mode;
#end

class Main 
{
	public static function main() 
	{
		#if sys_windows
		var desktopWidth = Display.width(0);
		var desktopHeight = Display.height(0);
		
		System.initEx('Lines', [{ width: desktopWidth, height: desktopHeight, mode: Mode.BorderlessWindow }], windowCallback, function() 		
		{
			var game = new Game();
			var engine = new Engine(game.init, game.update, game.draw, int(desktopWidth / 4), int(desktopHeight / 4), 30);
		});
		#else
		System.init({ title: 'Lines', width: 800, height: 600 }, function()
		{
			var game = new Game();
			var engine = new Engine(game.init, game.update, game.draw, int(800 / 4), int(600 / 4), 30);
		});
		#end
	}
	
	static function windowCallback(id:Int) {}
}