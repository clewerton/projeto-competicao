package TangoGames
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class Utils
	{
		public static const RADIANOS_TO_GRAUS:Number = 57.29577951308232;
		public static const GRAUS_TO_RADIANOS:Number = 0.017453292519943295;
		
		public function Utils() { }
		
		/**
		 * Gera numeros inteiros randomicos
		 * @param	min
		 * valor mínimo para o número randômico gerado
		 * @param	max
		 * valor máximo para o número randômico gerado
		 * @return
		 * número intero randomicamente gerado
		 */
		public static function Rnd(min:int, max:int):int {
			if (min <= max) 
			{
				return (min + Math.floor( Math.random() * (max - min + 1) ) );
			}
			else
			{
				throw ( new Error("ERRO valor nimimo maior que o máximo na chamada a fu~ção randomica") + max + "<" + min )
			}
		}
		
		public static function colisaoIntersecao( ob1:DisplayObject, ob2: DisplayObject, obRef: DisplayObject ):Rectangle {
			
			//var Rect1:Rectangle = ob1.getBounds(obRef);
			//var Offset1:Matrix = ob1.transform.matrix;
			//Offset1.tx = ob1.x - Rect1.x;
			//Offset1.ty = ob1.y - Rect1.y;	

			//var ClipBmpData1 = new BitmapData(Rect1.width, Rect1.height, true, 0);
			//ClipBmpData1.draw(ob1, Offset1);		

			//var Rect2:Rectangle = ob2.getBounds(obRef);
			//var Offset2:Matrix = ob2.transform.matrix;
			//Offset2.tx = ob2.x - Rect2.x;
			//Offset2.ty = ob2.y - Rect2.y;	

			//var ClipBmpData2 = new BitmapData(Rect2.width, Rect2.height, true, 0);
			//ClipBmpData2.draw(ob2, Offset2);		

 
			var alpha:uint = 255;
			
			var bds1:Rectangle =  ob1.getBounds(obRef);
			var bds2:Rectangle =  ob2.getBounds(obRef);
 
			if (((bds1.right < bds2.left) || (bds2.right < bds1.left)) || ((bds1.bottom < bds2.top) || (bds2.bottom < bds1.top)) ) { return null; }
			
			var bounds:Rectangle = new Rectangle();
			bounds.left   = Math.max(bds1.left  , bds2.left  );
			bounds.right  = Math.min(bds1.right , bds2.right );
			bounds.top    = Math.max(bds1.top   , bds2.top   );
			bounds.bottom = Math.min(bds1.bottom, bds2.bottom);
 
			var img:BitmapData = new BitmapData(bounds.width,bounds.height, true, 0);
 
			var mat:Matrix = ob1.transform.matrix;
			mat.tx = ob1.x - bounds.left;
			mat.ty = ob1.y - bounds.top;
			img.draw(ob1, mat, new ColorTransform(1,1,1,1,255,-255,-255,alpha));
 
			mat = ob2.transform.matrix;
			mat.tx = ob2.x - bounds.left;
			mat.ty = ob2.y - bounds.top;
			img.draw(ob2, mat, new ColorTransform(1,1,1,1,255,255,255,alpha),"difference");
 
			var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
 
			if (intersection.width == 0) { return null; }
 
			intersection.x += bounds.left;
			intersection.y += bounds.top;
 
			return intersection;
			
		}

	}

}