package TangoGames.Menus 
{
	
	/**
	 * Implementação para MovieClip Principal do Jogo para usar a Classe MenuControle
	 * @author Arthur
	 */
	public interface MenuMainInterface 
	{	
		/**
		 * metodo para manipução das opções selecionadas do controle de mmenus
		 * deve ser utilizada para executas as ações do menus pelo controle central
		 * @param	_menu
		 * referencia do objeto MenuBase selecionado
		 * @param	_opcao
		 * referencia do objeto MenuOpcao selecionado
		 * @return
		 * Se verdadeiro remove a tela do menu,
		 * se falso continua a tela do menu
		 */
		function manipulaMenuOpcaoSelecionada( _menu:MenuBase, _opcao: MenuOpcao):Boolean
	}
	
}