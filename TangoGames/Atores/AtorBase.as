package TangoGames.Atores 
{
	import fl.motion.AnimatorBase;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import TangoGames.Fases.FaseBase;
	/**
	 * Classe AtorBase auxila a controlar o coportamento dos elementos dinamicos do jogos
	 * @author Arthur Figueirdo
	 */
	public class AtorBase extends Sprite {
		//variaveis de representação visual da classe Ator
		private var SP_figurino:DisplayObject;
		
		//variavel para controlar a remoção automática do objeto AtorBase
		private var BO_marcadoRemocao:Boolean;
		
		//variavel para acoplar a funcionalizade de teste de teclado na classe AtorBase
		private var FC_funcaoTeclas:Function;
		
		//variavel para guardar a referencia a classe FaseBase que o AtorBase pertence
		private var FB_faseAtor:FaseBase;
		
		//Variaveis para controle do hittest da classe AtorBase
		private var VT_hitGrupos: Vector.<Class>;
		private var DO_hitObject:DisplayObject;
		
		//Variaveis de controle de entrada e saida do Stage
		private var RE_Bordas:Rectangle;
		private var BO_tododentro:Boolean = false;
		private var BO_tocandostage:Boolean = false;
		private var BO_todofora:Boolean = false;
		private var BO_gerarEventoStage:Boolean = false;
		private var BO_naoGeraPrimeiroEvento:Boolean;
		
		//controle de pausa
		private var BO_pausaAnimacao:Boolean;
		private var ST_animacao:String;
		private var ST_animacaofim:String;
		private var MC_animacao:MovieClip;
		
		//controle de teclas 1
		private var OB_teclas:Object;
		
		/**
		 * Contrutora da Classe AtorBase 
		 * @param	_figurino
		 * objeto que indica a representação visual do Ator na tela.
		 * será adicionado a display deste objeto Ator.
		 */
		public function AtorBase(_figurino:DisplayObjectContainer) 	{
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == AtorBase ) {
				throw (new Error("AtorBase: Esta classe não pode ser instanciada diretamente"))
			}
			
			if (!(this is AtorInterface)) {
				throw (new Error("AtorBase: A classe derivada do " + this.toString() + " deve implementar a interface AtorInterface"))				
			}
			//Inicializa representação visual do objeto
			SP_figurino = _figurino;
			addChild(SP_figurino);
			
			//Inicializa variaveis da classe;
			FC_funcaoTeclas =  null;
			FB_faseAtor = null;
			BO_marcadoRemocao = false;
			
			//Inicializa variaveis para o hitTeste 
			VT_hitGrupos = new Vector.<Class>;
			DO_hitObject = SP_figurino;
			
			//Inicializa controle de teclas
			OB_teclas = new Object;
			
			//controle de animacao
			BO_pausaAnimacao = false;
			ST_animacao = "";
			ST_animacaofim= "fim";
			MC_animacao = null;
			
			//adiciona evento para detectar quando o ator enta no stage
			this.addEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage, false, 0, true);
		}
		
		/**************************************************************************************
		*                           Área das funções privadas da classe
		************************************************************************************** /
		/**
		 * manipula evento quando o ator é adicionado no stage
		 * @param	e
		 */
		private function onAdicionadoStage(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage);
			if (FB_faseAtor == null) FB_faseAtor = FaseBase(parent)
			//this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovidoStage, false, 0, true);
		}
