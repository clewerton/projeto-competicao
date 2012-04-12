package TangoGames.Atores 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public interface AtorInterface 
	{
		function reinicializa():void; 
		function inicializa():void;
		function update(e:Event):void;
		function remove():void;
	}
	
}