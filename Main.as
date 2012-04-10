package  
{
	import TangoGames.Fases.*;
	import TangoGames.Menus.*;
	import TangoGames.Teclado.TeclasControle;
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class Main extends MovieClip implements MenuMainInterface
	{
		var menu:MenuControle;
		var fase:FaseControle;
		
		public function Main() 
		{
			mainmenu();
		}
		
		private function mainmenu():void {
			menu = new MenuPrincipal(this);
			menu.inicia();
			fase = new FasesJogo(this);
		}
		
		public function manipulaMenuOpcaoSelecionada(MenuCor:MenuBase, Opcao: MenuOpcao):Boolean {
			trace(MenuCor.ID_Menu); 
			trace(Opcao.valorRetorno);
			switch (MenuCor.ID_Menu) 
			{
				case "MenuFases": 
					
				break;
			default:
				fase.iniciaFase(MenuCor.ID_Menu, Opcao.valorRetorno);
				return true;
			}
			
			return false
		}
	}
}