package TangoGames.Menus {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe realiza o controle de navegação de Menus
	 * Deve ser derivada, não deve ser instanciada diretamente.
	 * @author Arthur Figueirdo
	 */
	public class MenuControle extends EventDispatcher {
		
		//variável de referencia ao objeto principal do jogo
		private var _mainapp:DisplayObjectContainer;
		
		//variável do menu ativo do jogo
		private var MenuCorrente:MenuBase;
		
		/**
		 * contrutora da Classe MenuControle
		 * @param	_main
		 * referencia ao objeto principal do jogo
		 */
		public function MenuControle(_main:DisplayObjectContainer) {
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == MenuControle ) {
				throw (new Error("MenuControle: Esta classe não pode ser instanciada diretamente"))
			}
			if (_main == null) {
				throw (new Error("MenuControle: O Parametro main não pode ser nulo"))				
			}
			if (!(_main is MenuMainInterface)) {
				throw (new Error("MenuControle: O objeto main fornecido deve implementar a Interface MenuMainInterface"))
			}
			this._mainapp = _main;
		}
		
		/***************************************************************************
		 *    Área dos métodos privados da classe
		 * ************************************************************************/
		/**
		 * manipula evento do menu para opção selecionada
		 * @param	e
		 * referencia do objeto evento retornado
		 */
		private function manipulaOpcaoSelecionada(e:MenuEvent):void {
			if (e.OpcaoObj.ProximoMenu != null) {
				desativaMenu();
				ativaMenu (e.OpcaoObj.ProximoMenu());
			}
			else
			{
				if (manipulaOpcaoMenu(MenuCorrente, e.OpcaoObj)) desativaMenu();
			}
		}

		/***************************************************************************
		 *    Área dos métodos protegidos da classe
		 * ************************************************************************/
		/**
		 * ativa o menu
		 * @param	mn
		 * referencia do objeto MenuBase
		 */
		protected function ativaMenu(mn:MenuBase):void {
			MenuCorrente = mn;
			_mainapp.addChild(MenuCorrente);
			MenuCorrente.addEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcaoSelecionada, false,0, true);
		}
		/**
		 * deativa o menu corrente
		 */
		protected function desativaMenu():void {
			MenuCorrente.removeEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcaoSelecionada);
			_mainapp.removeChild(MenuCorrente);
			MenuCorrente = null;
		}
		/**
		 * Este método é automaticamente chamado para ativar o menu inicial.
		 * Deve ser implementado pela classe deriva uma deficição específica do menu; 
		 * @return
		 * referencia do objeto MenuBase criado no método
		 */
		protected function defineMenuInicial():MenuBase {
			throw (new Error ("A classe derivada deve sobrescrever o metodo defineMenuInicial")) 
		}
		/**
		 * chamado a cada seleção de opção e chama metodo:
		 * MenuMainInterface(_mainapp).manipulaMenuOpcaoSelecionada(Menu,Opcao)
		 * pode ser sobrescrito.
		 * @param	Menu
		 * objeto MenuBase selecionada
		 * @param	Opcao
		 * objeto MenuOpcao selecionada
		 * @return
		 * se verdadeiro interrompe excução do menu se falso continua.
		 */
		protected function manipulaOpcaoMenu(Menu:MenuBase, Opcao: MenuOpcao):Boolean {
			return MenuMainInterface(_mainapp).manipulaMenuOpcaoSelecionada(Menu,Opcao)
		}

		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
		/**
		 * Inicia a execução do menu principal
		 */
		public function inicia():void {
			ativaMenu(defineMenuInicial());
		}

		 /***************************************************************************
		 *    Propriedade visíveis da Classe
		 * **************************************************************************/
		
		/**
		 * referencia ao objeto principal do jogo
		 */
		protected function get mainapp():DisplayObjectContainer 
		{
			return _mainapp;
		}
	}
}