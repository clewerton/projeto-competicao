package  {
	
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuOpcao;
	
	
	public class MenuUpgrades extends MenuBase {
		
		// vetores de butões
		private var VT_navioNivel		:Vector.<MovieClip>;
		private var VT_velaNivel		:Vector.<MovieClip>;
		private var VT_canhaoNivel		:Vector.<MovieClip>;
		private var VT_capacMunicao		:Vector.<MovieClip>;
		private var VT_tipoMunicao		:Vector.<MovieClip>;
		private var VT_frequenTiro		:Vector.<MovieClip>;
		private var VT_alcanceTiro		:Vector.<MovieClip>;
		
		//vectores
		private var VT_ativo			:Vector.<MovieClip>;
		private var VT_config			:Array;
		private var VT_atual			:Vector.<MovieClip>;
		
		//UPGRADES
		private var BC_upgrades			:BarcoHeroiUpgrades;
		
		//Controle Fases
		private var FC_faseDados		:FasesDados;
		
		//Campos dos valores Total e custo
		private var TF_total			:TextField;
		private var TF_custo			:TextField; 
		private var MC_comprar			:MovieClip;
		
		//custo dos upgrade compra;
		private var UI_custo			:uint;
		
		
		
		public function MenuUpgrades( _idMenu:String ) {

			super(_idMenu);
			
			//controle de ugrades do barco
			BC_upgrades 	= new BarcoHeroiUpgrades();
			
			//controle de fase
			FC_faseDados	= new FasesDados();
			
			//campos de total e custo
			TF_total 	= this.totalvalor;
			TF_custo 	= this.custovalor;
			MC_comprar	= this.botaocomprar;
		
			VT_navioNivel	= new Vector.<MovieClip>;
			VT_velaNivel	= new Vector.<MovieClip>;
			VT_canhaoNivel	= new Vector.<MovieClip>;
			VT_capacMunicao	= new Vector.<MovieClip>;
			VT_tipoMunicao	= new Vector.<MovieClip>;
			VT_frequenTiro	= new Vector.<MovieClip>;
			VT_alcanceTiro	= new Vector.<MovieClip>;
			
			VT_ativo 		= new Vector.<MovieClip>;
			VT_atual 		= new Vector.<MovieClip>;
			VT_config 		= new Array
			
			adicionaBotao();
			
			this.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseSobre, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT , mouseSobre, false, 0, true);
			
			atualizaTotais();
		
		}
				
		override protected function posicionaOpcao(_op:MenuOpcao):void {
			//Posiciona a opção voltar
			if (_op.valorRetorno == 99) {
				_op.x =  5;
				_op.y =  stage.stageHeight - _op.height;
				return
			}

			super.posicionaOpcao(_op);
			
		}
		
		private function adicionaBotao():void {
			
			UI_custo = 0;
			
			VT_ativo 		= new Vector.<MovieClip>;
			
			VT_atual 		= new Vector.<MovieClip>;
			
			VT_config 		= new Array
			
			configuraBotao(VT_navioNivel	, "nivelNavio"				, BC_upgrades.nivelNavio				);
			
			configuraBotao(VT_velaNivel		, "nivelVela"				, BC_upgrades.nivelVela					);
			
			configuraBotao(VT_canhaoNivel	, "nivelCanhao"				, BC_upgrades.nivelCanhao				);
			
			configuraBotao(VT_capacMunicao	, "nivelCapacidadeMunicao"	, BC_upgrades.nivelCapacidadeMunicao	);
			
			configuraBotao(VT_tipoMunicao  	, "nivelDanoTiro"			, BC_upgrades.nivelDanoTiro				);
			
			configuraBotao(VT_frequenTiro  	, "nivelFrequenciaTiro"		, BC_upgrades.nivelFrequenciaTiro		);
			
			configuraBotao(VT_alcanceTiro  	, "nivelAlcanceTiro"		, BC_upgrades.nivelAlcanceTiro			);
			
		}
		
		private function mouseSobre(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				var mc:MovieClip = MovieClip (e.target);
				if (mc == MC_comprar ) {
					if (podeComprar()) {
						switch (e.type) 
						{
							case MouseEvent.MOUSE_OVER:
								ligaDeslBlur(mc);
							break;
							case MouseEvent.MOUSE_OUT:
								ligaDeslBlur(mc,false);						
							break;
							default:
						}
					}
					return
				}
				var index:int = VT_ativo.indexOf(mc);
				if ( index > -1) {
					switch (e.type) 
					{
						case MouseEvent.MOUSE_OVER:
							ligaDeslBlur(mc);
						break;
						case MouseEvent.MOUSE_OUT:
							if (!VT_config[index].comprar) ligaDeslBlur(mc,false);						
						break;
						default:
					}
				}
			}
		}

		
		private function clicouUpgrade(e:MouseEvent):void {
			
			if (e.target is MovieClip) {
				var mc:MovieClip = MovieClip (e.target);
				if (mc == MC_comprar ) {
					if (podeComprar()) compraUpgrade();
					return
				}
				
				var index:int = VT_ativo.indexOf(mc);
				var custo:uint;
				var select:Boolean;
				var nomeUp:String;
				if (index > -1) {
					select 	= VT_config[index].comprar;
					custo 	= VT_config[index].custo;
					nomeUp  = VT_config[index].nome;
					for (var i:uint = 0 ; i < VT_config.length; i++) {
						if (VT_config[i].nome == nomeUp && VT_config[i].comprar) {
							UI_custo -= VT_config[i].custo;
							VT_config[i].comprar = false;
							ligaDeslBlur(VT_ativo[i], false);
						}
					}
					if (!select) {
						UI_custo += custo;
						VT_config[index].comprar = true;
						ligaDeslBlur(VT_ativo[index], true)
					}
					
					atualizaTotais();
				}
			}
		}
		
		private function compraUpgrade() {
			if (podeComprar()) {
				for (var i:uint = 0 ; i < VT_config.length; i++) {
					if (VT_config[i].comprar) {
						FC_faseDados.totalPontos -= VT_config[i].custo;
						VT_config[i].comprar = false;
						ligaDeslBlur(VT_ativo[i], false);
						BC_upgrades[VT_config[i].nome] = VT_config[i].nivel;
					}
				}
				//salva informações upgrades
				BC_upgrades.salvaDados();
				
				//salva informações fases
				FC_faseDados.salvaDados();
				
				//adiciona Botoes
				adicionaBotao();
				
				//atualização de totais
				atualizaTotais();
			}
		}
		
		private function configuraBotao (_VT:Vector.< MovieClip>, _nomeMC:String, _valorNV:uint ):void {
			var nomeMC:String;
			var nomeUp:String;
			var nomeVlr:String;
			var TF_valor:TextField;
			var custo:uint
			
			nomeUp 	= 	_nomeMC;
			_VT = new Vector.< MovieClip>;
			
			
			for (var i:uint = 0 ; i <= 2 ; i++) {
				nomeMC = _nomeMC + i.toString();
				_VT.push(this[nomeMC]);
				custo = BC_upgrades.custoUpgrade(nomeUp, i);
				if ( i > _valorNV ) {
					if (FC_faseDados.faseLiberada < BC_upgrades.faseLiberaUpgrade(nomeUp , i)) desabilitado( _VT[i] );
					else disponivel(_VT[i], nomeUp , i ,custo );
				}
				else if (i == _valorNV ) {
					nivelAtual ( _VT[i] );
				}
				else {
					desabilitado( _VT[i] );
				}
				if (i > 0) {
					nomeVlr 		= nomeMC + "valor";
					TF_valor		= this[nomeVlr];
					TF_valor.text 	= "$" + custo.toString();
				}
			}	
		}
		
		private function nivelAtual(_MC:MovieClip):void {
			VT_atual.push(_MC);						
			ligaDeslBlur(_MC, true, 0X00FF00);
			_MC.buttonMode = false;
			_MC.useHandCursor = false;
		}

		private function disponivel(_MC:MovieClip, _nome:String, _nivel:uint, _custo:uint):void {
			VT_ativo.push(_MC);
			VT_config.push({nome:_nome,nivel:_nivel,custo:_custo,comprar:false});
			_MC.buttonMode = true;
			_MC.useHandCursor = true;
		}
			
		private function ligaDeslBlur(_MC:MovieClip, _liga:Boolean = true,  _cor:uint = 0XFF0000):void {
			if (_liga) {
				var GF_filt:GlowFilter = new GlowFilter;		
				GF_filt.color = _cor;
				GF_filt.blurX = 14;  
				GF_filt.blurY = 14;
				_MC.filters = [GF_filt];
			}
			else {
				_MC.filters = [];
			}
			
		}
		
		private function desabilitado(_MC:MovieClip):void {
			var BF_filt_blur:BlurFilter = new BlurFilter;			
			BF_filt_blur.blurX = 5;
			BF_filt_blur.blurY = 5;
			BF_filt_blur.quality = BitmapFilterQuality.HIGH;
			_MC.filters = [BF_filt_blur];
		}
		
		private function atualizaTotais():void {
			TF_total.text = "$" + FC_faseDados.totalPontos.toString();
			TF_custo.text = "$" + UI_custo.toString();
			if (podeComprar()) {
				MC_comprar.buttonMode = true;
				MC_comprar.useHandCursor = true;
				MC_comprar.filters = [];
			}
			else {
				MC_comprar.buttonMode = false;
				MC_comprar.useHandCursor = false;
				desabilitado(MC_comprar); 
			}
		}
		
		private function podeComprar():Boolean {
			if ( UI_custo > 0 && FC_faseDados.totalPontos >= UI_custo ) return true;
			return false
		}
	}
}
