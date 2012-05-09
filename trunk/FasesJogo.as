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
			adicionaFase(1, "1 - Mar Negro", FaseTesouro);
			adicionaNivel(1, "Facil", 0);
			adicionaNivel(1, "Normal", 1);
			adicionaNivel(1, "Dificil", 2);
			
			faseBloqueada(1, false);
			
			adicionaFase(2, "2 - Mar Adriático", FaseTesouro);
			adicionaNivel(2, "Facil", 0);
			adicionaNivel(2, "Normal", 1);
			adicionaNivel(2, "Dificil", 2);
			
			adicionaFase(3, "3 - Mar Morto", FaseTesouro);
			adicionaNivel(3, "Facil", 0);
			adicionaNivel(3, "Normal", 1);
			adicionaNivel(3, "Dificil", 2);
			
			adicionaFase(4, "4 - Mar Egeu", FaseTesouro);
			adicionaNivel(4, "Facil", 0);
			adicionaNivel(4, "Normal", 1);
			adicionaNivel(4, "Dificil", 2);
			
			adicionaFase(5, "5 - Mar Caspio", FaseTesouro);
			adicionaNivel(5, "Facil", 0);
			adicionaNivel(5, "Normal", 1);
			adicionaNivel(5, "Dificil", 2);
			
			adicionaFase(6, "6 - Mar Golfo Pérsico", FaseTesouro);
			adicionaNivel(6, "Facil", 0);
			adicionaNivel(6, "Normal", 1);
			adicionaNivel(6, "Dificil", 2);
			
			adicionaFase(7, "7 - Mar Mediterâneo", FaseTesouro);
			adicionaNivel(7, "Facil", 0);
			adicionaNivel(7, "Normal", 1);
			adicionaNivel(7, "Dificil", 2);
			
		}	
		
		override public function carregaFaseParametros(_faseID:uint, _nivel:uint):FaseParamentos
		{
			return new FaseJogoParamentos(_faseID,_nivel);
		}
	}
}