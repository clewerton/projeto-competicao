package Fases.FaseTesouroElementos 
{
	import Fases.Efeitos.DanoBarcoInimigo;
	import Fases.Efeitos.ExplosaoTiroCanhaoGr;
	import Fases.FaseTesouro;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import TangoGames.Atores.AtorAnimacao;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	public class CanhaoIlhaAtor extends AtorBase implements AtorInterface 
	{
		//constantes de estado do canhão
		public const ESTADO_AGUARDANDO        	:uint = 1; 
		public const ESTADO_MIRANDO_HEROI		:uint = 2; 
		public const ESTADO_ATIRANDO_HEROI    	:uint = 3; 
		
		//imagem do canhão
		private var MC_canhao			:MovieClip;
		
		//ilha a qual pertence o canhão pirata
		private var AB_ilhaCanhao		:IlhaAtor
		
		//Referencia do Barco Heroi Alvo
		private var AB_barcoHeroiAlvo	:BarcoHeroiAtor;
		
		//estado atual do inimigo
		private var UI_estado			:uint = 0;
		
		//variaveis componentes da distancia
		private var NU_distX			:Number;
		private var NU_distY			:Number;
		private var NU_distancia		:Number;

		//Ponto onde esta o Alvo
		private var PT_alvo				:Point;
		
		//variáveis de controle da frequancia de Tiro do canhão
		private var UI_freqTiro			:uint;
		private var UI_contTiro			:uint;
		
		//variavis de controle de mira antecipada
		private var UI_distMinMirar		:uint;	
		
		//ajuste do angulo do canhão
		private var UI_velAngMax		:uint;
		private var NU_ajusteAng		:Number;
		
		//direcao do canhao em radianos
		private var NU_direcao			:Number;
		
		//controle de vida do canhão pirata
		private var NU_vidaAtual		:Number;
		private var NU_vidaMaxima		:Number;
		private var NU_vidaBarra		:Number;

		//mini barra de vida 
		private var SP_barraVida		:Sprite;
		private var SP_barraInterna		:Sprite;
		
		//tiro do canhao
		private var UI_tiroAlcance		:uint;
		private var UI_tiroVelocidade	:uint;
		private var UI_tiroPrecisao		:uint;
		private var UI_tiroPreciso		:Boolean;
		private var UI_tiroAngDispersao :uint;
		
		public function CanhaoIlhaAtor(_ilha:IlhaAtor) 
		{
			AB_ilhaCanhao = _ilha;
			
			MC_canhao = new Slot04;
			
			super(MC_canhao);
			
			MC_canhao.gotoAndStop("normal");
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function inicializa():void 
		{	
			//atualiza referencia do barco heroi
			AB_barcoHeroiAlvo = FaseTesouro(faseAtor).barcoHeroi;
			
			//inicializa variaveis para calculo do alvo
			PT_alvo =  new Point();
			NU_distX = 0;
			NU_distY = 0;
			
			//velocidade máxima angular do canhão pirata
			UI_velAngMax = 3;
			
			//informações sobre o tiro
			UI_tiroAlcance		= faseAtor.param[FaseJogoParamentos.PARAM_TIRO_ILHA_ALCANCE];
			UI_tiroVelocidade	= faseAtor.param[FaseJogoParamentos.PARAM_TIRO_ILHA_VELOCID];
			UI_tiroPrecisao		= faseAtor.param[FaseJogoParamentos.PARAM_ILHA_CANHAO_PRECISAO];
			UI_tiroPreciso		= faseAtor.param[FaseJogoParamentos.PARAM_ILHA_CANHAO_MIRA_PRECISA];
			UI_tiroAngDispersao = faseAtor.param[FaseJogoParamentos.PARAM_ILHA_CANHAO_ANG_DISPERSAO];
			//variavis de controle de mira antecipada
			UI_distMinMirar = UI_tiroAlcance * 1.25;
			
			//frequencia de tiro em frames
			UI_freqTiro         = faseAtor.param[FaseJogoParamentos.PARAM_ILHA_CANHAO_FREQ_TIRO];
			
			//valor de vida máxima do canhão pirata
			NU_vidaMaxima 		= faseAtor.param[FaseJogoParamentos.PARAM_ILHA_CANHAO_MAX_VIDA];
			
			//mini barra de vida
			SP_barraVida = geraSprite(0XFF0000, new Rectangle(0, 0, 50, 5), true);
			faseAtor.addChild(SP_barraVida);
			SP_barraInterna = geraSprite(0XFF0000, new Rectangle(0, 0, 50, 5), false);
			SP_barraVida.addChild(SP_barraInterna);
			
			reinicializa();
			
		}
		
		public function reinicializa():void 
		{
			//estado inicial do canhão
			UI_estado = ESTADO_AGUARDANDO;
			
			//valor do ajusta a ser aplicado
			NU_ajusteAng = 0;
			
			//angulo de direcao do canhão
			NU_direcao	= this.rotation * Utils.GRAUS_TO_RADIANOS;
			
			//vida atual canhão pirata
			NU_vidaAtual = NU_vidaMaxima;
			NU_vidaBarra = 0;
			
		}
		
		public function update(e:Event):void 
		{
			//barco foi destruido
			if ( NU_vidaAtual <= 0 ) { 
				marcadoRemocao = true;
				AB_ilhaCanhao.canhaoPirataDestruido()
				return;
			}
			
			//calcula distancia do Alvo e componentes
			calculaDistanciaAlvo();
			
			//barra de vida
			atualizaBarradeVida();
			
			switch (UI_estado) 
			{
				case ESTADO_AGUARDANDO:
					if (NU_distancia <= UI_distMinMirar) UI_estado = ESTADO_MIRANDO_HEROI;
				break;
				case ESTADO_MIRANDO_HEROI:
					atualizaMira();
					if (NU_distancia <= UI_tiroAlcance) UI_estado = ESTADO_ATIRANDO_HEROI;
					else if (NU_distancia > UI_distMinMirar) UI_estado = ESTADO_AGUARDANDO;
					UI_contTiro = UI_freqTiro;
				break;
				case ESTADO_ATIRANDO_HEROI:
					atualizaMira();
					disparaCanhao();
					if (NU_distancia > UI_tiroAlcance) UI_estado = ESTADO_MIRANDO_HEROI;
				break;
				default:
			}
		}
		
		public function remove():void 
		{
			faseAtor.removeChild(SP_barraVida);
		}
		
		/**************************************************************************
		 * controle de ação do canhão
		 * ***********************************************************************
		/**
		 * corrige algulo de mira do canhão
		 */
		private function atualizaMira():void {
			var dx:Number = NU_distX ;
			var dy:Number = NU_distY ;

			//antecipa a mira para destino do barco heroi
			if (UI_tiroPreciso) {
				dx += AB_barcoHeroiAlvo.veloX * ( NU_distancia / UI_tiroVelocidade ); 
				dy += AB_barcoHeroiAlvo.veloY * ( NU_distancia / UI_tiroVelocidade );
			}
			
			var ang = Math.atan2(dy, dx);

			NU_ajusteAng = corrigeDirecaoAlvo(ang, this.rotation);
			
			this.rotation += NU_ajusteAng;
			
			NU_direcao	= this.rotation * Utils.GRAUS_TO_RADIANOS;
			
		}
		 
		
		/******************************************************************
		 *  Controle do canhão pirata 
		 * ***************************************************************/
		/**
		 * calcula distancia do Barco Heroi
		 */
		private function calculaDistanciaAlvo() {	
			PT_alvo.x = AB_barcoHeroiAlvo.x;
			PT_alvo.y = AB_barcoHeroiAlvo.y;
			NU_distX = PT_alvo.x - this.x;
			NU_distY = PT_alvo.y - this.y;
			NU_distancia = Math.sqrt( ( NU_distX * NU_distX ) + ( NU_distY * NU_distY ) );
		}
		 
		/**
		 * disparo do canhão
		 */
		private function disparaCanhao() {
			UI_contTiro ++;
			if (UI_contTiro > UI_freqTiro) {
				if (Math.abs( NU_ajusteAng ) < UI_velAngMax ) {
					//calcula erro de dispersoa do tiro
					var erro:Number = 0;
					if (UI_tiroPrecisao < 100) {
						if ( Utils.Rnd( 0, 99 ) > UI_tiroPrecisao ) {
							var dif:Number = UI_tiroAngDispersao * Utils.GRAUS_TO_RADIANOS;
							erro =  ( ( dif * Math.random() ) - ( dif /2 ) );
						}
					}
					var rt:Rectangle = MovieClip(MC_canhao.canhaoponta).getBounds(faseAtor);
					faseAtor.adicionaAtor(new TiroInimigoAtor(TiroInimigoAtor.TTRO_CANHAO_ILHA, new Point(rt.x, rt.y), ( NU_direcao + erro ) ) );
					//cria efeito do tiro
					var efeito:AtorAnimacao = new ExplosaoTiroCanhaoGr();
					this.addChild(efeito);
					efeito.x = MC_canhao.canhaoponta.x;
					efeito.y = MC_canhao.canhaoponta.y;
					UI_contTiro = 0;
				}
			}
		}

		/**
		 * Corrige a direcao do canhão
		 * @param	_anguloRadiano
		 * angulo objetivo
		 * @param	_rotacaoAtual
		 * rotacao atual do canhão
		 * @return
		 * ajuste rotacao a ser apliacada ao canhão
		 */ 
		private function corrigeDirecaoAlvo(_anguloRadiano:Number, _rotacaoAtual:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * 180 / Math.PI) ;
			
			var diferenca:Number = _rotacaoAtual -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - _rotacaoAtual;
			
			if (ajusteAngulo > UI_velAngMax) ajusteAngulo = UI_velAngMax;
			
			if (ajusteAngulo < -UI_velAngMax) ajusteAngulo = -UI_velAngMax;
							
			return ajusteAngulo;
		}
		
		/************************************************************************************
		 * trata colisões
		 * **********************************************************************************/
		
		/**
		 * Trata a colisão do tiro do heroi
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