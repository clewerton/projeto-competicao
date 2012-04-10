package TangoGames.Fases 
{
	import TangoGames.Teclado.TeclasControle;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class FaseBase extends MovieClip
	{
		private var IN_Nivel:int;
		private var _mainapp:DisplayObjectContainer;
		private var BO_fimdeJogo:Boolean;
		private var BO_faseConcluida:Boolean;
		private var TC_teclas:TeclasControle;

		
		public function FaseBase(_main:DisplayObjectContainer, Nivel:int) 
		{
			if (this.toString() == "[object FaseBase]" ) {
				throw (new Error("FaseBase: Esta classe não pode ser instanciada diretamente"))
			}
			if (_main == null) {
				throw (new Error("FaseBase: O Parametro main não pode ser nulo"))				
			}
			this._mainapp = _main;
			this.IN_Nivel = Nivel;
		}
		/**
		 * Inicia a execução da fase
		 */
		public function iniciaFase():void {
			if (inicializacao()) {
			_mainapp.addChild(this);
			TC_teclas = new TeclasControle(this);
			stage.focus = this;
			continuaFase();
			}
		}
		/**
		 * Esta função deve ser usada para as inicializações específicas da Classe derivada
		 * é chamada no metodo iniciaFase;
		 * @return
		 * se falso(false) não a fase não será iniciada;
		 */
		protected function inicializacao():Boolean {
			throw (new Error ("A classe derivada deve sobrescrever o metodo inicialiazacao"));
			return false
		}
		
		/**
		 * Esta função será executa a cada evento Enter-Frame.
		 * Todas as atualizações da classe derivada devem ser inseridas nesta função
		 * @param	e
		 * parametro do tipo event obrigatório para funções de manipulação de eventos
		 */
		protected function update(e:Event):void {
			throw (new Error ("A classe derivada deve sobrescrever o metodo update"));
			
		}
		
		protected function continuaFase():void {
			_mainapp.addEventListener(Event.ENTER_FRAME, update, false, 0, true);			
		}
		
		protected function pausaFase():void {
			_mainapp.removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_PAUSA));
		}
		
		protected function concluiFase():void {
			_mainapp.removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_CONCLUIDA));
		}
		
		protected function terminaFase():void {
			_mainapp.removeEventListener(Event.ENTER_FRAME, update);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_PAUSA));
		}

		protected function removeFase():void {
			remocao();
			TC_teclas.destroi();
			TC_teclas = null;
			_mainapp.removeChild(this);
		}
		
		protected function remocao():void {
			throw (new Error ("A classe derivada deve sobrescrever o metodo remocao"));
		}
		
		protected function pressTecla(tecla:uint):Boolean {
			return TC_teclas.pressTecla(tecla);
		}
		
		public function get fimdeJogo():Boolean 
		{
			return BO_fimdeJogo;
		}
		
		public function get faseConcluida():Boolean 
		{
			return BO_faseConcluida;
		}
		
	}

}