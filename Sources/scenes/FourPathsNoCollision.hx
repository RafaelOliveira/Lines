package scenes;

import kha.Color;
import kha.Image;
import kha.math.Vector2;
import kha.math.Vector2i;
import micro.Micro;
import micro.Region;

// this is still crossing lines in some circumstances

class FourPathsNoCollision extends Scene
{
	var grid:Array<Array<Bool>>;
	var brush:Region;
	var position:Vector2;
	var newPosition:Vector2i;
	var tempPos:Vector2i;
	var tries:Int;
	var finished:Bool;
	var center:Vector2;
	var dir:Int;
	
	public function new() 
	{
		super();
		
		grid = new Array<Array<Bool>>();
		for (r in 0...Micro.gameHeight)
		{
			grid.push(new Array<Bool>());
			for (c in 0...Micro.gameWidth)
				grid[r].push(false);
		}
		
		var image = Image.createRenderTarget(1, 1);
		image.g2.begin(true, Color.White);
		image.g2.end();
		
		brush = new Region(image, 0, 0, 1, 1);
		
		center = new Vector2(Micro.gameWidth / 2, Micro.gameHeight / 2);
		position = new Vector2();
		newPosition = new Vector2i();
		tempPos = new Vector2i();
		tries = 0;
		finished = false;
		dir = newDir();
	}
	
	function newDir():Int
	{
		return Std.int(Math.random() * 8);
	}
	
	override public function update() 
	{
		if (finished)
			return;
		
		if (Math.random() > 0.8)
			dir = newDir();
		
		tries = 0;	
			
		getNewPosition();
		
		while (tries < 20 && !checkNewPosition())
		{
			dir = newDir();
			getNewPosition();
			tries++;
			
			if (tries >= 20)
			{
				finished = true;
				return;
			}
		}
		
		position.x += newPosition.x;
		position.y += newPosition.y;
		
		grid[Std.int(center.y + position.y)][Std.int(center.x + position.x)] = true;
		grid[Std.int(center.y + position.y)][Std.int(center.x - position.x)] = true;
		grid[Std.int(center.y - position.y)][Std.int(center.x + position.x)] = true;
		grid[Std.int(center.y - position.y)][Std.int(center.x - position.x)] = true;
	}
	
	function getNewPosition():Void
	{
		newPosition.x = 0;
		newPosition.y = 0;
		
		switch(dir)
		{
			case 0: newPosition.y--;
			case 1: newPosition.x++; newPosition.y--; 
			case 2: newPosition.x++;
			case 3: newPosition.x++; newPosition.y++;
			case 4: newPosition.y++;
			case 5: newPosition.x--; newPosition.y++;
			case 6: newPosition.x--;
			case 7: newPosition.x--; newPosition.y--;
		}
	}
	
	function checkNewPosition():Bool
	{
		tempPos.x = Std.int(center.x + position.x + newPosition.x);
		tempPos.y = Std.int(center.y + position.y + newPosition.y); 
		
		if (tempPos.x < 0 || tempPos.x > (grid[0].length - 1) || tempPos.y < 0 || tempPos.y > (grid.length - 1))
			return false;
			
		switch(dir)
		{
			case 0:
				if ((tempPos.y - 1) > -1 && (tempPos.y - 1) < (grid.length - 1) && tempPos.x > -1 && tempPos.x < (grid[0].length - 1))
				{
					if (grid[tempPos.y - 1][tempPos.x])
						return false;
				}
			case 1:
				if ((tempPos.y - 1) > -1 && (tempPos.y - 1) < (grid.length - 1) && (tempPos.x + 1) > -1 && (tempPos.x + 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y - 1][tempPos.x + 1])
						return false;
				}
			case 2:
				if (tempPos.y < -1 && tempPos.y < (grid.length - 1) && (tempPos.x + 1) < -1 && (tempPos.x + 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y][tempPos.x + 1])
						return false;
				}
			case 3:
				if ((tempPos.y + 1) < -1 && (tempPos.y + 1) < (grid.length - 1) && (tempPos.x + 1) < -1 && (tempPos.x + 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y + 1][tempPos.x + 1])
						return false;
				}
			case 4:
				if ((tempPos.y + 1) < -1 && (tempPos.y + 1) < (grid.length - 1) && tempPos.x < -1 && tempPos.x < (grid[0].length - 1))
				{
					if (grid[tempPos.y + 1][tempPos.x])
						return false;
				}
			case 5:
				if ((tempPos.y + 1) < -1 && (tempPos.y + 1) < (grid.length - 1) && (tempPos.x - 1) < -1 && (tempPos.x - 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y + 1][tempPos.x - 1])
						return false;
				}
			case 6:
				if (tempPos.y < -1 && tempPos.y < (grid.length - 1) && (tempPos.x - 1) < -1 && (tempPos.x - 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y][tempPos.x - 1])
						return false;
				}
			case 7:
				if ((tempPos.y - 1) < -1 && (tempPos.y - 1) < (grid.length - 1) && (tempPos.x - 1) < -1 && (tempPos.x - 1) < (grid[0].length - 1))
				{
					if (grid[tempPos.y - 1][tempPos.x - 1])
						return false;
				}
		}
		
		return true;
	}
	
	override public function draw() 
	{
		if (!finished)
		{
			brush.draw(center.x + position.x, center.y + position.y);
			brush.draw(center.x - position.x, center.y + position.y);
			brush.draw(center.x + position.x, center.y - position.y);
			brush.draw(center.x - position.x, center.y - position.y);
		}		
	}
}