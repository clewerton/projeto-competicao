package  Fases.FaseTesouroElementos
{
	
	import Fases.FaseTesouro;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	
	public class BarcoHeroiAtor extends AtorBase implements AtorInterface
	{
		
		//Barco
		//Direcao do barco em radianos
		private var NU_direcao:Number;
		private var NU_veloX:Number;
		private var NU_veloY:Number;
		private var NU_veloABS:Number;
		private var NU_veloMaxNor:Number;
		private var NU_veloMaxRod:Number;
		private var NU_friccaoVel:Number;
		private var NU_friccaoAng:Number;
		private var NU_friccaoAnc:Number;
		
		private var NU_veloAng:Number;
		private var NU_veloAngMax:Number;
		private var NU_veloAngTax:Number;
		

		private var NU_impacX:Number;
		private var NU_impacY:Number;
		private var NU_impacFric:Number;
		
		private var NU_AntX:Number;
		private var NU_AntY:Number;
		private var NU_AntAng:Number;
		
		private var IA_IlhaProxima:IlhaAtor;

		public function BarcoHeroiAtor() {
			super(new BarcoHeroi);
		}
		
		public function reinicializa():void
		{
			this.x = 0;
			this.y = 0;
			
			NU_direcao = -90 *Math.PI/180;
			NU_veloX = 0;
			NU_veloY = 0;
			NU_veloABS = 0;
			NU_veloAng = 0;
			
			NU_impacY = 0;
			NU_impacX = 0;
			
			this.rotation = 0;
			
			IA_IlhaProxima = null;
			
		}
		public function inicializa():void
		{
			this.hitGrupos = new Vector.<Class>;
			this.hitGrupos.push(IlhaAtor);			
			
			NU_veloAngMax = Math.PI / 45;
			NU_veloAngTax = Math.PI / 180;
			NU_veloMaxNor = 10;
			NU_veloMaxRod = 4;
			NU_friccaoVel = 0.98;
			NU_friccaoAng = 0.90;
			NU_friccaoAnc = 0.75;
			NU_impacFric = 0.75;
			
			reinicializa();
		
		}
		public function update(e:Event):void
		{
			NU_AntX = this.x;
			NU_AntY = this.y;
			NU_AntAng = this.rotation;
			
			if (pressTecla(Keyboard.E)) interageIlhaProxima();

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
			NU_impacX *= NU_impacFric;
			NU_impacY *= NU_impacFric;
			
			calculaVelocidade();
			
			this.x += NU_veloX + NU_impacX;
			this.y += NU_veloY + NU_impacY;
			this.rotation = (NU_direcao * 180) / Math.PI + 90;
			
			testeLimiteGlobal();

			parent.setChildIndex(this, parent.numChildren - 1);
			
		}
		
		private function interageIlhaProxima():void 
		{
			if (testaIlhaProxima()) IA_IlhaProxima.interageIlha(this);
		}
		
		private function testeLimiteGlobal():void 
		{
			var r:Rectangle = FaseTesouro(faseAtor).limGlob;
			if ( this.x  < r.left + 110 ) this.x = r.left + 110;
			else if ( this.x > r.right - 110  ) this.x = r.right - 110;
			if ( this.y < r.top + 110 ) this.y = r.top + 110;
			else if ( this.y > r.bottom - 110 ) this.y = r.bottom - 110;			
		}
		
		private function calculaVelocidade():void
		{
			if (Math.floor(Math.abs(NU_veloAng)*100) == 0) NU_veloAng = 0;
			if (Math.floor(NU_veloABS*100) == 0) NU_veloABS = 0;
			
			if (NU_veloAng > NU_veloAngMax) NU_veloAng = NU_veloAngMax;
			if (NU_veloAng < -NU_veloAngMax) NU_veloAng = -NU_veloAngMax;
						
			if (NU_veloAng == 0)
			{
				if (NU_veloABS > NU_veloMaxNor) NU_veloABS = NU_veloMaxNor;
			}
			else
			{
				if (NU_veloABS > NU_veloMaxRod) NU_veloABS = NU_veloMaxRod;
			}
			
			NU_direcao += NU_veloAng;
			
			NU_veloX = Math.cos(NU_direcao) * NU_veloABS;
			NU_veloY = Math.sin(NU_direcao) * NU_veloABS;
		}
		
		public function remove():void {
			
		}
		
		
		public function colidiuIlha(_ilha:IlhaAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _ilha, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1 , 1);
			NU_impacY += -Math.sin(ang) * impact;
			NU_impacX += -Math.cos(ang) * impact;
			NU_veloABS = 0;
		}
		
		private function testaIlhaProxima():Boolean {
			if (IA_IlhaProxima != null) {
				if (IA_IlhaProxima.revelada) {
					IA_IlhaProxima = null;
					return false;
				}
				var dist:Number = IA_IlhaProxima.calculaDistanciaSlot(this);
				if ( dist < IA_IlhaProxima.raioSlot) {
					return true
				}
				else {
					IA_IlhaProxima = null;
					return false;
				}
			}
			return false;
		}

		public function avisoIlha(_ilha:IlhaAtor) {
			if (_ilha.revelada) return;
			IA_IlhaProxima = _ilha;
		}
		
		public function geraImpacto(_impacX:Number, _impacY:Number) {
			NU_impacX += _impacX;
			NU_impacY += _impacY;
		}
		
		public function colidiuBarcoInimigo(_barcoInimigo:BarcoInimigoAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _barcoInimigo, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1 , 1);
			var impacX:Number = - Math.cos(ang) * impact;		
			var impacY:Number = - Math.sin(ang) * impact;
			NU_impacX += impacX;
			NU_impacY += impacY;
			_barcoInimigo.geraImpacto( -impacX, -impacY);
		}

		
	}
	
}
