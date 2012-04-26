package TangoGames.Fases 
{
	import Fases.FaseCasteloElementos.PontuacaoHUD;
	import fl.motion.AnimatorBase;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import TangoGames.Atores.AtorBase;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class FaseCaminho 
	{
		private var AR_mapa:Array;
		private var AR_tmpMapa:Array;
		private var AR_pontos:Array;
		private var AR_caminhoArr:Array;

		private var PT_ini:Point;
		private var PT_quadrado:Point;
		private var FB_fase: FaseBase;
		private var RT_fase: Rectangle;
		private var UI_dimX: uint;
		private var UI_dimY: uint;
		private var BO_diagonal:Boolean;
		
		private var NU_areaMaxHit:Number;
		
		public function FaseCaminho( _fase:FaseBase,_quadDim:Point) 
		{
			FB_fase = _fase;
			RT_fase = _fase.getRect(_fase);
			PT_quadrado =  _quadDim;
			UI_dimX = 0;
			UI_dimY = 0;
			AR_mapa = new Array;
			AR_caminhoArr = new Array;
			NU_areaMaxHit = ( PT_quadrado.x * PT_quadrado.y ) * 0.30;
		}
		
		public function montaMapa( _vetGrupo:Vector.<Class>) {
			AR_mapa = new Array;
			var pX:Number = RT_fase.left;
			var pY:Number = RT_fase.top;
			var rect:Rectangle;
			var _dimX:uint = 0;
			var _dimY:uint = 0;
			
			//avisa aos atores para recalcular o cache do bitmap
			for each (var ator:AtorBase in FB_fase.Atores) ator.cacheBitmap = false;
			
			while ( pX <= RT_fase.right ) {
				_dimY = 0;
				pY = RT_fase.top;
				AR_mapa[_dimX] = new Array;
				while ( pY <= RT_fase.bottom ) {
					rect = new Rectangle(pX , pY, PT_quadrado.x, PT_quadrado.y);
					if (testaIntersecao(rect,_vetGrupo)) AR_mapa[_dimX][_dimY] = 1;
					else AR_mapa[_dimX][_dimY] = 0;
					pY += PT_quadrado.y;
					_dimY++;
				}
				pX += PT_quadrado.x;
				_dimX++;
			}
			UI_dimX = _dimX;
			UI_dimY = _dimY;
		}
		
		private function testaIntersecao( _r:Rectangle, _vg:Vector.<Class> ):Boolean {
			var ra:Rectangle;
			var index:int;
			for each (var c:Class in _vg) {
				index = FB_fase.GrupoClass.indexOf(c);
				if (index>=0) {
					for each( var ator:AtorBase in FB_fase.GrupoAtores[index] ) if (testaIntersecaoBitMap(_r, ator)) return true;
				}
			}
			return false;
		}
		
		private function testaIntersecaoBitMap ( _r:Rectangle , ator:AtorBase ):Boolean {
			ator.calculaClipBmpData()
			if (!ator.clipRectan.intersects(_r)) return false;
			
			var inter:Rectangle =  ator.clipRectan.intersection(_r);
			
			if ( inter.width < 2 || inter.height < 2 ) return false; 
			
			var corte:Rectangle = new Rectangle();
			corte.left   = inter.left - ator.clipRectan.left;
			corte.top    = inter.top - ator.clipRectan.top;
			corte.width  = inter.width;
			corte.height = inter.height;
		
			
			var rt:Rectangle = ator.clipBitmap.rect
			
			if (rt.left > corte.left) corte.left = rt.left;
			if (rt.top > corte.top) corte.top = rt.top;
			if (rt.right < corte.right) corte.right = rt.right;
			if (rt.bottom < corte.bottom) corte.bottom = rt.bottom;
						
			var img:BitmapData = new BitmapData(corte.width, corte.height, true, 0);
			
			img.copyPixels( ator.clipBitmap, corte, new Point(0,0));
			
			var result:Rectangle =  img.getColorBoundsRect(0xFF000000, 0x00000000, false);
			
			img.dispose();
			
			if ( ( result.width * result.height ) < NU_areaMaxHit ) return false;
			
			return true;
			
		}
				
		public function get dimX():uint 
		{
			return UI_dimX;
		}
		
		public function get dimY():uint 
		{
			return UI_dimY;
		}
		
		public function get mapaArray():Array 
		{
			return AR_mapa;
		}
		
		public function geraSprite(cor:uint):Sprite {
			var sp:Sprite =  new Sprite;
			sp.graphics.lineStyle(0.2, cor, 1);
			sp.graphics.beginFill(cor, 0.4);
			sp.graphics.drawRect( -PT_quadrado.x / 2, -PT_quadrado.y / 2, PT_quadrado.x, PT_quadrado.y);
			sp.graphics.endFill();
			return sp;
		}
		
		/*****************************************************************************************
		 *                              CALCULO DE CAMINHO
		 * **************************************************************************************/
		/**
		 * Retorna o caminho entre dois pontos; 
		 * @param	_origem
		 * ponto de origem
		 * @param	_destino
		 * ponto de destino
		 * @param	diag
		 * movimento diagonal true = sim
		 * @return
		 * arrar de ponto do caminho
		 */
		public function caminho( _origem:Point, _destino:Point, diag:Boolean = true):Array {		
			BO_diagonal = diag;
			AR_tmpMapa = new Array;
			for(var i:Number = 0; i < UI_dimX; i++) {
				AR_tmpMapa[i] = new Array();		
				for(var j:Number = 0; j < UI_dimY; j++) {
					AR_tmpMapa[i][j] = 0;
				}
			}
			
			var iniPoint:Point = convertePonto(_origem);
			var fimPoint:Point = convertePonto(_destino);
			
			AR_tmpMapa[iniPoint.x][iniPoint.y] = 1;			
			AR_tmpMapa[fimPoint.x][fimPoint.y] = -1;
			
			AR_pontos = new Array;
			AR_pontos.push(iniPoint);

			var iteracoes:Number = iterate();					

			AR_caminhoArr = new Array();
			AR_caminhoArr = pegaCaminhoArray(fimPoint, iteracoes);
			
			AR_caminhoArr = caminhoMaisCurto(AR_caminhoArr);
			return AR_caminhoArr;
		}
		
		/**
		 * Converte o ponto real no ponto do mapa de quadrantes
		 * @param	_pontoReal
		 * ponto real
		 * @return
		 * ponto de quadrantes
		 */
		public function convertePonto(_pontoReal:Point):Point {
			var p:Point = new Point ( Math.floor( ( _pontoReal.x - RT_fase.left ) / PT_quadrado.x ), Math.floor( ( _pontoReal.y - RT_fase.top ) /  PT_quadrado.y) );
			if ( p.x > UI_dimX ) p.x = UI_dimX;
			else if (p.x < 0 ) p.x = 0;
			if ( p.y > UI_dimY ) p.y = UI_dimY;
			else if ( p.y < 0) p.y = 0;
			return p
		}

		/**
		 * Converte o ponto quadrante no ponto real
		 * @param	_ponto
		 * ponto
		 * @return
		 * ponto real
		 */
		public function convertePontoMapa(_ponto:Point):Point {
			var p:Point = new Point (  (  ( _ponto.x * PT_quadrado.x ) + ( PT_quadrado.x / 2 ) ) + RT_fase.left , ( ( _ponto.y * PT_quadrado.y )  + ( PT_quadrado.y / 2) ) + RT_fase.top  );
			return p
		}

		
		/**
		 * Otimiza o array	
		 */				
		private function caminhoMaisCurto(_caminho:Array): Array {
			var curto:Array = new Array();
			var curtoIter = 0;
			var diffX:Number = 0;
			var diffY:Number = 0;
			for(var i:Number = 0; i < _caminho.length; i++) {				
				if(i>0) {
					if(!(diffX == 0 && diffY == 0) && diffX == _caminho[i].x - _caminho[i-1].x && diffY == _caminho[i].y - _caminho[i-1].y) {
						curtoIter--;
					}
					diffX = _caminho[i].x - _caminho[i-1].x;
					diffY = _caminho[i].y - _caminho[i-1].y;
				}
				curto[curtoIter] = _caminho[i];
				curtoIter++;
			}
			return curto;
		}
		
		/**
		 * Retorna Array do Caminho de POntos dado pelo caminho tmpMapa tamanho array
		 */		
		private function pegaCaminhoArray(pt:Point, iteracao:Number):Array {
			var tmpPt:Point;
			var i:Number = pt.x;
			var j:Number = pt.y;
			
			if(iteracao == 0) {
				AR_caminhoArr = AR_caminhoArr.reverse();		
				return AR_caminhoArr;
			}
			
			if(i > 0 && AR_tmpMapa[i-1][j] == iteracao)  {
				tmpPt = new Point(i-1,j);
				AR_caminhoArr.push(tmpPt);
				pegaCaminhoArray(tmpPt, iteracao-1);
				return AR_caminhoArr;
			}
			if(j > 0 && AR_tmpMapa[i][j-1] == iteracao) {
				tmpPt = new Point(i,j-1);
				AR_caminhoArr.push(tmpPt);
				pegaCaminhoArray(tmpPt, iteracao-1);
				return AR_caminhoArr;
			}
			if(i < UI_dimX && AR_tmpMapa[i+1][j] == iteracao) {
				tmpPt = new Point(i+1,j);
				AR_caminhoArr.push(tmpPt);
				pegaCaminhoArray(tmpPt, iteracao-1);
				return AR_caminhoArr;
			}
			if(j < UI_dimY && AR_tmpMapa[i][j+1] == iteracao)  {
				tmpPt = new Point(i,j+1);	
				AR_caminhoArr.push(tmpPt);
				pegaCaminhoArray(tmpPt, iteracao-1);
				return AR_caminhoArr;
			}
			
			if(BO_diagonal) {
				if(i > 0 && j > 0 && AR_tmpMapa[i-1][j-1] == iteracao)  {
					tmpPt = new Point(i-1,j-1);
					AR_caminhoArr.push(tmpPt);
					pegaCaminhoArray(tmpPt, iteracao-1);
					return AR_caminhoArr;
				}
				if(i < UI_dimX && j < UI_dimY && AR_tmpMapa[i+1][j+1] == iteracao) {
					tmpPt = new Point(i+1,j+1);
					AR_caminhoArr.push(tmpPt);
					pegaCaminhoArray(tmpPt, iteracao-1);
					return AR_caminhoArr;
				}
				if(i > 0 && j < UI_dimY && AR_tmpMapa[i-1][j+1] == iteracao) {
					tmpPt = new Point(i-1,j+1);
					AR_caminhoArr.push(tmpPt);
					pegaCaminhoArray(tmpPt, iteracao-1);
					return AR_caminhoArr;
				}
				if(j > 0 && i < UI_dimX && AR_tmpMapa[i+1][j-1] == iteracao)  {
					tmpPt = new Point(i+1,j-1);	
					AR_caminhoArr.push(tmpPt);
					pegaCaminhoArray(tmpPt, iteracao-1);
					return AR_caminhoArr;
				}				
			}
			

			return new Array();
		}
		
		/**
		 * Iterates through map to find best rout for current step
		 */			
		private function iterate(iteracao:Number = 1):Number {
			var novosPontos:Array = new Array();
			for(var key:Number = 0; key < AR_pontos.length; key++) {
				var i:Number = AR_pontos[key].x;
				var j:Number = AR_pontos[key].y;

				// verifica se chegou ao fim
				if(i > 0 && AR_tmpMapa[i-1][j] == -1)
					return iteracao;			
				if(j > 0 && AR_tmpMapa[i][j-1] == -1)
					return iteracao;
				if(i < UI_dimX&& AR_tmpMapa[i+1][j] == -1)
					return iteracao;
				if(j < UI_dimY && AR_tmpMapa[i][j+1] == -1)
					return iteracao;
				if(BO_diagonal) {
					if(i > 0 && j > 0 && AR_tmpMapa[i-1][j-1] == -1)
						return iteracao;
					if(i < (UI_dimX-2) && j < (UI_dimY-2) && AR_tmpMapa[i+1][j+1] == -1)
						return iteracao;
					if(i > 0 && j < (UI_dimY-2) && AR_tmpMapa[i-1][j+1] == -1) {
						return iteracao;
					}
					if(j > 0 && i < (UI_dimX-2) && AR_tmpMapa[i+1][j-1] == -1)
						return iteracao;		
				}	
				
				if(i > 0 && AR_tmpMapa[i-1][j] == 0 && AR_mapa[i-1][j] != 1) {
					AR_tmpMapa[i-1][j] = iteracao+1;			
					novosPontos.push(new Point(i-1,j));
				}
				if(j > 0 && AR_tmpMapa[i][j-1] == 0 && AR_mapa[i][j-1] != 1) {

					AR_tmpMapa[i][j-1] = iteracao+1;
					novosPontos.push(new Point(i,j-1));
				}
				if(i < (UI_dimX-2) && AR_tmpMapa[i+1][j] == 0 && AR_mapa[i+1][j] != 1) {
					AR_tmpMapa[i+1][j] = iteracao+1;
					novosPontos.push(new Point(i+1,j));
				}
				if(j < (UI_dimY-2) && AR_tmpMapa[i][j+1] == 0 && AR_mapa[i][j+1] != 1) {
					AR_tmpMapa[i][j+1] = iteracao+1;		
					novosPontos.push(new Point(i,j+1));
				}
				if(BO_diagonal) {
					if(i > 0 && j > 0 && AR_tmpMapa[i-1][j-1] == 0 && AR_mapa[i-1][j-1] != 1) {
						AR_tmpMapa[i-1][j-1] = iteracao+1;			
						novosPontos.push(new Point(i-1,j-1));
					}
					if(i < (UI_dimX-2) && j < (UI_dimY-2) && AR_tmpMapa[i+1][j+1] == 0 && AR_mapa[i+1][j+1] != 1) {
						AR_tmpMapa[i+1][j+1] = iteracao+1;
						novosPontos.push(new Point(i+1,j+1));
					}
					if(i > 0 && j < (UI_dimY-2) && AR_tmpMapa[i-1][j+1] == 0 && AR_mapa[i-1][j+1] != 1) {
						AR_tmpMapa[i-1][j+1] = iteracao+1;
						novosPontos.push(new Point(i-1,j+1));
					}
					if(j > 0 && i < (UI_dimX-2) && AR_tmpMapa[i+1][j-1] == 0 && AR_mapa[i+1][j-1] != 1) {
						AR_tmpMapa[i+1][j-1] = iteracao+1;		
						novosPontos.push(new Point(i+1,j-1));
					}
				}						
			}		
			if(iteracao>UI_dimX*UI_dimY) {
				return iteracao;
			}			
			AR_pontos = novosPontos;
			iteracao = iterate(iteracao+1);
			return iteracao;
		}
	}
}