package Fases {
	import TangoGames.Fases.FaseBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Humberto Anjos
	 */
	public class FaseTeste1 extends FaseBase 
	{
		var _f:FlordaVida;
		public function FaseTeste1(_mainapp:DisplayObjectContainer, Nivel:int) {
			super(_mainapp, Nivel);
		}
		
		override protected function inicializacao():Boolean 
		{
			_f = new FlordaVida();
			this.addChild(_f);
			_f.x = stage.width / 2;
			_f.y = 0 - _f.height / 2;
			return true
		}
		override protected function update(e:Event):void {
			_f.y += 1;
			if (pressTecla(Keyboard.P)) {
				pausaFase()
			}
		}
	}
}
import flash.display.Sprite;
import flash.geom.Point;
internal class FlordaVida extends Sprite {
		
	private var _RAIO:Number = 50;
	
	public function FlordaVida() {
		super();
		desenhaCirculo(new Point(0, 0), _RAIO);
		desenhaCirculo(new Point(0, -_RAIO), _RAIO);
		desenhaCirculo(new Point(0, _RAIO), _RAIO);
		var C1:Point = new Point( Math.sqrt(3) * _RAIO / 2 , -_RAIO / 2 )
		var C2:Point = new Point( - Math.sqrt(3) * _RAIO / 2 , -_RAIO / 2 )
		var C3:Point = new Point( Math.sqrt(3) * _RAIO / 2 , _RAIO / 2 )
		var C4:Point = new Point( - Math.sqrt(3) * _RAIO / 2 , _RAIO / 2 )
		desenhaCirculo(C1, _RAIO);
		desenhaCirculo(C2, _RAIO);
		desenhaCirculo(C3, _RAIO);
		desenhaCirculo(C4, _RAIO);
		//
		desenhaCirculo(new Point( 0, 0), _RAIO * 2);
		//
		desenhaCirculo(new Point( 0, -_RAIO / 2) , _RAIO / 2);
		//desenhaCirculo(new Point( 0, _RAIO / 2) , _RAIO / 2);
		//desenhaCirculo(new Point( -_RAIO / 2, 0) , _RAIO / 2);
		//desenhaCirculo(new Point( _RAIO / 2, 0) , _RAIO / 2);
			
		
	}
	
	private function desenhaCirculo(pCentro: Point, pRaio: Number ) {
		this.graphics.lineStyle(1, 0X000000);
		this.graphics.drawCircle(pCentro.x ,pCentro.y, pRaio);		
	}
}