/*		private function onRemovidoStage(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovidoStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage, false, 0, true);
		}
*/	
		/**************************************************************************************
		 *             Área das funçõe públicas da classe
		 *************************************************************************************/
		/**
		 * Testa o hit entre este objeto e o objeto atorAlvo.
		 * O teste é feito pela forma gráfica exata do objeto. 
		 * A FaseBase utiliza esta método automaticamente para teste hit entre os grupos. Pode ser sobrescrita.
		 * @param	atorAlvo
		 * Objeto AtorBase para teste do hit.
		 * @return
		 */
		public function hitTestAtor(atorAlvo:AtorBase):Boolean {
			if (this == atorAlvo) return false;
			if (DO_hitObject.hitTestObject(atorAlvo.hitObject)) {
				if (testeHitShape(this, atorAlvo)) return true;
			}
			return false
		}
		
		/**
		 * adiciona uma classe hitGrupo do Ator
		 * a FaseBase testa o hit contra todos atores deste tipo classe
		 * @param	hitClasse
		 */
		public function adcionaClassehitGrupo(hitClasse:Class):void {
			if (VT_hitGrupos == null) VT_hitGrupos = new  Vector.<Class>;
			VT_hitGrupos.push(hitClasse)
		}
		/**
		 * remove uma classe do hitGrupo do ator
		 * a FaseBase não testa o hit com atores desta classe
		 * @param	hitClasse
		 */
		public function removeClassehitGrupo(hitClasse:Class):void {
			if (VT_hitGrupos == null) return
			var i:int = VT_hitGrupos.indexOf(hitClasse);
			if (i >= 0) VT_hitGrupos.splice(i, 1);			
		}
		protected function apagahitGrupo(hitClasse:Class):void {
			VT_hitGrupos =  new  Vector.<Class>;
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
			if (FC_funcaoTeclas == null) return false;
			var bo:Boolean = FC_funcaoTeclas(tecla);
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
		 * informa se uma tecla esta pressionada
		 * @param	tecla
		 * tecla para testar
		 * @return
		 * se verdadeiro a tecla esta precionada, se falso a tecla não esta precionada
		 */
		protected function pressTecla( tecla:uint):Boolean {
			if (FC_funcaoTeclas != null) return FC_funcaoTeclas(tecla);
			return false;
		}
		/**
		 * para animacão do ator
		 */
		public function paraAnimacaoAtor():void {
			paraAnimacao(this);
		}
		/**
		 * Para Animacao
		 * @param	content
		 * 
		 */
		protected function paraAnimacao(content:DisplayObjectContainer):void {
			if (content is MovieClip) (content as MovieClip).stop();
			if (content.numChildren) {
				var child:DisplayObjectContainer;
				for (var i:int, n:int = content.numChildren; i < n; ++i)
				{
					if (content.getChildAt(i) is DisplayObjectContainer)
					{
						child = content.getChildAt(i) as DisplayObjectContainer;
               
						if (child.numChildren) paraAnimacao(child);
						else if (child is MovieClip) (child as MovieClip).stop();
					}
				}
			}
		}
		
		/**
		 * Inicia animacao deve ser chamada o controleAnimacao no update 
		 * @param	_mc
		 * @param	_nome
		 */
		protected function iniciaAnima(_mc:MovieClip, _nome:String) {
			MC_animacao = _mc;
			ST_animacao= _nome;
			ST_animacaofim = _nome + "fim";
			MC_animacao.gotoAndPlay(ST_animacao);
		}
		
		protected function controleAnima() {
			if (ST_animacao != "") {
				if (MC_animacao.currentFrameLabel == ST_animacaofim) MC_animacao.gotoAndPlay(ST_animacao);
			}
		}
		
		protected function paraAnima(pose:String)
		{
			MC_animacao.gotoAndStop("pose");
			ST_animacao = ""
		}
		
		
		public function set funcaoTeclas(value:Function):void 
		{
			FC_funcaoTeclas = value;
		}
		
		public function get marcadoRemocao():Boolean 
		{
			return BO_marcadoRemocao;
		}
		
		public function set marcadoRemocao(value:Boolean):void 
		{
			BO_marcadoRemocao = value;
		}
		
		public function get hitGrupos():Vector.<Class> 
		{
			return VT_hitGrupos;
		}
		
		public function set hitGrupos(value:Vector.<Class>):void 
		{
			VT_hitGrupos = value;
		}
		
		public function get hitObject():DisplayObject 
		{
			return DO_hitObject;
		}
		
		public function set hitObject(value:DisplayObject):void 
		{
			DO_hitObject = value;
			var Rect:Rectangle = DO_hitObject.getBounds(faseAtor);
			var BD_hitBitMapData = new BitmapData(Rect.width, Rect.height, true, 0);
			BD_hitBitMapData.draw(DO_hitObject);
		}
		/**
		 * referencia ao objeto FaseBase que o ator pertence
		 */
		public function get faseAtor():FaseBase 
		{
			return FB_faseAtor;
		}
		/**
		 * referencia ao objeto FaseBase que o ator pertence
		 */		
		public function set faseAtor(value:FaseBase):void 
		{
			FB_faseAtor = value;
		}
		
		public function get gerarEventoStage():Boolean 
		{
			return BO_gerarEventoStage;
		}
		
		public function set gerarEventoStage(value:Boolean):void 
		{
			BO_gerarEventoStage = value;
		}
		
		public function get tododentro():Boolean 
		{
			return BO_tododentro;
		}
		
		public function get tocandostage():Boolean 
		{
			return BO_tocandostage;
		}
		
		public function get todofora():Boolean 
		{
			return BO_todofora;
		}
		
		protected function get figurino():DisplayObject 
		{
			return SP_figurino;
		}
		
		protected function set figurino(value:DisplayObject):void 
		{
			this.removeChild(SP_figurino);
			SP_figurino = value;
			this.addChildAt(SP_figurino, 0);
			DO_hitObject = SP_figurino;
		}
		
		public function get animacao():String 
		{
			return ST_animacao;
		}
		/**
		 * testa o contato pela forma do objeto
		 * @param	ob1
		 * @param	ob2
		 * @return
		 */
		protected function testeHitShape(ob1:DisplayObject, ob2:DisplayObject):Boolean {
			var Rect1:Rectangle = ob1.getBounds(faseAtor);
			var Offset1:Matrix = ob1.transform.matrix;
			Offset1.tx = ob1.x - Rect1.x;
			Offset1.ty = ob1.y - Rect1.y;	

			var ClipBmpData1 = new BitmapData(Rect1.width, Rect1.height, true, 0);
			ClipBmpData1.draw(ob1, Offset1);		

			var Rect2:Rectangle = ob2.getBounds(faseAtor);
			var Offset2:Matrix = ob2.transform.matrix;
			Offset2.tx = ob2.x - Rect2.x;
			Offset2.ty = ob2.y - Rect2.y;	

			var ClipBmpData2 = new BitmapData(Rect2.width, Rect2.height, true, 0);
			ClipBmpData2.draw(ob2, Offset2);		


			var Loc1:Point = new Point(Rect1.x, Rect1.y);
			var Loc2:Point = new Point(Rect2.x, Rect2.y);	
			var teste:Boolean = false
			if (ClipBmpData2.hitTest(Loc2, 255, ClipBmpData1, Loc1,	255	)) teste = true;
			ClipBmpData1.dispose();
			ClipBmpData2.dispose();
			return teste;
		}
		
		//***********************************************************************************************
		//**********              gera evento para os limites do stage                 ******************
		//***********************************************************************************************
		/**
		 * Método para calcular a dinamica do Ator em relação ao stage
		 */
		public function geraEventoStage():void {
			RE_Bordas = this.getBounds(stage);
			if ( !BO_todofora && !BO_tocandostage && !BO_tododentro ) {
				testesaiuStage(false);
				if (BO_todofora) return;
				testeentrouTodoStage(false);
				if (BO_tododentro) return;
				testetocouStage(false);
				return;
			}
			
			if ( BO_todofora ) {
				testeentrouStage()
				return;
			}
			
			if ( BO_tododentro ) {
				testetocouStage();
				return;
			}
			
			if ( BO_tocandostage || BO_tododentro) testesaiuStage();
			
			if ( BO_tocandostage || BO_todofora ) testeentrouTodoStage();
			
		}
		/**
		 * Método teste se o Ator tocou o stage
		 * @param	geraEvento
		 * se verdadeiro gera evento se falso não gera evento somente atualiza boleanas
		 */
		private function testetocouStage(geraEvento:Boolean = true):void { 
			if ( RE_Bordas.bottom > stage.stageHeight ) {
				BO_tododentro = false;
				BO_tocandostage = true;
				BO_todofora = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
			if ( RE_Bordas.top < 0 ) {
				BO_tododentro = false;
				BO_tocandostage = true;
				BO_todofora = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
			if ( RE_Bordas.right > stage.stageWidth  ) {
				BO_tododentro = false;
				BO_tocandostage = true;
				BO_todofora = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return
			}
			if ( RE_Bordas.left < 0  ) {
				BO_tododentro = false;
				BO_tocandostage = true;
				BO_todofora = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
		}
		/**
		 * Método para calcular se o ator saiu do stage
		 * @param	geraEvento
		 * se verdadeiro gera evento se falso não gera evento somente atualiza boleanas
		 */
		private function testesaiuStage(geraEvento:Boolean = true):void {
			if ( RE_Bordas.top > stage.stageHeight ) {
				BO_todofora = true;
				BO_tocandostage = false;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( RE_Bordas.bottom < 0 ) {
				BO_todofora = true;
				BO_tocandostage = false;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( RE_Bordas.left > stage.stageWidth  ) {
				BO_todofora = true;
				BO_tocandostage = false;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( RE_Bordas.right < 0  ) {
				BO_todofora = true;
				BO_tocandostage = false;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
		}
		/**
		 * Método teste se o Ator entrou no stage
		 * @param	geraEvento
		 * se verdadeiro gera evento se falso não gera evento somente atualiza boleanas
		 * */
		private function testeentrouStage(geraEvento:Boolean = true):void {
			if ( ( RE_Bordas.top < stage.stageHeight ) && ( RE_Bordas.top > 0 ) && ( RE_Bordas.left < stage.stageWidth  ) && ( RE_Bordas.right > 0  ) )  {
				BO_todofora = false;
				BO_tocandostage = true;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( RE_Bordas.bottom > 0 ) && ( RE_Bordas.bottom < stage.stageHeight ) && ( RE_Bordas.left < stage.stageWidth  ) && ( RE_Bordas.right > 0  ) ) {
				BO_todofora = false;
				BO_tocandostage = true;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( RE_Bordas.left < stage.stageWidth  ) && ( RE_Bordas.left > 0  ) && ( RE_Bordas.top < stage.stageHeight ) && ( RE_Bordas.bottom > 0 ) ) {
				BO_todofora = false;
				BO_tocandostage = true;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( RE_Bordas.right > 0  ) && ( RE_Bordas.right < stage.stageWidth  ) && ( RE_Bordas.top < stage.stageHeight ) && ( RE_Bordas.bottom > 0 ) ) {
				BO_todofora = false;
				BO_tocandostage = true;
				BO_tododentro = false;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}			
		}
		/**
		 * funcao detecta se entrou todo no stage
		 * @param	geraEvento
		 * se verdadeiro gera evento se falso não gera evento somente atualiza boleanas
		 */
		private function testeentrouTodoStage(geraEvento:Boolean = true):void {
			if ( ( RE_Bordas.bottom < stage.stageHeight ) && ( RE_Bordas.top > 0 ) && ( RE_Bordas.right < stage.stageWidth  ) && ( RE_Bordas.left > 0  ) ) {
				BO_todofora = false;
				BO_tocandostage = false;
				BO_tododentro = true;
				if (geraEvento) dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_TODO_STAGE) );
			}
		}
		
	}
}