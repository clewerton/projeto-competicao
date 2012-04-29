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
	public class TiroHeroiAtor extends AtorBase implements AtorInterface 
	{
		//tipos de tiro
		public static const TTRO_HEROI_NIVEL0:uint  = 0;
		public static const TTRO_HEROI_NIVEL1:uint  = 1;
		public static const TTRO_HEROI_NIVEL2:uint  = 2;

		//tipo de tiro
		var UI_tipo			:uint;

		//imagem do tiro
		var MC_Tiro:MovieClip;
		
		//controle de velocidade e direção
		var NU_VeloX		:Number;
		var NU_VeloY		:Number;
		var NU_VelABS		:Number;
		var NU_direcao		:Number
		
		//pontos de dano do tiro
		var NU_dano 		:Number;
		
		//distancia percorrida pelo tiro
		var UI_distancia	:Number;
		
		//alcance maximo do tiro
		var UI_alcance		:uint;
		
		//ator atingido
		private var AB_atorAtingido: AtorBase;
		
		//
		/**
		 * Cria novo tiro
		 * @param	_tiro
		 * tipo do tiro
		 * @param	_pontoIni
		 * ponto inicia que o diro será criado
		 * @param	_direcao
		 * direcao que do tiro
		 * @param   _deslocX  
		 * componente X de velocidade de delocamento
		 * @param   _deslocY  
		 * componente Y de velocidade de delocamento
		 */
		public function TiroHeroiAtor(  _tiro:uint, _pontoIni:Point, _direcao:Number, _deslocX:Number = 0, _deslocY:Number = 0 ) 
		{
			//inverte
			NU_direcao = _direcao + Math.PI;
			
			//tipo do tiro
			UI_tipo = _tiro;

			//coloca no ponto inicial
			this.x = _pontoIni.x;
			this.y = _pontoIni.y;
			
			//cria o movie clip do tiro
			switch (UI_tipo) 
			{
				case TTRO_HEROI_NIVEL0:
					MC_Tiro =  new BalaCanhao;
					NU_VelABS = 8;
					UI_alcance = Utils.Rnd( 200, 250 );
					NU_dano = 10;
				break;
				case TTRO_HEROI_NIVEL1:
					MC_Tiro =  new BalaCanhao;
					NU_VelABS = 10;
					UI_alcance = Utils.Rnd( 250, 300 );
					NU_dano = 15;
				break;
				case TTRO_HEROI_NIVEL2:
					MC_Tiro =  new BalaCanhao;
					NU_VelABS = 12;
					UI_alcance = Utils.Rnd( 300, 400 );
					NU_dano = 20;
				break;
				default:
			}
			
			//imagem do tiro
			MC_Tiro.rotation = NU_direcao * Utils.RADIANOS_TO_GRAUS;
			super(MC_Tiro);
			
			
			//calcula os compenentes de velocidade
			NU_VeloX = ( Math.cos(direcao) * NU_VelABS ) + _deslocX;
		    NU_VeloY = ( Math.sin(direcao) * NU_VelABS ) + _deslocY;
			
			//ator atingido
			AB_atorAtingido = null;
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{			
			adcionaClassehitGrupo(BarcoInimigoAtor);
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