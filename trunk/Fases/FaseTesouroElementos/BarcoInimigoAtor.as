package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import fl.motion.AnimatorBase;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class BarcoInimigoAtor extends AtorBase implements AtorInterface 
	{
		private var MC_barco:MovieClip;
		private var FB_faseRef:FaseTesouro;
		private var PT_objetivo:Point;
		private var DO_alvo:DisplayObject;
		private var NU_distancia:Number;
		
		//conponentes de direcao e movimento do barco
		private var NU_direcao:Number;
		private var NU_direAlvo:Number;
		private var NU_direX:Number;
		private var NU_direY:Number;
		private var NU_veloX:Number;
		private var NU_veloY:Number;
		private var NU_veloABS:Number;
		private var NU_veloMax:Number;
		private var NU_veloInc:Number;
		private var NU_friccaoVel:Number;
		private var NU_friccaoAng:Number;
		private var NU_impacY:Number;
		private var NU_impacX:Number;
		
		//controle de impacto com a ilha
		private var UI_travouIlha:uint;
		private var BO_travouIlha:Boolean;
		private var NU_desvioIlha:Number;
		
		private var VT_TEMP:Vector.<MovieClip>
		
		public function BarcoInimigoAtor() 
		{
			MC_barco =  new BarcoHeroi;
			super(MC_barco);
			
			//retirar se colocar virado pra direita originalmente
			MC_barco.rotation =  90;
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */
		
		public function reinicializa():void 
		{
			NU_direX = 0;
			NU_direY = 0;
			NU_veloX = 0;
			NU_veloY = 0;
			NU_impacX = 0;
			NU_impacY = 0;			
			NU_veloABS = 0
			UI_travouIlha = 0;
			NU_desvioIlha = 0;
		}
		
		public function inicializa():void 
		{
			//fricao
			NU_friccaoVel = 0.98;
			NU_veloMax = 5;
			
			//define alvo
			FB_faseRef = FaseTesouro(faseAtor);

			DO_alvo = FB_faseRef.barcoHeroi;
			
			adcionaClassehitGrupo(IlhaAtor);
			adcionaClassehitGrupo(BarcoHeroiAtor);
			
			VT_TEMP = new Vector.<MovieClip>;
			
			reinicializa();
		}
		
		public function update(e:Event):void 
		{
			calculaRotaAlvo()
			
			if (NU_distancia > 150) {
				NU_veloABS += 0.1;
				if ( NU_veloABS > NU_veloMax ) NU_veloABS = NU_veloMax;
				var ajuste:Number = corrigeDirecao(NU_direAlvo);
				this.rotation += ajuste;
				NU_direcao = this.rotation *  Utils.GRAUS_TO_RADIANOS;
				NU_direY = Math.sin(NU_direcao);
				NU_direX = Math.cos(NU_direcao);
			}
			
			this.x += ( NU_direX * NU_veloABS ) + NU_impacX;
			this.y += ( NU_direY * NU_veloABS ) + NU_impacY;
			NU_impacX = 0 ;
			NU_impacY = 0;
			
			NU_veloABS *= NU_friccaoVel;
			
			//if ( UI_travouIlha == 0 && NU_desvioIlha > 0 ) {
			//	NU_desvioIlha = 0;
			//}
			
			//if ( UI_travouIlha > 3 ) {
			//	NU_desvioIlha += Math.PI / 2;
			//	UI_travouIlha = 0;
			//}
		}
		
		public function remove():void 
		{
			
		}
		
		public function colidiuIlha(_ilha:IlhaAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _ilha, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = NU_veloABS * 1.1;
			NU_impacY -= ( Math.sin(ang) * impact ) ;
			NU_impacX -= ( Math.cos(ang) * impact ) ;
			UI_travouIlha++;
		}

		public function colidiuBarcoHeroi(_barcoHeroi:BarcoHeroiAtor) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, _barcoHeroi, faseAtor);
			if (ret == null) return;
			var dy:Number = ( ret.top  + ( ret.height / 2 ) ) - this.y;
			var dx:Number = ( ret.left + ( ret.width  / 2 ) ) - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = NU_veloABS * 1.5;
			NU_impacY += -Math.sin(ang) * impact;
			NU_impacX += -Math.cos(ang) * impact;
			NU_veloABS = 0;
		}
		
		
		/**
		 * calcula rota
		 */
		private function calculaRotaAlvo() {
			PT_objetivo = new Point( DO_alvo.x, DO_alvo.y);		
			var dx:Number = PT_objetivo.x - this.x;
			var dy:Number = PT_objetivo.y - this.y;
			NU_distancia = Math.sqrt( ( dx * dx ) + ( dy * dy ) );
			verificaPontos();
			dx = PT_objetivo.x - this.x;
			dy = PT_objetivo.y - this.y;		
			NU_direAlvo =  Math.atan2 ( dy, dx);
		}
		
		private function verificaPontos():void {
			var caminho:Array =  faseAtor.mapa.caminho( new Point (this.x, this.y),  new Point( DO_alvo.x, DO_alvo.y) , true);
			if (caminho.length < 3) {
				PT_objetivo = new Point( DO_alvo.x, DO_alvo.y);
			}
			else {
				PT_objetivo = faseAtor.mapa.convertePontoMapa(caminho[1]);
			}
			var m:MovieClip;
			var p:Point;
			var i:uint;
			for ( i = 0; i < VT_TEMP.length; i++) faseAtor.removeChild(VT_TEMP[i]);
			VT_TEMP = new Vector.<MovieClip>;
			for (i = 0 ; i < caminho.length ; i++) {
				m = new hitboxClass;
				VT_TEMP.push(m);
				faseAtor.addChild(m);
				p = faseAtor.mapa.convertePontoMapa(caminho[i]);
				m.x = p.x;
				m.y = p.y;
			}
			
		}
		
		
		/**
		 * Corrige a direcao
		 * @param	_anguloRadiano
		 * angulo objetivo
		 * @param	_rotacaoAtual
		 * rotacao atual
		 * @return
		 * ajuste rotacao a ser apliacada
		 */ 
		private function corrigeDirecao(_anguloRadiano:Number):Number {
			
			var anguloGraus:Number = Math.round(_anguloRadiano * Utils.RADIANOS_TO_GRAUS);
		
			var ajusteMax:Number = 3;
			
			var diferenca:Number = this.rotation -  anguloGraus ;
			
			if (diferenca > 180) anguloGraus += 360;
			else if (diferenca < -180) anguloGraus -= 360;
			
			var ajusteAngulo = anguloGraus - this.rotation;
			
			if (ajusteAngulo > ajusteMax) ajusteAngulo = ajusteMax;
			
			if (ajusteAngulo < -ajusteMax) ajusteAngulo = -ajusteMax;
							
			return ajusteAngulo;
		}
		
	}

}