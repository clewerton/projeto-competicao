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
			adicionaFase(1, "Caça ao Tesouro", FaseTesouro);
			adicionaNivel(1, "Facil", 0);
			adicionaNivel(1, "Normal", 1);
			adicionaNivel(1, "Dificil", 2);
		}	
	}
}