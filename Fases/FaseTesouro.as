package Fases 
{
	import Fases.FaseTesouroElementos.BarcoHeroiAtor;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FaseTesouro extends FaseBase implements FaseInterface
	{
		
		private var AB_barcoHeroi:BarcoHeroiAtor;
		private var MC_backGround:Sprite;
		private var RE_limites:Rectangle;

		
		public function FaseTesouro(_main:DisplayObjectContainer, Nivel:int) {
			super(_main, Nivel);
			MC_backGround = geraMarFundo()
			this.addChild(MC_backGround);
			MC_backGround.x = - MC_backGround.width / 2
			MC_backGround.y = - MC_backGround.height / 2
			
		}
		
		public function reiniciacao():void {
			
		}
		
		public function inicializacao():Boolean
		{
			AB_barcoHeroi = new BarcoHeroiAtor;
			adicionaAtor(AB_barcoHeroi);
			//limites de deslocamento do barco
			RE_limites = new Rectangle( 100, 100, stage.stageWidth - 200 , stage.stageHeight - 200);
			return true
		}
		
		public function update(e:Event):void
		{
			if (pressTecla(Keyboard.P))
			{
				pausaFase();
			}
			
			testaMovimentoHeroi();
			
		}
		
		private function testaMovimentoHeroi():void 
		{
			if (testaLimites()) {
				this.x -= AB_barcoHeroi.veloX ;
				this.y -= AB_barcoHeroi.veloY ;
			}
		}
		
		private function testaLimites():Boolean {
			var retHeroi:Rectangle = AB_barcoHeroi.getBounds(stage);
			var cX:Number = retHeroi.left + ( retHeroi.width / 2 );
			var cY:Number = retHeroi.top + ( retHeroi.height / 2) ;
			//trace("Heroi top=" + retHerio.top + " > " + "Stage.top=" + RE_limites.top )
			
			if ( cY < RE_limites.top) return true;
			if ( cY > RE_limites.bottom) return true;
			if ( cX > RE_limites.right) return true;
			if ( cX < RE_limites.left) return true;
			return false;
		}
		
		
		
		public function remocao():void { };
		
		public function colisao(C1:AtorBase, C2:AtorBase):void {};
		
		private function geraMarFundo():Sprite {
			var sp:Sprite = new Sprite;
			sp.graphics.lineStyle();
			sp.graphics.beginBitmapFill(new seawaterbmp);
			sp.graphics.drawRect(0, 0, 8000, 6000);
			sp.graphics.endFill();
			return sp;
		}
		
	}

}