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
			adicionaFase (1, "Defenda o Castelo", FaseCastelo);
			adicionaNivel(1, "Fácil", 1, false);
			adicionaNivel(1, "Normal", 2, false);
			adicionaNivel(1, "Difícil", 3, false);
			
			adicionaFase (2, "Viajem Espacial", FaseEspaco);
			adicionaNivel(2, "Fácil", 1, false);
			adicionaNivel(2, "Normal", 2, false);
			adicionaNivel(2, "Difícil", 3, false);
			
			adicionaFase(3,"Caça ao Tesouro", FaseTesouro);
			adicionaFase(4, "Fase de Teste1", FaseTeste1);
			
			faseBloqueada(1, false);
			faseBloqueada(2, false);
			faseBloqueada(3, false);
		}	
	}
}