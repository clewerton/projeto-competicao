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
	public class Heroi extends AtorBase implements AtorInterface
	{
		
		private var Vx:Number = 0;
		private var Vy:Number = 0;
		private var MC_naveHeroi:MovieClip;
		
		
		public function Heroi() 
		{
			
			MC_naveHeroi = new NaveHeroi();
			super(MC_naveHeroi);
			
		}
		
		
		private function moveHeroi():void {
			
			
			if (pressTecla(Keyboard.UP)) {
				Vy -= 3;
			}
			else if (pressTecla(Keyboard.DOWN)) {
				Vy += 3;
			}
			else {
				Vy = Vy * 0.7;
			}
			
			if (pressTecla(Keyboard.LEFT)) {
				Vx -= 3;
			}
			else if (pressTecla(Keyboard.RIGHT)) {
				Vx += 3;
			}
			else {
				Vx = Vx * 0.7;
			}
			this.y += Vy;
			this.x += Vx;
			
			if (Vx >= 10) {
				Vx = 10;
			}
			else if (Vx <= -10) {
				Vx = -10;
			}
			if (Vy >= 10) {
				Vy = 10;
			}
			else if (Vy <= -10) {
				Vy = - 10;
			}
			
		}
		
		private function limiteHeroi():void { // Limita o Heroi de sair da tela
			
			
			
			if (stage.stageWidth < (this.x + this.width/2)){  //bater na direita
			
				this.x = stage.stageWidth - this.width/2;
				
			}
			if ((this.x - this.width/2) < 0){    //bater na esquerda
			
				this.x= 0 + this.width/2;
				
			}
			if ((this.y - this.height/2) < 0){  //bater no topo
		
				this.y = this.height /2;
				
			}
			if (stage.stageHeight < (this.y + this.height/2)){  // bater em bxo
		
				this.y = stage.stageHeight - this.height /2;
				
			}
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
		public function remove():void { }
			
			
		
		
	}

}