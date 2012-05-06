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
		public static const PARAM_PONTOS_BARCO_INIMIGO 	= "PONTOS_BARCO_INIMIGO";
		public static const PARAM_PONTOS_CAPTURA_BOTE 	= "PONTOS_CAPTURA_BOTE";
		
		//Parametros do inimigo
		public static const PARAM_INIMIGO_VELOC_MAX		= "INIMIGO_VELOC_MAX";
		public static const PARAM_INIMIGO_QTD_CANHOES	= "INIMIGO_QTD_CANHOES";
		public static const PARAM_INIMIGO_FREQ_TIRO		= "INIMIGO_FREQ_TIRO";
		public static const PARAM_INIMIGO_MAXIMO_VIDA	= "INIMIGO_MAXIMO_VIDA";
		
		//Parametros do bote de fuga
		public static const PARAM_BOTE_FUGA_VELOC_MAX	= "BOTE_FUGA_VELOC_MAX";
		
		//Parametros do tiro inimigo
		public static const PARAM_TIRO_INIMIGO_VELOCID	= "TIRO_INIMIGO_VELOCID";
		public static const PARAM_TIRO_INIMIGO_DANO		= "TIRO_INIMIGO_DANO";
		public static const PARAM_TIRO_INIMIGO_ALCANCE	= "TIRO_INIMIGO_ALCANCE";
		
		//Paramentos de compra vida
		public static const PARAM_ILHA_PONTOS_POR_VIDA		= "ILHA_PONTOS_POR_VIDA";
		public static const PARAM_ILHA_QTD_VIDA_LOTE		= "ILHA_QTD_VIDA_LOTE";

		//Paramentos de compra municao
		public static const PARAM_ILHA_PONTOS_POR_MUNICAO	= "ILHA_PONTOS_POR_MUNICAO";
		public static const PARAM_ILHA_QTD_MUNICAO_LOTE		= "ILHA_QTD_MUNICAO_LOTE";

		//Parametros de Tesouro
		public static const PARAM_ILHA_TOTAL_PONTOS			= "ILHA_TOTAL_PONTOS";
		public static const PARAM_ILHA_QTD_PONTOS_LOTE		= "ILHA_QTD_PONTOS_LOTE";
		public static const PARAM_ILHA_QTD_MAX_INI_DEFESA	= "ILHA_QTD_MAX_INI_DEFESA";
		
		public function FaseJogoParamentos( _faseID:uint , _nivel:uint) 
		{
			super(_faseID, _nivel);
			
			//inicializa pontuacao de tesouros e barcos
			pontuacao();
			
			//caracteristicas do inimigo
			inimigo();
			
			//parametros das ilhas
			ilhas();
			
		}
		
		private function ilhas():void 
		{
			//vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
		}
		
		private function pontuacao() {
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
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
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
	}
}