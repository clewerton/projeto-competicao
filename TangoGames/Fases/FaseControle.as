package TangoGames.Fases 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
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
				throw (new Error("FaseBase: Esta classe não pode ser instanciada diretamente"))
			}
			
			this._mainapp = _main;
			
			fases = new Object;
			
		}
		
		public function iniciaFase(Nomefase:String, Nivel:int):void {
			
			faseCorrente = new fases[Nomefase](_mainapp,Nivel);
			_mainapp.addChild(faseCorrente);
			faseCorrente.iniciaFase();
		}
		
		protected function adicionaFase(nomeFase:String,classeFase:Class):void {
			
			fases[nomeFase] = classeFase;
		}
		
		public function get mainapp():DisplayObjectContainer 
		{
			return _mainapp;
		}
		
	}

}