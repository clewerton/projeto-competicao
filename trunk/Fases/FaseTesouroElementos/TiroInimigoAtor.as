package Fases.FaseTesouroElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class TiroInimigoAtor extends AtorBase implements AtorInterface 
	{
		
		var MC_Tiro:MovieClip;
		//var NU_DirX:Number;
		//var NU_DirY:Number;
		var NU_VeloX:Number;
		var NU_VeloY:Number;
		var NU_VelABS:Number;
		var NU_direcao:Number
		var NU_distancia:Number;
		
		public function TiroInimigoAtor(_direcao:Number) 
		{
			//inverte
			NU_direcao = _direcao + Math.PI;
			
			//valocidade da bala
			NU_VelABS = 5;
			
			//calcula os compenentes de velocidade
			NU_VeloX = Math.cos(direcao) * NU_VelABS;
		    NU_VeloY = Math.sin(direcao) * NU_VelABS;
			
			//cria o movie clip do tiro
			MC_Tiro =  new TiroCanhao;
			MC_Tiro.rotation = NU_direcao * 180 / Math.PI;
			super(MC_Tiro);
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{
			adcionaClassehitGrupo(BarcoHeroiAtor);
			NU_distancia = 0;
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
			NU_distancia += NU_VelABS;
			if (NU_distancia > 500) iniciaAnima(MC_Tiro, "splash");
		}
		
		public function remove():void 
		{
			
		}
		
		public function get distancia():Number 
		{
			return NU_distancia;
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