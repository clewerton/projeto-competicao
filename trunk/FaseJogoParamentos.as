package  
{
	import TangoGames.Fases.FaseParamentos;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseJogoParamentos extends FaseParamentos 
	{
		//Paramentros de tamanho do Mapa
		public static const PARAM_FASE_TAMANHO_ALTURA 		= "FASE_TAMANHO_ALTURA";
		public static const PARAM_FASE_TAMANHO_LARGURA 		= "FASE_TAMANHO_LARGURA";
		
		//Paramentros do Ilhas da Fase
		public static const PARAM_FASE_QTD_ILHAS_TESOURO	= "FASE_QTD_ILHAS_TESOURO";
		public static const PARAM_FASE_QTD_ILHAS_CANHAO		= "FASE_QTD_ILHAS_CANHAO";
		public static const PARAM_FASE_QTD_ILHAS_MUNICAO	= "FASE_QTD_ILHAS_MUNICA";
		public static const PARAM_FASE_QTD_ILHAS_VIDA		= "FASE_QTD_ILHAS_VIDA";
		
		//Paramentros quantidades de inimigos da Fase
		public static const PARAM_FASE_QTD_INIMIGOS			= "FASE_QTD_INIMIGOS";
		
		//Parametros da Pontuacao Fase
		public static const PARAM_PONTOS_BARCO_INIMIGO 		= "PONTOS_BARCO_INIMIGO";
		public static const PARAM_PONTOS_CAPTURA_BOTE 		= "PONTOS_CAPTURA_BOTE";
		public static const PARAM_PONTOS_CANHAO_ILHA 		= "PONTOS_CANHAO_ILHA";
		
		//Parametros do inimigo
		public static const PARAM_INIMIGO_VELOC_MAX			= "INIMIGO_VELOC_MAX";
		public static const PARAM_INIMIGO_QTD_CANHOES		= "INIMIGO_QTD_CANHOES";
		public static const PARAM_INIMIGO_FREQ_TIRO			= "INIMIGO_FREQ_TIRO";
		public static const PARAM_INIMIGO_MAXIMO_VIDA		= "INIMIGO_MAXIMO_VIDA";
		
		//Parametro da precisao do canhao do barco inimigo
		public static const PARAM_INIMIGO_PRECISAO			= "INIMIGO_PRECISAO";
		public static const PARAM_INIMIGO_MIRA_PRECISA		= "INIMIGO_MIRA_PRECISA";
		public static const PARAM_INIMIGO_ANG_DISPERSAO 	= "INIMIGO_ANG_DISPERSAO";

		//Parametros do bote de fuga
		public static const PARAM_BOTE_FUGA_VELOC_MAX		= "BOTE_FUGA_VELOC_MAX";
		
		//Parametros do tiro inimigo
		public static const PARAM_TIRO_INIMIGO_VELOCID		= "TIRO_INIMIGO_VELOCID";
		public static const PARAM_TIRO_INIMIGO_DANO			= "TIRO_INIMIGO_DANO";
		public static const PARAM_TIRO_INIMIGO_ALCANCE		= "TIRO_INIMIGO_ALCANCE";
		
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
		
		//Parametros de Ilha Canhão
		public static const PARAM_ILHA_CANHAO_FREQ_TIRO		= "ILHA_CANHAO_FREQ_TIRO";
		public static const PARAM_ILHA_CANHAO_MAX_VIDA		= "ILHA_CANHAO_MAX_VIDA";
		public static const PARAM_ILHA_CANHAO_PRECISAO		= "ILHA_CANHAO_PRECISAO";
		public static const PARAM_ILHA_CANHAO_MIRA_PRECISA	= "ILHA_CANHAO_MIRA_PRECISA";
		public static const PARAM_ILHA_CANHAO_ANG_DISPERSAO	= "ILHA_CANHAO_ANG_DISPERSAO";
		
		//tiro canhão inimigo
		public static const PARAM_TIRO_ILHA_VELOCID			= "TIRO_ILHA_VELOCID";
		public static const PARAM_TIRO_ILHA_DANO			= "TIRO_ILHA_DANO";
		public static const PARAM_TIRO_ILHA_ALCANCE			= "TIRO_ILHA_ALCANCE";
		
		
		/**
		 * 
		 * @param	_faseID
		 * @param	_nivel
		 */
		public function FaseJogoParamentos( _faseID:uint , _nivel:uint) 
		{
			super(_faseID, _nivel);
			
			//define valores padrao
			padrao();
			
			//define valores específico de cada fase
			switch (_faseID) 
			{
				case 1:
					fase01();
				break;
				case 2:
					fase02();
				break;
				case 3:
					fase03();
				break;
				case 4:
					fase04();
				break;
				case 5:
					fase05();
				break;
				case 6:
					fase06();
				break;
				case 7:
					fase07();
				break;
				default:
			}
		}
		/**
		 * Valores comuns das Fases
		 */
		private function padrao():void {
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
		
		/**
		 * Parametros da fase 01
		 */
		private function fase01():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 3200;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 2400;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 1;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 3;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 0;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 1;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 2;
		}
		
		/**
		 * Parametros da fase 02
		 */		
		private function fase02():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 3200;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 2400;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 2;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 3;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 1;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 1;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 3;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}

		/**
		 * Parametros da fase 03
		 */
		private function fase03():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 4000;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 3000;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 3;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 4;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 1;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 1;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 1;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
		
		/**
		 * Parametros da fase 04
		 */
		private function fase04():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 4000;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 3000;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 4;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 5;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 1;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 2;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 1;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
		
		/**
		 * Parametros da fase 5
		 */
		private function fase05():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 5000;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 3750;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 5;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 6;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 1;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 2;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 1;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
		
		/**
		 * Parametros da fase 06
		 */
		private function fase06():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 5000;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 3750;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 6;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 6;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 2;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 2;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 1;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
		
		/**
		 * Parametros da fase 07
		 */
		private function fase07():void {		
			//tamanho do mapa : manter a relacao 800X600 valor bom 5000 X 3750
			this[PARAM_FASE_TAMANHO_LARGURA]    = 5000;
			this[PARAM_FASE_TAMANHO_ALTURA]		= 3750;
			
			// quantidade de ilhas
			this[PARAM_FASE_QTD_ILHAS_TESOURO]	= 7;
			this[PARAM_FASE_QTD_ILHAS_CANHAO]	= 7;
			this[PARAM_FASE_QTD_ILHAS_MUNICAO]	= 2;
			this[PARAM_FASE_QTD_ILHAS_VIDA]		= 2;
			
			// quantidade de inimigos
			this[PARAM_FASE_QTD_INIMIGOS] 		= 1;
			
			//pontuacao
			this[PARAM_PONTOS_BARCO_INIMIGO] 	= 600;
			this[PARAM_PONTOS_CAPTURA_BOTE] 	= 300;
			this[PARAM_PONTOS_CANHAO_ILHA] 		= 1000;

			//ilha de vida
			this[PARAM_ILHA_PONTOS_POR_VIDA] 	= 1;
			this[PARAM_ILHA_QTD_VIDA_LOTE] 		= 10;
			
			//ilhas de municao
			this[PARAM_ILHA_PONTOS_POR_MUNICAO] = 10;
			this[PARAM_ILHA_QTD_MUNICAO_LOTE] 	= 2;
			
			//ilhas tesouro
			this[PARAM_ILHA_TOTAL_PONTOS] 		= 2000;
			this[PARAM_ILHA_QTD_PONTOS_LOTE] 	= 50;
			this[PARAM_ILHA_QTD_MAX_INI_DEFESA]	= 1;
			
			//ilha do canhao
			this[PARAM_ILHA_CANHAO_FREQ_TIRO]	 = 96;	
			this[PARAM_ILHA_CANHAO_MAX_VIDA]	 = 50;
			this[PARAM_ILHA_CANHAO_PRECISAO]	 = 0;
			this[PARAM_ILHA_CANHAO_MIRA_PRECISA] = 0;
			this[PARAM_ILHA_CANHAO_ANG_DISPERSAO]= 45;
			
			//Tiro Canhão Ilha
			this[PARAM_TIRO_ILHA_VELOCID]		= 8;
			this[PARAM_TIRO_ILHA_DANO]			= 50;
			this[PARAM_TIRO_ILHA_ALCANCE]		= 500;

			//barco inimigo
			this[PARAM_INIMIGO_MAXIMO_VIDA]		= 100;
			this[PARAM_INIMIGO_VELOC_MAX]		= 5;
			
			//canhões do barco inimigo
			this[PARAM_INIMIGO_QTD_CANHOES] 	= 1;
			this[PARAM_INIMIGO_FREQ_TIRO] 		= 48;	//EM FRAMES	
			
			//Precisão do barco inimigo 	
			this[PARAM_INIMIGO_PRECISAO]	 	= 100;   //0% a100%
			this[PARAM_INIMIGO_MIRA_PRECISA] 	= 1;   // (0) = NÃO ANTECIPA A MIRA  (1) = ANTECIPA
			this[PARAM_INIMIGO_ANG_DISPERSAO]	= 30;  //GRAUS DE DISPERSÃO DO TIRO IMPRECISO
			
			//tiro do barco inimigo
			this[PARAM_TIRO_INIMIGO_VELOCID]	= 10;
			this[PARAM_TIRO_INIMIGO_DANO]		= 10;
			this[PARAM_TIRO_INIMIGO_ALCANCE]	= 350;
			
			//bote de fuga
			this[PARAM_BOTE_FUGA_VELOC_MAX]     = 3;
			
		}
	}
}