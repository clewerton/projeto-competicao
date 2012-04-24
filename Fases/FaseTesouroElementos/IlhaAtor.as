package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		private var SP_slot:Sprite;
		private var UI_premioID: uint;
		private var UI_raioSlot: uint; 
		private var MC_nevoa:MovieClip;
		private var BO_revelada:Boolean;
		private var PT_posicao:Point;
		
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
			SP_slot = MC_ilha.slot;
			super(MC_ilha);
			MC_nevoa = new NevoaSlot;
			PT_posicao = new Point(9999999, 9999999);
		}
		
		public function reinicializa():void
		{
			UI_raioSlot = 200;
			UI_premioID = 0;
			BO_revelada = false;
			faseAtor.addChild(MC_nevoa);
		}
		
		public function inicializa():void
		{
			this.hitGrupos = new Vector.<Class>;
			this.hitGrupos.push(BarcoHeroiAtor);
			reinicializa()
		}
		public function update(e:Event):void
		{	if (PT_posicao.x != this.x || PT_posicao.y != this.y) reposicionouIlha();
			faseAtor.setChildIndex(MC_nevoa, faseAtor.numChildren - 1);
		}
		
		private function reposicionouIlha():void 
		{
			PT_posicao.x = this.x;
			PT_posicao.y = this.y;
			if (!BO_revelada) {
				var rt:Rectangle = SP_slot.getBounds(faseAtor);
				MC_nevoa.x = rt.left + ( rt.width / 2 );
				MC_nevoa.y = rt.top + (rt.height / 2);	
			}
		}
		
		public function remove():void
		{
			
		}
		
		public function definiPremio(_premio:uint):void
		{
			UI_premioID = _premio;
			
			switch (_premio) 
			{
				case FaseTesouro.PREMIO_TESOURO:
					MC_premio = new Slot01;
				break;
				
				case FaseTesouro.PREMIO_BARCO:
					MC_premio = new Slot02;
				break;
				
				case FaseTesouro.PREMIO_BALA:
					MC_premio = new Slot03;
				break;
				
				case FaseTesouro.PREMIO_PIRATAS:
					MC_premio = new Slot04;
				break;
				default:
			}
			SP_slot.addChildAt(MC_premio, 0);
			MC_premio.rotation = - MC_ilha.rotation;

		}
		
		override public function hitTestAtor(_atorAlvo:AtorBase):Boolean 
		{	if (_atorAlvo is BarcoHeroiAtor)
		{
				var dist:Number = calculaDistanciaSlot(_atorAlvo);
				if ( dist < UI_raioSlot) return true;
				else return false;
			}
			return super.hitTestAtor(_atorAlvo);
		}
		
		public function calculaDistanciaSlot(_atorAlvo:AtorBase):Number
		{
			var dy:Number = (this.y + SP_slot.y) - _atorAlvo.y ;
			var dx:Number = (this.x + SP_slot.x) - _atorAlvo.x ;
			var dist:Number = Math.sqrt( (dy * dy) + (dx * dx) );
			return dist;
		}
		
		public function interageIlha(_heroi:BarcoHeroiAtor):void
		{
			revelaIlha();
		}
		
		private function revelaIlha():void 
		{
			if (!BO_revelada) {
				BO_revelada = true;
				faseAtor.removeChild(MC_nevoa);
			}
		}
		
		public function get raioSlot():uint 
		{
			return UI_raioSlot;
		}
		
		public function get revelada():Boolean 
		{
			return BO_revelada;
		}
		
	}

}