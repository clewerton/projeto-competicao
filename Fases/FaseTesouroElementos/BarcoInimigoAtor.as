package Fases.FaseTesouroElementos 
{
	import Fases.Efeitos.DanoBarcoInimigo;
	import Fases.Efeitos.ExplosaoCanhao;
	import Fases.FaseTesouro;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class BarcoInimigoAtor extends AtorBase implements AtorInterface 
	{
		public const ESTADO_AGUARDANDO        :uint = 1; 
		public const ESTADO_PERSEGUINDO_HEROI :uint = 2; 
		public const ESTADO_ATIRANDO_HEROI    :uint = 3; 
		public const ESTADO_VOLTANDO_ORIGEM   :uint = 4; 
		
		private var MC_barco	:MovieClip;
		private var FB_faseRef	:FaseTesouro;
		private var PT_objetivo	:Point;
		private var PT_alvo		:Point;
		private var PT_origem	:Point;
		private var BO_origem	:Boolean;
		
		//estado do inimigo
		var UI_estado:uint = 0;

		private var NU_distancia:Number;
		
		//conponentes de direcao e movimento do barco
		private var NU_direcao		:Number;
		private var NU_direAlvo		:Number;
		private var NU_direX		:Number;
		private var NU_direY		:Number;
		private var NU_veloX		:Number;
		private var NU_veloY		:Number;
		private var NU_veloABS		:Number;
		private var NU_veloMax		:Number;
		private var NU_veloInc		:Number;
		private var NU_friccaoVel	:Number;
		private var NU_friccaoAng	:Number;
		private var NU_impacY		:Number;
		private var NU_impacX		:Number;
		
		//Controle de Ataque
		private var UI_alcanceTiro		:uint;
		private var MC_canhaoEsquerdo	:MovieClip;
		private var MC_canhaoDireito	:MovieClip;
		private var UI_tiroTempo		:uint;
		private var UI_tiroTempo2		:uint;
		private var UI_tiroSeque		:uint;

		//controle de impacto com a ilha
		//private var UI_travouIlha:uint;
		private var BO_bateuIlha		:Boolean;
		private var UI_bateuIlha		:Number;
		private var UI_naoBateuIlha		:Number;
		
		//variavel de Vida Inimigo
		private var NU_vidaAtual		:Number;
		private var NU_vidaMaxima		:Number;
		private var NU_vidaBarra		:Number;	
	
		//mini barra de vida barco
		private var SP_barraVida		:Sprite;
		private var SP_barraInterna		:Sprite;
		
		private var VT_TEMP				:Vector.<Sprite>;
	
		
		public function BarcoInimigoAtor() 
		{
			MC_barco =  new BarcoPirataCasco;
			super(MC_barco);
			addChild(new BarcoPirataVelas);
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */

		public function inicializa():void 
		{
			//fricao
			NU_friccaoVel = 0.98;
			NU_veloMax = 5;
			
			//valor de vida
			NU_vidaMaxima = 100;
			
			
			//ALCANCE DO TIRO
			UI_alcanceTiro = 300;
			
			//define alvo
			FB_faseRef = FaseTesouro(faseAtor);
		
			adcionaClassehitGrupo(IlhaAtor);
			adcionaClassehitGrupo(BarcoHeroiAtor);
			adcionaClassehitGrupo(BarcoInimigoAtor);
			
			VT_TEMP = new Vector.<Sprite>;
			
			PT_origem = new Point (this.x, this.y) ;
			
			//mini barra de vida
			SP_barraVida = geraSprite(0XFF0000, new Rectangle(0, 0, 50, 5), true);
			faseAtor.addChild(SP_barraVida);
			SP_barraInterna = geraSprite(0XFF0000, new Rectangle(0, 0, 50, 5), false);
			SP_barraVida.addChild(SP_barraInterna);

			//reinicia variaveis
			reinicializa();

		}

		
		public function reinicializa():void 
		{
			NU_direX = 0;
			NU_direY = 0;
			NU_veloX = 0;
			NU_veloY = 0;
			NU_impacX = 0;
			NU_impacY = 0;			
			NU_veloABS = 0
			//UI_travouIlha = 0;
			//NU_desvioIlha = 0;
			UI_bateuIlha = 0;
			BO_bateuIlha = true;
			UI_naoBateuIlha = 0;
			
			//PONTO DE ORIGEM
			BO_origem = false;
			
			//vida atual
			NU_vidaAtual = NU_vidaMaxima;
			NU_vidaBarra = 0;

			
			//alvo
			PT_alvo = new Point;
			UI_tiroTempo = 0;
			UI_tiroTempo2 = 0;
			UI_tiroSeque = 0;
			
			//estado do inimigo
			UI_estado = ESTADO_AGUARDANDO;
			
		}
		
		
		public function update(e:Event):void 
		{	
			
			if ( NU_vidaAtual <= 0 ) { 
				barcoDestruido();
				return;
			}
			
			atualizaBarradeVida();
			
			if (!BO_origem) {
				BO_origem = true;
				PT_origem = new Point(this.x, this.y);
			}
			
			calculaDistanciaBarco();
			
			switch (UI_estado) 
			{
				case ESTADO_AGUARDANDO:
					if (NU_distancia < 500) UI_estado = ESTADO_PERSEGUINDO_HEROI; 
				break;
				case ESTADO_PERSEGUINDO_HEROI:				
					perseguindoAlvo();
				break;
				case ESTADO_ATIRANDO_HEROI:				
					atirandoAlvo();
				break;
				case ESTADO_VOLTANDO_ORIGEM:
					voltandoOrigem();
				break;
				case ESTADO_VOLTANDO_ORIGEM:
					voltandoOrigem();
				break;
				default:
			}
			
			this.x += ( NU_direX * NU_veloABS ) + NU_impacX;
			this.y += ( NU_direY * NU_veloABS ) + NU_impacY;
			NU_impacX = 0 ;
			NU_impacY = 0;
			
			NU_veloABS *= NU_friccaoVel;
			
		}
		
		private function barcoDestruido():void 
		{
			var bote:BoteFugaAtor = new BoteFugaAtor();
			faseAtor.adicionaAtor(bote);
			bote.x = this.x - 20;
			bote.y = this.y;
			
			bote = new BoteFugaAtor();
			faseAtor.adicionaAtor(bote);
			bote.x = this.x ;
			bote.y = this.y + 20;
			
			bote = new BoteFugaAtor();
			faseAtor.adicionaAtor(bote);
			bote.x = this.x + 20;
			bote.y = this.y - 20;
			
			marcadoRemocao = true;
			
			var clonemorte:BarcoInimigoNaufragioAtor = new BarcoInimigoNaufragioAtor();
			
			faseAtor.adicionaAtor(clonemorte);
			
			clonemorte.x = this.x;
			clonemorte.y = this.y;
			clonemorte.rotation = this.rotation;
		}
		
		
		public function remove():void 
		{
			faseAtor.removeChild(SP_barraVida);
		}
		
		/*******************************************************************************
		 *   Perseguindo o Barco Heroi
		 ******************************************************************************/
		/**
		 * Perseguindo o Heroi
		 */
		private function perseguindoAlvo() {
			
			//ESCAPOU
			if (NU_distancia > 1000) {
				UI_estado = ESTADO_VOLTANDO_ORIGEM;
				return;
			}

			//dentro do alcançe do tiro
			if ( NU_distancia < UI_alcanceTiro * 0.8 ) {
				UI_estado = ESTADO_ATIRANDO_HEROI;
				return;
			}
			
			
			verificaPontos();
			
			calculaRotaAlvo()
			
			NU_veloABS += 0.1;
			if ( NU_veloABS > NU_veloMax ) NU_veloABS = NU_veloMax;
			var ajuste:Number = corrigeDirecao(NU_direAlvo);
			this.rotation += ajuste;
			NU_direcao = this.rotation *  Utils.GRAUS_TO_RADIANOS;
			NU_direY = Math.sin(NU_direcao);
			NU_direX = Math.cos(NU_direcao);
			
			
			if (BO_bateuIlha) {
				BO_bateuIlha = false;
				UI_bateuIlha++;
				UI_naoBateuIlha = 0;
			}
			else {
				UI_naoBateuIlha++;
				UI_bateuIlha = 0;
			}
			
			if (UI_naoBateuIlha > 100) {
				
			}
		}
		
		/**
		 * calcula distancia do Barco Heroi
		 */
		private function calculaDistanciaBarco() {	
			PT_alvo.x = FB_faseRef.barcoHeroi.x;
			PT_alvo.y = FB_faseRef.barcoHeroi.y;
			var dx:Number = FB_faseRef.barcoHeroi.x - this.x;
			var dy:Number = FB_faseRef.barcoHeroi.y - this.y;
			NU_distancia = Math.sqrt( ( dx * dx ) + ( dy * dy ) );
		}

		private function calculaRotaAlvo() {
			var dx:Number = PT_objetivo.x - this.x;
			var dy:Number = PT_objetivo.y - this.y;		
			NU_direAlvo =  Math.atan2 ( dy, dx);
		}
		
		private function verificaPontos():void {
			var caminho:Array =  faseAtor.mapa.caminho( new Point (this.x, this.y),  PT_alvo , true);
			if (caminho.length < 3) {
				PT_objetivo = new Point( PT_alvo.x, PT_alvo.y);
			}
			else {
				PT_objetivo = faseAtor.mapa.convertePontoMapa(caminho[1]);
			}			
			//geraQuadradosDebugCaminho(caminho);
		}
		
		/**
		 * Corrige a direcao
		 * @param	_anguloRadiano
		 * angulo objetivo
		 * @param	_rotacaoAtual
		 * rotacao atual
		 * @return
		 * ajuste rotacao a ser apliacada
		 */ 
		private function corrigeDirecao(_anguloRadiano:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * Utils.RADIANOS_TO_GRAUS);
		
			var ajusteMax:Number = 3;
			
			var diferenca:Number = this.rotation -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - this.rotation;
			
			if (ajusteAngulo > ajusteMax) ajusteAngulo = ajusteMax;
			
			if (ajusteAngulo < -ajusteMax) ajusteAngulo = -ajusteMax;
							
			return ajusteAngulo;
			
		}

		/*******************************************************************************
		 *   Atirando no Barco Heroi
		 ******************************************************************************/
		private function atirandoAlvo():void 
		{	
			if ( NU_distancia > UI_alcanceTiro ) {
				UI_estado = ESTADO_PERSEGUINDO_HEROI;
				return;
			}
			
			var dx:Number = FB_faseRef.barcoHeroi.x - this.x;
			var dy:Number = FB_faseRef.barcoHeroi.y - this.y;
			
			
			//antecipa a mira para o futuro ( VELOCIDADE DA BALA = 10);
			dx += FB_faseRef.barcoHeroi.veloX * ( NU_distancia / 10 ); 
			dy += FB_faseRef.barcoHeroi.veloY * ( NU_distancia / 10 ); 
			
			var angulo:Number =  Math.atan2(dy, dx);
			
			var viraEsqueda:Number = angulo + ( Math.PI / 2 );
			var anguloTiro:Number = angulo - ( Math.PI / 2 );
			//lado direito
			var ladoTiro:uint = 1;
			
			//verifica se vira pra esquerda ou direita
			if (Math.abs(calculaAjusteMiraLateral(viraEsqueda)) <  Math.abs(calculaAjusteMiraLateral(anguloTiro))) {
				anguloTiro = viraEsqueda;
				ladoTiro = 2;
			}
			
			//var direcaoAlvo:Number =  angulo * Utils.RADIANOS_TO_GRAUS; 
			
			var ajuste:Number = corrigeDirecao(anguloTiro);
			this.rotation += ajuste;
			NU_direcao = this.rotation *  Utils.GRAUS_TO_RADIANOS;
			NU_direY = Math.sin(NU_direcao);
			NU_direX = Math.cos(NU_direcao);
			
			//verifica se é para atirar
			UI_tiroTempo++;
			UI_tiroTempo2++;
			if ( Math.abs( Math.floor(ajuste) ) < 3 ) atira(ladoTiro);
			
		}
		
		private function atira(_lado:uint):void 
		{
			if (UI_tiroTempo < 50) return;
			if (UI_tiroTempo2 < Utils.Rnd(1,8)) return;
			UI_tiroTempo2 = 0;
			var ang:Number = this.rotation * Utils.GRAUS_TO_RADIANOS; 
			var rt:Rectangle;
			var canhao:String;
			UI_tiroSeque++;
			if (_lado == 1) {
				ang -= ( Math.PI / 2 );
				canhao = "canhaoDireito" + UI_tiroSeque
			}
			else {
				ang += ( Math.PI / 2 );
				canhao = "canhaoEsquerdo" + UI_tiroSeque
			}
			if (UI_tiroSeque >= 3) {
				UI_tiroSeque = 0;
				UI_tiroTempo = 0;
			}
			var mcCanhao:MovieClip = MovieClip(MC_barco.getChildByName(canhao))
			rt = MovieClip(mcCanhao).getBounds(faseAtor);
			faseAtor.adicionaAtor(new TiroInimigoAtor(TiroInimigoAtor.TTRO_CANHAO_BARCO, new Point( rt.x , rt.y ) , ang));
			
			var mcExp:MovieClip =  new ExplosaoCanhao;
			this.addChild(mcExp);
			mcExp.x = mcCanhao.x;
			mcExp.y = mcCanhao.y;
		}
		
		private function calculaAjusteMiraLateral(_anguloRadiano:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * Utils.RADIANOS_TO_GRAUS);
		
			var diferenca:Number = this.rotation -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - this.rotation;
			
			return ajusteAngulo;
		}
		
		/******************************************************************************
		 * voltando para o ponto de origem
		 * ****************************************************************************/
		
		private function voltandoOrigem():void 
		{
			var dx:Number = PT_origem.x - this.x;
			var dy:Number = PT_origem.y - this.y;
			if ( Math.sqrt( ( dx * dx ) + ( dy * dy ) ) < 50 ) {
				UI_estado = ESTADO_AGUARDANDO;
				return
			}

			var caminho:Array =  faseAtor.mapa.caminho( new Point (this.x, this.y),  PT_origem , true);
			if (caminho.length < 3) {
				PT_objetivo = PT_origem;
			}
			else {
				PT_objetivo = faseAtor.mapa.convertePontoMapa(caminho[1]);
			}	
			
			calculaRotaAlvo()
			
			NU_veloABS += 0.1;
			if ( NU_veloABS > NU_veloMax ) NU_veloABS = NU_veloMax;

			var ajuste:Number = corrigeDirecao(NU_direAlvo);
			this.rotation += ajuste;
			NU_direcao = this.rotation *  Utils.GRAUS_TO_RADIANOS;
			NU_direY = Math.sin(NU_direcao);
			NU_direX = Math.cos(NU_direcao);
		}
	
		/************************************************************************************
		 * trata colisões
		 * **********************************************************************************/
		
		public function colidiuIlha(_ilha:IlhaAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _ilha, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1,1);
			NU_impacY -= ( Math.sin(ang) * impact ) ;
			NU_impacX -= ( Math.cos(ang) * impact ) ;
			BO_bateuIlha = true;
		}

		public function colidiuBarcoHeroi(_barcoHeroi:BarcoHeroiAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _barcoHeroi, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1,1);
			var impacX:Number = - Math.cos(ang) * impact;		
			var impacY:Number = - Math.sin(ang) * impact;
			NU_impacX += impacX;
			NU_impacY += impacY;
			_barcoHeroi.geraImpacto( -impacX, -impacY);
		}
		
		public function colidiuBarcoInimigo(_barcoInimigo:BarcoInimigoAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _barcoInimigo, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 0.9 , 0.5 );
			var impacX:Number = - Math.cos(ang) * impact;		
			var impacY:Number = - Math.sin(ang) * impact;
			NU_impacX += impacX;
			NU_impacY += impacY;
			_barcoInimigo.geraImpacto( -impacX, -impacY);
		}
		
		public function geraImpacto(_impacX:Number, _impacY:Number) {
			NU_impacX += _impacX;
			NU_impacY += _impacY;
		}
		
		private function geraQuadradosDebugCaminho(_caminho:Array) {
			var m:Sprite;
			var p:Point;
			var i:uint;
			for ( i = 0; i < VT_TEMP.length; i++) faseAtor.removeChild(VT_TEMP[i]);
			VT_TEMP = new Vector.<Sprite>;
			for (i = 0 ; i < _caminho.length ; i++) {
				m = faseAtor.mapa.geraSprite(0X00FF00);
				VT_TEMP.push(m);
				faseAtor.addChild(m);
				p = faseAtor.mapa.convertePontoMapa(_caminho[i]);
				m.x = p.x;
				m.y = p.y;
			}
		}
		
		/**
		 * Trata a colisão do tiro com barcoHeroi
		 * @param	_tiro
		 * tiro que atingiu o barco
		 */
		public function foiAtingido( _tiro: TiroHeroiAtor) {
			//var ret:Rectangle = Utils.colisaoIntersecao(this, _tiro, faseAtor);
			//if (ret == null) return;
			var mcEfeito:MovieClip = new DanoBarcoInimigo;
			this.addChild(mcEfeito);
			var p:Point = this.globalToLocal (faseAtor.localToGlobal(new Point(_tiro.x, _tiro.y)));  
			mcEfeito.x = p.x;
			mcEfeito.y = p.y;
			mcEfeito.rotation = (_tiro.direcao * Utils.RADIANOS_TO_GRAUS) ;
			_tiro.atingiuAtor( this );
			NU_vidaAtual -= _tiro.dano;
		}
		
		/*************************************************************************************
		 * Mini HUD de vida
		 ************************************************************************************/
		
		private function atualizaBarradeVida():void 
		{
			SP_barraVida.x = this.x - 25 ;
			SP_barraVida.y = this.y - 80; 
			faseAtor.setChildIndex(SP_barraVida, faseAtor.numChildren - 1);
			if ( NU_vidaBarra != NU_vidaAtual) {
				NU_vidaBarra = NU_vidaAtual
		    	var tam:Number =  SP_barraVida.width * ( NU_vidaAtual / NU_vidaMaxima );
				SP_barraInterna.scrollRect = new Rectangle(0,0, tam ,SP_barraInterna.height)
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