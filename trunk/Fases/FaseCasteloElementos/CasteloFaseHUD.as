package Fases.FaseCasteloElementos 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class CasteloFaseHUD extends FaseHUD implements FaseHUDInterface 
	{
		
		//barra de vida do castelo
		private var MC_barraVida:MovieClip;
		private var MC_barraInterna: MovieClip;
		private var NU_percentual:Number;
		private var AB_castelo:CasteloAtor;
		
		public function CasteloFaseHUD(_castelo:CasteloAtor) {
			super();
			MC_barraVida = new BarraVidaHUD;
			MC_barraVida.alpha = 0.75;
			MC_barraInterna = MC_barraVida.barra;
			AB_castelo = _castelo;
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void {
			addChild(MC_barraVida);
			MC_barraVida.x = stage.stageWidth / 2;
			MC_barraVida.y = stage.stageHeight - MC_barraVida.height;			
			reinicializa();
		}
		
		public function reinicializa():void {
			NU_percentual = 100;
			var bX:Number = MC_barraInterna.x;
			var bY:Number = MC_barraInterna.y;
			MC_barraVida.removeChild(MC_barraInterna);
			MC_barraInterna = new BarraColorida;
			MC_barraVida.addChildAt(MC_barraInterna,0);
			MC_barraInterna.x = bX;
			MC_barraInterna.y = bY;
		}
		
		public function update(e:Event):void {
			var perc:Number = AB_castelo.percentualVida();
			if ( NU_percentual != perc) {
				NU_percentual = perc
				var tam:Number =  ( MC_barraVida.width * ( perc / 100 ) );
				MC_barraInterna.scrollRect = new Rectangle(0,0, tam ,MC_barraInterna.height)
			}
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		public function remove():void 
		{
			
		}
		
		private function atualizaBarra() {
			
		}
		
		public function get percentual():Number 
		{
			return NU_percentual;
		}
		
		public function set percentual(value:Number):void 
		{
			NU_percentual = value;
			MC_barraVida.addChild(MC_barraInterna);
		}
		/**
		 * cria fundo para o menu de interrupção
		 * @return
		 */
	}

}