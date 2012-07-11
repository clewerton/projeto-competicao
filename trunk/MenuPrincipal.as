package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
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
		//variaveis do menu principal
		public static const MENU_PRINCIPAL:String =  "MenuPrincipal";
		public static const MENU_UPGRADES:String  =  "MenuUpgrades";
		public static const MENU_TUTORIAL:String  =  "MenuTutorial";
		public static const MENU_CREDITOS:String  =  "MenuCreditos";
		
		//Musica
		private var SC_canalSom		:SoundChannel;
		private var SD_musicaAtual	:Sound;
		
		private	var TF_txtForm:TextFormat;
		private var FaseID:int;
		/**
		* Menu controle Principal do jogo
		* acionamento as opções do jogo e fases
		*/
		public function MenuPrincipal(_main:DisplayObjectContainer) {
			super(_main);
			configuraFormatacao();
			SC_canalSom = new SoundChannel
			SD_musicaAtual = null;
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
		//****************************************************
		//****  Metodos de sobrescritos do MenuControle   ****
		//****************************************************
		/**
		 * Método Sobrescrito para capturar as opções do menu de Fases
		 * e selecionar a FaseID antes do Menu de seleção da dificuldade
		 * @param	Menu
		 * Menu Corrente
		 * @param	Opcao
		 * Opcção Selecionada
		 * @return
		 * Verdadeiro (remove Menu) ou Falso (Não remove o menu)
		 */
		override protected function manipulaOpcaoMenu(Menu:MenuBase, Opcao:MenuOpcao):Boolean 
		{
			if (Menu.ID_Menu == "MenuFases") {
				FaseID = Opcao.valorRetorno;
				this.desativaMenu();
				this.ativaMenu(defineNivel());
				return false;
			}
			SC_canalSom.stop();
			SD_musicaAtual = null;
			return MenuMainInterface( mainapp).manipulaMenuOpcaoSelecionada(Menu, Opcao); 
		}
		
		//****************************************************
		//****    Metodos de definição de menus           ****
		//****************************************************		
		/**
		 * Define Menu Principal do Jogo, sobrecreve obrigatóriamente o método da classe MenuControle.
		 * @return
		 * Retorna uma instancia do Menu do tipo MenuBase
		 */
		override protected function defineMenuInicial():MenuBase 
		{	tocaMusica (new MusicaMenu);
				
			var mn:MenuBase = new MenuBase(MENU_PRINCIPAL, new MenuPrincipalFundo());
			mn.adicionaOpcao("New Game", 1 );
			//mn.adicionaOpcao("Opções", 2,defineMenuOpcoes);
			mn.adicionaOpcao("Stage Select",3,defineMenuFases);
			mn.adicionaOpcao("Upgrades", 4, defineMenuUpgrades);
			mn.adicionaOpcao("Tutorial", 5, defineMenuTutorial);
			mn.adicionaOpcao("Credits", 6, defineMenuCreditos);
			mn.formatacao = TF_txtForm;	
			return mn;
		}
		
		/**
		 * Define Menu Das Fase do Jogo
		 * * @return
		 * Retorna uma instancia do Menu do tipo MenuBase
		 */
		private function defineMenuFases():MenuBase {
			tocaMusica (new MusicaMenu);
			var mn:MenuBase = new MenuBase(MENU_CONTROLE_FASES , new MenuPrincipalFundo());
			controleFase.adicionaOpcoesMenu(mn);
			mn.adicionaOpcao("Return", 2 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}

		private function defineMenuUpgrades():MenuBase {
			tocaMusica (new MusicaUpgrade);
			var mn:MenuBase = new MenuUpgrades(MENU_UPGRADES);
			mn.semFundo = true;
			mn.adicionaOpcao("Return", 99 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}
		
		private function defineMenuTutorial():MenuBase {
			tocaMusica (new MusicaCreditos);
			var mn:MenuBase = new MenuTutorial(MENU_TUTORIAL, new MenuPrincipalFundo());
			mn.adicionaOpcao("Return", 99 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}

		private function defineMenuCreditos():MenuBase {
			tocaMusica (new MusicaCreditos);
			var mn:MenuBase = new MenuCreditos(MENU_CREDITOS, new MenuPrincipalFundo());
			mn.adicionaOpcao("Return", 99 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}
		
		
		/**
		 * Define Menu de Opções do Jogo
		 * * @return
		 * Retorna uma instancia do Menu do tipo MenuBase
		 */
	/*	private function defineMenuOpcoes():MenuBase {
			var mn:MenuBase = new MenuBase("MenuOpcoes",new MenuPrincipalFundo());
			mn.adicionaOpcao("Som", 1);
			mn.adicionaOpcao("Video", 2);
			mn.adicionaOpcao("Dificuldade", 3);
			mn.adicionaOpcao("Voltar", 2 , defineMenuInicial);			
			mn.formatacao = TF_txtForm;
			return mn;
		}*/
		
		/**
		 * Define Menu de níveis das fase do jogo
		 * * @return
		 * Retorna uma instancia do Menu do tipo MenuBase
		 */		
		private function defineNivel():MenuBase {
			tocaMusica (new MusicaMenu);
			var nome:String = ("menufase" + FaseID.toString());
			var mn:MenuBase = new MenuBase(nome,new MenuPrincipalFundo());
			mn.adicionaOpcao("Fácil", 1);
			mn.adicionaOpcao("Médio", 2);
			mn.adicionaOpcao("Dificíl", 3);
			mn.adicionaOpcao("Return", 2 , defineMenuFases);			
			mn.formatacao = TF_txtForm;
			return mn;
		}
		
		static public function get MENU_CONTROLE_FASES():String 
		{
			return MenuControle.MENU_CONTROLE_FASES;
		}
		
		private function tocaMusica(_musica:Sound):void {
			if (SD_musicaAtual == null) {
				SD_musicaAtual = _musica;
				SC_canalSom = SD_musicaAtual.play(0, int.MAX_VALUE);
			}
			else if (_musica != SD_musicaAtual ) {
				SC_canalSom.stop();
				SD_musicaAtual = _musica;
				SC_canalSom = SD_musicaAtual.play(0, int.MAX_VALUE);
			}
		}
		
	}
}