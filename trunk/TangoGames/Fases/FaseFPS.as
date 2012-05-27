package TangoGames.Fases 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	public class FaseFPS extends FaseHUD implements FaseHUDInterface 
	{
		private var TM_timer:Timer;
		private var TF_fps:TextField;
		private var TF_mem:TextField;
		private var UI_contaframe:uint;
		
		public function FaseFPS(cor:uint = 0XFFFF00) 
		{			
			TF_fps = new TextField();
			TF_fps.width=100;
			TF_fps.height = 20;
			TF_fps.defaultTextFormat = new TextFormat("_sans", 12, cor, true);
			addChild(TF_fps);
			
			TF_mem = new TextField();
			TF_mem.width=100;
			TF_mem.height = 20;
			TF_mem.defaultTextFormat = new TextFormat("_sans", 12, cor, true);
			addChild(TF_mem);
			TF_mem.y = 20;
			
			UI_contaframe = 0;
			
			TF_fps.text = " -- fps"
			TF_mem.text = " ---- Mb"
			
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			TF_mem.text = Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + "Mb";
			TF_fps.text = uint(UI_contaframe * 2).toString() + " FPS";
			UI_contaframe = 0;
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			TM_timer = new Timer(500);
			TM_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			TM_timer.start();
		}
		
		public function reinicializa():void 
		{
			
		}
		
		public function update(e:Event):void 
		{
			UI_contaframe++;
		}
		
		public function remove():void 
		{
			TM_timer.stop();
			TM_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		}
		
	}

}