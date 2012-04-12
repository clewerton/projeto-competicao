package TangoGames.Fases 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuEvent;
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class FaseControle extends EventDispatcher 
	{
		private var faseCorrente:FaseBase;
		private var fases:Object;
		private var _mainapp:DisplayObjectContainer;
		public function FaseControle(_main:DisplayObjectContainer) 
		{
			if (this.toString() == "[object FaseControle]" ) {
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
		
		public function iniciaFase(Nomefase:String, Nivel:int):void {
			if (faseCorrente != null) removeFaseCorrente();
			faseCorrente = new fases[Nomefase](_mainapp,Nivel);
			faseCorrente.iniciaFase();
			faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase, false, 0, true);
		}
		
		public function removeFaseCorrente() {
			faseCorrente.removeEventListener(FaseEvent.FASE_CONCLUIDA, controleInterrupcaoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_FIMDEJOGO, controleInterrupcaoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_PAUSA    , controleInterrupcaoFase);
			faseCorrente.removeFase();
			faseCorrente = null;
		}
		
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
		
		protected function adicionaFase(nomeFase:String,classeFase:Class):void {
			
			fases[nomeFase] = classeFase;
		}
		
		public function get mainapp():DisplayObjectContainer 
		{
			return _mainapp;
		}
				
		protected function criaMenuControle():void {
			var mn:MenuBase = new MenuBase("MenuControle",criaFundo());
			mn.adicionaOpcao("Continuar", 0);
			mn.adicionaOpcao("Reiniciar", 1);
			mn.adicionaOpcao("Sair", 2);
			_mainapp.addChild(mn);
			mn.addEventListener(MenuEvent.OPCAO_SELECIONADA, manipulaOpcao, false,0, true);
		}
		
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
		
		
		protected function criaFundo():Sprite {
			var sp:Sprite = new Sprite ;
			sp.graphics.lineStyle(1, 0X000000, 0);
			sp.graphics.beginFill(0X000000,0.2);
			sp.graphics.drawRect( 0 , 0 , _mainapp.stage.stageWidth , _mainapp.stage.stageHeight);
			sp.graphics.endFill();
			return sp;
		}
	}
}