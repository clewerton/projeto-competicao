package TangoGames.Menus {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import TangoGames.Fases.FaseControle;
	
	/**
	 * Classe realiza o controle de navegação de Menus
	 * Deve ser derivada, não deve ser instanciada diretamente.
	 * @author Arthur Figueirdo
	 */
	public class MenuControle extends EventDispatcher {
		
		public static const MENU_CONTROLE_FASES = "MenuControleFases";
		
		//variável de referencia ao objeto principal do jogo
		private var _mainapp:DisplayObjectContainer;
		
		//variável do menu ativo do jogo
		private var MenuCorrente:MenuBase;
		
		//variável do controle de Fase
		private var FC_controleFase: FaseControle;
		private var MB_menuControleFase: MenuBase;
		
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
				if (MenuCorrente.ID_Menu == MENU_CONTROLE_FASES && !e.OpcaoObj.faseControle) {
					if (manipulaOpcaoControleFase(MenuCorrente , e.OpcaoObj)) desativaMenu();
					return
				}
				if (manipulaOpcaoMenu(MenuCorrente, e.OpcaoObj)) desativaMenu();
			}
		}
		/**
		 * cria fundo para o menu de nivel da fase
		 * @return
		 */
		private function criaFundo():Sprite {
			var sp:Sprite = new Sprite ;
			sp.graphics.lineStyle(1, 0X000000, 0);
			sp.graphics.beginFill(0X000000,0.2);
			sp.graphics.drawRect( 0 , 0 , _mainapp.stage.stageWidth , _mainapp.stage.stageHeight);
			sp.graphics.endFill();
			return sp;
		}
		
		private function menuControleFase():MenuBase {
			return MB_menuControleFase;
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
		protected function manipulaOpcaoMenu(_menu:MenuBase, _opcao: MenuOpcao):Boolean {
			return MenuMainInterface(_mainapp).manipulaMenuOpcaoSelecionada(_menu,_opcao)
		}
		/**
		 * 
		 * @param	_menu
		 * @param	_opcao
		 * @return
		 */
		protected function manipulaOpcaoControleFase(_menu:MenuBase, _opcao:MenuOpcao):Boolean {
			if (controleFase.faseNives(_opcao.valorRetorno).length <= 1) {
				_opcao.faseControle = true;
				_opcao.faseID = _opcao.valorRetorno;
				_opcao.valorRetorno = 0;
				return manipulaOpcaoMenu(_menu, _opcao);
			}
			MB_menuControleFase = MenuCorrente;
			desativaMenu();

			var mn:MenuBase = new MenuBase(MENU_CONTROLE_FASES, MB_menuControleFase.fundo)
			mn.formatacao = MB_menuControleFase.formatacao;

			mn.fonte = MB_menuControleFase.fonte;
			
			controleFase.adicionaOpcoesNiveisMenu(_opcao.valorRetorno, mn);
			mn.adicionaOpcao("Voltar", 99,menuControleFase);
			ativaMenu(mn);
			return false;
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
		
		public function get controleFase():FaseControle 
		{
			return FC_controleFase;
		}
		
		public function set controleFase(value:FaseControle):void 
		{
			FC_controleFase = value;
		}
	}
}