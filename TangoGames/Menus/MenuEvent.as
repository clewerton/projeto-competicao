package TangoGames.Menus 
{
	import flash.events.Event;
	
	/**
	 * Clase Eventos do MenuBase
	 * Contém as Propriedades: OpcaoMenu (valor de retorno da opcao) e OpcaoObj (objeto MenuOpcao relacionada a opção criada no MenuBase)
	 * @author Diogo Honorato
	 */
	public class MenuEvent extends Event 
	{
		public static const OPCAO_SELECIONADA = "OpcaoSelecionada"
		public static const OPCAO_MOUSE_OVER = "OpcaoMouseOver"
		public static const OPCAO_MOUSE_OUT = "OpcaoMouseOut"
		
		private var IN_OpcaoMenu:int;
		private var MO_OpcaoObj:MenuOpcao ;
		
		/**
		 * Cria o Evento específico disparado pelo MenuBase
		 * @param	type
		 * Tipo do Evento
		 * @param	Opcao
		 * 
		 * @param	Obj
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function MenuEvent(type:String, Opcao: int = -1, OpcaoObj: MenuOpcao = null , bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			IN_OpcaoMenu = Opcao;
			MO_OpcaoObj = OpcaoObj;
		}
				
		override public function clone():flash.events.Event 
		{
			return new MenuEvent(type, IN_OpcaoMenu, MO_OpcaoObj, bubbles, cancelable);
		}
		
		override public function toString():String 
		{
			return formatToString("MenuEvent", "type", "OpcaoMenu", "OpcaoObj", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get OpcaoMenu():int 
		{
			
			return IN_OpcaoMenu;			
		}
		
		public function get OpcaoObj():MenuOpcao 
		{
			return MO_OpcaoObj;
		}
	}
}