package TangoGames.Fases 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseEvent extends Event 
	{
		public static const FASE_PAUSA:String = "FasePausa"
		public static const FASE_FIMDEJOGO:String = "FaseFimdeJogo"
		public static const FASE_CONCLUIDA:String = "FaseConcluida"
		public function FaseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new FaseEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FaseEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}