package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		private var SP_slot:Sprite;
		private var UI_premioID: uint;
		private var UI_raioSlot: uint; 
		private var MC_nevoa:MovieClip;
		private var BO_revelada:Boolean;
		
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
		}
		
		public function reinicializa():void {
			UI_raioSlot = 200;
			UI_premioID = 0;
			BO_revelada = false;
			SP_slot.addChild(MC_nevoa);
		}
		
		public function inicializa():void {
			this.hitGrupos = new Vector.<Class>;
			this.hitGrupos.push(BarcoHeroiAtor);
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
				SP_slot.addChildAt(MC_premio,0);
			}
		}
		
		override public function hitTestAtor(_atorAlvo:AtorBase):Boolean 
		{	if (_atorAlvo is BarcoHeroiAtor) {
				var dist:Number = calculaDistanciaSlot(_atorAlvo);
				if ( dist < UI_raioSlot) return true;
				else return false;
			}
			return super.hitTestAtor(_atorAlvo);
		}
		
		public function calculaDistanciaSlot(_atorAlvo:AtorBase):Number {
			var dy:Number = (this.y + SP_slot.y) - _atorAlvo.y ;
			var dx:Number = (this.x + SP_slot.x) - _atorAlvo.x ;
			var dist:Number = Math.sqrt( (dy * dy) + (dx * dx) );
			return dist;
		}
		
		public function interageIlha(_heroi:BarcoHeroiAtor):void {
			revelaIlha();
		}
		
		private function revelaIlha():void 
		{
			if (!BO_revelada) {
				BO_revelada = true;
				SP_slot.removeChild(MC_nevoa);
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