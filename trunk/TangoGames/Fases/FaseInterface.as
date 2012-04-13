package TangoGames.Fases 
{
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	
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
		function colisao(C1:AtorBase, C2:AtorBase);
	}
	
}