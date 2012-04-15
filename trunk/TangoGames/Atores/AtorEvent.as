package TangoGames.Atores 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class AtorEvent extends Event 
	{
		public static const ATOR_SAIU_STAGE:String = "AtorSaiuStage";
		public static const ATOR_TOCOU_STAGE:String = "AtorTocouStage";
		public static const ATOR_VOLTOU_STAGE:String = "AtorVoltouStage";
		public static const ATOR_VOLTOU_TODO_STAGE:String = "AtorVoltouTodoStage";
		
		public function AtorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new AtorEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AtorEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}