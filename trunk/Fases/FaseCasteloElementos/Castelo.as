package Fases.FaseCasteloElementos 
{
	import fl.motion.AnimatorBase;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Castelo extends AtorBase implements AtorInterface
	{
		private var MC_castelo:MovieClip;
		private var MC_heroi:MovieClip;
		private var OB_Torres:Object;
		private var ST_posicaoHeroi:String ;
		private var MC_destino:MovieClip;
		private var ST_destinoHeroi:String ;
		private var BO_calculaRota:Boolean;
		//private var BO_andandoParaCentro:Boolean;
		private var BO_andandoParaDestino:Boolean;
		private var NU_velocHeroi:Number;
		private var NU_velXHeroi:Number;
		private var NU_velYHeroi:Number;
		private var PT_saidaTorre:Point;
		//private var PT_direcentro:Point;
		
		
		public function Castelo() {
			MC_castelo = new CasteloBase();
			super(MC_castelo);
			
			MC_heroi = new PersonagemTorre();
			this.addChild(MC_heroi);
			
			
		}
		
		public function inicializa():void {
			NU_velocHeroi = 5;
			OB_Torres = new Object;
			OB_Torres[MovieClip(MC_castelo.Hitbox1).name] = MC_castelo.Hitbox1;
			OB_Torres[MovieClip(MC_castelo.Hitbox2).name] = MC_castelo.Hitbox2;
			OB_Torres[MovieClip(MC_castelo.Hitbox3).name] = MC_castelo.Hitbox3;
			OB_Torres[MovieClip(MC_castelo.Hitbox4).name] = MC_castelo.Hitbox4;
			OB_Torres[MovieClip(MC_castelo.Hitbox5).name] = MC_castelo.Hitbox5;
			OB_Torres[MovieClip(MC_castelo.centro).name] = MC_castelo.centro;
			reinicializa();
		}

		public function reinicializa():void {
			//BO_andandoParaCentro = false;
			BO_andandoParaDestino = false;
			PT_saidaTorre = new Point(0, 0);
			MC_heroi.x = 0;
			MC_heroi.y = 0;
			ST_destinoHeroi = "";
			BO_calculaRota = false;
			ST_posicaoHeroi = "centro";
			NU_velXHeroi = 0;
			NU_velYHeroi = 0;
			MC_heroi.scaleX = 1;
			MC_heroi.scaleY = 1;
			MC_castelo.addEventListener(MouseEvent.CLICK, clickTorre, false, 0, true);
		}
		
		public function update(e:Event):void {
			if (BO_calculaRota) calcularRota();
			if (BO_andandoParaDestino) {
				MC_heroi.x += NU_velXHeroi;
				MC_heroi.y += NU_velYHeroi;
				if (MC_heroi.hitTestObject(MC_destino)) {
					PT_saidaTorre = new Point (MC_heroi.x, MC_heroi.y);
					if (ST_destinoHeroi == "centro") {
						PT_saidaTorre = new Point (0, 0) ;						
					}
					else {
						MC_heroi.scaleX = 1.5;
						MC_heroi.scaleY = 1.5;
					}
					NU_velXHeroi = 0;
					NU_velYHeroi = 0;
					MC_heroi.x = MC_destino.x;
					MC_heroi.y = MC_destino.y;
					BO_andandoParaDestino = false;
					ST_posicaoHeroi = ST_destinoHeroi;
				}
			}
		}
		
		private function calcularRota():void 
		{   
			if (!BO_andandoParaDestino) {
				MC_heroi.x = PT_saidaTorre.x;
				MC_heroi.y = PT_saidaTorre.y;
				MC_heroi.scaleX = 1;
				MC_heroi.scaleY = 1;
			}
			var ang:Number = Math.atan2(MC_destino.y - MC_heroi.y , MC_destino.x - MC_heroi.x);
			NU_velXHeroi =  Math.cos(ang) * NU_velocHeroi;
			NU_velYHeroi =  Math.sin(ang) * NU_velocHeroi;
			BO_andandoParaDestino = true;
			BO_calculaRota = false;
		}
		
		public function remove():void {
			MC_castelo.removeEventListener(MouseEvent.CLICK, clickTorre);		
		}
		
		private function clickTorre(e:Event):void 
		{
			var nome:String = MovieClip(e.target).name;
			if (nome in OB_Torres) {
				MC_destino = MovieClip(e.target);
				ST_destinoHeroi = MovieClip(e.target).name;
				BO_calculaRota = true;
			}
		}
		
	}

}