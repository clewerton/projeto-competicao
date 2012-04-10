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
		/**
		 * Valor de Retorno para controle da interrupcao da Fase
		 */
		public static const INTERRUPCAO_CONTINUAR:uint = 0;
		public static const INTERRUPCAO_REINICIAR:uint = 1;
		public static const INTERRUPCAO_FINALIZAR:uint = 2;
		
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
			if (!(this is FaseInterface)) {
				throw (new Error("FaseBase: A classe derivada do " + this.toString() + " deve implementar a interface FaseInterface"))				
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
		/**
		 * Metodo reinicia a fase interrompida do ponto de pausa
		 */
		protected function continuaFase():void {
			_mainapp.addEventListener(Event.ENTER_FRAME, update, false, 0, true);			
		}
		
		/**
		 * Metodo chamado para interromper a fase
		 */
		protected function interrompeFase():void {
			_mainapp.removeEventListener(Event.ENTER_FRAME, update);
			switch (interrompidaFase()) {
				case INTERRUPCAO_CONTINUAR :
					continuaFase();
					break;
				case INTERRUPCAO_REINICIAR :
					reiniciarFase();
					break;
				case INTERRUPCAO_FINALIZAR :
					removeFase();
				break;
					throw ( new Error ("Valor de retorno não correspondente ao valor esperado (0-continua / 1-reinicia / 2-finaliza)") ) 
				default:
			} 
		}
		/**
		 * metodo chamado quando a fase for interrompida
		 * pausa, fim de jogo e fase concluida
		 * @return
		 * retorna o controle da ação a seguir.
		 * INTERRUPCAO_CONTINUAR =0; INTERRUPCAO_REINICIAR= 1 ; INTERRUPCAO_FINALIZAR:uint = 2; 
		 */
		protected function interrompidaFase():uint {
			return 0;
		}
		/**
		 * Metodo chamado para reiniciar a fase
		 */
		protected function reiniciarFase():void {
			BO_fimdeJogo = false;
			BO_faseConcluida = false;
			reiniciacao();
			continuaFase();
		}		
		/**
		 * Este metodo deve ser sobrescrito com ações específicas
		 * da classe derivada para reiniciar a fase
		 */
		protected function reiniciacao():void {
			throw (new Error ("A classe derivada deve sobrescrever o metodo reiniciacao"));
		}		
		/**
		 * Metodo chamado para remover a fase
		 */
		protected function removeFase():void {
			remocao();
			TC_teclas.destroi();
			TC_teclas = null;
			_mainapp.removeChild(this);
		}
		/**
		 * Este metodo deve ser sobrescrito com ações específicas
		 * da classe derivada para remover a classe
		 */		
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