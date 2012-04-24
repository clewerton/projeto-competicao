package TangoGames.Fases 
{
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
		
		private var IN_faseID:int;
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
		
		//controle de teclas 1
		private var OB_teclas:Object;

		//Controle de HUD
		private var VT_HUDS:Vector.<FaseHUD>;
		
		/**
		 * construtora da Class FaseBase
		 * @param	_main
		 * referencia ao objeto principal do jogo
		 * @param	_nivel
		 * Número do nível da fase
		 */
		public function FaseBase(_main:DisplayObjectContainer, _nivel:int) 
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
			this.IN_nivel = _nivel;
			
			//inicializa vetores da FaseBase
			VT_Atores = new Vector.<AtorBase>;
			VT_GrupoClass =  new Vector.<Class>;
			VT_GrupoAtores = new Vector.<Vector.<AtorBase>>;
			VT_HUDS = new Vector.<FaseHUD>;
			OB_teclas = new Object;
		}

		
		 
		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
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
			this.dispatchEvent(new FaseEvent(FaseEvent.FASE_CONTINUA));
			this.addEventListener(Event.ENTER_FRAME, updateFase, false, 0, true);			
		}
		/**
		 * Adiciona AtorBase na fase
		 * e chama o metodo inicializa do AtorBase
		 * @param	_ator
		 * referencia do objeto AtorBase que será acrescentado na cena da fase
		 */
		public function adicionaAtor(_ator:AtorBase, hitGrupos: Vector.<Class> = null)  {
			this.addChild(_ator);
			_ator.funcaoTeclas = this.pressTecla;
			_ator.faseAtor = this;
			VT_Atores.push(_ator);
			adicionaGrupoAtor(_ator , hitGrupos);
			AtorInterface(_ator).inicializa();
			dispatchEvent(new FaseEvent(FaseEvent.ATOR_CRIADO, _ator));
		}
		/**
		 * Adiciona AtorBase na fase
		 * e chama o método remove do AtorBase
		 * @param	_ator
		 * referencia do objeto AtorBase que será removida da cena da fase 
		 */
		public function removeAtor(_ator:AtorBase)  {
			var i:uint = VT_Atores.indexOf(_ator);
			VT_Atores.splice(i, 1);
			removeGrupoAtor(_ator);
			AtorInterface(_ator).remove();
			this.removeChild(_ator);
			dispatchEvent(new FaseEvent(FaseEvent.ATOR_REMOVIDO, _ator));
		}
		/**
		 * Adiciona vetor de Grupos de Classe para hittest
		 * @param	_ator
		 * referencia do objeto AtorBase
		 * @param	hitGrupos
		 * vetor de classes do grupo de hit
		 */
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
		/**
		 * Remove grupo uma classe do grupo de hit do Ator 
		 * @param	_ator
		 * referencia do objeto AtorBase
		 */
		public function removeGrupoAtor(_ator:AtorBase)  {
			var classTipo:Class = Class(getDefinitionByName(getQualifiedClassName(_ator)));
			var index:int = VT_GrupoClass.indexOf(classTipo);
			var i:int = VT_GrupoAtores[index].indexOf(_ator);
			if (i >= 0) VT_GrupoAtores[index].splice(i, 1);
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
			
			for each (var hud:FaseHUD in VT_HUDS) FaseHUDInterface(hud).reinicializa();
			
			continuaFase();
			
			OB_teclas = new Object;
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
			var t:uint =  VT_Atores.length;
			var i:int;
			for ( i = t - 1 ; i >= 0 ; i-- ) removeAtor(AtorBase(VT_Atores[i]));
			
			t = VT_HUDS.length;
			for ( i = t - 1 ; i >= 0 ; i-- ) removeHUD(FaseHUD(VT_HUDS[i]));
			
			VT_Atores = new Vector.<AtorBase>;
			
			VT_HUDS = new Vector.<FaseHUD>;
			
			_mainapp.removeChild(this);
			
		}
		/**
		 * adiciona HUD na Fase
		 * @param	_hud
		 * referencia do objeto FaseHUD
		 */
		public function adicionaHUD(_hud:FaseHUD):void {
			this.addChild(_hud);
			VT_HUDS.push(_hud);
			FaseHUDInterface(_hud).inicializa();
		}
		/**
		 * remove HUD na Fase
		 * @param	_hud
		 * referencia do objeto FaseHUD
		 */
		public function removeHUD(_hud:FaseHUD):void {
			var i:uint = VT_HUDS.indexOf(_hud);
			VT_HUDS.splice(i, 1);
			FaseHUDInterface(_hud).remove();
			this.removeChild(_hud);
		}
		/***************************************************************************
		 *    Área dos métodos protegidos da classe
		 * ************************************************************************/
		/**
		 * informa se uma tecla esta pressionada
		 * @param	tecla
		 * tecla para testar
		 * @return
		 * se verdadeiro a tecla esta precionada, se falso a tecla não esta precionada
		 */
		protected function pressTecla(tecla:uint):Boolean {
			if (TC_teclas != null) { return TC_teclas.pressTecla(tecla) };
			return false;
		}
		/**
		 * informa se uma tecla foi precionada uma vez e foi solta solta
		 * se a tecla ficar pressionada não gera true duas vezes
		 * @param	tecla
		 * tecla para testar
		 * @return
		 * se verdadeiro a tecla foi precionada uma vez, se falso a tecla não foi liberada
		 */
		protected function pressTecla1( tecla:uint ):Boolean {
			if (TC_teclas == null) return false;
			var bo:Boolean = TC_teclas.pressTecla(tecla);
			if (bo) {
				var p:Boolean = false;
				if (tecla in OB_teclas) p = OB_teclas[tecla];
				OB_teclas[tecla] = true;
				if (p) return false;
				else return true;
			}
			else {
				OB_teclas[tecla] = false;
				return false;
			}
			return false;
		}
		/**
		 * Metodo chamado para pausa da fase 
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
			for each( var ator:AtorBase in VT_Atores) ator.paraAnimacaoAtor()
			dispatchEvent(new FaseEvent(FaseEvent.FASE_FIMDEJOGO));
		}

		/**
		 * Metodo chamado para concluir a fase
		 */
		protected function concluidaFase():void {
			BO_faseConcluida = true;
			this.removeEventListener(Event.ENTER_FRAME, updateFase);
			for each( var ator:AtorBase in VT_Atores) ator.paraAnimacaoAtor()
			dispatchEvent(new FaseEvent(FaseEvent.FASE_CONCLUIDA));
		}

		/***************************************************************************
		 *    Área dos métodos privados da classe
		 * ************************************************************************/
		/**
		 * Update da FaseBase
		 * @param	e
		 */
		private function updateFase(e:Event):void {
			
			//chama update da fase
			FaseInterface(this).update(e);
			
			if (BO_pausa || BO_fimdeJogo || BO_faseConcluida) {
				//atualiza huds
				for each (var h:FaseHUD in VT_HUDS) FaseHUDInterface(h).update(e);
				return;
			}
			
			//chama o update dos atores
			var ator:AtorBase;
			for each (ator in VT_Atores) ator.cacheBitmap = false;
			var VT_remover:Vector.<AtorBase> =  new Vector.<AtorBase>;
			for each (ator in VT_Atores) { 
				if (ator.marcadoRemocao) VT_remover.push(ator);
				else {
					AtorInterface(ator).update(e);
					if (ator.gerarEventoStage) ator.geraEventoStage();
					testaHitGrupos(ator);
				}
			}
			
			//atualiza huds
			for each (var hud:FaseHUD in VT_HUDS) FaseHUDInterface(hud).update(e);
			
			//Remover atores que estao marcados para remoção
			for each (ator in VT_remover) removeAtor(ator); 
			VT_remover =  new Vector.<AtorBase>;			
		}
		/**
		 * Testa o hit com entre os grupos de hit.
		 * @param	_ator
		 * referencia do objeto AtorBase que será testado o hit
		 */
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
		/***************************************************************************
		 *    Propriedade visíveis da Classe
		 * ************************************************************************/

		/**
		 * indica o fim do Jogo sem vitória
		 */
		public function get fimdeJogo():Boolean 
		{
			return BO_fimdeJogo;
		}
		
		/**
		 * indica se a fase foi concluida com sucesso 
		 */
		public function get faseConcluida():Boolean {
			return BO_faseConcluida;
		}
		
		/**
		 * indica se entrou em pausa do jogo
		 */
		public function get pausa():Boolean {
			return BO_pausa;
		}
		
		/**
		 * Vetor de atores da fase
		 */
		public function get Atores():Vector.<AtorBase> {
			return VT_Atores;
		}
		
		/**
		 * valor do nível da fase
		 */
		public function get nivel():int {
			return IN_nivel;
		}
		
		public function get faseID():int 
		{
			return IN_faseID;
		}
		
		public function set faseID(value:int):void 
		{
			IN_faseID = value;
		}
	}
}