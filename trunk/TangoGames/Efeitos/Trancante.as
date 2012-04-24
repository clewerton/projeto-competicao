package TangoGames.Efeitos 
{
	import com.flashandmath.dg.geom3D.Point3D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import TangoGames.Utils.Mundo;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class Trancante extends Sprite 
	{
		
		private var _displayPai:DisplayObjectContainer; 
		private var _cor: uint;
		private var _line:Number
		private var _vetor:Point;
		private var _distancia:Number;
		private var _cota:uint;
		
		public function Trancante( displayPai: DisplayObjectContainer , Ponto: Point , Vetor: Point, Distancia: Number) 
		{
			super();
			_displayPai = displayPai;
			_vetor = Vetor;
			_distancia = Distancia;
			
			this.alpha = Math.random() + 0.5
	
			geraLinha();

			_displayPai.addChild(this);
			this.x = Ponto.x;
			this.y = Ponto.y;
			
			addEventListener(Event.EXIT_FRAME, onFrame, false, 0 , true);
			
		}
		
		private function onFrame(e:Event):void 
		{
			alpha -= 0.03;
			if (alpha <= 0) {
				removeEventListener(Event.EXIT_FRAME, onFrame);
				_displayPai.removeChild(this);
			}
		}
		
		private function geraLinha() {
			// color
			var vermelho:uint = 255; // Mundo.Rnd(126, 255);
			var verde:uint = Mundo.Rnd(170, 255);
			var azul:uint = 100; //Mundo.Rnd(5, 15);
			_cor = vermelho * 0x010000 + verde * (0x000100) + azul;
			_line = 0.1 + ( Math.random() - 0.1 );
			this.graphics.lineStyle( _line , _cor, 1 );
			_cota = 0 ;
			var ponto1:Point = new Point(0, 0);          //geraponto();
			var ponto2:Point = geraponto(1, 1);
			while ( _cota < _distancia ) {
				this.graphics.moveTo( ponto1.x , ponto1.y);
				this.graphics.lineTo( ponto2.x , ponto2.y);
				ponto1 = geraponto(120,150);
				ponto2 = geraponto(10,50);
			}
		}
		
		private function geraponto(rmin:uint, rmax:uint):Point {
			var p:Point = new Point()
			_cota += Mundo.Rnd( rmin, rmax);
			p.x = _vetor.x * _cota;
			p.y = _vetor.y * _cota;
			return p;
		}
	}
}