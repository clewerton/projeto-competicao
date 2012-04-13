package Fases.FaseEspacoElementos 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Teclado.TeclasControle;
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class Meteoros extends AtorBase implements AtorInterface
	{
		
		private var MC_Meteoro:MovieClip;
		private var Tipo:int;
		
		
		public function Meteoros(Nivel:int) 
		{
			
			MC_Meteoro = new Meteroro();
			super(MC_Meteoro);
			
			Tipo = Rnd(1, 3);
			MC_Meteoro.gotoAndStop(Tipo);
		}
		
		
		private function moveMeteoro():void {
			
			if (Nivel == 1) {
				
				if (Tipo == 1) {
					MC_Meteoro -= 1;
				}
				else if (Tipo == 2) {
					MC_Meteoro -= 2
				}
				else if (Tipo == 3) {
					MC_Meteoro -= 3;
				}
			}
			
			else if (Nivel == 2) {
				if (Tipo == 1) {
					MC_Meteoro -= 2;
				}
				else if (Tipo == 2) {
					MC_Meteoro -= 3;
				}
				else if (Tipo == 3) {
					MC_Meteoro -= 4;
				}
			}
			
			else if (Nivel == 3) {
				if (Tipo == 1) {
					MC_Meteoro -= 3;
				}
				else if (Tipo == 2) {
					MC_Meteoro -= 5;
				}
				else if (Tipo == 3) {
					MC_Meteoro -= 7;
				}
			}
			
			
			
		}
		
		private function limiteMeteoro():void { // verifica a posição dos meteoros 
			
			
			
			
		}
		
		
		public function inicializa():void {
			
		}

		public function reinicializa():void {
			Vx = 0;
			Vy = 0;
		}
		
		public function update(e:Event):void {
			
			moveHeroi();
			limiteHeroi();
			
		}
		public function remove():void {
			
		}
		
		
		static public function Rnd(min:int, max:int):int {
   			if (min <= max) 
  			{
   				return (min + Math.floor( Math.random() * (max - min + 1) ) );
   			}
   			else
   			{
    			throw ( new Error("ERRO valor nimimo maior que o máximo na chamada a fu~ção randomica") + max + "<" + min )
   			}
  		}
			
			
		
		
	}

}