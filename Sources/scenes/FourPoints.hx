package scenes;

import micro.Draw.*;
import micro.Micro.*;

typedef Point = {
	x:Int,
	y:Int,
	dirX:Int,
	dirY:Int,
}
	
class FourPoints extends Scene
{
	inline static var max_points:Int = 4;
	
	var t = 0;
		
	var points:Array<Point>;
	var points2:Array<Point>;
	var points3:Array<Point>;
	
	var scrW = 0;
	var scrH = 0;

	public function new() 
	{
		super();
		
		scrW = gameWidth - 1;
		scrH = gameHeight - 1;		
		
		points = new Array<Point>();
		points2 = new Array<Point>();
		points3 = new Array<Point>();
		
		for (i in 0...(max_points))
		{
			points.push({ x: int(rnd(scrW)), y: int(rnd(scrH)), dirX: getRandomDir(), dirY: getRandomDir() });
			points2.push({ x: points[i].x, y: points[i].y, dirX: points[i].dirX, dirY: points[i].dirY });
			
			if (points2[i].dirX == -1)
				points2[i].x += 4;
			else
				points2[i].x -= 4;
				
			if (points2[i].dirY == -1)
				points2[i].y += 4;
			else
				points2[i].y -= 4;
				
			points3.push({ x: points2[i].x, y: points2[i].y, dirX: points2[i].dirX, dirY: points2[i].dirY });
			
			if (points3[i].dirX == -1)
				points3[i].x += 4;
			else
				points3[i].x -= 4;
				
			if (points3[i].dirY == -1)
				points3[i].y += 4;
			else
				points3[i].y -= 4;
		}
	}
	
	function getRandomDir()
	{
		var dir = int(rnd(2));
		
		if (dir == 0)
			return -1;
		else
			return 1;
	}	
	
	override public function update() 
	{	
		t += 1;
		
		updatePoints(points);
		updatePoints(points2);
		updatePoints(points3);
	}
	
	function updatePoints(points:Array<Point>)
	{
		for (p in points)
		{			
			if (p.dirX == -1)
				p.x -= 2;
			else
				p.x += 2;
				
			if (p.dirY == -1)
				p.y -= 2;
			else
				p.y += 2;
				
			if (p.x < 0)
			{
				p.x = 0;
				p.dirX = 1;
			}
			else if (p.x > scrW)
			{
				p.x = scrW;
				p.dirX = -1;
			}
			
			if (p.y < 0)
			{
				p.y = 0;
				p.dirY = 1;
			}
			else if (p.y > scrH)
			{
				p.y = scrH;
				p.dirY = -1;
			}
		}
	}
	
	override public function draw()
	{
		cls();
		
		var j = 0;
		
		for (i in 0...(max_points))
		{
			if (i < (max_points - 1))
				j = i + 1;
			else
				j = 0;
			
			if (i % 2 == 0)
			{
				line(points[i].x, points[i].y, points[j].x, points[j].y, 0xff1e90ff);
				line(points2[i].x, points2[i].y, points2[j].x, points2[j].y, 0xff125191);
				line(points3[i].x, points3[i].y, points3[j].x, points3[j].y, 0xff092847);
			}
			else
			{
				line(points[i].x, points[i].y, points[j].x, points[j].y, 0xffff4500);
				line(points2[i].x, points2[i].y, points2[j].x, points2[j].y, 0xff912700);
				line(points3[i].x, points3[i].y, points3[j].x, points3[j].y, 0xff471300);
			}
		}
	}
}