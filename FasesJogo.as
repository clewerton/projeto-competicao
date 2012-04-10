package  
{
	import TangoGames.Fases.*;
	import Fases.*;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class FasesJogo extends FaseControle 
	{
		
		public function FasesJogo(_mainapp:DisplayObjectContainer) 
		{
			super(_mainapp);
			adicionaFase("menufase1", FaseTeste1);
			adicionaFase("menufase2", FaseTeste2);
		}	
	}
}