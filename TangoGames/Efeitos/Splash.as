package TangoGames.Efeitos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import TangoGames.Utils.Mundo;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class Splash extends Sprite {
		
		
		private var _QTD:int = 12;       			// Numero de trasso
        private var _OPACIDADE:Number = 1;        // Brilho inicial do trasso
        private var _OPACI_INC:Number = -0.15;      // Incremento brilho de cada trasso
		private var _AR_Trasso:Vector.<Shape>;
		private var _AR_Direcao:Vector.<Point>;
		private var _Displaypai:DisplayObjectContainer;
		
		public function Splash(Displaypai:DisplayObjectContainer, Ponto: Point, Normal: Point) {
			_AR_Trasso = new Vector.<Shape>;
			_AR_Direcao = new Vector.<Point>;
			_Displaypai = Displaypai;
            for (var i:int = 0; i < _QTD; i++) {
				var anguloRadiano:Number = Math.atan2( Normal.y , Normal.x );
				//trace("Normal x=" + Normal.x + "; y=" + Normal.y);
				var angleGraus:Number = Math.round(anguloRadiano*180/Math.PI);
				//trace("Angulo " + angleGraus)
				angleGraus = angleGraus + Mundo.Rnd( -45, 45);
				//trace("Angulo Novo " + angleGraus)
				anguloRadiano = angleGraus * Math.PI / 180;
				var NovoN:Point = new Point ( Math.cos(anguloRadiano) , Math.sin(anguloRadiano));
				//trace("NovoNormal x=" + NovoN.x + "; y=" + NovoN.y);
				_AR_Direcao.push(NovoN);
				var sh:Shape = criaTrasso(254, Mundo.Rnd(126, 254), Mundo.Rnd(0, 254), Mundo.Rnd(5, 15), NovoN);
				_AR_Trasso.push(sh);
				this.addChild(sh);
			}
			_Displaypai.addChild(this);
			this.x = Ponto.x;
			this.y = Ponto.y;
			addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
		}
		
		private function criaTrasso(vermelho:int, verde:int, azul:int, tamanho:Number, Normal:Point ):Shape {
           	var sh: Shape = new Shape();
           	var color:uint = vermelho * 0x010000 + verde * (0x000100) + azul;
			sh.graphics.lineStyle( 1 , color , _OPACIDADE );
			sh.graphics.moveTo( 0, 0 );
			sh.graphics.lineTo( Normal.x * tamanho , Normal.y * tamanho );
			return sh;
        }		
	
		private function onFrame(e:Event):void 
		{
			var retira:Boolean = true;
			for (var i:int = 0; i < _QTD; i++) {
				var pt:Point = _AR_Direcao[i];
				var sh:Shape = _AR_Trasso[i];
				var v:Number = 2 + Math.random() * 3
				sh.x += pt.x * v ;
				sh.y += pt.y * v ;
				sh.alpha -= 0.10 + Math.random() / 10
				if (sh.alpha > 0) retira = false;
			}
			if (retira) {
				removeEventListener(Event.ENTER_FRAME, onFrame);
				_Displaypai.removeChild(this);
			}
		}
	}
}