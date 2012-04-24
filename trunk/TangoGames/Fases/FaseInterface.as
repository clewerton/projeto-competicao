package TangoGames.Fases 
{
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	
	/**
	 * Controla as fase do jogo
	 * @author Arthur Figueirdo
	 */
	public interface FaseInterface 
	{
		/**
		 * implementar reinicializao da fase
		 * metodo chamado pelo FaseBase
		 */
		function reiniciacao():void; 
		/**
		 * implementar inicializacao da fase
		 * metodo chamado pelo FaseBase para iniciar a fase apos addChild
		 * @return
		 * se falso nao inicia o EnterFrame da fase;
		 */
		function inicializacao():Boolean;
		/**
		 * implementar update da fase
		 * metodo chamado pelo FaseBase no update do EnterFrame
		 * @return
		 */
		function update(e:Event):void;
		/**
		 * implementar remocao da fase
		 * metodo chamado pelo FaseBase ao encerrar a fase
		 * @return
		 */
		function remocao():void;
		/**
		 * implementar colisao da fase metodo chamado pelo FaseBase
		 * a cada colisao detectada entre os atores da fasee;
		 * @return
		 */
		function colisao(C1:AtorBase, C2:AtorBase):void;
	}
	
}