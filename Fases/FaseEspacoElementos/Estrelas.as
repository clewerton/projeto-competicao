package Fases.FaseEspacoElementos 
{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;

	public class Estrelas extends MovieClip
	{
 
		private var stageRef:Stage;
		private var speed:Number;
 
		public function  Estrelas(stageRef:Stage)
		{
			this.stageRef = stageRef;
			setupStar(true);
 
			//addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
		}
 
		public function setupStar(randomizeX:Boolean = false) : void
		{
			//inline conditional, looks complicated but it's not.
			x = randomizeX ? Math.random()*stageRef.stageWidth : stageRef.stageWidth;
			y = Math.random()*stageRef.stageHeight;
			alpha = Math.random();
			rotation = Math.random()*360;
			scaleX = Math.random();
			scaleY = Math.random();
 
			speed = 2 + Math.random()*2;
		}
 
		//public function loop(e:Event) : void
		public function update() : void
		{
			x -= speed;
 
			if (x < 0)
				setupStar();
 
		}
 
	}
}

