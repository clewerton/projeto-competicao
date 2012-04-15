package TangoGames.Fases 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuEvent;
	/**
	 * controle de execução das fases do jogo
	 * @author Arthur Figueiredo
	 */
	public class FaseControle extends EventDispatcher 
	{
		//variável que mantem a fase corrente
		private var faseCorrente:FaseBase;
		
		//lista de nomes das fase registradas e suas Classes
		private var fases:Object;
		
		//referencia ao MovieClip principal do documeno
		private var _mainapp:DisplayObjectContainer;
		
		/**
		 * construtora da fase
		 * @param	_main
		 * referencia do objeto principal do jogo
		 */
		public function FaseControle(_main:DisplayObjectContainer) 
		{
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == FaseControle ) {
				throw (new Error("FaseControle: Esta classe não pode ser instanciada diretamente"))
			}
			if (_main == null) {
				throw (new Error("FaseControle: O Parametro main não pode ser nulo"))				
			}
			if (!(_main is FaseMainInterface)) {
				throw (new Error("FaseControle: O objeto main fornecido deve implementar a Interface FaseMainInterface"))
			}

			this._mainapp = _main;
			
			this.fases = new Object;
			
			this.faseCorrente = null;
			
		}
		
		/***************************************************************************
		 *    Área dos métodos privados da classe
		 * ************************************************************************/
		/**
		 * manipula evento de interrupacao da fase pausa, terminada e concluida.
		 * @param	e
		 * evento retornado
		 */
		private function controleInterrupcaoFase(e:FaseEvent):void 
		{	var mn:MenuBase = new MenuBase("MenuControle", criaFundo());
			switch (e.type) {
				case FaseEvent.FASE_PAUSA:
					mn.adicionaOpcao("Continuar", 0)
					mn.adicionaOpcao("Reiniciar", 1);
					mn.adicionaOpcao("Abandonar", 2);
				break;
				case FaseEvent.FASE_FIMDEJOGO:
					mn.adicionaOpcao("Reiniciar", 1);
					mn.adicionaOpcao("Sair", 2);
				break;
				case FaseEvent.FASE_CONCLUIDA:
					mn.adicionaOpcao("Joga Novamente", 1);
					mn.adicionaOpcao("Proxima Fase", 4);
					mn.adicionaOpcao("Sair", 2);
				break;
					
				default:
			}
			_mainapp.addChild(mn);
			mn.addEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcao, false,0, true);
		}
		
		/**
		 * manipula de retorno a seleção da opção do menu de interrupção
		 * @param	e
		 * referencia do objeto evento retornado
		 */
		private function manipulaOpcao(e:MenuEvent):void 
		{
			_mainapp.removeChild(MenuBase(e.currentTarget));
			switch (e.OpcaoObj.valorRetorno) 
			{
				case 0:
				  faseCorrente.continuaFase();
				  break;
				case 1:
				  faseCorrente.reiniciarFase();
				  break;
				case 2:
				  removeFaseCorrente();
				  FaseMainInterface(_mainapp).manipulaSairFases()
				  break;
				default:
			} 
		}
		
		/**
		 * cria fundo para o menu de interrupção
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

		/***************************************************************************
		 *    Área dos métodos protegidos da classe
		 * ************************************************************************/
		/**
		 * adiciona uma nova fase a lista de fases que será controlada
		 * @param	nomeFase
		 * texto identificador da fase para referencia de controle
		 * @param	classeFase
		 * Nome da Classe de um fase específica
		 */
		protected function adicionaFase(nomeFase:String,classeFase:Class):void {
			
			fases[nomeFase] = classeFase;
		}
		/**
		 * remove a fase que esta sendo executada
		 */
		protected function removeFaseCorrente():void {
			faseCorrente.removeEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase);
			faseCorrente.removeFase();
			faseCorrente = null;
		}

		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
		/**
		 * Inicia execução da fase 
		 * @param	Nomefase
		 * Nome texto identificador da fase
		 * @param	Nivel
		 * Número do nível da fase que será executada
		 */
		public function iniciaFase(Nomefase:String, Nivel:int):void {
			if (faseCorrente != null) removeFaseCorrente();
			faseCorrente = new fases[Nomefase](_mainapp,Nivel);
			faseCorrente.iniciaFase();
			faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase, false, 0, true);
		}
		
		/***************************************************************************
		 *    Propriedade visíveis da Classe
		 * ************************************************************************/
		/**
		 * referencia da objeto principal do jogo
		 */
		public function get mainapp():DisplayObjectContainer 
		{
			return _mainapp;
		}		
	}
}