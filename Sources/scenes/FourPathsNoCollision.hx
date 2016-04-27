package scenes;

import kha.Color;
import kha.Image;
import kha.math.Vector2;
import kha.math.Vector2i;
import micro.Micro;
import micro.Region;

typedef Point2 = {
	x:Int,
	y:Int,
	dir:Int,
	lastDir:Int
}

class FourPathsNoCollision extends Scene
{
	var grid:Array<Array<Bool>>;
	var brush:Region;
	var points:Array<Point2>;
	var tries:Int;
	var triesJump:Int;
	var finished:Array<Bool>;
	var allFinished:Bool;
	var checkAllFinished:Bool;
	var lastCells:Array<Vector2i>;
	
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
		
		points = new Array<Point2>();
		finished = new Array<Bool>();
		for (i in 0...4)
		{
			var dir = Std.int(Math.random() * 8);
			points.push({ x: Std.int(Math.random() * Micro.gameWidth), y: Std.int(Math.random() * Micro.gameHeight), 
						  dir: dir, lastDir: dir });
			finished.push(false);
		}
		
		tries = 0;
		allFinished = false;
	}
	
	function newDir(id:Int = -1):Void
	{
		if (id == -1)
		{
			for (point in points)
			{
				do 
				{
					point.lastDir = point.dir;
					point.dir = Std.int(Math.random() * 8);	
				} 
				while (point.dir == point.lastDir);
			}
		}
		else
		{
			do 
			{
				points[id].lastDir = points[id].dir;
				points[id].dir = Std.int(Math.random() * 8);
			}
			while (points[id].dir == points[id].lastDir);
		}
	}
	
	function checkDir(id:Int):Void
	{
		var dirOk:Bool;
		tries = 0;
		triesJump = 0;
		
		do
		{
			dirOk = true;
			
			switch(points[id].dir)
			{
				case 0:
					if ((points[id].y - 1) < 0 || (points[id].y - 1) > (Micro.gameHeight - 1) ||
					    points[id].x < 0 || points[id].x > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y - 1][points[id].x])
						dirOk = false;
				case 1:
					if ((points[id].y - 1) < 0 || (points[id].y - 1) > (Micro.gameHeight - 1) ||
					    (points[id].x + 1) < 0 || (points[id].x + 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y - 1][points[id].x + 1])
						dirOk = false;
					else if (grid[points[id].y - 1][points[id].x] || grid[points[id].y][points[id].x + 1])
						dirOk = false;
				case 2:
					if (points[id].y < 0 || points[id].y > (Micro.gameHeight - 1) ||
					    (points[id].x + 1) < 0 || (points[id].x + 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y][points[id].x + 1])
						dirOk = false;
				case 3:
					if ((points[id].y + 1) < 0 || (points[id].y + 1) > (Micro.gameHeight - 1) ||
					    (points[id].x + 1) < 0 || (points[id].x + 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y + 1][points[id].x + 1])
						dirOk = false;
					else if (grid[points[id].y][points[id].x + 1] || grid[points[id].y + 1][points[id].x])
						dirOk = false;
				case 4:
					if ((points[id].y + 1) < 0 || (points[id].y + 1) > (Micro.gameHeight - 1) ||
					    points[id].x < 0 || points[id].x > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y + 1][points[id].x])
						dirOk = false;
				case 5:
					if ((points[id].y + 1) < 0 || (points[id].y + 1) > (Micro.gameHeight - 1) ||
					    (points[id].x - 1) < 0 || (points[id].x - 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y + 1][points[id].x - 1])
						dirOk = false;
					else if (grid[points[id].y][points[id].x - 1] || grid[points[id].y + 1][points[id].x])
						dirOk = false;
				case 6:
					if (points[id].y < 0 || points[id].y > (Micro.gameHeight - 1) ||
					    (points[id].x - 1) < 0 || (points[id].x - 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y][points[id].x - 1])
						dirOk = false;
				case 7:
					if ((points[id].y - 1) < 0 || (points[id].y - 1) > (Micro.gameHeight - 1) ||
					    (points[id].x - 1) < 0 || (points[id].x - 1) > (Micro.gameWidth - 1))
						dirOk = false;
					else if (grid[points[id].y - 1][points[id].x - 1])
						dirOk = false;
					else if (grid[points[id].y][points[id].x - 1] || grid[points[id].y - 1][points[id].x])
						dirOk = false;
			}
			
			//trace('$id $dirOk');
			tries++;
			
			if (tries > 20)
			{
				tries = 0;
				triesJump++;
				
				points[id].x = Std.int(Math.random() * Micro.gameWidth);
				points[id].y = Std.int(Math.random() * Micro.gameHeight);	
			}
			
			if (triesJump > 20)
			{
				if (lastCells == null)
				{
					lastCells = new Array<Vector2i>();
					for (r in 0...grid.length)
					{
						for (c in 0...grid[r].length)
						{
							if (!grid[r][c])
								lastCells.push(new Vector2i(c, r));
						}
					}	
				}
				
				if (lastCells.length > 0)
				{
					var cell = Std.int(Math.random() * lastCells.length);
					points[id].x = lastCells[cell].x;
					points[id].y = lastCells[cell].y;
					lastCells.splice(cell, 1);
					dirOk = true;
				}
				else
				{
					finished[id] = true;
					dirOk = true;
					trace('$id finished');
				}
			}
			
			if (!dirOk)
				newDir(id);
			
		} while (!dirOk);
	}
	
	override public function update() 
	{
		if (allFinished)
			return;
			
		if (Math.random() > 0.8)
			newDir();
			
		for (i in 0...points.length)
		{
			if (!finished[i])
				checkDir(i);
		}
		
		checkAllFinished = true;	
			
		for (i in 0...points.length)
		{
			if (!finished[i])
			{
				switch(points[i].dir)
				{
					case 0:
						if (points[i].y > 0)
							points[i].y--;
					case 1:
						if (points[i].x < (Micro.gameWidth - 2) && points[i].y > 0)
						{
							points[i].x++;
							points[i].y--; 
						}
					case 2:
						if (points[i].x < (Micro.gameWidth - 2))
							points[i].x++;
					case 3:
						if (points[i].x < (Micro.gameWidth - 2) && points[i].y < (Micro.gameHeight - 2))
						{
							points[i].x++;
							points[i].y++;
						}
					case 4:
						if (points[i].y < (Micro.gameHeight - 2))
							points[i].y++;
					case 5:
						if (points[i].x > 0 && points[i].y < (Micro.gameHeight - 2))
						{
							points[i].x--; 
							points[i].y++;
						}
					case 6:
						if (points[i].x > 0)
							points[i].x--;
					case 7:
						if (points[i].x > 0 && points[i].y > 0)
						{
							points[i].x--;
							points[i].y--;
						}
				}
				
				grid[points[i].y][points[i].x] = true;
				
				if (lastCells != null)
				{
					for (j in 0...lastCells.length)
					{
						if (lastCells[j].x == points[i].x && lastCells[j].y == points[i].y)
						{
							lastCells.splice(j, 1);
							break;
						}
					}
				}
				
				checkAllFinished = false;
			}
		}
		
		if (checkAllFinished)
			allFinished = true;
	}
	
	override public function draw() 
	{
		if (!allFinished)
		{
			brush.draw(points[0].x, points[0].y, false, false, Color.Green);
			brush.draw(points[1].x, points[1].y, false, false, Color.Red);
			brush.draw(points[2].x, points[2].y, false, false, Color.Blue);
			brush.draw(points[3].x, points[3].y, false, false, Color.Yellow);
		}		
	}
}