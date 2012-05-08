package TangoGames.Atores 
{
	import Fases.FaseTesouroElementos.BarcoHeroiAtor;
	import fl.motion.AnimatorBase;
	import flash.display.Bitmap;
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
		private var SP_figurino			:DisplayObject;
		
		//variavel para controlar a remoção automática do objeto AtorBase
		private var BO_marcadoRemocao	:Boolean;
		
		//variavel para acoplar a funcionalizade de teste de teclado na classe AtorBase
		private var FC_funcaoTeclas		:Function;
		
		//variavel para guardar a referencia a classe FaseBase que o AtorBase pertence
		private var FB_faseAtor			:FaseBase;
		
		//Variaveis para controle do hittest da classe AtorBase
		private var VT_hitGrupos		:Vector.<Class>;
		private var DO_hitObject		:DisplayObject;
		private var BO_cacheBitmap		:Boolean;
		private var BD_clipBitmap		:BitmapData;
		private var RT_clipRectan		:Rectangle;
		private var UI_clipX		 	:int;
		private var UI_clipY		 	:int;
		private var UI_clipRotation	 	:int;
				
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
			VT_hitGrupos 	= new Vector.<Class>;
			DO_hitObject 	= SP_figurino;
			BO_cacheBitmap 	=  false;
			UI_clipX		= 0;
			UI_clipY		= 0;
			UI_clipRotation	= 0;
			
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
		public function hitTestAtor(_atorAlvo:AtorBase):Boolean {
			if (this == _atorAlvo) return false;
			if (DO_hitObject.hitTestObject(_atorAlvo.hitObject)) {
				//if (testeHitShape(this, atorAlvo)) return true;
				if (testeHitShapeAtor(_atorAlvo)) return true;
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
		 * Remove AtorAnimacao
		 * @param	content
		 * 
		 */
		protected function removeAnimacao(content:DisplayObjectContainer, _vt:Vector.<AtorAnimacao> = null ):void {
			var boss:Boolean = false;
			if (_vt == null) {
				boss = true;
				_vt =  new Vector.<AtorAnimacao>;
			}
			
			if (content.numChildren) {
				var child:DisplayObjectContainer;
				for (var i:int, n:int = content.numChildren; i < n; ++i)
				{
					if (content.getChildAt(i) is DisplayObjectContainer)
					{
						child = content.getChildAt(i) as DisplayObjectContainer;
						if (child.numChildren) removeAnimacao(child, _vt);
						else if (child is AtorAnimacao) _vt.push(child)
					}
				}
			}
			
			if (content is AtorAnimacao) _vt.push(content);
			
			if (boss) for each (var a:AtorAnimacao in _vt) a.parent.removeChild(a);
			
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
		
		public function get cacheBitmap():Boolean 
		{
			return BO_cacheBitmap;
		}
		
		public function set cacheBitmap(value:Boolean):void 
		{
			BO_cacheBitmap = value;
		}
		
		public function get clipBitmap():BitmapData 
		{
			return BD_clipBitmap;
		}
		
		public function set clipBitmap(value:BitmapData):void 
		{
			BD_clipBitmap = value;
		}
		
		public function get clipRectan():Rectangle 
		{
			return RT_clipRectan;
		}
		
		public function set clipRectan(value:Rectangle):void 
		{
			RT_clipRectan = value;
		}
		/**
		 * testa o contato pela forma do objeto
		 * @param	ob1
		 * @param	ob2
		 * @return
		 */
/*		protected function testeHitShape(ob1:DisplayObject, ob2:DisplayObject):Boolean {
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
		}*/

		protected function testeHitShapeAtor2(_ator:AtorBase):Boolean {
			calculaClipBmpData();
			
			_ator.calculaClipBmpData();

			var Loc1:Point = new Point(RT_clipRectan.x, RT_clipRectan.y);
			var Loc2:Point = new Point(_ator.clipRectan.x, _ator.clipRectan.y);	
			if (BD_clipBitmap.hitTest(Loc1, 255, _ator.clipBitmap, Loc2,	255	)) return true;
			return false;
		}

		
		public function calculaClipBmpData2():void {
			if (!BO_cacheBitmap) {
				BO_cacheBitmap = true;
				RT_clipRectan = this.getBounds(faseAtor);
				var Offset:Matrix = this.transform.matrix;
				Offset.tx = this.x - RT_clipRectan.x;
				Offset.ty = this.y - RT_clipRectan.y;	
				BD_clipBitmap = new BitmapData(RT_clipRectan.width, RT_clipRectan.height, true, 0);
				BD_clipBitmap.draw(this, Offset);
			}
		}
		
		public function calculaClipBmpData():void {
			if (!BO_cacheBitmap) {
				BO_cacheBitmap = true;
				if ( UI_clipX != this.x || UI_clipY != this.y || UI_clipRotation != this.rotation ) {
					
					// atualiza situacao
					UI_clipX = this.x;
					UI_clipY = this.y;
					UI_clipRotation = this.rotation;
					
					//retangulo do clip
					RT_clipRectan = DO_hitObject.getBounds(faseAtor);
				
					// calculate the transform for the display object relative to the common parent
					var parentXformInvert:Matrix = faseAtor.transform.concatenatedMatrix.clone();
					parentXformInvert.invert();
					var targetXform:Matrix = DO_hitObject.transform.concatenatedMatrix.clone();
					targetXform.concat(parentXformInvert);
					
					// translate the target into the rect's space
					targetXform.translate( -RT_clipRectan.x, -RT_clipRectan.y);
					
					// cria clip bitmap
					BD_clipBitmap = new BitmapData(RT_clipRectan.width, RT_clipRectan.height, true, 0);
					BD_clipBitmap.draw(DO_hitObject, targetXform);
					
				}
			}
		}
		
		private function testeHitShapeAtor ( _ator:AtorBase ):Boolean {
			
			this.calculaClipBmpData()		

			_ator.calculaClipBmpData()
			
			var recinter:Rectangle = this.clipRectan.intersection(_ator.clipRectan);

			recinter.left	= recinter.left;
			recinter.top	= recinter.top;
			recinter.width  = Math.ceil(recinter.width);
			recinter.height = Math.ceil(recinter.height);
			
			if (recinter.width <=2 || recinter.height <=2 ) return false;
			
			var corte1:Rectangle = new Rectangle();

			corte1.left   = Math.ceil(recinter.left - this.clipRectan.left);
			corte1.top    = Math.ceil(recinter.top - this.clipRectan.top);
			corte1.width  = recinter.width;
			corte1.height = recinter.height;
			
			
			var rt1:Rectangle = this.clipBitmap.rect
			
			if (rt1.left > corte1.left) corte1.left = rt1.left;
			if (rt1.top > corte1.top) corte1.top = rt1.top;
			if (rt1.right < corte1.right) corte1.right = rt1.right;
			if (rt1.bottom < corte1.bottom) corte1.bottom = rt1.bottom;
						
			var img1:BitmapData = new BitmapData(corte1.width, corte1.height, true, 0);
			
			img1.copyPixels( this.clipBitmap, corte1, new Point(0,0));
			
			var corte2:Rectangle = new Rectangle();

			corte2.left   = recinter.left - _ator.clipRectan.left;
			corte2.top    = recinter.top - _ator.clipRectan.top;
			corte2.width  = recinter.width;
			corte2.height = recinter.height;
			
			var rt2:Rectangle = _ator.clipBitmap.rect
			
			if (rt2.left > corte2.left) corte2.left = rt2.left;
			if (rt2.top > corte2.top) corte2.top = rt2.top;
			if (rt2.right < corte2.right) corte2.right = rt2.right;
			if (rt2.bottom < corte2.bottom) corte2.bottom = rt2.bottom;
						
			var img2:BitmapData = new BitmapData(corte2.width, corte2.height, true, 0);
			
			img2.copyPixels( _ator.clipBitmap, corte2, new Point(0,0));
			
			var ok:Boolean = false
			
			if (img1.hitTest(new Point(0,0), 255, img2, new Point(0,0),	255	) ) ok = true;
			
			img1.dispose();
			
			img2.dispose();
			
			return ok;
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
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	class PixelPerfectCollisionDetection
	{
		/** Get the collision rectangle between two display objects. **/
		public static function getCollisionRect(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Rectangle
		{
			// get bounding boxes in common parent's coordinate space
			var rect1:Rectangle = target1.getBounds(commonParent);
			var rect2:Rectangle = target2.getBounds(commonParent);
			// find the intersection of the two bounding boxes
			var intersectionRect:Rectangle = rect1.intersection(rect2);
			if (intersectionRect.size.length> 0)
			{
				if (pixelPrecise)
				{
					// size of rect needs to integer size for bitmap data
					intersectionRect.width = Math.ceil(intersectionRect.width);
					intersectionRect.height = Math.ceil(intersectionRect.height);
					// get the alpha maps for the display objects
					var alpha1:BitmapData = getAlphaMap(target1, intersectionRect, BitmapDataChannel.RED, commonParent);
					var alpha2:BitmapData = getAlphaMap(target2, intersectionRect, BitmapDataChannel.GREEN, commonParent);
					// combine the alpha maps
					alpha1.draw(alpha2, null, null, BlendMode.LIGHTEN);
					// calculate the search color
					var searchColor:uint;
					if (tolerance <= 0)
					{
						searchColor = 0x010100;
					}
					else
					{
						if (tolerance> 1) tolerance = 1;
						var byte:int = Math.round(tolerance * 255);
						searchColor = (byte <<16) | (byte <<8) | 0;
					}
					// find color
					var collisionRect:Rectangle = alpha1.getColorBoundsRect(searchColor, searchColor);
					collisionRect.x += intersectionRect.x;
					collisionRect.y += intersectionRect.y;
					return collisionRect;
				}
				else
				{
					return intersectionRect;
				}
			}
			else
			{
				// no intersection
				return null;
			}
		}
		/** Gets the alpha map of the display object and places it in the specified channel. **/
		private static function getAlphaMap(target:DisplayObject, rect:Rectangle, channel:uint, commonParent:DisplayObjectContainer):BitmapData
		{
			// calculate the transform for the display object relative to the common parent
			var parentXformInvert:Matrix = commonParent.transform.concatenatedMatrix.clone();
			parentXformInvert.invert();
			var targetXform:Matrix = target.transform.concatenatedMatrix.clone();
			targetXform.concat(parentXformInvert);
			// translate the target into the rect's space
			targetXform.translate(-rect.x, -rect.y);
			// draw the target and extract its alpha channel into a color channel
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bitmapData.draw(target, targetXform);
			var alphaChannel:BitmapData = new BitmapData(rect.width, rect.height, false, 0);
			alphaChannel.copyChannel(bitmapData, bitmapData.rect, new Point(0, 0), BitmapDataChannel.ALPHA, channel);
			return alphaChannel;
		}
		/** Get the center of the collision's bounding box. **/
		public static function getCollisionPoint(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Point
		{
			var collisionRect:Rectangle = getCollisionRect(target1, target2, commonParent, pixelPrecise, tolerance);
			if (collisionRect != null && collisionRect.size.length> 0)
			{
				var x:Number = (collisionRect.left + collisionRect.right) / 2;
				var y:Number = (collisionRect.top + collisionRect.bottom) / 2;
				return new Point(x, y);
			}
			return null;
		}
		/** Are the two display objects colliding (overlapping)? **/
		public static function isColliding(target1:DisplayObject, target2:DisplayObject, commonParent:DisplayObjectContainer, pixelPrecise:Boolean = false, tolerance:Number = 0):Boolean
		{
			var collisionRect:Rectangle = getCollisionRect(target1, target2, commonParent, pixelPrecise, tolerance);
			if (collisionRect != null && collisionRect.size.length> 0) return true;
			else return false;
		}
	}