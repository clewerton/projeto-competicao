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
	public class InimigoAtor extends AtorBase implements AtorInterface 
	{
		private var MC_Inimigo:MovieClip;
		private var NU_veloc:Number;
		private var NU_velX:Number;
		private var NU_velY:Number;
		private var BO_ataca:Boolean;
		private var CA_alvo:Castelo
		
		public function InimigoAtor(alvoCastelo:Castelo) 
		{
			MC_Inimigo = new Inimigo1;
			super(MC_Inimigo);
			CA_alvo = alvoCastelo;
		}
		public function inicializa():void {
			NU_veloc = 1;
			reinicializa();
		}

		public function reinicializa():void {
			BO_ataca = true;
			NU_velX = 0;
			NU_velY = 0;
			calcularRota();
		}
		
		public function update(e:Event):void {
			if (BO_ataca) {
				this.x += NU_velX;
				this.y += NU_velY;
			}
		}
		public function remove():void { };
		
		private function calcularRota():void {
			var ang:Number = Math.atan2(CA_alvo.y - this.y , CA_alvo.x - this.x);
			NU_velX =  Math.cos(ang) * NU_veloc;
			NU_velY =  Math.sin(ang) * NU_veloc;
		}
	}
}