package TangoGames.Atores 
{
	import flash.events.Event;
	
	public interface AtorInterface 
	{
		/**
		 * metodo de inicialização chamada pela FaseBase
		 * o método adicionaAtor da FaseBase chama este método
		 */
		function inicializa():void;
		/**
		 * metodo de reinicialização chamada pela FaseBase
		 * o método reinicializacao da FaseBase chama este método
		 */
		function reinicializa():void; 
		/**
		 * metodo de update  chamada pela FaseBase
		 * o método update da FaseBase chama este método
		 */
		function update(e:Event):void;
		/**
		 * metodo de remove chamada pela FaseBase
		 * o método removeAtor da FaseBase chama este método
		 */
		function remove():void;
	}
	
}