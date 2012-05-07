package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.events.Event;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	/**
	 * ...
	 * @author Arthur Werneck
	 */
	public class TesouroHUD extends FaseHUD implements FaseHUDInterface 
	{
		private var FB_faseTesouro:FaseTesouro;
		private var VT_Tesouro:Vector.<MovieClip>
		private var UI_ultQtd:uint;
		
		public function TesouroHUD() 
		{
			VT_Tesouro = new Vector.<MovieClip>;
			super();			
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			FB_faseTesouro = FaseTesouro(faseHUD);
			this.x = stage.stageWidth - 50 * FB_faseTesouro.qtdTesouros;
			this.y = 20;
			reinicializa();
		}
		
		
		public function reinicializa():void 
		{
			for (var i:uint = 0 ; i < VT_Tesouro.length ; i++) {
				this.removeChild(VT_Tesouro[i]);
			}
			VT_Tesouro = new Vector.<MovieClip>;			
			geraTesouroImg();
			UI_ultQtd = 0;
		}
		
		private function geraTesouroImg():void
		{
			var tesouroImg:MovieClip;
			for (var i:uint = 0 ; i < FB_faseTesouro.qtdTesouros ; i++) {
				tesouroImg = new Slot01();
				tesouroImg.stop();
				tesouroImg.scaleX = 0.75;
				tesouroImg.scaleY = 0.75;
				tesouroImg.alpha = 0.3;
				tesouroImg.y = tesouroImg.height / 2;
				tesouroImg.x = tesouroImg.width / 2 + (tesouroImg.width + 10) * i;
				this.addChild(tesouroImg);
				VT_Tesouro.push(tesouroImg);
			}
		}
		
		public function update(e:Event):void 
		{
			if (UI_ultQtd != FB_faseTesouro.tesourosPegos)
			{
				UI_ultQtd = FB_faseTesouro.tesourosPegos;
				for (var i:uint = 0 ; i < FB_faseTesouro.qtdTesouros ; i++)
				{
					if (i < FB_faseTesouro.tesourosPegos) {
						VT_Tesouro[i].alpha = 1;
						VT_Tesouro[i].gotoAndStop("cheio");
					}
					else {
						VT_Tesouro[i].gotoAndStop("vazio");
						VT_Tesouro[i].alpha = 0.3;
					}
				}
			}
		}
		
		public function remove():void 
		{
			for (var i:uint = 0 ; i < VT_Tesouro.length ; i++) {
				this.removeChild(VT_Tesouro[i]);
			}
			VT_Tesouro = new Vector.<MovieClip>;
		}
	}
}