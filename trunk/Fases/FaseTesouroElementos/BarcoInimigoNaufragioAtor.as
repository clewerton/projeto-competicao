package Fases.FaseTesouroElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	
	public class BarcoInimigoNaufragioAtor extends AtorBase implements AtorInterface 
	{
		var MC_Naufragio:MovieClip;
		
		public function BarcoInimigoNaufragioAtor() 
		{
			MC_Naufragio = new BarcoInimigoNaufragio;
			super(MC_Naufragio );
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			
		}
		
		public function inicializa():void 
		{
			MC_Naufragio.gotoAndPlay("naufragio");

		}
		
		public function update(e:Event):void 
		{
			if (MC_Naufragio.currentFrameLabel == "naufragiofim") marcadoRemocao = true;

		}
		
		public function remove():void 
		{
			
		}
		
	}

}