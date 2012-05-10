package  {
	
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuOpcao;
	
	
	public class MenuUpgrades extends MenuBase {
		
		
		public function MenuUpgrades( _idMenu:String ) {

			super(_idMenu);
			
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

	}
	
}
