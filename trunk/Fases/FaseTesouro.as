package Fases 
{
	import adobe.utils.ProductManager;
	import Fases.FaseTesouroElementos.BarcoHeroiAtor;
	import Fases.FaseTesouroElementos.BarcoInimigoAtor;
	import Fases.FaseTesouroElementos.BoteFugaAtor;
	import Fases.FaseTesouroElementos.CanhaoIlhaAtor;
	import Fases.FaseTesouroElementos.IlhaAtor;
	import Fases.FaseTesouroElementos.TesouroHUD;
	import Fases.FaseTesouroElementos.TiroHeroiAtor;
	import Fases.FaseTesouroElementos.TiroInimigoAtor;
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
	import TangoGames.Fases.FaseFPS;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseInterface;
	import TangoGames.Utils;
	
	/**
	 * 
	 * @author ...
	 */
	public class FaseTesouro extends FaseBase implements FaseInterface
	{
		public static const PREMIO_TESOURO:uint =  1;
		public static const PREMIO_BALA:uint =  2;
		public static const PREMIO_BARCO:uint =  3;
		public static const PREMIO_PIRATAS:uint =  4;
		
		public const MAPA_LARGURA:uint = 5000;
		public const MAPA_ALTURA:uint = 3750;
		
		private var AB_barcoHeroi:BarcoHeroiAtor;
		private var MC_backGround:Sprite;
		private var RE_limites:Rectangle;
		private var RE_limGlob:Rectangle;
		private var BO_limites:Boolean;
		private var NU_limVX:Number;
		private var NU_limVY:Number;
		
		//Variaveis das Ilhas
		private var VT_ilhas:Vector.<IlhaAtor>;
		private var UI_qtdIlhas:uint;
		private var UI_qtdBala:uint;
		private var UI_contBala:uint;
		private var UI_qtdBarco:uint;
		private var UI_contBarco:uint;
		private var UI_qtdPiratas:uint;
		private var UI_contPiratas:uint;
		
		//variaveis dos Inimigos
		private var VT_Inimigos:Vector.<BarcoInimigoAtor>
		private var UI_qtdMaxInimigos:uint;
		
		
		//controle de soom do mapa
		private var BO_zoom:Boolean;
		private var NU_escala:Number;
		private var BO_centralizado:Boolean;
		
		//DISPLAY FPS
		private var FH_FPS:FaseHUD;
		
		//Controle de Tesouros
		private var UI_qtdTesouros:uint;
		private var UI_contTesouros:uint;
		private var UI_tesourosPegos:uint;
		private var FH_tesouroHUD: TesouroHUD;
		
			
		public function FaseTesouro(_main:DisplayObjectContainer, Nivel:int) {
			super(_main, Nivel);
			MC_backGround = geraMarFundo();
			this.addChild(MC_backGround);
			MC_backGround.x = -  MC_backGround.width / 2;
			MC_backGround.y = -  MC_backGround.height / 2;
		}

		public function inicializacao():Boolean
		{
			//coloca medidor de FPS
			FH_FPS = new FaseFPS();
			adicionaHUD(FH_FPS);
			
			//cria barco Heroi;
			AB_barcoHeroi = new BarcoHeroiAtor;
			adicionaAtor(AB_barcoHeroi);
			
			//limites de deslocamento do barco
			RE_limites = new Rectangle( 100, 100, stage.stageWidth - 200 , stage.stageHeight - 200);
			RE_limGlob = new Rectangle( - ( this.width / 2 ) , - ( this.height / 2 ) ,  this.width , this.height);
			
			//inicializa controle de ilhas
			UI_qtdIlhas = 15;
			UI_qtdTesouros = 3;
			UI_qtdBala = 4;
			UI_qtdBarco = 4
			UI_qtdPiratas = 4;
			VT_ilhas = new Vector.<IlhaAtor>;
			
			//inicializa Inimigos
			VT_Inimigos = new Vector.<BarcoInimigoAtor>;
			UI_qtdMaxInimigos = 5;
			
			//cpntrole de ZOOM e VISÃO
			NU_escala =  stage.stageWidth / MAPA_LARGURA;
			BO_centralizado = true;
			
			//hud de Tesouros
			FH_tesouroHUD = new TesouroHUD(this);
			adicionaHUD(FH_tesouroHUD);
			
			reiniciacao();
			
			return true
		}
		
		public function reiniciacao():void
		{
			for each (var ilha:IlhaAtor in VT_ilhas) removeAtor(ilha);
			VT_ilhas = new Vector.<IlhaAtor>;

			for each (var ini:BarcoInimigoAtor in VT_Inimigos) removeAtor(ini);
			VT_Inimigos = new Vector.<BarcoInimigoAtor>;
			
			//controle de tesouros
			UI_tesourosPegos = 0;
			
			BO_zoom = false;
			BO_limites = false;
			NU_limVX = 0;
			NU_limVX = 0;
			this.scaleX = 1;
			this.scaleY = 1;
			this.x = stage.stageWidth / 2 ;
			this.y = stage.stageHeight / 2 ;
			geraIlhas();
			
			//monta mapas
			var vg:Vector.<Class> = new Vector.<Class>
			vg.push(IlhaAtor);
			montaMapa(new Point(50, 50), vg);
			
			//pintaQuadradosDebugMapa()
			
			geraInimigo();
		}
		
		public function update(e:Event):void
		{
			//Pressionado pausa do Jogo
			if (pressTecla1(Keyboard.P))
			{
				pausaFase();
			}
			
			//troca camera
			if (pressTecla1(Keyboard.C)) BO_centralizado = !BO_centralizado;

			
			//Centraliza visão do heroi
			if (!BO_zoom && BO_centralizado) {
				if (!limiteCentral()) {
					mudafocoMapa(new Point(AB_barcoHeroi.x, AB_barcoHeroi.y));
				}
			}
			
			//Pressionado ZOOM IN / ZOOM OUT
			if (pressTecla1(Keyboard.Z))
			{
				var ini:BarcoInimigoAtor;
				if (BO_zoom)
				{
					BO_zoom = false;
					this.scaleX = 1;
					this.scaleY = 1;
					this.x = - AB_barcoHeroi.x + ( stage.stageWidth / 2 );
					this.y = - AB_barcoHeroi.y + ( stage.stageHeight / 2 );
					testeRetornoZoom();
					for each (ini in VT_Inimigos) ini.visible =true
				}
				else
				{
					this.scaleX = NU_escala;
					this.scaleY = NU_escala;
					this.x = stage.stageWidth  / 2 ;
					this.y = stage.stageHeight / 2 ;
					BO_zoom = true;
					for each (ini in VT_Inimigos) ini.visible =false
				}
			}
			
			//Testa os Limites do Mapa para o Heroi
			if (!BO_zoom) testaMovimentoHeroi();
			
		}
		
		public function remocao():void
		{
		}
		
		public function colisao(C1:AtorBase, C2:AtorBase):void
		{
			if (C1 is TiroHeroiAtor) {
				if (C2 is BarcoInimigoAtor) {
					BarcoInimigoAtor(C2).foiAtingido(TiroHeroiAtor(C1));
					return
				}
				else if (C2 is CanhaoIlhaAtor) {
					CanhaoIlhaAtor(C2).foiAtingido(TiroHeroiAtor(C1));
					return				
				}
			}
			if (C1 is TiroInimigoAtor && C2 is BarcoHeroiAtor) {
				BarcoHeroiAtor(C2).foiAtingido(TiroInimigoAtor(C1));
				return
			}			
			if (C1 is BarcoHeroiAtor && C2 is IlhaAtor)
			{
				BarcoHeroiAtor(C1).colidiuIlha(IlhaAtor(C2));
				return;
			}
			if (C1 is IlhaAtor && C2 is BarcoHeroiAtor)
			{
				BarcoHeroiAtor(C2).avisoIlha(IlhaAtor(C1));
				return;
			}
			if (C1 is BarcoInimigoAtor) {
				if ( C2 is BarcoInimigoAtor ) {
					BarcoInimigoAtor(C1).colidiuBarcoInimigo(BarcoInimigoAtor(C2));
					return;
				}
				else if ( C2 is IlhaAtor) {
					BarcoInimigoAtor(C1).colidiuIlha(IlhaAtor(C2));
					return;
				}
				else if (C2 is BarcoHeroiAtor) {
				BarcoInimigoAtor(C1).colidiuBarcoHeroi(BarcoHeroiAtor(C2));
				return;
				}
			}
			if (C1 is BoteFugaAtor) BoteFugaAtor(C1).colisaoPadrao(C2);

			trace(C1, " colidiu com ", C2);

		}
		
		/***********************************************************
		 * geracao das Inimigos
		 * *********************************************************/

		private function geraInimigo():void 
		{
			var barcoIni:BarcoInimigoAtor;
			
			for (var i:uint = 0 ; i < UI_qtdMaxInimigos ; i++) {
				barcoIni = new BarcoInimigoAtor();
				VT_Inimigos.push(barcoIni);
				adicionaAtor(barcoIni);
				randomizaPosicaoInimigo(barcoIni);
				while (!testaSobreposicao(barcoIni)) randomizaPosicaoInimigo(barcoIni);
			}
		}
		
		private function randomizaPosicaoInimigo(_ini:BarcoInimigoAtor):void
		{	
			_ini.x =  Utils.Rnd( RE_limGlob.left , RE_limGlob.right );
			_ini.y = Utils.Rnd( RE_limGlob.top , RE_limGlob.bottom );			
		}

		/***********************************************************
		 * geracao das ILhas
		 * *********************************************************/

		 private function geraIlhas():void 
		{
			UI_contTesouros = 0;
			UI_contBala = 0;
			UI_contBarco = 0;
			UI_contPiratas = 0;
			var cont:uint = 0;
			var ilha:IlhaAtor;
			while (cont < UI_qtdIlhas) 
			{ 	ilha = new IlhaAtor();;
				adicionaAtor(ilha);
				sorteiaIlha(ilha);
				while (!testaSobreposicao(ilha)) randomizaPosicaoIlha(ilha);
				VT_ilhas.push(ilha);
				cont++;
			} 
		}
		
		private function testaSobreposicao(_ator:AtorBase):Boolean
		{
			for each (var ator:AtorBase in Atores)
			{
				if (ator != _ator) {if (_ator.hitTestObject(ator)) return false}
			}
			return true;
		}
		
		private function sorteiaIlha(_ilha:IlhaAtor):void
		{
			randomizaPosicaoIlha(_ilha);
			if (UI_contTesouros < UI_qtdTesouros)
			{
				_ilha.definiPremio(PREMIO_TESOURO);
				UI_contTesouros++;
			}
			else if (UI_contBarco < UI_qtdBarco)
			{
				_ilha.definiPremio(PREMIO_BARCO);
				UI_contBarco++;
			}
			else if (UI_contBala < UI_qtdBala)
			{
				_ilha.definiPremio(PREMIO_BALA);
				UI_contBala++;
			}
			else if (UI_contPiratas < UI_qtdPiratas)
			{
				_ilha.definiPremio(PREMIO_PIRATAS);
				UI_contPiratas++;
			}
		}
		
		private function randomizaPosicaoIlha(_ilha:IlhaAtor):void
		{	
			_ilha.x =  Utils.Rnd( RE_limGlob.left + ( _ilha.width / 2 ) , RE_limGlob.right - (_ilha.width / 2));
			_ilha.y = Utils.Rnd( RE_limGlob.top + ( _ilha.height / 2 ) , RE_limGlob.bottom - (_ilha.height / 2));			
		}

		/***********************************************************
		 * métodos privados
		 ***********************************************************/
		
		private function geraMarFundo():Sprite
		{
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
		
		private function mudafocoMapa(_ponto:Point) {
			this.x = - _ponto.x + ( stage.stageWidth  / 2 );
			this.y = - _ponto.y + ( stage.stageHeight / 2 );
		}
		
		private function limiteCentral():Boolean
		{
			if ( ( (  stage.stageWidth  / 2 ) - AB_barcoHeroi.x) < RE_limGlob.left + stage.stageWidth) return true;
			else  if ( ( (  stage.stageWidth  / 2 ) - AB_barcoHeroi.x) > RE_limGlob.right) return true;
			if ( ( ( stage.stageHeight / 2 ) - AB_barcoHeroi.y) < RE_limGlob.top + stage.stageHeight ) return true;
			else if ( ( ( stage.stageHeight / 2 ) - AB_barcoHeroi.y) > RE_limGlob.bottom) return true;
			return false;
		}
		
		
		private function testeRetornoZoom():void 
		{
			if ( this.x < RE_limGlob.left + stage.stageWidth) this.x = RE_limGlob.left+stage.stageWidth;
			else  if ( this.x > RE_limGlob.right) this.x = RE_limGlob.right;
			if ( this.y < RE_limGlob.top + stage.stageHeight ) this.y = RE_limGlob.top+stage.stageHeight;
			else if ( this.y > RE_limGlob.bottom) this.y = RE_limGlob.bottom;
		}
		
		private function testaMovimentoHeroi():void
		{
			if (testaLimites())
			{
				this.x += NU_limVX ;
				this.y += NU_limVY ;
			}
		}
		
		private function testaLimites():Boolean
		{
			var retHeroi:Rectangle = AB_barcoHeroi.getBounds(stage);
			var cX:Number =  retHeroi.left + ( retHeroi.width / 2 );
			var cY:Number =  retHeroi.top + ( retHeroi.height / 2);
			var teste:Boolean = false;
			NU_limVX = 0;
			NU_limVY = 0;
			if ( cY < RE_limites.top)
			{
				NU_limVY = RE_limites.top - cY;
				teste = true;
			}
			else if ( cY > RE_limites.bottom )
			{
				NU_limVY = RE_limites.bottom - cY;
				teste = true;
			}
			if ( cX > RE_limites.right )
			{
				NU_limVX = RE_limites.right -cX;
				teste = true;
			}
			else if ( cX < RE_limites.left )
			{
				NU_limVX = RE_limites.left - cX;
				teste = true;
			}
			return teste
		}

		
		/***********************************************************
		 * Propriedade públicas
		 ***********************************************************/
		
		public function get limGlob():Rectangle 
		{
			return RE_limGlob;
		}
		
		public function get barcoHeroi():BarcoHeroiAtor 
		{
			return AB_barcoHeroi;
		}
		
		public function get tesourosPegos():uint 
		{
			return UI_tesourosPegos;
		}
		
		public function set tesourosPegos(value:uint):void 
		{
			UI_tesourosPegos = value;
		}
		
		public function get qtdTesouros():uint 
		{
			return UI_qtdTesouros;
		}
	
		private function pintaQuadradosDebugMapa() {
			//pinta mapa
			var m:Sprite;
			var p:Point;
			var k:uint;
			var j:uint;
			for (k=0 ; k < mapa.dimX ; k++) {
				for (j = 0 ; j < mapa.dimY ; j++) {
					p = new Point(k, j);
					if ( mapa.mapaArray[k][j] == 1 ) {
						m = mapa.geraSprite(0XFF0000);
						this.addChild(m);
						p = mapa.convertePontoMapa(p);
						m.x = p.x;
						m.y = p.y;
					}
				}
			}
		}
	}
}