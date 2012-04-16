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
		private var FB_faseCorrente:FaseBase;
		
		//lista de nomes das fase registradas e suas Classes
		private var VT_fases:Vector.<FaseDado>;
		private var VT_fasesID:Vector.<uint>;
		
		//referencia ao MovieClip principal do documeno
		private var DO_mainapp:DisplayObjectContainer;
		
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

			this.DO_mainapp = _main;
			
			this.FB_faseCorrente = null;
			
			VT_fases = new Vector.<FaseDado>;
			
			VT_fasesID = new Vector.<uint>;
			
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
			DO_mainapp.addChild(mn);
			mn.addEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcao, false,0, true);
		}
		
		/**
		 * manipula de retorno a seleção da opção do menu de interrupção
		 * @param	e
		 * referencia do objeto evento retornado
		 */
		private function manipulaOpcao(e:MenuEvent):void 
		{
			DO_mainapp.removeChild(MenuBase(e.currentTarget));
			switch (e.OpcaoObj.valorRetorno) 
			{
				case 0:
				  FB_faseCorrente.continuaFase();
				  break;
				case 1:
				  FB_faseCorrente.reiniciarFase();
				  break;
				case 2:
				  removeFaseCorrente();
				  FaseMainInterface(DO_mainapp).manipulaSairFases()
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
			sp.graphics.drawRect( 0 , 0 , DO_mainapp.stage.stageWidth , DO_mainapp.stage.stageHeight);
			sp.graphics.endFill();
			return sp;
		}

		/***************************************************************************
		 *    Área dos métodos protegidos da classe
		 * ************************************************************************/
		/**
		 * adiciona uma nova fase a lista de fases que será controlada
		 * @param   faseID
		 * Número inteiro identificador da fase
		 * @param	nomeMenu
		 * texto que será apresentado no menu
		 * @param	classeFase
		 * Nome da Classe de um fase específica
		 */
		protected function adicionaFase( faseID:uint,  nomeMenu: String, classeFase:Class ):void {
			VT_fases.push(new FaseDado(faseID, nomeMenu, classeFase));
			VT_fasesID.push(faseID);
		}
		/**
		 * adiciona nivel a faae
		 * @param	faseID
		 * Número de identificação da fase
		 * @param	nomeNivel
		 * Nome do Nível apresentado no menu
		 * @param	valorNivel
		 * Nome do nivel que será passado no acionamento da fase
		 */
		protected function adicionaNivel( faseID:uint,  nomeNivel: String, valorNivel: uint, bloq: Boolean = true ):void {
			var i:int = VT_fasesID.indexOf(faseID);			
			VT_fases[i].adicionaNiveis( nomeNivel, valorNivel, bloq);
		}
		
		protected function faseBloqueada( faseID:uint, bloqueada:Boolean):void {
			var i:uint = VT_fasesID.indexOf(faseID);
			VT_fases[i].bloqueada = bloqueada;
			if (!bloqueada) {
				if (VT_fases[i].VT_Niveis.length == 0 ) VT_fases[i].adicionaNiveis( "Unico", 0 );
				VT_fases[i].VT_Niveis[0].bloq = false;
			}
		}
		
		/**
		 * remove a fase que esta sendo executada
		 */
		protected function removeFaseCorrente():void {
			FB_faseCorrente.removeEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase);
			FB_faseCorrente.removeEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase);
			FB_faseCorrente.removeEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase);
			FB_faseCorrente.removeFase();
			FB_faseCorrente = null;
		}

		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
		/**
		 * Inicia execução da fase 
		 * @param	faseID
		 * Número inteiro identificador da fase
		 * @param	Nivel
		 * Número do nível da fase que será executada
		 */
		public function iniciaFase(_faseID:uint, _nivel:int):void {
			if (FB_faseCorrente != null) removeFaseCorrente();
			var i:uint = VT_fasesID.indexOf(_faseID);
			FB_faseCorrente = new VT_fases[i].classFase(DO_mainapp, _nivel);
			FB_faseCorrente.iniciaFase();
			FB_faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase, false, 0, true);
		}
		/**
		 * adiciona as Fase registradas no Menu de opções
		 * @param	_menu
		 * referencia do objeto MenuBase para inclusão de opções das fase do jogo
		 */
		public function adicionaOpcoesMenu(_menu:MenuBase):void {
			for each (var fd:FaseDado in VT_fases) {
				_menu.adicionaOpcao( fd.nomeMenu, fd.ID,null,null,!fd.bloqueada)
			}
		}
		/**
		 * adiciona opcoes dos níveis do Menu
		 * @param	_faseID
		 * número do ID da fase 
		 * @param	_menu
		 * referencia do objeto MenuBase
		 */
		public function adicionaOpcoesNiveisMenu(_faseID:uint, _menu:MenuBase):void {
			var index:uint = VT_fasesID.indexOf(_faseID);
			for (var i:uint = 0; i < VT_fases[index].VT_Niveis.length; i++ ) {
				_menu.adicionaOpcaoNiveisFase(_faseID, VT_fases[index].VT_Niveis[i].nome, VT_fases[index].VT_Niveis[i].valor ,null,null,!VT_fases[index].VT_Niveis[i].bloq)
			}
		}

		
		public function faseNives(_faseID:uint):Array {
			var i:int = VT_fasesID.indexOf(_faseID);
			return VT_fases[i].VT_Niveis;			
		}
		
		/***************************************************************************
		 *    Propriedade visíveis da Classe
		 * ************************************************************************/
		/**
		 * referencia da objeto principal do jogo
		 */
		public function get mainapp():DisplayObjectContainer 
		{
			return DO_mainapp;
		}		
	}
}
internal class FaseDado {
	public var classFase:Class;
	public var ID:	uint;
	public var nomeMenu: String;
	public var bloqueada:Boolean;
	public var VT_Niveis:Array;
	public function FaseDado( _faseID:uint , _nomeMenu: String, _classeFase:Class) {
		classFase = _classeFase;
		ID = _faseID;
		nomeMenu = _nomeMenu;
		bloqueada = true;
		VT_Niveis = new Array;
	}
	public function adicionaNiveis(_nome:String, _valor:uint, _bloq:Boolean = true) {
		var i:uint = VT_Niveis.push( { nome:_nome, valor: _valor, bloq: _bloq } );
	}
	
}