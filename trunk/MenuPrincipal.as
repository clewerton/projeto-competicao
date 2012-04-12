package  
{
	import TangoGames.Menus.*;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Menu controle Principal do jogo
	 * acionamento as opções do jogo e fases
	 */
	public class MenuPrincipal extends MenuControle {	
		private	var TF_txtForm:TextFormat;
		private var FaseID:int;
		/**
		* Menu controle Principal do jogo
		* acionamento as opções do jogo e fases
		*/
		public function MenuPrincipal(main:DisplayObjectContainer) {
			super(main);
			configuraFormatacao();
		}
			
		//****************************************************
		//****    Metodos privados da classe              ****
		//****************************************************
		private function configuraFormatacao():void {
			TF_txtForm = new TextFormat;
			TF_txtForm.size = 50;
			TF_txtForm.align = TextFormatAlign.CENTER;
			TF_txtForm.bold = true;			
		}
		
		override protected function defineMenuInicial():MenuBase 
		{
			var mn:MenuBase = new MenuBase("MenuPrincipal",new MenuPrincipalFundo());
			mn.adicionaOpcao("Novo Jogo", 1,null , new Iniciar());
			mn.adicionaOpcao("Opções", 1,defineMenuOpcoes);
			mn.adicionaOpcao("Selecionar Fase",2,defineMenuFases);
			mn.formatacao = TF_txtForm;	
			return mn
		}
		
		private function defineMenuFases():MenuBase {
			var mn:MenuBase = new MenuBase("MenuFases",new MenuPrincipalFundo());
			mn.adicionaOpcao("Defenda o Castelo", 1);
			mn.adicionaOpcao("Fase Teste 1", 2);
			mn.adicionaOpcao("Voltar", 2 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}
		private function defineMenuOpcoes():MenuBase {
			var mn:MenuBase = new MenuBase("MenuOpcoes",new MenuPrincipalFundo());
			mn.adicionaOpcao("Som", 1);
			mn.adicionaOpcao("Video", 2);
			mn.adicionaOpcao("Dificuldade", 3);
			mn.adicionaOpcao("Voltar", 2 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}
		
		private function defineNivel():MenuBase {
			var nome:String = ("menufase" + FaseID.toString());
			var mn:MenuBase = new MenuBase(nome,new MenuPrincipalFundo());
			mn.adicionaOpcao("Fácil", 1);
			mn.adicionaOpcao("Médio", 2);
			mn.adicionaOpcao("Dificíl", 3);
			mn.adicionaOpcao("Voltar", 2 , defineMenuFases);			
			mn.formatacao = TF_txtForm;
			return mn;
		}		

		override protected function manipulaOpcaoMenu(Menu:MenuBase, Opcao:MenuOpcao):Boolean 
		{
			if (Menu.ID_Menu == "MenuFases") {
				FaseID = Opcao.valorRetorno;
				this.desativaMenu();
				this.ativaMenu(defineNivel());
				return false;
				
			}
			return MenuMainInterface( mainapp).manipulaMenuOpcaoSelecionada(Menu, Opcao); 
		}
	}
}