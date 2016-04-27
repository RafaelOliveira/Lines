package;

import kha.Color;
import kha.Key;
import kha.math.Vector2i;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.Scheduler;
import kha.System;
import micro.Draw;
import micro.Draw.*;
import micro.SColor.*;
import micro.Micro.*;
import scenes.*;

class Game
{	
	var scene:Scene;	
	
	public function new() 
	{	
		
	}
	
	public function init()
	{		
		loadPal(0);
		
		chooseScene();
		
		#if sys_windows
		var k = Keyboard.get();
		k.notify(keyDown, null);
		
		var m = Mouse.get();
		m.notify(mouseDown, null, mouseMove, null);
		#end
	}
	
	function chooseScene()
	{
		switch(rndi(3))
		{
			case 0: scene = new FourPoints();
			case 1: scene = new Triangles();
			case 2: scene = new FourPaths();
		}		
	}
	
	public function update() 
	{	
		scene.update();
	}
	
	function keyDown(key:Key, char:String):Void
	{
		System.requestShutdown();
	}
	
	function mouseDown(button:Int, x:Int, y:Int):Void
	{
		System.requestShutdown();
	}
	
	function mouseMove(x:Int, y:Int, movementX:Int, movementY:Int):Void
	{
		System.requestShutdown();
	}

	public function draw()
	{
		scene.draw();
	}
}