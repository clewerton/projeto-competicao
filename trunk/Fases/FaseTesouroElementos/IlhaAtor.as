package Fases.FaseTesouroElementos 
{
	import Fases.Efeitos.DanoBarcoInimigo;
	import Fases.FaseTesouro;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Fases.FaseEvent;
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class IlhaAtor extends AtorBase implements AtorInterface {
		
		//PREMIOS
		public static const PREMIO_TESOURO:uint =  1;
		public static const PREMIO_BALA:uint =  2;
		public static const PREMIO_BARCO:uint =  3;
		public static const PREMIO_PIRATAS:uint =  4;

	
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
		
		//premio de vida
		private var UI_custoVida		:uint;
		private var UI_vidaLote			:uint;
		private var UI_contador			:uint;		
		private var UI_frequencia		:uint;		

		//premio de municao
		private var UI_custoMunicao		:uint;
		private var UI_municaoLote		:uint;
		
		//canhão da ilha
		private var BO_ativoCanhao		:Boolean;
		
		//tesouro
		private var TA_tesouro			:TesouroIlhaAtor;
		private var BO_temTesouro		:Boolean;
		private var UI_qtd_Max_inimigos	:uint;
		private var UI_qtd_inimigos		:uint;
		
		//vetor de inimigos protetores da ilha
		private var VT_protetores		:Vector.<BarcoInimigoAtor>
		
		public function IlhaAtor() 
		{
			var sort:int = Utils.Rnd(1, 5);
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
				case 5:
					MC_ilha = new IlhaBase05;
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
			
			//raio de interatividade do barco heroi com a ilha
			UI_raioSlot = 220;
			
			//pontos por vida na ilha de vida
			UI_custoVida = faseAtor.param [ FaseJogoParamentos.PARAM_ILHA_PONTOS_POR_VIDA ];
			UI_vidaLote  = faseAtor.param [ FaseJogoParamentos.PARAM_ILHA_QTD_VIDA_LOTE];
			
			//custo da municao e quantidade por entrega
			UI_custoMunicao = faseAtor.param [ FaseJogoParamentos.PARAM_ILHA_PONTOS_POR_MUNICAO ];
			UI_municaoLote  = faseAtor.param [ FaseJogoParamentos.PARAM_ILHA_QTD_MUNICAO_LOTE];
			
			//quantidade maxiam de inimigos chamado pela ilha pelo ativado tesouro
			UI_qtd_Max_inimigos = faseAtor.param [ FaseJogoParamentos.PARAM_ILHA_QTD_MAX_INI_DEFESA];
			
			//frequncia de venda de vida e municao
			UI_frequencia = 24;
			
			// reinicia valores
			reinicializa()
		}
		
		public function reinicializa():void
		{
			UI_qtd_inimigos = 0;
			UI_contador 	= UI_frequencia;
			BO_dentroRaio 	= false;
			BO_revelada 	= false;
			BO_temTesouro 	= false;
			BO_ativoCanhao 	= false;
			faseAtor.addChild(MC_nevoa);
			
			VT_protetores = new Vector.<BarcoInimigoAtor>;
			
		}
		
		public function update(e:Event):void
		{			
			if (PT_posicao.x != this.x || PT_posicao.y != this.y) reposicionouIlha();
			
			if (!BO_revelada) faseAtor.setChildIndex(MC_nevoa, faseAtor.numChildren - 1);
			else if (UI_premioID == PREMIO_TESOURO && BO_temTesouro ) chamaBarcosPiratas();
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
				case PREMIO_TESOURO:
					MC_premio = new Slot01;
				break;
				case PREMIO_BARCO:
					MC_premio = new Slot02;
				break;
				case PREMIO_BALA:
					MC_premio = new Slot03;
				break;
				case PREMIO_PIRATAS:
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
			{   var dist:Number = calculaDistanciaSlot(_atorAlvo);
				if (!BO_revelada) {
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
					if ( dist < UI_raioSlot ) {
						UI_contador++;
						if (UI_contador > UI_frequencia) {
							UI_contador = 0;
							return true;
						}
						else return false;
					}
					else return false;
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
					case PREMIO_TESOURO:
						MC_premio.visible = false;
						TA_tesouro = new TesouroIlhaAtor(this);
						TA_tesouro.x = PT_centroSlot.x;
						TA_tesouro.y = PT_centroSlot.y;
						faseAtor.adicionaAtor(TA_tesouro);
						BO_temTesouro = true;
					break;
					case PREMIO_PIRATAS:
						MC_premio.visible = false;
						BO_ativoCanhao = true;
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
			if (BO_ativoCanhao) {
				BO_ativoCanhao = false;
				MC_premio.visible = true;
				MC_premio.gotoAndStop("destruido");
				FaseTesouro (faseAtor).destruiCanhao(MC_premio);
			}
		}
		
		/**************************************************************************
		 * tesouro ilha
		 * ***********************************************************************/
		public function get pontosTesouro():uint
		{
			if (BO_temTesouro) return TA_tesouro.pegarPontos();
			else return 0;
		}
		
		public function tesouroVazio():void {
			MC_premio.visible = true;
			MC_premio.gotoAndStop("vazio");
			if (BO_temTesouro) {
				BO_temTesouro = false;
				
				//limpa protetores
				for each ( var bi:BarcoInimigoAtor in VT_protetores) bi.ativaPerseguidor();
				UI_qtd_inimigos = 0;
				VT_protetores = new Vector.<BarcoInimigoAtor>;			
				
				//remove o bau Ator
				TA_tesouro = null;
				
				//contabiliza tesouro pego
				FaseTesouro(faseAtor).pegouTesouro(this);
			}
		}
		
		public function chamaBarcosPiratas():void {
			for (var i:uint = 0 ; i < VT_protetores.length; i++) {
				if (VT_protetores[i].marcadoRemocao) {
					UI_qtd_inimigos--;
					VT_protetores.splice(i, 1);
					break;
				}
			}
			if ( UI_qtd_inimigos >= UI_qtd_Max_inimigos ) return;
			
			var pt:Point  =  faseAtor.mapa.convertePonto( new Point(this.x, this.y), true);
			var ptreal:Point = faseAtor.mapa.convertePontoMapa(pt);
			var barcoIni:BarcoInimigoAtor 
			
			while (UI_qtd_inimigos < UI_qtd_Max_inimigos) {
				barcoIni= new BarcoInimigoAtor();
				faseAtor.adicionaAtor(barcoIni);
				barcoIni.definePosicaoOrigem(ptreal);
				randomizaPosicaoInimigo(barcoIni);
				UI_qtd_inimigos++;
				VT_protetores.push(barcoIni);
			}
		}
		
		private function randomizaPosicaoInimigo(_ini:BarcoInimigoAtor):void
		{	
			var rt:Rectangle = FaseTesouro(faseAtor).limGlob;
			//x
			if ( this.x > 0 ) _ini.x = Utils.Rnd( 0 , rt.right );
			else _ini.x = Utils.Rnd( rt.left  , 0 );
			//y
			if ( this.y > 0 ) _ini.y = rt.bottom - 50;	
			else _ini.y = rt.top - 50;						
		}
		/***************************************************************************
		 * Propriedade publicas
		 * ************************************************************************/
		
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
		
		public function get premioID():uint 
		{
			return UI_premioID;
		}
		
		public function get vidaPremio():uint 
		{
			return UI_vidaLote;
		}
		
		public function get vidaCusto():uint
		{
			return UI_custoVida * UI_vidaLote;
		}

		public function get municaoPremio():uint 
		{
			return UI_municaoLote;
		}
		
		public function get municaoCusto():uint
		{
			return UI_municaoLote * UI_custoMunicao;
		}

	}

}