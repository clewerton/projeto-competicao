package Fases 
{
	import Fases.Efeitos.AvisoPontos;
	import Fases.FaseTesouroElementos.BarcoHeroiAtor;
	import Fases.FaseTesouroElementos.BarcoHeroiHUD;
	import Fases.FaseTesouroElementos.BarcoInimigoAtor;
	import Fases.FaseTesouroElementos.BoteFugaAtor;
	import Fases.FaseTesouroElementos.CanhaoIlhaAtor;
	import Fases.FaseTesouroElementos.IlhaAtor;
	import Fases.FaseTesouroElementos.MunicaoHUD;
	import Fases.FaseTesouroElementos.PontosHUD;
	import Fases.FaseTesouroElementos.TesouroHUD;
	import Fases.FaseTesouroElementos.TiroHeroiAtor;
	import Fases.FaseTesouroElementos.TiroInimigoAtor;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
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
	import TangoGames.Fases.FaseControle;
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
		//tamanho do mapa
		private var UI_mapa_Largura	:uint; 
		private var UI_mapa_Altura	:uint; 
		
		//Fase Dados
		private var FC_faseDados	:FasesDados

		//Barco controle
		private var BU_barcoUpgrade	:BarcoHeroiUpgrades;
		
		//barco heroi
		private var AB_barcoHeroi	:BarcoHeroiAtor;
		
		//fundo do mapa
		private var MC_backGround	:Sprite;
		private var RE_limites		:Rectangle;
		private var RE_limGlob		:Rectangle;
		private var BO_limites		:Boolean;
		private var NU_limVX		:Number;
		private var NU_limVY		:Number;
		
		//Variaveis das Ilhas
		private var VT_ilhas		:Vector.<IlhaAtor>;
		private var UI_qtdIlhas		:uint;
		private var UI_qtdBala		:uint;
		private var UI_contBala		:uint;
		private var UI_qtdBarco		:uint;
		private var UI_contBarco	:uint;
		private var UI_qtdPiratas	:uint;
		private var UI_contPiratas	:uint;
		
		//variaveis dos Inimigos
		private var UI_qtdMaxInimigos:uint;
		
		//controle de soom do mapa
		private var BO_zoom			:Boolean;
		private var NU_escala		:Number;
		private var BO_centralizado	:Boolean;
		
		//DISPLAY FPS
		private var FH_FPS:FaseHUD;
		
		//Controle de Tesouros
		private var UI_qtdTesouros	:uint;
		private var UI_contTesouros	:uint;
		private var UI_tesourosPegos:uint;
		private var FH_tesouroHUD	:TesouroHUD;
		
		//Pontos da Fase
		private var UI_pontos		:uint;
		private var FH_pontosHUD	:PontosHUD;
		
		//HUD de vida do Barco
		private var FH_barcoHUD		:BarcoHeroiHUD;
		
		//HUD de munição
		private var FH_municaoHUD	:MunicaoHUD;
		
		public function FaseTesouro(_main:DisplayObjectContainer, _faseCtr:FaseControle, _faseID:uint, _nivel:uint) {
			super(_main, _faseCtr, _faseID, _nivel);
			
			//Fase dados
			FC_faseDados = new FasesDados;
			
			//Barco Upgrades
			BU_barcoUpgrade = new BarcoHeroiUpgrades();
			
			//tamanho do mapa
			UI_mapa_Largura	= param[FaseJogoParamentos.PARAM_FASE_TAMANHO_LARGURA];
			UI_mapa_Altura	= param[FaseJogoParamentos.PARAM_FASE_TAMANHO_ALTURA];
			
			MC_backGround = geraMarFundo();
			this.addChild(MC_backGround);
			MC_backGround.x = -  MC_backGround.width / 2;
			MC_backGround.y = -  MC_backGround.height / 2;
		}
		
		public function inicializacao():Boolean
		{
			//coloca medidor de FPS
			FH_FPS = new FaseFPS();
			//adicionaHUD(FH_FPS);
			
			//cria barco Heroi;
			AB_barcoHeroi = new BarcoHeroiAtor;
			adicionaAtor(AB_barcoHeroi);
			
			//limites de deslocamento do barco
			RE_limites = new Rectangle( 100, 100, stage.stageWidth - 200 , stage.stageHeight - 200);
			RE_limGlob = new Rectangle( - ( this.width / 2 ) , - ( this.height / 2 ) ,  this.width , this.height);
			
			//inicializa controle de ilhas
			UI_qtdTesouros 	= param[FaseJogoParamentos.PARAM_FASE_QTD_ILHAS_TESOURO];
			UI_qtdBala 		= param[FaseJogoParamentos.PARAM_FASE_QTD_ILHAS_MUNICAO];
			UI_qtdBarco 	= param[FaseJogoParamentos.PARAM_FASE_QTD_ILHAS_VIDA];
			UI_qtdPiratas 	= param[FaseJogoParamentos.PARAM_FASE_QTD_ILHAS_CANHAO];
			UI_qtdIlhas 	= UI_qtdTesouros + UI_qtdBala + UI_qtdBarco + UI_qtdPiratas ;
			VT_ilhas = new Vector.<IlhaAtor>;
			
			//inicializa Inimigos
			UI_qtdMaxInimigos = param[FaseJogoParamentos.PARAM_FASE_QTD_INIMIGOS];
			
			//cpntrole de ZOOM e VISÃO
			NU_escala =  stage.stageWidth / UI_mapa_Largura;
			BO_centralizado = true;
			
			//hud de Tesouros
			FH_tesouroHUD = new TesouroHUD();
			adicionaHUD(FH_tesouroHUD);
			
			//HUD do barco
			FH_barcoHUD =  new BarcoHeroiHUD;
			adicionaHUD(FH_barcoHUD);
			
			//HUD Pontos
			FH_pontosHUD = new PontosHUD;
			adicionaHUD(FH_pontosHUD);
			
			//HUD Munição
			FH_municaoHUD = new MunicaoHUD;
			adicionaHUD(FH_municaoHUD);
			
			//Reinicia variaveis
			reiniciacao();
			
			return true
		}
		
		public function reiniciacao():void
		{
			//remove atores
			removeAtores();
			
			//reposiciona barco
			AB_barcoHeroi.x = 0;
			AB_barcoHeroi.y = 0;
			
			//controle de tesouros
			UI_tesourosPegos = 0;
			UI_pontos = FC_faseDados.totalPontos;
			
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
			
			//coloca quadrados vermelhos marcando o mapeamento
			//pintaQuadradosDebugMapa()
			
			geraInimigo();
			
		}
		
		public function update(e:Event):void
		{	
			//termina o jogo
			if ( barcoHeroi.vidaAtual <= 0) {
				
				//ZERA UPGRADES DO BARCO
				//BU_barcoUpgrade.zeraUpgrades();
				
				terminoFase();
				return;
			}

			//ganhou o jogo
			if ( UI_tesourosPegos >= UI_qtdTesouros) {
				
				//conclui fase 
				if ( FC_faseDados.faseLiberada < faseID ) FC_faseDados.faseLiberada = faseID;
				FC_faseDados.totalPontos = UI_pontos;
				FC_faseDados.salvaDados();
				
				concluidaFase();
				return;
			}

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
				}
				else
				{
					this.scaleX = NU_escala;
					this.scaleY = NU_escala;
					this.x = stage.stageWidth  / 2 ;
					this.y = stage.stageHeight / 2 ;
					BO_zoom = true;
				}
			}
			
			//Testa os Limites do Mapa para o Heroi
			if (!BO_zoom) testaMovimentoHeroi();
			
		}
		
		public function remocao():void
		{
		}
		
		/*****************************************************************
		 * Remove atores para reinicializacao
		 * ***************************************************************/
		/**
		 * remove os atores para reiniciar
		 */
		private function removeAtores():void 
		{
			var ator:AtorBase;
			var VT_TEMP:Vector.<AtorBase> =  new Vector.<AtorBase>;
			
			for each (ator in Atores) if (!(ator is BarcoHeroiAtor) ) VT_TEMP.push(ator);
			
			for each (ator in VT_TEMP) removeAtor(ator);
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

			//trace(C1, " colidiu com ", C2);

		}
		
		/***********************************************************
		 * geracao das Inimigos
		 * *********************************************************/

		private function geraInimigo():void 
		{
			var barcoIni:BarcoInimigoAtor;
			
			for (var i:uint = 0 ; i < UI_qtdMaxInimigos ; i++) {
				barcoIni = new BarcoInimigoAtor();
				adicionaAtor(barcoIni);
				randomizaPosicaoInimigo(barcoIni);
				while (!testaSobreposicao(barcoIni)) randomizaPosicaoInimigo(barcoIni);
			}
		}
		
		private function randomizaPosicaoInimigo(_ini:BarcoInimigoAtor):void
		{	
			_ini.x = Utils.Rnd( RE_limGlob.left , RE_limGlob.right );
			_ini.y = Utils.Rnd( RE_limGlob.top  , RE_limGlob.bottom );			
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
				_ilha.definiPremio(IlhaAtor.PREMIO_TESOURO);
				UI_contTesouros++;
			}
			else if (UI_contBarco < UI_qtdBarco)
			{
				_ilha.definiPremio(IlhaAtor.PREMIO_BARCO);
				UI_contBarco++;
			}
			else if (UI_contBala < UI_qtdBala)
			{
				_ilha.definiPremio(IlhaAtor.PREMIO_BALA);
				UI_contBala++;
			}
			else if (UI_contPiratas < UI_qtdPiratas)
			{
				_ilha.definiPremio(IlhaAtor.PREMIO_PIRATAS);
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
			sp.graphics.drawRect(0, 0, UI_mapa_Largura, UI_mapa_Altura);
			sp.graphics.endFill();
			sp.graphics.beginFill(0X0099C, 0.5);
			sp.graphics.drawRect(0, 0, UI_mapa_Largura, UI_mapa_Altura);
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
		
		/****************************************************************************
		 * Contagem de pontuacao
		 * *************************************************************************/
		public function pegouTesouro(_dobj:DisplayObject) {
			UI_tesourosPegos++;
		}

		public function pegouPontosTesouro(_dobj:DisplayObject, _pts:uint) {
			UI_pontos += _pts;
			avisoPontos(_dobj, _pts);
		}
		
		public function destruiCanhao(_dobj:DisplayObject) {
			var pts:uint = param[FaseJogoParamentos.PARAM_PONTOS_CANHAO_ILHA];
			UI_pontos += pts;
			avisoPontos(_dobj, pts);
		}

		public function destruiBarco(_dobj:DisplayObject) {
			var pts:uint = param[FaseJogoParamentos.PARAM_PONTOS_BARCO_INIMIGO];
			UI_pontos += pts;
			avisoPontos(_dobj, pts);
		}

		public function capturouBote(_dobj:DisplayObject) {
			var pts:uint = param[FaseJogoParamentos.PARAM_PONTOS_CAPTURA_BOTE];
			UI_pontos += pts;
			avisoPontos(_dobj, pts);
		}
		
		public function comprouVida(_dobj:DisplayObject,_custo:int) {
			UI_pontos -= _custo;
			avisoPontos(_dobj, -_custo);
		}

		public function comprouMunicao(_dobj:DisplayObject,_custo:int) {
			UI_pontos -= _custo;
			avisoPontos(_dobj, -_custo);
		}
		
		private function avisoPontos(_dobj:DisplayObject , _pontos:int):void {
			var anima:AvisoPontos = new AvisoPontos (_pontos);
			var rt:Rectangle = _dobj.getBounds(stage);
			anima.x = rt.x + ( rt.width / 2 );
			anima.y = rt.y + ( rt.height / 2 );
			this.camadaSup.addChild(anima);
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
		
		public function get qtdTesouros():uint 
		{
			return UI_qtdTesouros;
		}
		
		public function get pontos():uint 
		{
			return UI_pontos;
		}
		
		public function set pontos(value:uint):void 
		{
			UI_pontos = value;
		}
	
		/*******************************************************************************
		 *  metodos de apoio desenvolvimento
		 * ****************************************************************************/
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