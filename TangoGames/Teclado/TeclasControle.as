package TangoGames.Teclado 
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	/**
	 * Controle de teclado para capturar os eventos KEYDOWN e KEYUP
	 * dispoe do metodo pressTecla que infor se uma tecla esta pressionada
	 * 
	 */
	public class TeclasControle 
	{
		//variavel que mantem indice das teclas pressionadas
		private var OB_teclas:Object;
		
		//objeto reference onde será adicionado os eventos de KEYDOWN e KEYUP
		private var ED_obj:EventDispatcher;
		
		/**
		 * Construtura do controle de teclas
		 * @param	_obj
		 * ojbeto onde será adicionado os eventos de KEYDOWN e KEYUP
		 * para captura das teclas precionadas
		 */
		public function TeclasControle(_obj:EventDispatcher) {
			OB_teclas = new Object;
			ED_obj = _obj;
			ED_obj.addEventListener(KeyboardEvent.KEY_DOWN, teclaPrecionada, false, 0, true);
			ED_obj.addEventListener(KeyboardEvent.KEY_UP, teclaLiberada, false, 0, true);
		}
		/**********************************************************************
		 *              Área das funções privadas da classe
		 * *******************************************************************/
		/**
		 * manipula evento de KEYDOWN
		 * @param	e
		 * evento enviado
		 */
		private function teclaPrecionada(e:KeyboardEvent):void 
		{
			OB_teclas[e.keyCode] = true;
		}
		/**
		 * manipula evento de KEYUP
		 * @param	e
		 * evento enviado
		 */		
		private function teclaLiberada(e:KeyboardEvent):void {
			OB_teclas[e.keyCode] = false;
		}
		/**********************************************************************
		 *              Área das funções publicas da classe
		 * *******************************************************************/
		/**
		 * Verifica se uma tecla esta pressionada
		 * @param	codigoTecla
		 * codigo da tecla para verificação se esta pressionada;
		 * @return
		 * Se verdadeiro indica que a tecla do codigoTecla esta precionada
		 */
		public function pressTecla(codigoTecla:uint):Boolean {
			if (codigoTecla in OB_teclas) {
				return OB_teclas[codigoTecla];
			}
			return false
		}
		/**
		 * destroi elementos do objeto;
		 */
		public function destroi():void {
			OB_teclas = null;
			ED_obj.removeEventListener(KeyboardEvent.KEY_DOWN, teclaPrecionada);
			ED_obj.removeEventListener(KeyboardEvent.KEY_UP, teclaLiberada);
		}
	}

}