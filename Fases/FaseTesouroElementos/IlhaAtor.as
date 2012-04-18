package Fases.FaseTesouroElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class IlhaAtor extends AtorBase implements AtorInterface{
		
		private var MC_ilha:MovieClip;
		
		public function IlhaAtor() 
		{
			var sort:int = Utils.Rnd(1, 4);
			switch (sort) 
			{
				case 1:
					MC_ilha = new IlhaBase01;
				break;
				case 2:
					MC_ilha = new IlhaBase02;
				break;
				case 3:
					MC_ilha = new IlhaBase03;
				break;
				case 4:
					MC_ilha = new IlhaBase04;
				break;
				default:
					MC_ilha = new IlhaBase01;				
			}
			MC_ilha.rotation = Utils.Rnd(0, 359);
			super(MC_ilha);
		}
		
		public function reinicializa():void {
			
		}
		
		public function inicializa():void {
			
		}
		public function update(e:Event):void {
			
		}
		
		public function remove():void {
			
		}
		
	}

}