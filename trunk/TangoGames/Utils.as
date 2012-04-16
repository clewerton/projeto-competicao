package TangoGames
{
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class Utils
	{
		
		public function Utils() { }
		
		/**
		 * Gera numeros inteiros randomicos
		 * @param	min
		 * valor mínimo para o número randômico gerado
		 * @param	max
		 * valor máximo para o número randômico gerado
		 * @return
		 * número intero randomicamente gerado
		 */
		public static function Rnd(min:int, max:int):int {
			if (min <= max) 
			{
				return (min + Math.floor( Math.random() * (max - min + 1) ) );
			}
			else
			{
				throw ( new Error("ERRO valor nimimo maior que o máximo na chamada a fu~ção randomica") + max + "<" + min )
			}
		}
		
	}

}