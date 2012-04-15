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
	public class Main extends MovieClip implements MenuMainInterface,FaseMainInterface
	{
		private var menus:MenuControle;
		private var fases:FaseControle;
		
		public function Main() 
		{
			mainmenu();
		}
		
		private function mainmenu():void {
			menus = new MenuPrincipal(this);
			menus.inicia();
			fases = new FasesJogo(this);
		}
		
		public function manipulaMenuOpcaoSelecionada(MenuCor:MenuBase, Opcao: MenuOpcao):Boolean {
			switch (MenuCor.ID_Menu) 
			{
				case "MenuFases": 
					
				break;
			default:
				fases.iniciaFase(MenuCor.ID_Menu, Opcao.valorRetorno);
				return true;
			}
			
			return false
		}
		
		public function manipulaSairFases():void {
			menus.inicia();
		}
		
	}
}