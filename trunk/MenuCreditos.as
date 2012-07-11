package  {
	
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import TangoGames.Menus.MenuBase;
	import TangoGames.Menus.MenuOpcao;

	/**
	 * ...
	 * @author Diogo Honorato
	 */
	
	public class MenuCreditos extends MenuBase
	{
		
		public function MenuCreditos( _idMenu:String,_fundo:Sprite=null)
		{
			super(_idMenu);
		
		}
				
		override protected function posicionaOpcao(_op:MenuOpcao):void
		{
			//Posiciona a opção voltar
			if (_op.valorRetorno == 99)
			{
				_op.x =  5;
				_op.y =  stage.stageHeight - _op.height;
				return
			}
			super.posicionaOpcao(_op);
		}
	}
}