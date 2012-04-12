package Fases 
{
	import Fases.FaseCasteloElementos.Castelo;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FaseCastelo extends FaseBase implements FaseInterface
	{
		private var casteloAtor:Castelo;
		public function FaseCastelo(_main:DisplayObjectContainer, Nivel:int) 
		{
			super(_main, Nivel);
			this.addChild(new BackGroundCastelo);
			
		}
		public function reiniciacao():void {
		}
		public function inicializacao():Boolean {
			casteloAtor = new Castelo();			
			casteloAtor.x = stage.stageWidth / 2;
			casteloAtor.y = stage.stageHeight / 2;
			adicionaAtor(casteloAtor);
			return true;
		}
			
			
		public function update(e:Event):void {
			if (pressTecla(Keyboard.P)) {
				pausaFase();
			}
		}
		public function remocao():void {};
		
	}

}