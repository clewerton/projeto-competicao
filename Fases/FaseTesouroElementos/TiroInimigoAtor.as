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
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class TiroInimigoAtor extends AtorBase implements AtorInterface 
	{
		//tipos de tiro
		public static const TTRO_CANHAO_ILHA	:uint  = 1;
		public static const TTRO_CANHAO_BARCO   :uint = 2;

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
			//inverte
			NU_direcao = _direcao + Math.PI;
			
			//tipo do tiro
			UI_tipo = _tiro;
			
			//pontos de dano
			NU_dano = 10;

			//coloca no ponto inicial
			this.x = _pontoIni.x;
			this.y = _pontoIni.y;
			
			//cria o movie clip do tiro
			switch (UI_tipo) 
			{
				case TTRO_CANHAO_ILHA:
					MC_Tiro =  new TiroCanhao;
					NU_VelABS = 10;
					UI_alcance = 500;
				break;
				case TTRO_CANHAO_BARCO:
					MC_Tiro =  new BalaCanhao;
					NU_VelABS = 10;
					UI_alcance = Utils.Rnd( 250, 350 );
				break;
				default:
			}
			
			//registro imagem do tiro
			MC_Tiro.rotation = NU_direcao * Utils.RADIANOS_TO_GRAUS;
			super(MC_Tiro);
			
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
			adcionaClassehitGrupo(BarcoHeroiAtor);
			UI_distancia = 0;
			iniciaAnima(MC_Tiro, "andar");
		}
		
		public function update(e:Event):void 
		{
			controleAnima();
			this.x += NU_VeloX;
			this.y += NU_VeloY;
			UI_distancia += NU_VelABS;
			if (UI_distancia > UI_alcance) {
				var splash:AtorAnimacao;
				var pt:Point = faseAtor.mapa.convertePonto( new Point(this.x, this.y) );
				if (faseAtor.mapa.mapaArray[pt.x][pt.y] == 1) splash = new ImpactoTerra();
				else splash = new SplashAgua();
				
				splash.x = this.x;
				splash.y = this.y;
				splash.rotation = this.rotation;
				faseAtor.addChild(splash);
				marcadoRemocao = true;
			}
		}
		
		public function atingiuAtor( _ator:AtorBase ) {
			//SC_canal = SD_impacto.play(0);
			marcadoRemocao = true;
			AB_atorAtingido = _ator;
		}
		
		public function remove():void 
		{
			
		}
		
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