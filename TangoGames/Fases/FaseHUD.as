package TangoGames.Fases 
{
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseHUD extends MovieClip 
	{
		//variavel para guardar a referencia a classe FaseBase que o FaseHUD pertence
		private var FB_faseHUD:FaseBase;

		public function FaseHUD() {
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == FaseBase ) {
				throw (new Error("FaseHUD: Esta classe não pode ser instanciada diretamente"))
			}
			if (!(this is FaseHUDInterface)) {
				throw (new Error("FaseHUD: A classe derivada do " + this.toString() + " deve implementar a interface FaseHUDInterface"))				
			}			
		}
		
		public function get faseHUD():FaseBase {
			return FB_faseHUD;
		}
		
		public function set faseHUD(value:FaseBase):void {
			FB_faseHUD = value;
		}
		
	}

}