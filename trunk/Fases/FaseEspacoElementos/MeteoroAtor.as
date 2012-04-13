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
	public class MeteoroAtor extends AtorBase implements AtorInterface
	{
		
		private var MC_Meteoro:MovieClip;
		private var Tipo:int = 1;
		private var dificuldade:int;		
		
		public function MeteoroAtor(nivel:int) 
		{
			dificuldade = nivel;
			
			MC_Meteoro = new Meteoro();
			super(MC_Meteoro);
			
			Tipo = Rnd(1, 3);
			MC_Meteoro.gotoAndStop(Tipo);
			//MC_Meteoro.x = stage.stageWidth + MC_Meteoro.width;
			
			this.rotation = Rnd(0, 360);
		}
		
		
		private function moveMeteoro():void {
			
			if (dificuldade == 1) {
				
				if (Tipo == 1) {
					this.x -= 3;
				}
				else if (Tipo == 4) {
					this.x -= 2
				}
				else if (Tipo == 5) {
					this.x -= 3;
				}
			}
			
			else if (dificuldade == 2) {
				if (Tipo == 1) {
					this.x -= 4;
				}
				else if (Tipo == 7) {
					this.x -= 3;
				}
				else if (Tipo == 10) {
					this.x -= 4;
				}
			}
			
			else if (dificuldade == 3) {
				if (Tipo == 1) {
					this.x -= 7;
				}
				else if (Tipo == 2) {
					this.x -= 10;
				}
				else if (Tipo == 3) {
					this.x -= 14;
				}
			}
			
			
			
		}
		
		private function limiteMeteoro():void { // verifica a posição dos meteoros 
			
			if (this.x < 0 - this.width) {
							
				marcadoRemocao = true;
			}

		}
		
		
		public function inicializa():void {
			
		}

		public function reinicializa():void {
			
		}
		
		public function update(e:Event):void {
			
			moveMeteoro();
			limiteMeteoro();
						
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