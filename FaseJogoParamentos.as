package  
{
	import TangoGames.Fases.FaseParamentos;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseJogoParamentos extends FaseParamentos 
	{
		//Parametros da Pontuacao Fase
		public static const PARAM_PONTOS_TESOURO 		= "PONTOS_TESOURO";
		public static const PARAM_PONTOS_BARCO_INIMIGO 	= "PONTOS_BARCO_INIMIGO";
		public static const PARAM_PONTOS_CAPTURA_BOTE 	= "PONTOS_CAPTURA_BOTE";
		
		//Parametros do inimigo
		public static const PARAM_INIMIGO_VELOC_MAX		= "INIMIGO_VELOC_MAX";
		public static const PARAM_INIMIGO_QTD_CANHOES	= "INIMIGO_QTD_CANHOES";
		public static const PARAM_INIMIGO_FREQ_TIRO		= "INIMIGO_FREQ_TIRO";
		public static const PARAM_INIMIGO_MAXIMO_VIDA	= "INIMIGO_MAXIMO_VIDA";
		
		//Parametros do tiro inimigo
		public static const PARAM_TIRO_INIMIGO_VELOCID	= "TIRO_INIMIGO_VELOCID";
		public static const PARAM_TIRO_INIMIGO_DANO		= "TIRO_INIMIGO_DANO";
		public static const PARAM_TIRO_INIMIGO_ALCANCE	= "TIRO_INIMIGO_ALCANCE";
		
		public function FaseJogoParamentos( _faseID:uint , _nivel:uint) 
		{
			super(_faseID, _nivel);
			
			//inicializa pontuacao de tesouros e barcos
			pontuacao();
			
			//caracteristicas do inimigo
			inimigo();
			
		}
		
		private function pontuacao() {
			this[PARAM_PONTOS_TESOURO] 			= 1000;
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 500;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 1000;		
			switch (faseID) 
			{
				case 2:
					this[PARAM_PONTOS_TESOURO] = 2000;
				break;
					
				default:
			}
		}
		
		/**
		 * 
		 */
		private function inimigo() {
			//barco inimigo
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	    = 10;
			this[PARAM_TIRO_INIMIGO_DANO]			= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]		= 350;
			
		}
	}
}