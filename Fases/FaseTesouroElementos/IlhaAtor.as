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
		
		//figurino da ilha
		private var MC_ilha				:MovieClip;
		
		//slot base da ilha
		private var SP_slot				:Sprite;

		//premio da ilhas
		private var MC_premio			:MovieClip;
		private var UI_premioID			:uint;
		
		//Raio de interação da ilha
		private var UI_raioSlot			:uint;
		private var BO_dentroRaio		:Boolean;

		//névoa da ilha não revelada
		private var MC_nevoa			:MovieClip;
		
		//indica se a ilha já foi revelada
		private var BO_revelada			:Boolean;
		
		//posição fixa da ilha
		private var PT_posicao			:Point;
		
		//ponto de referencia global do centro do slot
		private var PT_centroSlot		:Point;
		
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
			
			//nevoa da ilha
			MC_nevoa = new NevoaSlot;
			MC_nevoa.gotoAndStop("inativo");
			
			this.cacheAsBitmap = true;
			hitObject = this;
		}
		/**********************************************************************************
		 *  métodos da interface AtorBase
		 * *******************************************************************************/
		
		public function inicializa():void
		{
			adcionaClassehitGrupo(BarcoHeroiAtor);		
			
			UI_premioID = 0;
			PT_posicao = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
			PT_centroSlot = new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			UI_raioSlot = 200;
			
			reinicializa()
		}
		
		public function reinicializa():void
		{
			BO_dentroRaio = false;
			BO_revelada = false;
			faseAtor.addChild(MC_nevoa);
		}
		
		public function update(e:Event):void
		{			
			if (PT_posicao.x != this.x || PT_posicao.y != this.y) reposicionouIlha();
			
			if (!BO_revelada) faseAtor.setChildIndex(MC_nevoa, faseAtor.numChildren - 1);
		}
				
		public function remove():void
		{
			if (!BO_revelada) faseAtor.removeChild(MC_nevoa);
		}
		
		/*******************************************************************************
		 *  Premios da ilha e interface
		 * ****************************************************************************/
		/**
		 * Defeine Premiacao da ilha
		 * @param	_premio
		 */
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
			MC_premio.stop();
			MC_ilha.addChild(MC_premio);
			MC_premio.x = SP_slot.x;
			MC_premio.y = SP_slot.y;
			MC_premio.rotation = - MC_ilha.rotation;
		}
		/**
		 * reposicionou Ilha
		 */
		private function reposicionouIlha():void 
		{
			PT_posicao.x = this.x;
			PT_posicao.y = this.y;
			if (!BO_revelada)
			{
				var rt:Rectangle = SP_slot.getBounds(faseAtor);
				PT_centroSlot = new Point( rt.left + ( rt.width / 2 ) , rt.top + (rt.height / 2) );
				MC_nevoa.x = PT_centroSlot.x;
				MC_nevoa.y = PT_centroSlot.y; 
			}	
		}		
		
		/*****************************************************************
		 * Colisão da Ilha
		 * **************************************************************/
		 
		override public function hitTestAtor(_atorAlvo:AtorBase):Boolean 
		{	
			if (_atorAlvo is BarcoHeroiAtor)
			{
				if (!BO_revelada) {
					var dist:Number = calculaDistanciaSlot(_atorAlvo);
					if ( dist < UI_raioSlot) {
						BO_dentroRaio = true;
						MC_nevoa.gotoAndStop("ativo");
						return true;
					}
					else {
						BO_dentroRaio = false;
						MC_nevoa.gotoAndStop("inativo");
						return false;
					}
				}
				else {
					return false;
				}
			}
			return super.hitTestAtor(_atorAlvo);
		}
		
		public function calculaDistanciaSlot(_atorAlvo:AtorBase):Number
		{
			var dy:Number = PT_centroSlot.y - _atorAlvo.y ;
			var dx:Number = PT_centroSlot.x - _atorAlvo.x ;
			var dist:Number = Math.sqrt( (dy * dy) + (dx * dx) );
			return dist;
		}
		
		public function interageIlha(_heroi:BarcoHeroiAtor):void
		{
			revelaIlha();
		}
		
		private function revelaIlha():void 
		{
			if (!BO_revelada)
			{
				BO_revelada = true;
				faseAtor.removeChild(MC_nevoa);
				switch (UI_premioID) 
				{
					case FaseTesouro.PREMIO_TESOURO:
						FaseTesouro(faseAtor).pegouTesouro();
					break;
					case FaseTesouro.PREMIO_PIRATAS:
						MC_premio.visible = false;
						var canhao:CanhaoIlhaAtor = new CanhaoIlhaAtor(this);
						canhao.x = PT_centroSlot.x;
						canhao.y = PT_centroSlot.y;
						faseAtor.adicionaAtor(canhao);
					break;
					default:
				}
			}
		}
		
		/**
		 * canhão pirata destruido
		 */
		public function canhaoPirataDestruido() {
			MC_premio.visible = true;
			MC_premio.gotoAndStop("destruido");
		}
		
		public function get raioSlot():uint 
		{
			return UI_raioSlot;
		}
		
		public function get revelada():Boolean 
		{
			return BO_revelada;
		}
		
		public function get dentroRaio():Boolean 
		{
			return BO_dentroRaio;
		}
		
	}

}