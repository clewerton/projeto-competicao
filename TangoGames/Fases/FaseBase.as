package TangoGames.Fases 
{
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Teclado.TeclasControle;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class FaseBase extends MovieClip {
		
		private var IN_Nivel:int;
		private var _mainapp:DisplayObjectContainer;
		private var BO_fimdeJogo:Boolean;
		private var BO_faseConcluida:Boolean;
		private var BO_pausa:Boolean;
		
		//controle de teclado
		private var TC_teclas:TeclasControle;
		
		//controle de atores
		private var VT_Atores:Vector.<AtorBase>;
		
		
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
			VT_Atores = new Vector.<AtorBase>;
		}
		/**
		 * Inicia a execução da fase
		 */
		public function iniciaFase():void {
			_mainapp.addChild(this);
			if (FaseInterface(this).inicializacao()) {
				continuaFase();
			}
		}
		/**
		 * Esta função deve ser usada para as inicializações específicas da Classe derivada
		 * é chamada no metodo iniciaFase;
		 * @return
		 * se falso(false) não a fase não será iniciada;
		 */
		//protected function inicializacao():Boolean {
		//	throw (new Error ("A classe derivada deve sobrescrever o metodo inicialiazacao"));
		//	return false
		//}
		
		/**
		 * Esta função será executa a cada evento Enter-Frame.
		 * Todas as atualizações da classe derivada devem ser inseridas nesta função
		 * @param	e
		 * parametro do tipo event obrigatório para funções de manipulação de eventos
		 */
		//protected function update(e:Event):void {
		//	throw (new Error ("A classe derivada deve sobrescrever o metodo update"));
		//}
		/**
		 * Metodo reinicia a fase interrompida do ponto de pausa
		 */
		public function continuaFase():void {
			TC_teclas = new TeclasControle(stage);
			stage.stageFocusRect = false;
			stage.focus = stage;
			BO_pausa = false;
			_mainapp.addEventListener(Event.ENTER_FRAME, updateFase, false, 0, true);			
		}
		
		private function updateFase(e:Event):void {
			FaseInterface(this).update(e);
			for each (var ator:AtorBase in VT_Atores) { AtorInterface(ator).update(e); }
		}
		
		/**
		 * Metodo chamado para fase parada
		 */
		protected function pausaFase():void {
			TC_teclas.destroi();
			TC_teclas = null;
			BO_pausa = true;
			_mainapp.removeEventListener(Event.ENTER_FRAME, updateFase);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_PAUSA))
		}
		
		/**
		 * Metodo chamado para terminar a fase
		 */
		protected function terminoFase():void {
			BO_fimdeJogo = true;
			_mainapp.removeEventListener(Event.ENTER_FRAME, updateFase);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_FIMDEJOGO))
		}

		/**
		 * Metodo chamado para concluir a fase
		 */
		protected function concluidaFase():void {
			BO_faseConcluida = true;
			_mainapp.removeEventListener(Event.ENTER_FRAME, updateFase);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_CONCLUIDA));
		}

		/**
		 * Metodo chamado para reiniciar a fase
		 */
		public function reiniciarFase():void {
			BO_fimdeJogo = false;
			BO_faseConcluida = false;
			BO_pausa = false;
			
			FaseInterface(this).reiniciacao();
			for each (var ator:AtorBase in VT_Atores) AtorInterface(ator).reinicializa();

			continuaFase();
		}		
		/**
		 * Este metodo deve ser sobrescrito com ações específicas
		 * da classe derivada para reiniciar a fase
		 */
		//protected function reiniciacao():void {
		//	throw (new Error ("A classe derivada deve sobrescrever o metodo reiniciacao"));
		//}		
		/**
		 * Metodo chamado para remover a fase
		 */
		public function removeFase():void {
			FaseInterface(this).remocao();
			if (TC_teclas != null) {
				TC_teclas.destroi();
				TC_teclas = null;
			}
			for each ( var ator:AtorBase in VT_Atores) {
				AtorInterface(ator).remove();
			}
			VT_Atores = new Vector.<AtorBase>;
			_mainapp.removeChild(this);
		}
		/**
		 * Este metodo deve ser sobrescrito com ações específicas
		 * da classe derivada para remover a classe
		 */		
		//protected function remocao():void {
		//	throw (new Error ("A classe derivada deve sobrescrever o metodo remocao"));
		//}
		
		public function adicionaAtor(_ator:AtorBase) {
			_mainapp.addChild(_ator);
			AtorInterface(_ator).inicializa();
			_ator.funcaoTeclas = this.pressTecla;
			VT_Atores.push(_ator);
		}
		
		protected function pressTecla(tecla:uint):Boolean {
			if (TC_teclas != null) { return TC_teclas.pressTecla(tecla) };
			return false;
		}
		
		public function get fimdeJogo():Boolean 
		{
			return BO_fimdeJogo;
		}
		
		public function get faseConcluida():Boolean 
		{
			return BO_faseConcluida;
		}
		
		public function get pausa():Boolean 
		{
			return BO_pausa;
		}
	}
}