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
		private var FD_dados		:FasesDados;
		
		public function FasesJogo(_mainapp:DisplayObjectContainer) 
		{
			super(_mainapp);
			
			//carrega Fase Dados
			FD_dados = new FasesDados();
			
			//primeira fase
			adicionaFase(1, "1 - Mar Negro", FaseTesouro);
			//adicionaNivel(1, "Facil", 0);
			//adicionaNivel(1, "Normal", 1);
			//adicionaNivel(1, "Dificil", 2);
			
			faseBloqueada(1, false);
			
			//adiciona segunda fase
			adicionaFase(2, "2 - Mar Adriático", FaseTesouro);
			//adicionaNivel(2, "Facil", 0);
			//adicionaNivel(2, "Normal", 1);
			//adicionaNivel(2, "Dificil", 2);
			
			trace("faseliberada:", FD_dados.faseLiberada);
			//desbloquea fase 2
			if (FD_dados.faseLiberada >= 2) faseBloqueada(2, false);
			
			//adiciona terceira fase
			adicionaFase(3, "3 - Mar Morto", FaseTesouro);
			//adicionaNivel(3, "Facil", 0);
			//adicionaNivel(3, "Normal", 1);
			//adicionaNivel(3, "Dificil", 2);
			
			//desbloquea fase 3
			if (FD_dados.faseLiberada >= 3) faseBloqueada(3, false);
			
			//adiciona quarta fase
			adicionaFase(4, "4 - Mar Egeu", FaseTesouro);
			//adicionaNivel(4, "Facil", 0);
			//adicionaNivel(4, "Normal", 1);
			//adicionaNivel(4, "Dificil", 2);
			
			//desbloquea fase 4
			if (FD_dados.faseLiberada >= 4) faseBloqueada(4, false)
			
			//adiciona quinta fase
			adicionaFase(5, "5 - Mar Caspio", FaseTesouro);
			//adicionaNivel(5, "Facil", 0);
			//adicionaNivel(5, "Normal", 1);
			//adicionaNivel(5, "Dificil", 2);

			//desbloquea fase 5
			if (FD_dados.faseLiberada >= 5) faseBloqueada(5, false)
			
			//adiciona sexta fase
			adicionaFase(6, "6 - Mar Golfo Pérsico", FaseTesouro);
			//adicionaNivel(6, "Facil", 0);
			//adicionaNivel(6, "Normal", 1);
			//adicionaNivel(6, "Dificil", 2);

			//desbloquea fase 6
			if (FD_dados.faseLiberada >= 6) faseBloqueada(6, false)
					
			//adiciona setima fase
			adicionaFase(7, "7 - Mar Mediterâneo", FaseTesouro);
			//adicionaNivel(7, "Facil", 0);
			//adicionaNivel(7, "Normal", 1);
			//adicionaNivel(7, "Dificil", 2);
			
			//desbloquea fase 6
			if (FD_dados.faseLiberada >= 7) faseBloqueada(7, false)
		}	
		
		override public function carregaFaseParametros(_faseID:uint, _nivel:uint):FaseParamentos
		{
			return new FaseJogoParamentos(_faseID,_nivel);
		}
		
		
	}
}