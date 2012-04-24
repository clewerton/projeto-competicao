package TangoGames.Fases 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public interface FaseHUDInterface 
	{
		/**
		 * metodo de inicialização chamada pela FaseBase
		 */
		function inicializa():void;
		/**
		 * metodo de reinicialização chamada pela FaseBase
		 */
		function reinicializa():void; 
		/**
		 * metodo de update chamada pela FaseBase
		 */
		function update(e:Event):void;
		/**
		 * metodo de remove chamada pela FaseBase
		 */
		function remove():void;
	}
	
}