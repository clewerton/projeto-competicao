package  {
	
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
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
		private var VT_nomes			:Vector.<String>;
		private var VT_atual			:Vector.<MovieClip>;
		
		//UPGRADES
		private var BC_upgrades			:BarcoHeroiUpgrades;
		
		public function MenuUpgrades( _idMenu:String ) {

			super(_idMenu);
			
			BC_upgrades 	= new BarcoHeroiUpgrades();
			
			VT_navioNivel	= new Vector.<MovieClip>;
			VT_velaNivel	= new Vector.<MovieClip>;
			VT_canhaoNivel	= new Vector.<MovieClip>;
			VT_capacMunicao	= new Vector.<MovieClip>;
			VT_tipoMunicao	= new Vector.<MovieClip>;
			VT_frequenTiro	= new Vector.<MovieClip>;
			VT_alcanceTiro	= new Vector.<MovieClip>;
			
			VT_ativo 		= new Vector.<MovieClip>;
			VT_atual 		= new Vector.<MovieClip>;
			VT_nomes 		= new Vector.<String> ;
			
			adicionaBotao();
			
			this.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseSobre, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT , mouseSobre, false, 0, true);
			
			
		}
		
		private function mouseSobre(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				var mc:MovieClip = MovieClip (e.target);
				if (VT_ativo.indexOf(mc)> -1) {
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
			}
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
			
			configuraBotao(VT_navioNivel	, "navionivel"		, BC_upgrades.nivelNavio				);
			
			configuraBotao(VT_velaNivel		, "velasnivel"		, BC_upgrades.nivelVela					);
			
			configuraBotao(VT_canhaoNivel	, "canhoesnivel"	, BC_upgrades.nivelCanhao				);

			configuraBotao(VT_capacMunicao	, "capacidadenivel" , BC_upgrades.nivelCapacidadeMunicao	);
			
			configuraBotao(VT_tipoMunicao  	, "municaonivel"	, BC_upgrades.nivelDanoTiro				);
			
			configuraBotao(VT_frequenTiro  	, "frequencianivel"	, BC_upgrades.nivelFrequenciaTiro		);
			
			configuraBotao(VT_alcanceTiro  	, "alcancenivel"	, BC_upgrades.nivelAlcanceTiro			);
			
		}
		
		private function clicouUpgrade(e:MouseEvent):void {
			
			if (e.target is MovieClip) {
				var mc:MovieClip = MovieClip (e.target);
				var index:int = VT_ativo.indexOf(mc);
				if (index > -1) {
					trace(VT_nomes[index]);
				}
			}
		}
			
		private function configuraBotao (_VT:Vector.< MovieClip>, _nomeMC:String, _valorNV:uint ):void {
			var nomeMC:String;
			
			_VT = new Vector.< MovieClip>;
			
			for (var i:uint = 0 ; i <= 2 ; i++) {
				nomeMC = _nomeMC + i.toString();
				_VT.push(this[nomeMC]);
				if ( i > _valorNV ) disponivel(_VT[i],_nomeMC);
			}
			
			nivelAtual (_VT[_valorNV]);
			
		}
		
		private function nivelAtual(_MC:MovieClip):void {
			VT_atual.push(_MC);						
			ligaDeslBlur(_MC, true, 0X00FF00);
		}

		private function disponivel(_MC:MovieClip, _nome:String):void {
			VT_ativo.push(_MC);
			VT_nomes.push(_nome);
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
		
	}
	
}
