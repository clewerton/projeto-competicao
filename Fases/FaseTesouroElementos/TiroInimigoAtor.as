package Fases.FaseTesouroElementos 
{
	import Fases.Efeitos.ImpactoTerra;
	import Fases.Efeitos.SplashAgua;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import TangoGames.Atores.AtorAnimacao;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	public class TiroInimigoAtor extends AtorBase implements AtorInterface 
	{
		//tipos de tiro
		public static const TTRO_CANHAO_ILHA		:uint  = 1;
		public static const TTRO_CANHAO_BARCO   	:uint  = 2;
		
		//tipo de tiro
		private var UI_tipo			:uint;

		//imagem do tiro
		private var MC_Tiro			:MovieClip;
		
		//controle de velocidade e direcao
		private var NU_VeloX		:Number;
		private var NU_VeloY		:Number;
		private var NU_VelABS		:Number;
		private var NU_direcao		:Number
		
		//pontos de dano do tiro
		private var NU_dano 		:Number;
		
		//distancia percorrida pelo tiro
		private var UI_distancia	:Number;
		
		//alcance maximo do tiro
		private var UI_alcance		:uint;
		
		//ator atingido
		private var AB_atorAtingido: AtorBase;
		
		/**
		 * Cria novo tiro
		 * @param	_tiro
		 * tipo do tiro
		 * @param	_pontoIni
		 * ponto inicia que o diro será criado
		 * @param	_direcao
		 * direcao que do tiro
		 */
		public function TiroInimigoAtor(  _tiro:uint, _pontoIni:Point, _direcao:Number ) 
		{
			//tipo do tiro
			UI_tipo = _tiro;
			
			//coloca no ponto inicial
			this.x = _pontoIni.x;
			this.y = _pontoIni.y;
			
			//direção do tiro
			NU_direcao = _direcao;
			
			//cria o movie clip do tiro
			switch (UI_tipo) 
			{
				case TTRO_CANHAO_ILHA:
					MC_Tiro    =  new TiroCanhao;
				break;
				case TTRO_CANHAO_BARCO:
					MC_Tiro    =  new BalaCanhao;
				break;
				default:
			}
			
			super(MC_Tiro);
			
		}
		
		public function calculaVariaveisIniciais() {
			
			//cria o movie clip do tiro
			switch (UI_tipo) 
			{
				case TTRO_CANHAO_ILHA:
					UI_alcance = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_ILHA_ALCANCE];
					UI_alcance *= ( (Math.random() * 0.2 ) + 0.9 );
					//velocidade do tiro
					NU_VelABS  = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_ILHA_VELOCID];
					//pontos de dano
					NU_dano    = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_ILHA_DANO];
				break;
				case TTRO_CANHAO_BARCO:
					UI_alcance = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_INIMIGO_ALCANCE];
					//inclui randomico de 10% +-
					UI_alcance *= ( (Math.random() * 0.2 ) + 0.9 );
					//velocidade do tiro
					NU_VelABS  = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_INIMIGO_VELOCID ];
					//pontos de dano
					NU_dano    = faseAtor.param[FaseJogoParamentos.PARAM_TIRO_INIMIGO_DANO];
				break;
				default:
			}
			
			//registro imagem do tiro
			MC_Tiro.rotation = NU_direcao * Utils.RADIANOS_TO_GRAUS;
			
			//calcula os compenentes de velocidade
			NU_VeloX = Math.cos(direcao) * NU_VelABS;
		    NU_VeloY = Math.sin(direcao) * NU_VelABS;
			
			//ator atingido
			AB_atorAtingido = null;
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{	
			//calcula variaveis iniciais
			calculaVariaveisIniciais();
			
			//adiciona hit teste grupo
			adcionaClassehitGrupo(BarcoHeroiAtor);
			
			//inicializa distancia percorrida
			UI_distancia = 0;
			
			//inica animacao do tiro
			iniciaAnima(MC_Tiro, "andar");
		}
		
		public function update(e:Event):void 
		{
			controleAnima();
			this.x += NU_VeloX;
			this.y += NU_VeloY;
			UI_distancia += NU_VelABS;
			if (UI_distancia > UI_alcance) fimAlcance();
		}

		public function remove():void 
		{
			
		}
		
		
		/*****************************************************************
		 * métodos chamados update
		 * **************************************************************/
		/**
		 * tiro atingiu ator
		 * @param	_ator
		 * referencia do objeto atingido
		 */
		public function atingiuAtor( _ator:AtorBase ) {
			marcadoRemocao = true;
			AB_atorAtingido = _ator;
		}
		/**
		 * final do alcance do tiro
		 */
		public function fimAlcance() {
			var splash:AtorAnimacao;
			var pt:Point = faseAtor.mapa.convertePonto( new Point(this.x, this.y) );
			if (faseAtor.mapa.mapaArray[pt.x][pt.y] == 1) splash = new ImpactoTerra();
			else splash = new SplashAgua();
			//animacao de splash da água ou de terra
			splash.x = this.x;
			splash.y = this.y;
			splash.rotation = this.rotation;
			faseAtor.addChild(splash);
			marcadoRemocao = true;
		}
		
		/****************************************************************
		 * propriedades públicas da classe
		 ****************************************************************/
		 
		public function get distancia():Number 
		{
			return UI_distancia;
		}
		
		public function get direcao():Number 
		{
			return NU_direcao;
		}
		
		public function get VelABS():Number 
		{
			return NU_VelABS;
		}
		
		public function get dano():Number 
		{
			return NU_dano;
		}
		
	}

}