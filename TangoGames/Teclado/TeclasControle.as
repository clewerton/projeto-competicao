package TangoGames.Teclado 
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class TeclasControle 
	{
		var OB_teclas:Object;
		var ED_obj:EventDispatcher;
		public function TeclasControle(_obj) {
			OB_teclas = new Object;
			ED_obj = _obj;
			ED_obj.addEventListener(KeyboardEvent.KEY_DOWN, teclaPrecionada, false, 0, true);
			ED_obj.addEventListener(KeyboardEvent.KEY_UP, teclaLiberada, false, 0, true);
		}
			
		private function teclaPrecionada(e:KeyboardEvent):void 
		{
			OB_teclas[e.keyCode] = true;
		}
		
		private function teclaLiberada(e:KeyboardEvent):void {
			OB_teclas[e.keyCode] = false;
		}

		public function pressTecla(codigoTecla:uint):Boolean {
			if (codigoTecla in OB_teclas) {
				return OB_teclas[codigoTecla];
			}
			return false
		}
		public function destroi() {
			OB_teclas = new Object;
			ED_obj.removeEventListener(KeyboardEvent.KEY_DOWN, teclaPrecionada);
			ED_obj.removeEventListener(KeyboardEvent.KEY_UP, teclaLiberada);
		}
		
	}

}