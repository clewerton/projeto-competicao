package  
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FasesDados
	{
		//armazena objetos
		private var SO_evolucao			:SharedObject;
		
		//total de pontos
		private var UI_totalPontos		:uint;
		
		//fase liberada
		private var UI_faseLiberada		:uint;
		
		public function FasesDados() 
		{
			UI_totalPontos		= 0;
			UI_faseLiberada		= 1;
			carregaDados();
		}
		
		/**
		 * Carrega dados Salvos
		 */
		public function carregaDados():void {
			for (upnome in SO_evolucao.data) this[upnome] = SO_evolucao.data[upnome];
		}
		
		/**
		 * Salva dados carregados
		 */
		public function salvaDados():void {
			SO_evolucao.data = {
				totalPontos				:UI_totalPontos
			}
			SO_evolucao.flush();
		}
		
		public function get totalPontos():uint 
		{
			return UI_totalPontos;
		}
		
		public function set totalPontos(value:uint):void 
		{
			UI_totalPontos = value;
		}
		
		public function get faseLiberada():uint 
		{
			return UI_faseLiberada;
		}
		
		public function set faseLiberada(value:uint):void 
		{
			UI_faseLiberada = value;
		}
		
	}

}