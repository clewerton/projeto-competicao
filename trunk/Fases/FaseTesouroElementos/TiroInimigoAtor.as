package Fases.FaseTesouroElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
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
		public static const TTRO_CANHAO_ILHA:uint  = 1;
		public static const TTRO_CANHAO_BARCO:uint = 2;
		
		var MC_Tiro:MovieClip;
		//var NU_DirX:Number;
		//var NU_DirY:Number;
		var NU_VeloX:Number;
		var NU_VeloY:Number;
		var NU_VelABS:Number;
		var NU_direcao:Number
		
		//distancia percorrida pelo tiro
		var UI_distancia:Number;
		
		//alcance maximo do tiro
		var UI_alcance:uint;
		
		//tipo de tiro
		var UI_tipo:uint;
		
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

			//coloca no ponto inicial
			this.x = _pontoIni.x;
			this.y = _pontoIni.y;
			
			//cria o movie clip do tiro
			switch (UI_tipo) 
			{
				case TTRO_CANHAO_ILHA:
					MC_Tiro =  new TiroCanhao;
					NU_VelABS = 5;
					UI_alcance = 500;
				break;
				case TTRO_CANHAO_BARCO:
					MC_Tiro =  new BolaCanhaoBarco;
					NU_VelABS = 10;
					UI_alcance = Utils.Rnd( 250, 350 );
				break;
				default:
			}
			
			MC_Tiro.rotation = NU_direcao * Utils.RADIANOS_TO_GRAUS;
			super(MC_Tiro);
			
			
			//calcula os compenentes de velocidade
			NU_VeloX = Math.cos(direcao) * NU_VelABS;
		    NU_VeloY = Math.sin(direcao) * NU_VelABS;
			
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{			
			adcionaClassehitGrupo(BarcoHeroiAtor);
			UI_distancia = 0;
			iniciaAnima(MC_Tiro,"andar")
		}
		
		public function update(e:Event):void 
		{
			if (animacao == "splash") {
				if ( MC_Tiro.currentFrameLabel == "splashfim" ) marcadoRemocao = true;
				return;
			}
			controleAnima();
			this.x += NU_VeloX;
			this.y += NU_VeloY;
			UI_distancia += NU_VelABS;
			if (UI_distancia > UI_alcance) iniciaAnima(MC_Tiro, "splash");
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
		
	}

}