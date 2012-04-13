package TangoGames.Atores 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
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
		public function AtorBase(_figurino:DisplayObjectContainer) 	{
			if (this.toString() == "[object AtorBase]" ) {
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
		}
		
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
	}
}