package Fases {
	import TangoGames.Fases.FaseBase;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Humberto Anjos
	 */
	public class FaseTeste2 extends FaseBase 
	{
		
		public function FaseTeste2(_mainapp:DisplayObjectContainer, Nivel:int) 
		{
			super(_mainapp,Nivel);
			
			this.addChild(new fasetest);
		}
		
	}

}