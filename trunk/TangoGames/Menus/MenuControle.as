package TangoGames.Menus {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Classe realiza o controle de navegação de Menus
	 * Deve ser derivada, não deve ser instanciada diretamente.
	 * @author Arthur Figueirdo
	 */
	public class MenuControle extends EventDispatcher {
		private var _mainapp:DisplayObjectContainer;
		//Vetor de menus existentes
		private var MenuCorrente:MenuBase;

		public function MenuControle(main:DisplayObjectContainer) {
			if (this.toString() == "[object MenuControle]" ) {
				throw (new Error("MenuControle: Esta classe não pode ser instanciada diretamente"))
			}
			if (main == null) {
				throw (new Error("MenuControle: O Parametro main não pode ser nulo"))				
			}
			if (!(main is MenuMainInterface)) {
				throw (new Error("MenuControle: O objeto main fornecido deve implementar a Interface MenuMainInterface"))
			}
			this._mainapp = main;
		}
		
		public function inicia() {
			ativaMenu(defineMenuInicial());
		}
		
		protected function ativaMenu(mn:MenuBase) {
			MenuCorrente = mn;
			_mainapp.addChild(MenuCorrente);
			MenuCorrente.addEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcaoSelecionada, false,0, true);
		}
		protected function desativaMenu() {
			MenuCorrente.removeEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcaoSelecionada);
			_mainapp.removeChild(MenuCorrente);
			MenuCorrente = null;
		}
		
		private function manipulaOpcaoSelecionada(e:MenuEvent):void {
			if (e.OpcaoObj.ProximoMenu != null) {
				desativaMenu();
				ativaMenu (e.OpcaoObj.ProximoMenu());
			}
			else
			{
				if (manipulaOpcaoMenu(MenuCorrente, e.OpcaoObj)) { desativaMenu() }
			}
		}
		
		protected function defineMenuInicial():MenuBase {
			throw (new Error ("A classe derivada deve sobrescrever o metodo defineMenuInicial")) 
		}
		
		protected function manipulaOpcaoMenu(Menu:MenuBase, Opcao: MenuOpcao):Boolean {
			return MenuMainInterface(_mainapp).manipulaMenuOpcaoSelecionada(Menu,Opcao)
		}
		
		protected function get mainapp():DisplayObjectContainer 
		{
			return _mainapp;
		}

	}
}