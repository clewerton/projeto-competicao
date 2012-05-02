package  
{
	import TangoGames.Fases.FaseParamentos;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseJogoParamentos extends FaseParamentos 
	{
		//Parametros da FAse
		public static const PARAM_PONTO_TESOURO = "PONTOS_TESOURO";
		
		public function FaseJogoParamentos( _faseID:uint , _nivel:uint) 
		{
			super(_faseID, _nivel);
			//inicializa pontuacao de tesouros
			inicializaPontuacaoTesouros()
		}
		
		private function inicializaPontuacaoTesouros() {
			this[PARAM_PONTO_TESOURO] = 1000;
			switch (faseID) 
			{
				case 2:
					this[PARAM_PONTO_TESOURO] = 2000;
				break;
					
				default:
			}
		}
	}
}