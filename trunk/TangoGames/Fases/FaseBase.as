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
		
		private var IN_nivel:int;
		private var _mainapp:DisplayObjectContainer;
		private var BO_fimdeJogo:Boolean;
		private var BO_faseConcluida:Boolean;
		private var BO_pausa:Boolean;
		
		//controle de teclado
		private var TC_teclas:TeclasControle;
		
		//controle de atores
		private var VT_Atores:Vector.<AtorBase>;
		private var VT_GrupoClass:Vector.<Class>;
		private var VT_GrupoAtores:Vector.<Vector.<AtorBase>>;
		
		
		public function FaseBase(_main:DisplayObjectContainer, Nivel:int) 
		{
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == FaseBase ) {
				throw (new Error("FaseBase: Esta classe não pode ser instanciada diretamente"))
			}
			if (!(this is FaseInterface)) {
				throw (new Error("FaseBase: A classe derivada do " + this.toString() + " deve implementar a interface FaseInterface"))				
			}
			if (_main == null) {
				throw (new Error("FaseBase: O Parametro main não pode ser nulo"))				
			}
			this._mainapp = _main;
			this.IN_nivel = Nivel;
			VT_Atores = new Vector.<AtorBase>;
			VT_GrupoClass =  new Vector.<Class>;
			VT_GrupoAtores = new Vector.<Vector.<AtorBase>>;
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
		 * Metodo reinicia a fase interrompida do ponto de pausa
		 */
		public function continuaFase():void {
			TC_teclas = new TeclasControle(stage);
			stage.stageFocusRect = false;
			stage.focus = this;
			BO_pausa = false;
			this.addEventListener(Event.ENTER_FRAME, updateFase, false, 0, true);			
		}
		/****************************************************************************
		 *                     Update global da Fase                                *
		 * @param	e                                                               *  
		 ****************************************************************************/
		private function updateFase(e:Event):void {
			
			//chama update da fase
			FaseInterface(this).update(e);
			
			if (BO_pausa || BO_fimdeJogo || BO_faseConcluida) return;
			
			//chama o update dos atores
			var ator:AtorBase;
			var VT_remover:Vector.<AtorBase> =  new Vector.<AtorBase>;
			for each (ator in VT_Atores) { 
				if (ator.marcadoRemocao) VT_remover.push(ator);
				else {
					AtorInterface(ator).update(e);
					if (ator.gerarEventoStage) ator.geraEventoStage();
					testaHitGrupos(ator);
				}
			}
			
			//Remover atores que estao marcados para remoção
			for each (ator in VT_remover) removeAtor(ator); 
			VT_remover =  new Vector.<AtorBase>;			
		}
		
		private function testaHitGrupos(_ator:AtorBase):void {
			if (_ator.hitGrupos != null) {
				var index:int;
				for each (var c:Class in _ator.hitGrupos) {
					index = VT_GrupoClass.indexOf(c);
					if (index>=0) {
						for each( var atorColidiu:AtorBase in VT_GrupoAtores[index] ) if (_ator.hitTestAtor(atorColidiu)) FaseInterface(this).colisao(_ator , atorColidiu);
					}
				}
			}
		}
		/**
		 * Metodo chamado para fase parada
		 */
		protected function pausaFase():void {
			TC_teclas.destroi();
			TC_teclas = null;
			BO_pausa = true;
			this.removeEventListener(Event.ENTER_FRAME, updateFase);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_PAUSA));
		}
		
		/**
		 * Metodo chamado para terminar a fase
		 */
		protected function terminoFase():void {
			BO_fimdeJogo = true;
			this.removeEventListener(Event.ENTER_FRAME, updateFase);
			dispatchEvent(new FaseEvent(FaseEvent.FASE_FIMDEJOGO));
		}

		/**
		 * Metodo chamado para concluir a fase
		 */
		protected function concluidaFase():void {
			BO_faseConcluida = true;
			this.removeEventListener(Event.ENTER_FRAME, updateFase);
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
		public function adicionaAtor(_ator:AtorBase, hitGrupos: Vector.<Class> = null)  {
			this.addChild(_ator);
			AtorInterface(_ator).inicializa();
			_ator.funcaoTeclas = this.pressTecla;
			VT_Atores.push(_ator);
			adicionaGrupoAtor(_ator , hitGrupos);
			dispatchEvent(new FaseEvent(FaseEvent.ATOR_CRIADO, _ator));
		}
		public function removeAtor(_ator:AtorBase)  {
			var i:uint = VT_Atores.indexOf(_ator);
			VT_Atores.splice(i, 1);
			removeGrupoAtor(_ator);
			AtorInterface(_ator).remove();
			this.removeChild(_ator);
			dispatchEvent(new FaseEvent(FaseEvent.ATOR_REMOVIDO, _ator));
		}
		
		public function adicionaGrupoAtor(_ator:AtorBase, hitGrupos: Vector.<Class> = null)  {
			var classTipo:Class = Class(getDefinitionByName(getQualifiedClassName(_ator)));
			var index:int = VT_GrupoClass.indexOf(classTipo);
			if (index < 0 ) {
				index = VT_GrupoClass.push(classTipo) - 1;
				VT_GrupoAtores.push(new Vector.<AtorBase>);
			}
			VT_GrupoAtores[index].push(_ator);
			_ator.hitGrupos = hitGrupos;
		}

		public function removeGrupoAtor(_ator:AtorBase)  {
			var classTipo:Class = Class(getDefinitionByName(getQualifiedClassName(_ator)));
			var index:int = VT_GrupoClass.indexOf(classTipo);
			var i:int = VT_GrupoAtores[index].indexOf(_ator);
			if (i >= 0) VT_GrupoAtores[index].splice(i, 1);
		}

		protected function pressTecla(tecla:uint):Boolean {
			if (TC_teclas != null) { return TC_teclas.pressTecla(tecla) };
			return false;
		}
		
		public function get fimdeJogo():Boolean 
		{
			return BO_fimdeJogo;
		}
		
		public function get faseConcluida():Boolean {
			return BO_faseConcluida;
		}
		
		public function get pausa():Boolean {
			return BO_pausa;
		}
		
		public function get Atores():Vector.<AtorBase> {
			return VT_Atores;
		}
		
		public function get nivel():int {
			return IN_nivel;
		}
	}
}