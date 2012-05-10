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
			fases = new FasesJogo(this);
			menus.controleFase = fases;
			menus.inicia();
		}
		
		public function manipulaMenuOpcaoSelecionada(_menuCor:MenuBase, _opcao: MenuOpcao):Boolean {
			
			
			switch (_menuCor.ID_Menu) {
				
				case MenuPrincipal.MENU_PRINCIPAL:
					if (_opcao.valorRetorno == 1) {
						fases.inicia();
						return true;
					}
				break;
				case MenuPrincipal.MENU_CONTROLE_FASES:
					fases.iniciaFase(_opcao.faseID, _opcao.valorRetorno);
					return true;
				break;
				default:
			}
			return false
		}
		
		public function manipulaSairFases():void {
			menus.inicia();
		}
		
	}
}