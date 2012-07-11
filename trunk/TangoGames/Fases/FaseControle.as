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
	 * 
	 */
	public class FaseControle extends EventDispatcher 
	{
		//variável que mantem a fase corrente
		private var FB_faseCorrente		:FaseBase;
		
		//lista de nomes das fase registradas e suas Classes
		private var VT_fases			:Vector.<FaseDado>;
		private var VT_fasesID			:Vector.<uint>;
		
		//referencia ao MovieClip principal do documeno
		private var DO_mainapp			:DisplayObjectContainer;
		
		//variavel que indica que concluiu a última fase
		private var BO_ultimaFaseOK		:Boolean;
		private var UI_ultimaFaseID		:uint;
		
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

			this.DO_mainapp 		= _main;
						
			this.FB_faseCorrente 	= null;

			VT_fases 		= new Vector.<FaseDado>;
			
			VT_fasesID 		= new Vector.<uint>;
			
			BO_ultimaFaseOK = false;
			
			UI_ultimaFaseID = 0;
			
		}
		
		/***************************************************************************
		 *    Área dos métodos privados da classe
		 * ************************************************************************/
		/**
		 * manipula evento de interrupacao da fase pausa, terminada e concluida.
		 * pode ser sobrescrita para controle das interrupções da Fase
		 * @param	e
		 * evento retornado
		 */
		protected function controleInterrupcaoFase(e:FaseEvent):void 
		{	var mn:MenuBase = new MenuBase("MenuControle", criaFundo());
			switch (e.type) {
				case FaseEvent.FASE_PAUSA:
					mn.adicionaOpcao("Continue", 0)
					mn.adicionaOpcao("Restart", 1);
					mn.adicionaOpcao("Back to Menu", 2);
				break;
				case FaseEvent.FASE_FIMDEJOGO:
					mn.adicionaOpcao("Restart", 1);
					mn.adicionaOpcao("Back to Menu", 2);
				break;
			case FaseEvent.FASE_CONCLUIDA:
					if (!destravaProximaFase(FaseBase(e.currentTarget).faseID , FaseBase(e.currentTarget).nivel)) {
						ultimaFaseOK = true;
						removeFaseCorrente();
						FaseMainInterface(DO_mainapp).manipulaSairFases();
						return;
					}
					mn.adicionaOpcao("Play Again", 1);
					mn.adicionaOpcao("Next Stage", 4);
					mn.adicionaOpcao("Back to Menu", 2);
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
				case 4:
				  if (proximaFase(FB_faseCorrente.faseID,FB_faseCorrente.nivel)) FaseMainInterface(DO_mainapp).manipulaSairFases();
				default:
			} 
		}
		
		/**
		 * cria fundo para o menu de interrupção
		 * @return
		 */
		private function criaFundo():Sprite {
			var sp:Sprite = new Sprite;
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
			UI_ultimaFaseID = faseID;
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
		
		/**
		 * Desbloqueia proxima fase
		 * @param	_faseID
		 * id da fase anterior
		 * @param	_nivel
		 * nivel de dificuldade anterior
		 * @return
		 * falso se última fase
		 */
		protected function destravaProximaFase(_faseID:uint, _nivel:uint):Boolean  {
			
			//desbloqueia proxima fase
			var i:uint = VT_fasesID.indexOf(_faseID);
			if (i >= VT_fases.length - 1) return false;
			i++;
			VT_fases[i].bloqueada = false;
			if ( VT_fases[i].VT_Niveis.length == 0) VT_fases[i].adicionaNiveis( "Unico", 0 );			
			for (var ni:uint = 0 ; ni < VT_fases[i].VT_Niveis.length ; ni++) {
				VT_fases[i].VT_Niveis[ni].bloq = false;
				if ( VT_fases[i].VT_Niveis[ni].valor == _nivel ) break;
			}
			return true;
		}

		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
		/**
		 * Prossegue na proxima fase
		 * @param	faseAtual
		 * ID da fase corrente
		 * @return
		 * se verdadeiro terminou o Jogo se falso não concluiu
		 */
		public function proximaFase(faseAtual:uint, nivelAtual:uint):Boolean {
			if (FB_faseCorrente != null) removeFaseCorrente();
			var i:uint = VT_fasesID.indexOf(faseAtual);
			if ( i >= VT_fases.length - 1) {
				BO_ultimaFaseOK = true;
				return true;			
			}
			i++;
			if (VT_fases[i].bloqueada) {
				throw (new Error("Fase bloqueada!"))
				return true
			}
			FB_faseCorrente = new VT_fases[i].classFase(DO_mainapp,this, VT_fases[i].ID, nivelAtual);
			FB_faseCorrente.iniciaFase();
			FB_faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase, false, 0, true);
			return false;
		}
		
		/**
		 * Inicia automaticamento a primeira fase ou a última fase salva
		 */
		public function inicia():void {
			if (FB_faseCorrente != null) removeFaseCorrente();
			var nivel:uint =  VT_fases[0].VT_Niveis[0].valor
			FB_faseCorrente = new VT_fases[0].classFase(DO_mainapp,this,VT_fases[0].ID, nivel);
			FB_faseCorrente.iniciaFase();
			FB_faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase, false, 0, true);
			FB_faseCorrente.addEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase, false, 0, true);
		}

		/**
		 * Inicia execução da fase 
		 * @param	faseID
		 * Número inteiro identificador da fase
		 * @param	Nivel
		 * Número do nível da fase que será executada
		 */
		public function iniciaFase(_faseID:uint, _nivel:uint):void {
			if (FB_faseCorrente != null) removeFaseCorrente();
			var i:uint = VT_fasesID.indexOf(_faseID);
			FB_faseCorrente = new VT_fases[i].classFase(DO_mainapp, this, _faseID,_nivel);
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
		
		/**
		 * retorna o array de niveis da fase
		 * @param	_faseID
		 * ID da fase
		 * @return
		 */
		public function faseNives(_faseID:uint):Array {
			var i:int = VT_fasesID.indexOf(_faseID);
			return VT_fases[i].VT_Niveis;			
		}
		
		/**
		 * Este método retorna dos paramentros específicos da fase
		 * @param	faseID
		 * ID da fase
		 * @return
		 * objeto com os paramentos especificos da fase
		 */
		public function carregaFaseParametros(_faseID:uint, _nivel:uint):FaseParamentos {
			throw (new Error("FaseControle: O método 'carregaFaseParametros' deve ser sobrescrito/implementado pela classe derivada de " + this.toString()));
			return null;
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
		
		public function get faseCorrente():FaseBase 
		{
			return FB_faseCorrente;
		}
		
		public function get ultimaFaseID():uint 
		{
			return UI_ultimaFaseID;
		}
		
		public function get ultimaFaseOK():Boolean 
		{
			return BO_ultimaFaseOK;
		}
		
		public function set ultimaFaseOK(value:Boolean):void 
		{
			BO_ultimaFaseOK = value;
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