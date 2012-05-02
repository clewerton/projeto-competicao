package Fases.FaseTesouroElementos  {
	
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	
	public class PontosHUD extends FaseHUD implements FaseHUDInterface {
		
		private var TF_pontos:TextField;
		private var UI_pontos:uint;
		
		public function PontosHUD() {
			TF_pontos = this.pontos;
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			UI_pontos =  FaseTesouro(faseHUD).pontos;
			TF_pontos.text = UI_pontos.toString();
			this.x = (stage.stageWidth-this.width) / 2 ;
			this.y = 10;			
		}
		
		public function reinicializa():void 
		{
			
		}
		
		public function update(e:Event):void 
		{
			var pontos:uint = FaseTesouro(faseHUD).pontos;
			if (pontos != UI_pontos) {
				TF_pontos.text = pontos.toString();
				UI_pontos = pontos;
			}
		}
		
		public function remove():void 
		{
			
		}
	}
	
}
