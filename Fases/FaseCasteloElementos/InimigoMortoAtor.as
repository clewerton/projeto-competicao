package Fases.FaseCasteloElementos 
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
	public class InimigoMortoAtor extends AtorBase implements AtorInterface 
	{
		private var MC_corpo:MovieClip
		private var BO_fade:Boolean;
		
		public function InimigoMortoAtor(tipo:uint) 
		{
			if (tipo == 1) MC_corpo = new InimigoMorto1
			
			super(MC_corpo);
			
			
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function inicializa():void 
		{
			MC_corpo.play();
			BO_fade = false;
		}
		
		public function reinicializa():void 
		{

			marcadoRemocao = true;
		}
		
		public function update(e:Event):void 
		{
			if (MC_corpo.currentFrameLabel == "sumindo") BO_fade = true;
			if (BO_fade) MC_corpo.alpha -= 0.1;
			if (MC_corpo.currentFrameLabel == "fim") {
				MC_corpo.stop();
				marcadoRemocao = true;
			}
			
		}
		
		public function remove():void 
		{
			
		}
		
	}

}