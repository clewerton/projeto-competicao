package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import fl.motion.AnimatorBase;
	import fl.motion.Source;
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
		private var VT_efeitoExplosao	:Vector.<MovieClip>;
		private var SC_canalCanhao1		:SoundChannel;
		private var SC_canalCanhao2		:SoundChannel;
		private var SC_canalCanhao3		:SoundChannel;
		private var SD_somCanhao		:Sound;

				
		//controle de impacto com a ilha
		//private var UI_travouIlha:uint;
		private var BO_bateuIlha		:Boolean;
		private var UI_bateuIlha		:Number;
		private var UI_naoBateuIlha		:Number;
		
		private var VT_TEMP				:Vector.<Sprite>
		
		public function BarcoInimigoAtor() 
		{
			MC_barco =  new BarcoPirataCasco;
			super(MC_barco);
			addChild(new BarcoPirataVelas);
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
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
			
			//alvo
			PT_alvo = new Point;
			UI_tiroTempo = 0;
			UI_tiroTempo2 = 0;
			UI_tiroSeque = 0;
			VT_efeitoExplosao = new Vector.<MovieClip>;
			SD_somCanhao = new somCanhao;
			SC_canalCanhao1 = new SoundChannel;
			SC_canalCanhao2 = new SoundChannel;
			SC_canalCanhao3 = new SoundChannel;
			
			//estado do inimigo
			UI_estado = ESTADO_AGUARDANDO;
		}
		
		public function inicializa():void 
		{
			//fricao
			NU_friccaoVel = 0.98;
			NU_veloMax = 5;
			
			//ALCANCE DO TIRO
			UI_alcanceTiro = 300;
			
			//define alvo
			FB_faseRef = FaseTesouro(faseAtor);
		
			adcionaClassehitGrupo(IlhaAtor);
			adcionaClassehitGrupo(BarcoHeroiAtor);
			adcionaClassehitGrupo(BarcoInimigoAtor);
			
			VT_TEMP = new Vector.<Sprite>;
			
			PT_origem = new Point (this.x, this.y) ;
			
			reinicializa();
		}
		
		public function update(e:Event):void 
		{
			if (!BO_origem) {
				BO_origem = true;
				PT_origem = new Point(this.x, this.y);
			}
			
			calculaDistanciaBarco();
			
			efeitoExplosao();
			
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
				default:
			}
			
			this.x += ( NU_direX * NU_veloABS ) + NU_impacX;
			this.y += ( NU_direY * NU_veloABS ) + NU_impacY;
			NU_impacX = 0 ;
			NU_impacY = 0;
			
			NU_veloABS *= NU_friccaoVel;
			
		}
		
		public function remove():void 
		{
			
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
			VT_efeitoExplosao.push(mcExp)
			this.addChild(mcExp);
			mcExp.x = mcCanhao.x;
			mcExp.y = mcCanhao.y;
			mcExp.gotoAndPlay("explosao");
			
			switch (UI_tiroSeque) {
				case 0:
					SC_canalCanhao1 = SD_somCanhao.play(0);
				break;
				case 1:
					SC_canalCanhao2 = SD_somCanhao.play(0);
				break;
				case 2:
					SC_canalCanhao3 = SD_somCanhao.play(0);
				break;
			}
		}
		
		private function calculaAjusteMiraLateral(_anguloRadiano:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * Utils.RADIANOS_TO_GRAUS);
		
			var diferenca:Number = this.rotation -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - this.rotation;
			
			return ajusteAngulo;
		}

		
		private function efeitoExplosao():void 
		{
			var VT_DEL:Vector.<uint> =  new Vector.<uint>; 
			var i:uint;
			for ( i = 0 ; i < VT_efeitoExplosao.length ; i++ ) if ( VT_efeitoExplosao[i].currentFrameLabel == "explosaofim" ) VT_DEL.push(i);
			for each ( var index:uint in VT_DEL) {
				this.removeChild(VT_efeitoExplosao[index]);
				VT_efeitoExplosao.splice(index, 1);
			}
			VT_DEL =  new Vector.<uint>; 
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

	}

}