package TangoGames.Efeitos 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class PontoColorido extends Sprite  {
		// 
        private static var _QTD_ELLIPSE:int = 5;       	// Numero de elipses que formam um ponto colorido
        private static var _OPACIDADE:Number = 0.8;     // Brilho inicial do ponto colorido
        private static var _OPACI_INC:Number = -0.15;   // Incremento brilho de cada elipse do ponto colorido

        //public var swingRadius:Number;
        //public var counter:int = 0;
        //public var swingSpeed:int = 5;
        //public var upSpeed:Number = 1;
        //public var centerX:Number;
        		
        // for firwork
        public var BrilhoDec:Number = -0.02;
        public var VelocX:Number = 1;
        public var VelocY:Number = 1;
        public var gravidade:Number = 1;

		
		public function PontoColorido(vermelho:int, verde:int, azul:int, tamanhoX:Number, tamanhoY:Number) {
            var opac:Number = _OPACIDADE;
            
            for (var i:int = 0; i < _QTD_ELLIPSE; i++)
            {
            	var elipse : Shape = new Shape();
            	var color:uint = vermelho * 0x010000 + verde * (0x000100) + azul;
                if (i == 0)
                {
                    // adiciona um ponto branco no centro
	            	elipse.graphics.beginFill(0xFFFFFF);
					elipse.graphics.drawEllipse(0, 0, tamanhoX , tamanhoY);
                }
                else
                {
	            	elipse.graphics.beginFill(color);
					elipse.graphics.drawEllipse(0, 0, tamanhoX, tamanhoY);
					elipse.alpha = opac;
                    opac += _OPACI_INC;
                    tamanhoX += tamanhoX;
                    tamanhoY += tamanhoY;
					var myBitmap:BitmapData = new BitmapData(tamanhoX, tamanhoY, false, 0);
					
                }
                // posiciona o ponto no centro do regsitro e addciona no sprite principal
                elipse.x = -elipse.width/2;
                elipse.y = -elipse.height /2;
                addChild(elipse);
            }
        }

        /////////////////////////////////////////////////////        
        // Metodos Publicos
        /////////////////////////////////////////////////////	

        // animação do ponto colorido
        public function animaPonto():void {
            this.alpha += BrilhoDec;

            VelocY += gravidade;
            x += VelocX;
            y += VelocY;
			rotation += Math.random() * 2;
        }		
	}

}