package TangoGames.Atores 
{
	import fl.motion.AnimatorBase;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class AtorBase extends Sprite {
		private var SP_figurino:DisplayObject;
		private var FC_funcaoTeclas:Function;
		private var BO_marcadoRemocao:Boolean;
		private var VT_hitGrupos: Vector.<Class>;
		private var DO_hitObject:DisplayObject;
		private var FB_faseAtor:FaseBase;
		
		//Variaveis de controle de entrada e saida do Stage
		private var RE_Bordas:Rectangle;
		private var BO_tododentro:Boolean = false;
		private var BO_tocandostage:Boolean = false;
		private var BO_todofora:Boolean = false;
		private var BO_gerarEventoStage:Boolean = false;
		private var BO_naoGeraPrimeiroEvento:Boolean;
		
		public function AtorBase(_figurino:DisplayObjectContainer) 	{
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == AtorBase ) {
				throw (new Error("AtorBase: Esta classe não pode ser instanciada diretamente"))
			}
			
			if (!(this is AtorInterface)) {
				throw (new Error("AtorBase: A classe derivada do " + this.toString() + " deve implementar a interface AtorInterface"))				
			}
			
			SP_figurino = _figurino;
			addChild(SP_figurino);
			FC_funcaoTeclas =  null;
			BO_marcadoRemocao = false;
			VT_hitGrupos = new Vector.<Class>;
			//hitTeste 
			DO_hitObject = SP_figurino;
			FB_faseAtor = null;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage, false, 0, true);
		}
		
		public function hitTestAtor(atorAlvo:AtorBase):Boolean {
			if (DO_hitObject.hitTestObject(atorAlvo.hitObject)) {
				if (testeHitShape(this, atorAlvo)) return true;
			}
			return false
		}
		
		private function onAdicionadoStage(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage);
			if (FB_faseAtor == null) FB_faseAtor = FaseBase(parent)
			//this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovidoStage, false, 0, true);
		}
		
		protected function adcionaClasehitGrupo(hitClasse:Class):void {
			if (VT_hitGrupos == null) VT_hitGrupos = new  Vector.<Class>;
			VT_hitGrupos.push(hitClasse)
		}
		protected function removeClasehitGrupo(hitClasse:Class):void {
			if (VT_hitGrupos == null) return
			var i:int = VT_hitGrupos.indexOf(hitClasse);
			if (i >= 0) VT_hitGrupos.splice(i, 1);			
		}
		protected function apagahitGrupo(hitClasse:Class):void {
			VT_hitGrupos =  new  Vector.<Class>;
		}
/*		private function onRemovidoStage(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovidoStage);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage, false, 0, true);
		}
*/		
		
		protected function pressTecla(tecla:uint):Boolean {
			if (FC_funcaoTeclas != null) { return FC_funcaoTeclas(tecla) };
			return false;
		}
		
		public function set funcaoTeclas(value:Function):void 
		{
			FC_funcaoTeclas = value;
		}
		
		public function get figurino():DisplayObject 
		{
			return SP_figurino;
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
		
		public function get faseAtor():FaseBase 
		{
			return FB_faseAtor;
		}
		
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