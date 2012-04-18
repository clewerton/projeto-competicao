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
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FaseTesouro extends FaseBase implements FaseInterface
	{
		public static const PREMIO_TESOURO:uint =  1;
		
		public const MAPA_LARGURA:uint = 4000;
		public const MAPA_ALTURA:uint = 3000;
		
		private var AB_barcoHeroi:BarcoHeroiAtor;
		private var MC_backGround:Sprite;
		private var RE_limites:Rectangle;
		private var RE_limGlob:Rectangle;
		private var BO_limites:Boolean;
		private var NU_limVX:Number;
		private var NU_limVY:Number;
		
		private var VT_ilhas:Vector.<IlhaAtor>;
		private var UI_qtdIlhas:uint;
		
		private var UI_qtdTesouros:uint;
		private var UI_contTesouros:uint;
		
		private var BO_zoom:Boolean;
		private var NU_escala:Number;
		
		private var wait:uint;
		
		public function FaseTesouro(_main:DisplayObjectContainer, Nivel:int) {
			super(_main, Nivel);
			MC_backGround = geraMarFundo();
			this.addChild(MC_backGround);
			MC_backGround.x = -  MC_backGround.width / 2;
			MC_backGround.y = -  MC_backGround.height / 2;			
		}

		public function inicializacao():Boolean
		{
			AB_barcoHeroi = new BarcoHeroiAtor;
			adicionaAtor(AB_barcoHeroi);
			//limites de deslocamento do barco
			RE_limites = new Rectangle( 100, 100, stage.stageWidth - 200 , stage.stageHeight - 200);
			RE_limGlob = new Rectangle( - ( this.width / 2 ) , - ( this.height / 2 ) ,  this.width , this.height);
			//vetor ilhas
			UI_qtdIlhas = 15;
			UI_qtdTesouros = 3;
			
			VT_ilhas = new Vector.<IlhaAtor>;
			NU_escala =  stage.stageWidth / MAPA_LARGURA;
			reiniciacao();
			return true
		}

		
		public function reiniciacao():void {
			for each (var i:IlhaAtor in VT_ilhas) {
				removeAtor(i);
			}
			VT_ilhas = new Vector.<IlhaAtor>;
			BO_zoom = false;
			BO_limites = false;
			NU_limVX = 0;
			NU_limVX = 0;
			this.scaleX = 1;
			this.scaleY = 1;
			this.x = stage.stageWidth / 2 ;
			this.y = stage.stageHeight / 2 ;
			geraIlhas();
		}
		
		private function geraIlhas():void 
		{
			UI_contTesouros = 0;
			var cont:uint = 0;
			var ilha:IlhaAtor;
			while (cont < UI_qtdIlhas) 
			{ 	ilha = new IlhaAtor();;
				adicionaAtor(ilha);
				sorteiaIlha(ilha);
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
		
		
		private function sorteiaIlha(_ilha:IlhaAtor):void {
			randomizaPosicaoIlha(_ilha);
			if (UI_contTesouros < UI_qtdTesouros) {
				_ilha.definiPremio(PREMIO_TESOURO);
				UI_contTesouros++;
			}
		}
		
		private function randomizaPosicaoIlha(_ilha:IlhaAtor):void
		{	
			_ilha.x =  Utils.Rnd( RE_limGlob.left + ( _ilha.width / 2 ) , RE_limGlob.right - (_ilha.width / 2));
			_ilha.y = Utils.Rnd( RE_limGlob.top + ( _ilha.height / 2 ) , RE_limGlob.bottom - (_ilha.height / 2));			
		}
		
		
		public function update(e:Event):void
		{
			if (pressTecla(Keyboard.P))
			{
				pausaFase();
			}
			wait++;
			if (pressTecla(Keyboard.Z))
			{
				if (wait > 10) {
					if (BO_zoom) {
						this.scaleX = 1;
						this.scaleY = 1;
						BO_zoom = false;
						this.x = - AB_barcoHeroi.x + ( stage.stageWidth / 2 );
						this.y = - AB_barcoHeroi.y + ( stage.stageHeight / 2 );
						testeRetornoZoom();
						wait = 0;
					}
					else {
						this.scaleX = NU_escala;
						this.scaleY = NU_escala;
						this.x = stage.stageWidth / 2  ;
						this.y = stage.stageHeight / 2;
						BO_zoom = true;
						wait = 0;
					}
				}
			}

			if (!BO_zoom) testaMovimentoHeroi();
			
		}
		
		private function testeRetornoZoom():void 
		{
			if ( this.x < RE_limGlob.left + stage.stageWidth) this.x = RE_limGlob.left+stage.stageWidth;
			else  if ( this.x > RE_limGlob.right - stage.stageWidth) this.x = RE_limGlob.right;
			if ( this.y < RE_limGlob.top + stage.stageHeight ) this.y = RE_limGlob.top+stage.stageHeight;
			else if ( this.y > RE_limGlob.bottom) this.y = RE_limGlob.bottom;
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
			if (C1 is BarcoHeroiAtor && C2 is IlhaAtor) {
				BarcoHeroiAtor(C1).colidiuIlha(IlhaAtor(C2));
				return;
			}
			if (C1 is IlhaAtor && C2 is BarcoHeroiAtor) {
				BarcoHeroiAtor(C2).avisoIlha(IlhaAtor(C1));
				return;
			}
			trace(C1, " colidiu com ", C2);
		}
		
		private function geraMarFundo():Sprite {
			var sp:Sprite = new Sprite;
			sp.graphics.lineStyle();
			//sp.graphics.beginFill(0X0099C, 1);
			sp.graphics.beginBitmapFill(new seawaterbmp);
			sp.graphics.drawRect(0, 0, MAPA_LARGURA, MAPA_ALTURA);
			sp.graphics.endFill();
			sp.graphics.beginFill(0X0099C, 0.5);
			sp.graphics.drawRect(0, 0, MAPA_LARGURA, MAPA_ALTURA);
			sp.graphics.endFill();
			return sp;
		}
		
		public function get limGlob():Rectangle 
		{
			return RE_limGlob;
		}
		
	}

}