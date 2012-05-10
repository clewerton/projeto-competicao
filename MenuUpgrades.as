package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuOpcao;
	
	
	public class MenuUpgrades extends MenuBase {
		
		
		//VARIAVEIS DE EFEITO
		private var GF_filt:GlowFilter = new GlowFilter();
		
		// variáveis de criação dos butões
		private var navio1:MovieClip;
		private var navio2:MovieClip;
		private var navio3:MovieClip;
		
		//VELAS
		private var vela1:MovieClip;
		private var vela2:MovieClip;
		private var vela3:MovieClip;
		
		//CANHAO
		private var canhao1:MovieClip;
		private var canhao2:MovieClip;
		private var canhao3:MovieClip;
		
		//QUANTIDADE DE MUNICAO
		private var quantMunicao1:MovieClip;
		private var quantMunicao2:MovieClip;
		private var quantMunicao3:MovieClip;
		
		//MUNICAO
		private var municao1:MovieClip;
		private var municao2:MovieClip;
		private var municao3:MovieClip;
		
		//FREQUENCIA DE TIRO
		private var velocidadeTiro1:MovieClip;
		private var velocidadeTiro2:MovieClip;
		private var velocidadeTiro3:MovieClip;
		
		//POTENCIA DO TIRO
		private var potenciadoTiro1:MovieClip;
		private var potenciadoTiro2:MovieClip;
		private var potenciadoTiro3:MovieClip;
		
		
		public function MenuUpgrades( _idMenu:String ) {

			super(_idMenu);
			
						
			adicionaBotao();
			
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
			
			navio1 = this.navionivel0
			navio1.buttonMode = true;
			navio1.useHandCursor = true;
			navio1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			navio2 = this.navionivel1;
			navio2.buttonMode = true;
			navio2.useHandCursor = true;
			//aplicando o blur
			
			aplica_blur(navio2);
			
			navio2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			navio3 = this.navionivel2;
			navio3.buttonMode = true;
			navio3.useHandCursor = true;
			navio3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			// VELAS
			
			vela1 = this.velasnivel0;
			vela1.buttonMode = true;
			vela1.useHandCursor = true;
			vela1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			vela2 = this.velasnivel1;
			vela2.buttonMode = true;
			vela2.useHandCursor = true;
			vela2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			vela3 = this.velasnivel2;
			vela3.buttonMode = true;
			vela3.useHandCursor = true;
			vela3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			//CANHAO
			
			canhao1 = this.canhoesnivel0;
			canhao1.buttonMode = true;
			canhao1.useHandCursor = true;
			canhao1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			canhao2 = this.canhoesnivel1;
			canhao2.buttonMode = true;
			canhao2.useHandCursor = true;
			canhao2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			canhao3 = this.canhoesnivel2;
			canhao3.buttonMode = true;
			canhao3.useHandCursor = true;
			canhao3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			//QUANTIDADE DE MUNICAO
			
			quantMunicao1 = this.capacidadenivel0;
			quantMunicao1.buttonMode = true;
			quantMunicao1.useHandCursor = true;
			quantMunicao1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			quantMunicao2 = this.capacidadenivel1;
			quantMunicao2.buttonMode = true;
			quantMunicao2.useHandCursor = true;
			quantMunicao2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			quantMunicao3 = this.capacidadenivel2;
			quantMunicao3.buttonMode = true;
			quantMunicao3.useHandCursor = true;
			quantMunicao3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			//	MUNICAO
			
			municao1 = this.municaonivel0;
			municao1.buttonMode = true;
			municao1.useHandCursor = true;
			municao1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			municao2 = this.municaonivel1;
			municao2.buttonMode = true;
			municao2.useHandCursor = true;
			municao2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			municao3 = this.municaonivel2;
			municao3.buttonMode = true;
			municao3.useHandCursor = true;
			municao3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			//FREQUENCIA DE TIRO
			velocidadeTiro1 = this.frequencianivel0;
			velocidadeTiro1.buttonMode = true;
			velocidadeTiro1.useHandCursor = true;
			velocidadeTiro1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			velocidadeTiro2 = this.frequencianivel1;
			velocidadeTiro2.buttonMode = true;
			velocidadeTiro2.useHandCursor = true;
			velocidadeTiro2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			velocidadeTiro3 = this.frequencianivel2;
			velocidadeTiro3.buttonMode = true;
			velocidadeTiro3.useHandCursor = true;
			velocidadeTiro3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			//POTENCIA DO TIRO
			potenciadoTiro1 = this.alcancenivel0;
			potenciadoTiro1.buttonMode = true;
			potenciadoTiro1.useHandCursor = true;
			potenciadoTiro1.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			potenciadoTiro2 = this.alcancenivel1;
			potenciadoTiro2.buttonMode = true;
			potenciadoTiro2.useHandCursor = true;
			potenciadoTiro2.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			potenciadoTiro3 = this.alcancenivel2;
			potenciadoTiro3.buttonMode = true;
			potenciadoTiro3.useHandCursor = true;
			potenciadoTiro3.addEventListener(MouseEvent.CLICK, clicouUpgrade, false, 0, true);
			
			
			
			
			
		}
		
		private function clicouUpgrade(e:MouseEvent):void {
						
			switch (e.currentTarget) 
			{
				case navio2:
					
					trace("navio2");
				break;
				
				
				case navio3:
				
				break;
				
				
				
				case vela2:
				
				break;
				
				
				
				case vela3:
				
				break;
				
				
				
				case canhao2:
				
				break;
				
				
				
				case canhao3:
				
				break;
				
				
				
				case quantMunicao2:
				
				break;
				
				
				
				
				case quantMunicao3:
				
				break;
				
				
				
				case municao2:
				
				break;
				
				
				
				case municao3:
				
				break;
				
				
				
				case velocidadeTiro2:
				
				break;
				
				
				
				
				case velocidadeTiro3:
				
				break;
				
				
				
				
				case potenciadoTiro2:
				
				break;
				
				
				
				
				case potenciadoTiro3:
				
				break;
				
				
				
				
			}
			
			trace("clicou");
			
		}
		
		
		
		
		private function aplica_blur(MC:MovieClip):void {
			
			//GF_filt.color = 0XFF0000;
			GF_filt.color = 0X00FF00;
			GF_filt.blurX = 14;  
			GF_filt.blurY = 14;
			
			MC.filter = [GF_filt];
			
		}
		
		
		
		
		
		

	}
	
}
