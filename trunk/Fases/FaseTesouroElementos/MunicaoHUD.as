package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class MunicaoHUD extends FaseHUD implements FaseHUDInterface 
	{
		private var MC_municao:MovieClip;
		private var TF_municao:TextField;
		private var UI_municao:uint;
		private var UI_muniMax:uint;
		private var BH_barcoHeroi:BarcoHeroiAtor;
		public function MunicaoHUD() 
		{	
			TF_municao = new TextField;
			MC_municao = new Slot03;
			UI_municao = 9999;
			UI_muniMax = 9999;
			super();
			
			TF_municao.defaultTextFormat = new TextFormat("_sans", 21, 0X8AEC5F);
			TF_municao.autoSize = TextFieldAutoSize.RIGHT;
			TF_municao.text = UI_municao.toString + "/" + UI_muniMax.toString;
			this.addChild(TF_municao);
			TF_municao.x = -TF_municao.width - MC_municao.width - 10;
			TF_municao.y = -TF_municao.height - 2;
			
			this.addChild(MC_municao);
			var rt:Rectangle = MC_municao.getBounds(this);
			MC_municao.scaleX = 0.5;
			MC_municao.scaleY = 0.5;
			MC_municao.x = rt.left - 10;
			MC_municao.y = rt.top + 2; 
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			this.x = stage.stageWidth;
			this.y = stage.stageHeight;
			BH_barcoHeroi = FaseTesouro(faseHUD).barcoHeroi;
			reinicializa();
		}
		
		public function reinicializa():void 
		{
			
		}
		
		public function update(e:Event):void 
		{
			var municao:uint = BH_barcoHeroi.municao;
			var muniMax:uint = BH_barcoHeroi.muniMax;
			if (municao != UI_municao) {
				UI_municao = municao;
				UI_muniMax = muniMax;
				TF_municao.text = UI_municao.toString() + "/" + UI_muniMax.toString();
			}
		}
		
		public function remove():void 
		{
			
		}
		
	}

}