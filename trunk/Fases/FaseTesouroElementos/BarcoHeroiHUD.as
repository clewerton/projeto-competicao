package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	public class BarcoHeroiHUD extends FaseHUD implements FaseHUDInterface 
	{
		
		//barra de vida do barco heroi
		private var MC_barraVida	:MovieClip;
		private var MC_barraInterna	:MovieClip;
		private var NU_vidaAtual	:Number;
		
		//referencia do Barco Heroi
		private var AB_barcoHeroi	:BarcoHeroiAtor;
		
		public function BarcoHeroiHUD() {
			super();
			MC_barraVida = new BarraVidaHUD;
			MC_barraVida.alpha = 0.75;
			MC_barraInterna = MC_barraVida.barra;
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void {
			//atualiza referencia do barco heroi	
			AB_barcoHeroi =	FaseTesouro(faseHUD).barcoHeroi;
			
			//adiciona barra de vida
			addChild(MC_barraVida);
			this.x = stage.stageWidth / 2;
			this.y = stage.stageHeight - this.height;			
			reinicializa();
		}
		
		public function reinicializa():void {
			NU_vidaAtual = 0;
			var bX:Number = MC_barraInterna.x;
			var bY:Number = MC_barraInterna.y;
			MC_barraVida.removeChild(MC_barraInterna);
			MC_barraInterna = new BarraColorida;
			MC_barraVida.addChildAt(MC_barraInterna,0);
			MC_barraInterna.x = bX;
			MC_barraInterna.y = bY;
		}
		
		public function update(e:Event):void {
			var vida:Number = AB_barcoHeroi.vidaAtual;
			if ( NU_vidaAtual != vida) {
				var tam:Number =  ( MC_barraVida.width * ( vida / AB_barcoHeroi.vidaMaxima ) );
				MC_barraInterna.scrollRect = new Rectangle(0, 0, tam , MC_barraInterna.height)
				NU_vidaAtual = vida;
			}
		}
		
		public function remove():void 
		{
			
		}
		
		/**
		 * cria fundo para o menu de interrupção
		 * @return
		 */
	}

}