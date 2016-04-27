package scenes;

import kha.Color;
import kha.Image;
import kha.math.Vector2;
import micro.Micro;
import micro.Region;

class FourPaths extends Scene
{
	var brush:Region;
	var position:Vector2;
	var center:Vector2;
	var dir:Int;
	
	public function new() 
	{
		super();
		
		var image = Image.createRenderTarget(1, 1);
		image.g2.begin(true, Color.White);
		image.g2.end();
		
		brush = new Region(image, 0, 0, 1, 1);
		
		center = new Vector2(Micro.gameWidth / 2, Micro.gameHeight / 2);
		position = new Vector2();
		dir = newDir();
	}
	
	function newDir():Int
	{
		return Std.int(Math.random() * 8);
	}
	
	override public function update() 
	{
		if (Math.random() > 0.8)
			dir = newDir();
		
		switch(dir)
		{
			case 0: position.y--;
			case 1: position.y--; position.x++;
			case 2: position.x++;
			case 3: position.x++; position.y++;
			case 4: position.y++;
			case 5: position.x--; position.y++;
			case 6: position.x--;
			case 7: position.x--; position.y--;
		}	
	}
	
	override public function draw() 
	{
		brush.draw(center.x + position.x, center.y + position.y);
		brush.draw(center.x - position.x, center.y + position.y);
		brush.draw(center.x + position.x, center.y - position.y);
		brush.draw(center.x - position.x, center.y - position.y);
	}
}