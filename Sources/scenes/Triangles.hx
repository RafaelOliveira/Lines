package scenes;

import micro.Draw.*;
import micro.Micro.*;

class Triangles extends Scene
{
	var angle = 0.0;
	var lenght = 80;
	var angle_stepsize = 0.6;
	var c = [0xff004455, 0xff0088aa, 0xff00ccff];
	
	public function new() 
	{
		super();
	}
	
	override public function draw()
	{		
		cls();
		
		camera.x = -halfGameWidth + sin(angle) * 120;
			
		var xangle = angle;		
		
		for (i in 0...3)
		{
			xangle -= (i * 0.05);
			
			line(lenght * cos(xangle), lenght * sin(xangle) + halfGameHeight, lenght * cos(xangle + 2), lenght * sin(xangle + 2) + halfGameHeight, c[i]);
			line(lenght * cos(xangle + 2), lenght * sin(xangle + 2) + halfGameHeight, lenght * cos(xangle + 4), lenght * sin(xangle + 4) + halfGameHeight, c[i]);
			line(lenght * cos(xangle + 4), lenght * sin(xangle + 4) + halfGameHeight, lenght * cos(xangle), lenght * sin(xangle) + halfGameHeight, c[i]);			
		}
		
		angle += angle_stepsize * elapsed;
		
		if (angle > (2 * PI))
			angle -= (2 * PI);
			
		camera.reset();
	}
	
}