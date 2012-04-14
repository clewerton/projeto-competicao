package TangoGames.Atores 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		private var OB_hitObject:DisplayObject;
		private var FB_faseAtor:FaseBase;
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
			OB_hitObject = figurino;
			FB_faseAtor = null;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdicionadoStage, false, 0, true);
		}
		
		private function onAdicionadoStage(e:Event):void 
		{
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
			return OB_hitObject;
		}
		
		public function set hitObject(value:DisplayObject):void 
		{
			OB_hitObject = value;
		}
		
		public function get faseAtor():FaseBase 
		{
			return FB_faseAtor;
		}
		
		public function set faseAtor(value:FaseBase):void 
		{
			FB_faseAtor = value;
		}
	}
}