package Fases {
	import TangoGames.Atores.AtorBase;
	import TangoGames.Fases.FaseBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * ...
	 * @author Humberto Anjos
	 */
	public class FaseTeste1 extends FaseBase implements FaseInterface {
		var _f:FlordaVida;
		public function FaseTeste1(_mainapp:DisplayObjectContainer, Nivel:int) {
			super(_mainapp, Nivel);
		}
		
		public function inicializacao():Boolean {
			_f = new FlordaVida();
			this.addChild(_f);
			reiniciacao();
			return true
		}
		public function update(e:Event):void {
			_f.y += 1;
			if (pressTecla(Keyboard.P)) {
				pausaFase();
			}
			if (pressTecla(Keyboard.UP )) {
				_f.y -= 2;
			}
			if (_f.y > (stage.stageHeight + (_f.height / 2))) {
				terminoFase();
			}
			if (_f.y < - _f.height ) {
				concluidaFase();
			}
		}
		
		public function reiniciacao():void {
			_f.x = stage.stageWidth/ 2;
			_f.y = 0 - _f.height / 2;
		}
			
		public function remocao():void { };
		
		public function colisao(C1:AtorBase, C2:AtorBase) {
			trace("Colidiu" + C1 + " com " + C2);
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
