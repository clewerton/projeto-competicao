package TangoGames.Fases 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public interface FaseInterface 
	{
		function reiniciacao():void; 
		function inicializacao():Boolean;
		function update(e:Event):void;
		function remocao():void;
	}
	
}