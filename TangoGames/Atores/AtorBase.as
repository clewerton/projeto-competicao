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
		var SP_figurino:DisplayObject;
		var FC_funcaoTeclas:Function;
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
		}
		
		protected function pressTecla(tecla:uint):Boolean {
			if (FC_funcaoTeclas != null) { return FC_funcaoTeclas(tecla) };
			return false;
		}
		
		public function set funcaoTeclas(value:Function):void 
		{
			FC_funcaoTeclas = value;
		}
	}

}