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
		private var SO_dados			:SharedObject;
		
		//total de pontos
		private var UI_totalPontos		:uint;
		
		//fase liberada
		private var UI_faseLiberada		:uint;
		
		public function FasesDados() 
		{
			UI_totalPontos		= 0;
			UI_faseLiberada		= 0;
			//
			SO_dados	 = SharedObject.getLocal( "fasesdados" );
			carregaDados();
		}
		
		/**
		 * Carrega dados Salvos
		 */
		public function carregaDados():void {
			//SO_dados.clear;
			if (SO_dados.data.gamedata != undefined) {
				for (var nome in SO_dados.data.gamedata) this[nome] = SO_dados.data.gamedata[nome];
			}
		}
		
		/**
		 * Salva dados carregados
		 */
		public function salvaDados():void {
			SO_dados.data.gamedata= {
				totalPontos				:UI_totalPontos
			}
			SO_dados.flush();
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