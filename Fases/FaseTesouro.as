package Fases 
{
	import Fases.FaseTesouroElementos.BarcoHeroiAtor;
	import Fases.FaseTesouroElementos.IlhaAtor;
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
		private var BO_limites:Boolean;
		private var NU_limVX:Number;
		private var NU_limVY:Number;
		
		private var VT_ilhas:Vector.<IlhaAtor>;
		private var UI_qtdIlhas:uint;
		
		public function FaseTesouro(_main:DisplayObjectContainer, Nivel:int) {
			super(_main, Nivel);
			MC_backGround = geraMarFundo()
			this.addChild(MC_backGround);
			MC_backGround.x = - MC_backGround.width / 2;
			MC_backGround.y = - MC_backGround.height / 2;			
		}
		
		public function reiniciacao():void {
			BO_limites = false;
			NU_limVX = 0;
			NU_limVX = 0;
			this.x = 0;
			this.y = 0;
			geraIlhas();
		}
		
		private function geraIlhas():void 
		{
			var cont:uint = 0;
			var ilha:IlhaAtor;
			while (cont < UI_qtdIlhas) 
			{ 	ilha = sorteiaIlha();
				adicionaAtor(ilha);
				while (!testaIlha(ilha)) randomizaPosicaoIlha(ilha);
				VT_ilhas.push(ilha);				
				cont++;
			} 
		}
		
		private function testaIlha(_ilha:IlhaAtor):Boolean {
			for each (var ator:AtorBase in Atores) {
				if (ator != _ilha) {if (_ilha.hitTestAtor(ator)) return false}
			}
			return true;
		}
		
		
		private function sorteiaIlha():IlhaAtor {
			var ilha:IlhaAtor = new IlhaAtor();
			randomizaPosicaoIlha(ilha);
			//trace("ilha x:", ilha.x);
			//trace("ilha y:", ilha.y);
			return ilha;
		}
		private function randomizaPosicaoIlha(_ilha:IlhaAtor):void
		{	
			_ilha.x = (100 + _ilha.width + ( Math.random() * (this.width - 200 - _ilha.width * 2  ) ) ) - ( this.width / 2 )  ;
			_ilha.y = 100 + _ilha.height + ( Math.random() * (this.height - 200 - _ilha.height * 2  ) ) - ( this.height / 2 );			
		}
		
		public function inicializacao():Boolean
		{
			AB_barcoHeroi = new BarcoHeroiAtor;
			adicionaAtor(AB_barcoHeroi);
			//limites de deslocamento do barco
			RE_limites = new Rectangle( 100, 100, stage.stageWidth - 200 , stage.stageHeight - 200);
			//vetor ilhas
			UI_qtdIlhas = 30;
			VT_ilhas = new Vector.<IlhaAtor>;
			reiniciacao();
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
		
		private function testaMovimentoHeroi():void {
			if (testaLimites()) {
				this.x += NU_limVX ;
				this.y += NU_limVY ;
			}
		}
		
		private function testaLimites():Boolean {
			var retHeroi:Rectangle = AB_barcoHeroi.getBounds(stage);
			var cX:Number =  retHeroi.left + ( retHeroi.width / 2 );
			var cY:Number =  retHeroi.top + ( retHeroi.height / 2);
			var teste:Boolean = false;
			NU_limVX = 0;
			NU_limVY = 0;
			if ( cY < RE_limites.top) {
				NU_limVY = RE_limites.top - cY;
				teste = true;
			}
			else if ( cY > RE_limites.bottom )  {
				NU_limVY = RE_limites.bottom - cY;
				teste = true;
			}
			if ( cX > RE_limites.right ) {
				NU_limVX = RE_limites.right -cX;
				teste = true;
			}
			else if ( cX < RE_limites.left ) {
				NU_limVX = RE_limites.left - cX;
				teste = true;
			}
			return teste
		}
		
		public function remocao():void {
		}
		
		public function colisao(C1:AtorBase, C2:AtorBase):void {
			//trace(C1, " colidiu com ", C2);
			
			if (C1 is BarcoHeroiAtor && C2 is IlhaAtor) {
				BarcoHeroiAtor(C1).colidiuIlha(IlhaAtor(C2));
			}
			
			
			
		}
		
		private function geraMarFundo():Sprite {
			var sp:Sprite = new Sprite;
			sp.graphics.lineStyle();
			//sp.graphics.beginFill(0X0099C, 1);
			sp.graphics.beginBitmapFill(new seawaterbmp);
			sp.graphics.drawRect(0, 0, 8000, 6000);
			sp.graphics.endFill();
			sp.graphics.beginFill(0X0099C, 0.5);
			sp.graphics.drawRect(0, 0, 8000, 6000);
			sp.graphics.endFill();
			return sp;
		}
		
	}

}