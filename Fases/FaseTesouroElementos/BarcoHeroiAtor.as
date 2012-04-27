﻿package  Fases.FaseTesouroElementos
{
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	
	public class BarcoHeroiAtor extends AtorBase implements AtorInterface
	{	
		//Upgrade canhão
		public static const UPGRADE_CANHOES_NIVEL0		:uint = 1;
		public static const UPGRADE_CANHOES_NIVEL1		:uint = 2;
		public static const UPGRADE_CANHOES_NIVEL2		:uint = 3;

		//Upgrade de tempo de recarga
		public static const UPGRADE_RECARGA_NIVEL0		:uint = 48;
		public static const UPGRADE_RECARGA_NIVEL1		:uint = 36;
		public static const UPGRADE_RECARGA_NIVEL2		:uint = 24;
		
		//Upgrate do tipo tiro
		public static const UPGRADE_TIRO_NIVEL0			:uint = 0;
		public static const UPGRADE_TIRO_NIVEL1			:uint = 1;
		public static const UPGRADE_TIRO_NIVEL2			:uint = 2;
		
		//Situacao Upgrades
		private var UI_nivelCanhoes	:uint		
		private var UI_nivelRecarga	:uint		
		private var UI_nivelTiro	:uint		

		//Barco
		private var MC_Barco		:MovieClip;
		private var MC_velas		:MovieClip
		
		//Direcao do barco em radianos
		private var NU_direcao		:Number;
		
		//Componentes de velocidade X e Y
		private var NU_veloX		:Number;
		private var NU_veloY		:Number;
		
		//velocidade Absoluta atual
		private var NU_veloABS		:Number;
		
		//valocidade angular atual
		private var NU_veloAng		:Number;

		//limites de velocidade e rotação
		private var NU_veloAngMax	:Number;
		private var NU_veloAngTax	:Number;
		private var NU_veloMaxNor	:Number;
		private var NU_veloMaxRod	:Number;
		
		//coeficientes de fricção
		private var NU_friccaoVel	:Number;
		private var NU_friccaoAng	:Number;
		private var NU_friccaoAnc	:Number;
		
		//variaveis de impacto
		private var NU_impacX		:Number;
		private var NU_impacY		:Number;
		private var NU_impacFric	:Number;
		
		//efeitos especiais
		private var VT_efeitoAtingido	:Vector.<MovieClip>;
		
		//ilha encontrada no raio de interação
		private var IA_IlhaProxima		:IlhaAtor;
		
		//contantes de controle de tiro
		private const ATIRA_ESQUERDA	:uint = 1;
		private const ATIRA_DIREITA		:uint = 2;
		
		//variaveis de controle da salva de tiros do barco heroi
		private var UI_tempoTiroEsq		:uint;
		private var UI_tempoTiroDir		:uint;
		private var UI_tempoSalvaEsq	:uint;
		private var UI_tempoSalvaDir	:uint;
		private var BO_dispararEsq		:Boolean;
		private var BO_dispararDir		:Boolean;
		private var UI_SeqTiroEsq		:uint;
		private var UI_SeqTiroDir		:uint;
		private var UI_tempoRecarga		:uint;
		private var VT_efeitoCanhao		:Vector.<MovieClip> ;
		
		/**
		 * Função contrutora do BarcoHeroi
		 */
		public function BarcoHeroiAtor() {
			//Define a  imagem para o casco do navio
			MC_Barco = new BarcoHeroiCasco;
			super(MC_Barco);
			
			//anexa a imagem da Vela
			MC_velas = new BarcoHeroiVelas;
			this.addChild(MC_velas)
			//posiciona da vela no slot
			MC_velas.x = MC_Barco.slotVela.x;
			MC_velas.y = MC_Barco.slotVela.y;
		}
		
		/*******************************************************************************
		 *       Métodos da inplementados de AtorInterface
		 * ****************************************************************************/
		
		/**
		 * Método inicializa chamado na adição do Ator 
		 * pela FaseBase do ator
		 */
		public function inicializa():void
		{
			this.hitGrupos = new Vector.<Class>;
			this.hitGrupos.push(IlhaAtor);			
			
			NU_veloAngMax = Math.PI / 45;
			NU_veloAngTax = Math.PI / 180;
			NU_veloMaxNor = 10;
			NU_veloMaxRod = 4;
			NU_friccaoVel = 0.98;
			NU_friccaoAng = 0.90;
			NU_friccaoAnc = 0.75;
			NU_impacFric = 0.75;
			
		
			//inicializa upgrades
			iniciaUpgrades();
			
			//inicializa variaveis dos efeitos
			VT_efeitoAtingido = new Vector.<MovieClip>;
			VT_efeitoCanhao   = new Vector.<MovieClip>;
			
			reinicializa();
		
		}
		
		/**
		 * Inicializa upgrades
		 */
		private function iniciaUpgrades():void 
		{
			//upgrades
			UI_nivelCanhoes = UPGRADE_CANHOES_NIVEL0;
			UI_nivelRecarga = UPGRADE_RECARGA_NIVEL0;
			UI_tempoRecarga = UI_nivelRecarga;
			UI_nivelTiro    = UPGRADE_TIRO_NIVEL0;
		}

		
		/**
		 * Método reinicializa chamado na reinicializacao da Fase
		 */
		public function reinicializa():void
		{
			removeEfeitos();
			
			this.x = 0;
			this.y = 0;
			
			NU_direcao = -90 * Utils.GRAUS_TO_RADIANOS;
			NU_veloX = 0;
			NU_veloY = 0;
			NU_veloABS = 0;
			NU_veloAng = 0;
			
			NU_impacY = 0;
			NU_impacX = 0;
			
			IA_IlhaProxima = null;
			
			//zera contador de tempo para o tiro
			UI_tempoTiroEsq = 0;
			UI_tempoTiroDir = 0;
			UI_tempoSalvaEsq = 0;
			UI_tempoSalvaDir = 0;
			BO_dispararEsq = false;
			BO_dispararDir = false;
			UI_SeqTiroEsq	= 0;
			UI_SeqTiroDir	= 0;
		}

		/**
		 * Metodo update chamado no evento update da fase
		 * toda lógica do Enter-Frame deve estar aqui
		 * @param	e
		 * referencia do objeto Event
		 */
		public function update(e:Event):void
		{
			//controle de animaçao de efeitos especiais
			controleEfeitos();
			
			//responde aos comandos de teclado
			controleTeclado();
			
			//calcula velocidade e direção
			calculaVelocidade();
			
			//aplica movimento ao barco
			this.x += NU_veloX + NU_impacX;
			this.y += NU_veloY + NU_impacY;
			this.rotation = NU_direcao * Utils.RADIANOS_TO_GRAUS;
			
			//restringe o movimento do barco dentro dos limites do mpa
			testeLimiteGlobal();
			
			//coloca o barco na camada 
			parent.setChildIndex(this, parent.numChildren - 1);
			
		}
		
		
		/**
		 * Método chamado na remocao do Ator da Fase
		 */
		public function remove():void {
			removeEfeitos();
		}
		
		/***********************************************************************************************
		 * funções usar no  método update
		 * ********************************************************************************************/
		/**
		 * Controle de teclas pressionadas e ações
		 */
		private function controleTeclado():void 
		{
			//TIRA SO PARA TESTE
			if (pressTecla1(Keyboard.NUMBER_1)) UI_nivelCanhoes = UPGRADE_CANHOES_NIVEL0;
			if (pressTecla1(Keyboard.NUMBER_2)) UI_nivelCanhoes = UPGRADE_CANHOES_NIVEL1;
			if (pressTecla1(Keyboard.NUMBER_3)) UI_nivelCanhoes = UPGRADE_CANHOES_NIVEL2;
			
			//Tecla de interacao com a Ilha
			if (pressTecla(Keyboard.E)) interageIlhaProxima();

			//Tecla para avançar
			if (pressTecla(Keyboard.UP))	NU_veloABS += 1;
			
			//tecla para girar para esquerda
			if (pressTecla(Keyboard.LEFT))	NU_veloAng -= NU_veloAngTax;
			
			//tecla para girar para esquerda
			if (pressTecla(Keyboard.RIGHT)) NU_veloAng += NU_veloAngTax;
			
			//tecla para freia (jogar ancora)
			if (pressTecla(Keyboard.DOWN))	{
				NU_veloABS *= NU_friccaoAnc;
				NU_veloAng *= NU_friccaoAnc;
			}
			
			//tecla de tiro para esquerda
			if (BO_dispararEsq) {
				if (atiraCanhoes(ATIRA_ESQUERDA, "UI_tempoSalvaEsq", "UI_SeqTiroEsq")) {
					if (UI_SeqTiroEsq == 0) BO_dispararEsq = false;
				}
			}
			else {
				UI_tempoTiroEsq++;
				if ( UI_tempoTiroEsq >= UI_tempoRecarga ) {
					UI_tempoTiroEsq = UI_tempoRecarga;
					if (pressTecla(Keyboard.A)) {
						BO_dispararEsq = true;
						UI_tempoTiroEsq = 0;
						UI_SeqTiroEsq = 0;
						UI_tempoSalvaEsq = 10;
					}
				}
			}
			
			//tecla de tiro para direita
			if (BO_dispararDir) {
				if (atiraCanhoes(ATIRA_DIREITA, "UI_tempoSalvaDir", "UI_SeqTiroDir" )) {
					if (UI_SeqTiroDir == 0) BO_dispararDir = false;
				}
				trace("disparou direito Seq:", UI_SeqTiroDir, " tempo salva: ",UI_tempoSalvaDir);
			}
			else {
				UI_tempoTiroDir++;
				if ( UI_tempoTiroDir >= UI_tempoRecarga ) {
					UI_tempoTiroDir = UI_tempoRecarga;
					if (pressTecla(Keyboard.D)) {
						BO_dispararDir = true;
						UI_tempoTiroDir = 0;
						UI_SeqTiroDir = 0;
						UI_tempoSalvaDir = 10;
					}
				}
			}
		}
		
		private function atiraCanhoes( _bordo:uint, _tempoSalva:String, _seqTiro:String ):Boolean 
		{
			this[_tempoSalva]++;
			if (this[_tempoSalva] < Utils.Rnd(1, 8) ) return false;
			this[_tempoSalva] = 0;

			this[_seqTiro]++;
			
			if (this[_seqTiro] > UI_nivelCanhoes) {
				this[_seqTiro] = 0;
				return true;
			}
			
			//calcula a direcao do tior
			var ang:Number = this.rotation * Utils.GRAUS_TO_RADIANOS; 
			var rt:Rectangle;
			var canhao:String;
			if (_bordo == ATIRA_DIREITA) {
				ang -= ( Math.PI / 2 );
				canhao = "canhaoDireito" + this[_seqTiro];
			}
			else {
				ang += ( Math.PI / 2 );
				canhao = "canhaoEsquerdo" + this[_seqTiro];
			}
			
			//identifica posicao do canhao que ira atirar
			var mcCanhao:MovieClip = MovieClip(MC_Barco.getChildByName(canhao))
			rt = MovieClip(mcCanhao).getBounds(faseAtor);
			faseAtor.adicionaAtor(new TiroHeroiAtor ( UI_nivelTiro, new Point( rt.x , rt.y ) , ang, NU_veloX , NU_veloY  ));
			
			//cria efeito visual do tiro
			var mcExp:MovieClip =  new ExplosaoCanhao;
			VT_efeitoCanhao.push(mcExp)
			this.addChild(mcExp);
			mcExp.x = mcCanhao.x;
			mcExp.y = mcCanhao.y;
			mcExp.gotoAndPlay("explosao");
			
			return true;
		}
		/**
		 * calcula a velocidade  e rotacao
		 */
		private function calculaVelocidade():void
		{
			//Aplica fricção aos movimentos
			NU_veloABS *= NU_friccaoVel;
			NU_veloAng *= NU_friccaoAng;
			NU_impacX *= NU_impacFric;
			NU_impacY *= NU_impacFric;
			
			//zera as velociades residuais
			if (Math.floor(Math.abs(NU_veloAng)*100) == 0) NU_veloAng = 0;
			if (Math.floor(NU_veloABS*100) == 0) NU_veloABS = 0;
			
			//limita a velociadade angular
			if (NU_veloAng > NU_veloAngMax) NU_veloAng = NU_veloAngMax;
			if (NU_veloAng < -NU_veloAngMax) NU_veloAng = -NU_veloAngMax;
						
			//incrementa velocidade máxima quando não esta em rotação
			if (NU_veloAng == 0)
			{
				if (NU_veloABS > NU_veloMaxNor) NU_veloABS = NU_veloMaxNor;
			}
			else
			{
				if (NU_veloABS > NU_veloMaxRod) NU_veloABS = NU_veloMaxRod;
			}
			
			//incrementa a velocidade angular
			NU_direcao += NU_veloAng;
			
			//calcula componentes X e Y  da velocidade baseado na direção do barco
			NU_veloX = Math.cos(NU_direcao) * NU_veloABS;
			NU_veloY = Math.sin(NU_direcao) * NU_veloABS;
		}
		/**
		 * restringe o movimento do Barco para fora
		 * dos limites do mapa.
		 */
		private function testeLimiteGlobal():void 
		{
			var r:Rectangle = FaseTesouro(faseAtor).limGlob;
			if ( this.x  < r.left + 110 ) this.x = r.left + 110;
			else if ( this.x > r.right - 110  ) this.x = r.right - 110;
			if ( this.y < r.top + 110 ) this.y = r.top + 110;
			else if ( this.y > r.bottom - 110 ) this.y = r.bottom - 110;			
		}
		
		/**
		 * controle das ainimações e efeitos
		 */
		private function controleEfeitos():void 
		{
			//remove efeito do impacto
			var VT_DEL:Vector.<uint> =  new Vector.<uint>; 
			var i:uint;
			var index:uint;
			for ( i = 0 ; i < VT_efeitoAtingido.length ; i++ ) if ( VT_efeitoAtingido[i].currentFrameLabel == "explosaofim" ) VT_DEL.push(i);
			for each ( index in VT_DEL) {
				this.removeChild(VT_efeitoAtingido[index]);
				VT_efeitoAtingido.splice(index, 1);
			}

			//remove efeito do tiro canhao
			VT_DEL =  new Vector.<uint>; 
			for ( i = 0 ; i < VT_efeitoCanhao.length ; i++ ) if ( VT_efeitoCanhao[i].currentFrameLabel == "explosaofim" ) VT_DEL.push(i);
			for each ( index in VT_DEL) {
				this.removeChild(VT_efeitoCanhao[index]);
				VT_efeitoCanhao.splice(index, 1);
			}

		}
		/**
		 * remove todos efeitos
		 */
		private function removeEfeitos():void {
			//remove efeito do impacto
			var i:uint;
			for ( i = 0 ; i < VT_efeitoAtingido.length ; i++ ) this.removeChild(VT_efeitoAtingido[i]);
			//remove efeito do tiro
			for ( i = 0 ; i < VT_efeitoCanhao.length ; i++ ) this.removeChild(VT_efeitoCanhao[i]);
			
			VT_efeitoAtingido = new Vector.<MovieClip>;
			VT_efeitoCanhao = new Vector.<MovieClip>;
		}

		
		/***************************************************************************************
		 * Colisão do Barco Heroi
		 ***************************************************************************************/
		/**
		 * interage com a ilha proxima
		 */
		private function interageIlhaProxima():void 
		{
			if (testaIlhaProxima()) IA_IlhaProxima.interageIlha(this);
		}
		/**
		 * testa se ilha pode interagir
		 * @return
		 * se verdadeiro a ilha pode interagir se falso não
		 */
		private function testaIlhaProxima():Boolean {
			if (IA_IlhaProxima != null) {
				if (IA_IlhaProxima.revelada) {
					IA_IlhaProxima = null;
					return false;
				}
				var dist:Number = IA_IlhaProxima.calculaDistanciaSlot(this);
				if ( dist < IA_IlhaProxima.raioSlot) {
					return true
				}
				else {
					IA_IlhaProxima = null;
					return false;
				}
			}
			return false;
		}
		
		/**
		 * Trata a colisão do Barco Heroi com a ilha
		 * @param	_ilha
		 * ila
		 */
		public function colidiuIlha(_ilha:IlhaAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _ilha, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1 , 1);
			NU_impacY += -Math.sin(ang) * impact;
			NU_impacX += -Math.cos(ang) * impact;
			NU_veloABS = 0;
		}
		
		/**
		 * Ilha avisa quando esta proxima
		 * @param	_ilha
		 */
		public function avisoIlha(_ilha:IlhaAtor) {
			if (_ilha.revelada) return;
			IA_IlhaProxima = _ilha;
		}
		
		/**
		 * gera o efeito de impacto no barco
		 * @param	_impacX
		 * componente do impacto X
		 * @param	_impacY
		 * componente do impacto Y
		 */
		public function geraImpacto(_impacX:Number, _impacY:Number) {
			NU_impacX += _impacX;
			NU_impacY += _impacY;
		}
		
		/**
		 * Trata colisão do Barco com Inimigo
		 * @param	_barcoInimigo
		 * barco inimigo
		 */
		public function colidiuBarcoInimigo(_barcoInimigo:BarcoInimigoAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _barcoInimigo, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1 , 1);
			var impacX:Number = - Math.cos(ang) * impact;		
			var impacY:Number = - Math.sin(ang) * impact;
			NU_impacX += impacX;
			NU_impacY += impacY;
			_barcoInimigo.geraImpacto( -impacX, -impacY);
		}

		/**
		 * Trata a colisão do tiro com barcoHeroi
		 * @param	_tiro
		 * tiro que atingiu o barco
		 */
		public function foiAtingido( _tiro: TiroInimigoAtor) {
			//var ret:Rectangle = Utils.colisaoIntersecao(this, _tiro, faseAtor);
			//if (ret == null) return;
			var mcEfeito:MovieClip = new DanoBarcoHeroi;
			this.addChild(mcEfeito);
			var p:Point = this.globalToLocal (faseAtor.localToGlobal(new Point(_tiro.x, _tiro.y)));  
			mcEfeito.x = p.x;
			mcEfeito.y = p.y;
			mcEfeito.rotation = _tiro.direcao * Utils.RADIANOS_TO_GRAUS;
			VT_efeitoAtingido.push(mcEfeito);
			mcEfeito.gotoAndPlay("explosao");
			_tiro.atingiuAtor( this );
		}		
	}
}
