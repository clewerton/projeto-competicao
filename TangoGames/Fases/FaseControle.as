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
			
			if (this.toString() == "[object FaseBase]" ) {
				throw (new Error("FaseControle: Esta classe não pode ser instanciada diretamente"))
			}
			if (_main == null) {
				throw (new Error("FaseControle: O Parametro main não pode ser nulo"))				
			}
			if (!(_main is FaseMainInterface)) {
				throw (new Error("FaseControle: O objeto main fornecido deve implementar a Interface FaseMainInterface"))
			}

			this._mainapp = _main;
			
			fases = new Object;
			
		}
		
		public function iniciaFase(Nomefase:String, Nivel:int):void {
			
			faseCorrente = new fases[Nomefase](_mainapp,Nivel);
			faseCorrente.iniciaFase();
			faseCorrente.addEventListener(FaseEvent.FASE_CONCLUIDA, controleconclusaoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_FIMDEJOGO, controleFimdeJogoFase, false, 0, true);
			faseCorrente.addEventListener(FaseEvent.FASE_PAUSA, controlePausaFase, false, 0, true);
		}
		public function removeFaseCorrente() {
			faseCorrente.removeEventListener(FaseEvent.FASE_CONCLUIDA, controleconclusaoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_FIMDEJOGO, controleFimdeJogoFase);
			faseCorrente.removeEventListener(FaseEvent.FASE_PAUSA, controlePausaFase);
			faseCorrente.removeFase();
		}
		
		protected function controlePausaFase(e:FaseEvent):void 
		{
			criaMenuControle();
		}
		
		protected function controleFimdeJogoFase(e:FaseEvent):void 
		{
			criaMenuControle();
		}
		
		protected function controleconclusaoFase(e:FaseEvent):void 
		{
			criaMenuControle();
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