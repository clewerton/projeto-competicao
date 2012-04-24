package TangoGames.Fases 
{
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseEvent extends Event 
	{
		//constantes estaticas dos nome dos eventos
		public static const FASE_PAUSA:String = "FasePausa";
		public static const FASE_FIMDEJOGO:String = "FaseFimdeJogo";
		public static const FASE_CONCLUIDA:String = "FaseConcluida";
		public static const FASE_CONTINUA:String = "FaseContinua";
		public static const ATOR_CRIADO:String = "AtorCriado";
		public static const ATOR_REMOVIDO:String = "AtorRemovido";
		
		private var AB_ator:AtorBase;
		
		public function FaseEvent(type:String, ator:AtorBase = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			AB_ator = ator;
		} 
		
		public override function clone():Event 
		{ 
			return new FaseEvent(type, AB_ator, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("FaseEvent", "type", "fase",  "ator", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get ator():AtorBase 
		{
			return AB_ator;
		}
				
	}
	
}