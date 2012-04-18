package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
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
		private var MC_premio: MovieClip;
		private var UI_premioID: uint;
		
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
			UI_premioID = 0;
		}
		
		public function inicializa():void {
			reinicializa()
		}
		public function update(e:Event):void {
			
		}
		
		public function remove():void {
			
		}
		
		public function definiPremio(_premio:uint):void {
			UI_premioID = _premio;
			if (FaseTesouro.PREMIO_TESOURO ==  _premio) {
				MC_premio = new Slot01;
				DisplayObjectContainer(MC_ilha.slot).addChild(MC_premio);
			}
		}
		
	}

}