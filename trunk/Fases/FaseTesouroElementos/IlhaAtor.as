package Fases.FaseTesouroElementos 
{
	import Fases.FaseCasteloElementos.PontuacaoHUD;
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
		private var MC_ilha:MovieClip;
		
		//slot base da ilha
		private var SP_slot:Sprite;

		//premio da ilhas
		private var MC_premio: MovieClip;
		private var UI_premioID: uint;
		
		//Raio de interação da ilha
		private var UI_raioSlot: uint;
		private var BO_dentroRaio: Boolean;

		//névoa da ilha não revelada
		private var MC_nevoa:MovieClip;
		
		//indica se a ilha já foi revelada
		private var BO_revelada:Boolean;
		
		//posição fixa da ilha
		private var PT_posicao:Point;
		
		//ponto de referencia global do centro do slot
		private var PT_centroSlot:Point;
		
		//variávei dos PREMIO PIRATA
		private var UI_freqTiro:uint;
		private var UI_contTiro:uint;
		
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
		}
		
		public function reinicializa():void
		{
			UI_raioSlot = 200;
			BO_dentroRaio = false;
			UI_premioID = 0;
			BO_revelada = false;
			faseAtor.addChild(MC_nevoa);
			PT_posicao = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
			PT_centroSlot = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
		}
		
		public function inicializa():void
		{
			adcionaClassehitGrupo(BarcoHeroiAtor);
			
			//Inicializa variaveis dos pirtas
			UI_freqTiro = 24;
			
			reinicializa()
		}
		public function update(e:Event):void
		{			
			if (PT_posicao.x != this.x || PT_posicao.y != this.y) reposicionouIlha();
			
			if (BO_revelada)
			{
				if (UI_premioID == FaseTesouro.PREMIO_PIRATAS) updatePiratas();
			}
			else {
				faseAtor.setChildIndex(MC_nevoa, faseAtor.numChildren - 1);
			}
		}
		
		private function updatePiratas() {
			var dx:Number = PT_centroSlot.x - FaseTesouro(faseAtor).barcoHeroi.x;
			var dy:Number = PT_centroSlot.y - FaseTesouro(faseAtor).barcoHeroi.y;
			var dist:Number = Math.sqrt( ( dx * dx ) + ( dy * dy ) );
			UI_contTiro++;
			if (dist < 500) {
				var ang:Number = Math.atan2(dy, dx);
				var ajuste:Number = corrigeDirecaoAlvo(ang, MC_premio.rotation);
				if (Math.abs( Math.floor( ajuste * 10 ) ) == 0 ) {
					//ATIRA
					if (UI_contTiro > UI_freqTiro) {
						var tiro:TiroInimigoAtor = new TiroInimigoAtor(ang);
						tiro.x = PT_centroSlot.x;
						tiro.y = PT_centroSlot.y;
						faseAtor.adicionaAtor(tiro);
						UI_contTiro = 0;
					}
				}
				else {
					MC_premio.rotation += ajuste;
				}
			}
		}
		
		public function remove():void
		{
			if (!BO_revelada) faseAtor.removeChild(MC_nevoa);
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
			
			this.cacheAsBitmap = true;
			
		}
		
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
			var rt:Rectangle = SP_slot.getBounds(faseAtor);
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
			}
		}
				
		/**
		 * Corrige a direcao do canhão
		 * @param	_anguloRadiano
		 * angulo objetivo
		 * @param	_rotacaoAtual
		 * rotacao atual do canhão
		 * @return
		 * ajuste rotacao a ser apliacada ao canhão
		 */ 
		private function corrigeDirecaoAlvo(_anguloRadiano:Number, _rotacaoAtual:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * 180 / Math.PI) - MC_ilha.rotation;
		
			var ajusteMax:Number = 3;
			
			var diferenca:Number = _rotacaoAtual -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - _rotacaoAtual;
			
			if (ajusteAngulo > ajusteMax) ajusteAngulo = ajusteMax;
			
			if (ajusteAngulo < -ajusteMax) ajusteAngulo = -ajusteMax;
							
			return ajusteAngulo;
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