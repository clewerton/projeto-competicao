package TangoGames.Fases 
{
	import Fases.FaseCasteloElementos.Castelo;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
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
		private var OB_GrupoAtores:Object;
		
		
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
			OB_GrupoAtores = new Object;
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
			
			//chama update da fase
			FaseInterface(this).update(e);
			
			//chama o update dos atores
			var ator:AtorBase;
			var VT_remover:Vector.<AtorBase> =  new Vector.<AtorBase>;
			for each (ator in VT_Atores) { 
				if (ator.marcadoRemocao) VT_remover.push(ator);
				else AtorInterface(ator).update(e);
			}
			
			//Remover atores que estao marcados para remoção
			for each (ator in VT_remover) removeAtor(ator); 
			VT_remover =  new Vector.<AtorBase>;			
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
		 * Adiciona AtorBase na fase
		 * @param	_ator
		 * Ator que será acrescentado na cena da fase
		 */
		public function adicionaAtor(_ator:AtorBase)  {
			_mainapp.addChild(_ator);
			AtorInterface(_ator).inicializa();
			_ator.funcaoTeclas = this.pressTecla;
			VT_Atores.push(_ator);
			adicionaGrupoAtor(_ator);
		}
		public function removeAtor(_ator:AtorBase)  {
			var i:uint = VT_Atores.indexOf(_ator);
			VT_Atores.splice(i, 1);
			removeGrupoAtor(_ator);
			AtorInterface(_ator).remove();
			_mainapp.removeChild(_ator);
		}
		
		public function adicionaGrupoAtor(_ator:AtorBase)  {
			//trace(getDefinitionByName(getQualifiedClassName(_ator)));
			var tipo:String = getQualifiedClassName(_ator);
			var VT_grupo:Vector.<AtorBase>;
			if (tipo in OB_GrupoAtores) VT_grupo = OB_GrupoAtores[tipo];
			else VT_grupo = new Vector.<AtorBase>;
			VT_grupo.push(_ator);
		}

		public function removeGrupoAtor(_ator:AtorBase)  {
			//trace(getDefinitionByName(getQualifiedClassName(_ator)));
			var tipo:String = getQualifiedClassName(_ator);
			if (tipo in OB_GrupoAtores) {
				var VT_grupo:Vector.<AtorBase> = OB_GrupoAtores[tipo];
				var i:int = VT_grupo.indexOf(_ator);
				if (i >= 0) VT_grupo.splice(i, 1);
			}
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
		
		public function get Atores():Vector.<AtorBase> 
		{
			return VT_Atores;
		}
	}
}