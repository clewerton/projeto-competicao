package Fases.FaseTesouroElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	
	public class TesouroIlhaAtor extends AtorBase implements AtorInterface 
	{
		//imagem do bau
		private var MC_Tesouro		:MovieClip;
		
		//ilha do tesouro
		private var AB_ilha			:IlhaAtor
		
		//valor total de pontos
		private var UI_totalPontos	:uint;
		
		//valor de pontos por lote
		private var UI_pontosLote	:uint;
		
		//valor da resta de pontos
		private var UI_pontos		:uint;
		
		//mini de quantidade de tesouro
		private var SP_barraPontos	:Sprite;
		private var SP_barraInterna	:Sprite;
		private var UI_pontosBarra	:uint;
		
		
		public function TesouroIlhaAtor(_ilha: IlhaAtor ) 
		{
			MC_Tesouro = new Slot01;
			
			AB_ilha = _ilha;
			
			super(MC_Tesouro);
			
			MC_Tesouro.gotoAndStop("cheio");
			
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{
			UI_totalPontos 	= faseAtor.param[FaseJogoParamentos.PARAM_ILHA_TOTAL_PONTOS];
			UI_pontosLote	= faseAtor.param[FaseJogoParamentos.PARAM_ILHA_QTD_PONTOS_LOTE];
			UI_pontos		=  UI_totalPontos;
			UI_pontosBarra 	= 0;
			//mini barra tesouro
			SP_barraPontos = geraSprite(0X00FF00, new Rectangle(0, 0, 5, 50), true);
			faseAtor.addChild(SP_barraPontos);
			SP_barraPontos.rotation = 180;
			SP_barraInterna = geraSprite(0X00FF00, new Rectangle(0, 0, 5, 50), false);
			SP_barraPontos.addChild(SP_barraInterna);
			
		}
		
		public function update(e:Event):void 
		{
			atualizaBarradeTesouro()
		}
		
		public function remove():void 
		{
			faseAtor.removeChild(SP_barraPontos);
		}
	
		/*************************************************************************************
		 * Interacao
		 * **********************************************************************************/
		public function pegarPontos():uint {
			if (UI_pontosLote <= UI_pontos) {
				UI_pontos -= UI_pontosLote
				return UI_pontosLote;
			}
			else if (UI_pontos > 0) {
				var pontos:uint = UI_pontos;
				UI_pontos = 0;
				AB_ilha.tesouroVazio();
				marcadoRemocao =true
				return pontos;
			}
			else {
				AB_ilha.tesouroVazio();
				marcadoRemocao =true
				return 0
			}
		}
		
		/*************************************************************************************
		 * Mini HUD de tesouro
		 ************************************************************************************/
		
		private function atualizaBarradeTesouro():void 
		{
			SP_barraPontos.x = this.x + this.width - 15  ;
			SP_barraPontos.y = this.y + 20; 
			faseAtor.setChildIndex(SP_barraPontos, faseAtor.numChildren - 1);
			if ( UI_pontos != UI_pontosBarra ) {
				UI_pontosBarra = UI_pontos
				var perc:Number = UI_pontos / UI_totalPontos;
		    	var tam:Number =  SP_barraPontos.height * perc;
				SP_barraInterna.scrollRect = new Rectangle(0, 0 , SP_barraInterna.width , tam)
				perc *= 100;
				if (perc > 75) {
					MC_Tesouro.gotoAndStop("cheio");
				}
				else if (perc > 50 ) {
					MC_Tesouro.gotoAndStop("meiocheio");
				}
				else if (perc > 25) {
					MC_Tesouro.gotoAndStop("metade");
					
				}
				else {
					MC_Tesouro.gotoAndStop("meiovazio");
				}
			}
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		public function geraSprite(cor:uint, _ret:Rectangle, _contormo:Boolean ):Sprite {
			var sp:Sprite =  new Sprite;
			if (_contormo) sp.graphics.lineStyle(0.1, cor, 1);
			else sp.graphics.lineStyle();
			if (_contormo) sp.graphics.beginFill( 0X000000, 0);
			else sp.graphics.beginFill(cor, 0.75);
			sp.graphics.drawRect(_ret.left, _ret.left, _ret.width, _ret.height);
			sp.graphics.endFill();
			return sp;
		}
		
	}

}