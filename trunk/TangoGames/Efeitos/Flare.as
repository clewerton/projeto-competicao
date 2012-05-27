package TangoGames.Efeitos 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Flare extends Sprite 
	{
		private var _stageRef:Stage;
		private var _pontoIni: Point;

		private static var _TAM_MIN_PONTO:Number = 1.0;        // Tamanho minimo do ponto
        private static var _TAM_MAX_PONTO:Number = 1.0;        // The maximo do ponto
        private static var COLOR_OFFSET:Number = 128;          // Configure the brightness of the dots
	    private static var _velocX:Number = 1;                 // Velocidade x 
        private static var _velocY:Number = 1;                 // Velocidade y
	    private static var _velocMAX:Number = 5;               // Velocidade max modular
		private static var _numMAX:Number = 5;                 // Numero maximo de flares
		
		private static var GRAVITY:Number = 0.5;               // Gravity
		private static var CRITICAL_ALPHA:Number = 0.1;		   // Critical Point for removing useless dots
		
		// List for storing the added dots in the stage
        private var _fireworks : Array = new Array();
		
		public function Flare(StageRef:Stage , PontoIni: Point) {
			_stageRef = StageRef;
			_pontoIni = PontoIni;
			_stageRef.addChild(this);
			x = _pontoIni.x;
			y = _pontoIni.y;
		}
		
		public function acendeFlare():void {
			acendeUmFlare();
			this.addEventListener(Event.ENTER_FRAME, on_enter_frame);	
        }
		
		private function acendeUmFlare() {
			// define random properties of the magic dots
			var tamX : Number = _TAM_MIN_PONTO + (_TAM_MAX_PONTO - _TAM_MIN_PONTO) * Math.random();
			var tamY : Number = _TAM_MIN_PONTO + (_TAM_MAX_PONTO - _TAM_MIN_PONTO) * Math.random();
            var red : int = (COLOR_OFFSET + ((255 - COLOR_OFFSET) * Math.random()));
            var green : int = (COLOR_OFFSET + ((255 - COLOR_OFFSET) * Math.random()));
            var blue : int = (COLOR_OFFSET + ((255 - COLOR_OFFSET) * Math.random()));
				
			direcaoAleatoria();
            var pontot : PontoColorido = new PontoColorido(red, green, blue, tamX, tamY);
            pontot.VelocX = _velocX;
            pontot.VelocY = _velocY;
            pontot.gravidade = 0;
            pontot.animaPonto();
            _fireworks.push(pontot);
            addChild(pontot);
		}
		
		
		private function on_enter_frame(e:Event):void {
			for (var i:int = _fireworks.length - 1; i >= 0; i--) {
                var pt:PontoColorido= _fireworks[i] as PontoColorido;
                pt.animaPonto();
                
                // remove the dot if the alpha is too small
                if (pt.alpha <= CRITICAL_ALPHA) {
                    removeChild(pt);
                    _fireworks.splice(i, 1);
                }
            }
			if (_fireworks.length < _numMAX) {
				acendeUmFlare();
			}
			
		}
		
		private function direcaoAleatoria() {
			var angulo:Number = Rnd(0, 359) * Math.PI / 180
			_velocMAX = 1 ; Rnd(1, 5)
			_velocX = Math.sin(angulo) * _velocMAX;
            _velocY = Math.cos(angulo) * _velocMAX;
		}

		private function Rnd(min:int, max:int):int {
			if (min <= max) 
			{
				return (min + Math.floor( Math.random() * (max - min + 1) ) );
			}
			else
			{
				throw ( new Error("ERRO valor nimimo maior que o máximo na chamada a fu~ção randomica") + max + "<" + min )
			}
		}		
	}
}