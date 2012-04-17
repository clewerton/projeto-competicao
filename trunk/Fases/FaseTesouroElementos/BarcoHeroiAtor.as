package  Fases.FaseTesouroElementos
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	
	
	public class BarcoHeroiAtor extends AtorBase implements AtorInterface
	{
		
		//Direcao do barco em radianos
		private var NU_direcao:Number;
		private var NU_veloX:Number;
		private var NU_veloY:Number;
		private var NU_veloABS:Number;
		private var NU_veloMax:Number;
		private var NU_friccaoVel:Number;
		private var NU_friccaoAng:Number;
		private var NU_friccaoAnc:Number;
		
		private var NU_veloAng:Number;
		private var NU_veloAngMax:Number;
		private var NU_veloAngTax:Number;
		
		
		
		public function BarcoHeroiAtor()
		{
			super(new BarcoHeroi);
			
		}
		
		public function reinicializa():void
		{
			this.x = stage.stageWidth / 2;
			this.y = stage.stageHeight / 2;
			
			NU_direcao = -90 *Math.PI/180;
			NU_veloX = 0;
			NU_veloY = 0;
			NU_veloABS = 0;
			NU_veloAng = 0;
			
			this.rotation = 0;
		}
		public function inicializa():void
		{
			NU_veloAngMax = Math.PI / 45;
			NU_veloAngTax = Math.PI / 5;
			NU_veloMax = 5;
			NU_friccaoVel = 0.98;
			NU_friccaoAng = 0.90;
			NU_friccaoAnc = 0.75;
			
			reinicializa();
						
		}
		public function update(e:Event):void
		{
			if (pressTecla(Keyboard.W))
			{
				NU_veloABS += 1;
			}
			
			if (pressTecla(Keyboard.A))
			{
				NU_veloAng -= NU_veloAngTax;
			}
			
			if (pressTecla(Keyboard.D))
			{
				NU_veloAng += NU_veloAngTax;
			}
			
			if (pressTecla(Keyboard.S))
			{
				NU_veloABS *= NU_friccaoAnc;
				NU_veloAng *= NU_friccaoAnc;
			}
			
			NU_veloABS *= NU_friccaoVel;
			NU_veloAng *= NU_friccaoAng;
			
			calculaVelocidade();
			
			this.x += NU_veloX;
			this.y += NU_veloY;
			this.rotation = (NU_direcao * 180) / Math.PI + 90;
		}
		
		private function calculaVelocidade():void
		{
			if (NU_veloAng > NU_veloAngMax) NU_veloAng = NU_veloAngMax;
			if (NU_veloAng < -NU_veloAngMax) NU_veloAng = -NU_veloAngMax;
			NU_direcao += NU_veloAng;
			
			
			if (NU_veloABS > NU_veloMax) NU_veloABS = NU_veloMax;
			
			NU_veloX = Math.cos(NU_direcao) * NU_veloABS;
			NU_veloY = Math.sin(NU_direcao) * NU_veloABS;
		}
		
		public function remove():void
		{
			
		}
		
		public function get veloY():Number 
		{
			return NU_veloY;
		}
		
		public function get veloX():Number 
		{
			return NU_veloX;
		}
	}
	
}
