package Fases.FaseTesouroElementos 
{
	import Fases.FaseTesouro;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Utils;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class BoteFugaAtor extends AtorBase implements AtorInterface 
	{
		//imagem do barco
		private var MC_barco		:MovieClip;
		
		//Referencia do Barco Herio
		private var AB_barcoHeroi	:BarcoHeroiAtor;
		private var PT_alvo			:Point;
		
		//componentes da distancia do barco Heroi
		private var NU_distX		:Number;
		private var NU_distY		:Number;
		private var NU_distancia	:Number;
		
		//distancia de captura
		private var UI_distCaptura	:uint;
		private var BO_capturar		:Boolean;
		private var MC_captura		:MovieClip;

		
		//velocidade maxima
		private var NU_veloMax		:Number;
		
		//Ponto de fuga
		private var PT_PontoFuga	:Point;
		private var PT_objetivo     :Point;
		private var BO_colidiu		:Boolean;
		private var UI_colidiuIlha	:uint;
	
		//conponentes de direcao e movimento do barco
		private var NU_direcao		:Number;
		private var NU_direAlvo		:Number;
		private var NU_direX		:Number;
		private var NU_direY		:Number;
		//private var NU_veloX		:Number;
		//private var NU_veloY		:Number;
		private var NU_veloABS		:Number;
		//private var NU_veloInc		:Number;
		private var NU_impacY		:Number;
		private var NU_impacX		:Number;
		
		
		private var VT_TEMP:Vector.<Sprite>;
	
		
		public function BoteFugaAtor() 
		{
			MC_barco =  new Bote;
			super(MC_barco);
			MC_captura = new Capture;
		}
		
		/* INTERFACE TangoGames.Atores.AtorInterface */

		public function inicializa():void 
		{
			//Atualiza referencid do Barco Heroi
			AB_barcoHeroi = FaseTesouro ( faseAtor ).barcoHeroi;
			
			//velocidade maxima
			NU_veloMax = faseAtor.param[FaseJogoParamentos.PARAM_BOTE_FUGA_VELOC_MAX];
			
			//Distancia do barco para captura
			UI_distCaptura = 100;
			
			//adiciona hit teste
			adcionaClassehitGrupo(IlhaAtor);
			adcionaClassehitGrupo(BarcoHeroiAtor);
			adcionaClassehitGrupo(BarcoInimigoAtor);
			adcionaClassehitGrupo(BoteFugaAtor);
			
			PT_alvo = new Point(0, 0);

			VT_TEMP = new Vector.<Sprite>;
			//reinicia variaveis
			reinicializa();
		}

		
		public function reinicializa():void 
		{
			NU_direX = 0;
			NU_direY = 0;
			NU_impacX = 0;
			NU_impacY = 0;			
			NU_veloABS = 0;
			
			//contador de colisão com a ilha
			UI_colidiuIlha = 0;
			
			//alvo
			PT_PontoFuga = selecionaPontodeFuga();
			
			//capturar?
			BO_capturar = false;
			
			verificaCaminho();
			
		}
				
		public function update(e:Event):void 
		{	
			calculaDistanciaBarco();
			
			if (NU_distancia < UI_distCaptura ) {
				if (!BO_capturar) {
					BO_capturar = true;
					addChild(MC_captura);
					AB_barcoHeroi.avisoBote (this);
				}
			}
			else if (BO_capturar) {
				BO_capturar = false;
				removeChild (MC_captura);
			}
			
			if ( UI_colidiuIlha > 12 ) {
				//alvo
				PT_PontoFuga = selecionaPontodeFuga();
				verificaCaminho();
				UI_colidiuIlha = 0
				BO_colidiu = false;
			}
			
			fugindo();
			this.x += ( NU_direX * NU_veloABS ) + NU_impacX;
			this.y += ( NU_direY * NU_veloABS ) + NU_impacY;
			NU_impacX = 0 ;
			NU_impacY = 0;			
		}
		
		public function remove():void 
		{
			for (var i:uint = 0; i < VT_TEMP.length; i++) faseAtor.removeChild(VT_TEMP[i]);
		}
		
		/*******************************************************************************
		 *  Fugindo
		 ******************************************************************************/
		/**
		 * Perseguindo o Heroi
		 */
		private function selecionaPontodeFuga():Point
		{
			var pt:Point = new Point;
			var sort:uint  = Utils.Rnd(0, 3);
			switch (sort) 
			{
				case 0 :
					pt.x = Utils.Rnd(FaseTesouro(faseAtor).limGlob.left,FaseTesouro(faseAtor).limGlob.right)
					pt.y = FaseTesouro(faseAtor).limGlob.top;
				break;
				case 1 :
					pt.x = Utils.Rnd(FaseTesouro(faseAtor).limGlob.left,FaseTesouro(faseAtor).limGlob.right)
					pt.y = FaseTesouro(faseAtor).limGlob.bottom;
				break;
				case 2 :
					pt.y = Utils.Rnd(FaseTesouro(faseAtor).limGlob.top,FaseTesouro(faseAtor).limGlob.bottom)
					pt.x = FaseTesouro(faseAtor).limGlob.left;
				break;
				case 3 :
					pt.y = Utils.Rnd(FaseTesouro(faseAtor).limGlob.top,FaseTesouro(faseAtor).limGlob.bottom)
					pt.x = FaseTesouro(faseAtor).limGlob.right;
				break;
				default:
			} 
			return pt;
		}
		
		/**
		 * indo para o ponto de fuga
		 */
		private function fugindo():void 
		{
			var dx:Number = PT_objetivo.x - this.x;
			var dy:Number = PT_objetivo.y - this.y;
			if ( Math.sqrt( ( dx * dx ) + ( dy * dy ) ) < 100 ) {
				dx = PT_PontoFuga.x - this.x;
				dy = PT_PontoFuga.y - this.y;
				if ( Math.sqrt( ( dx * dx ) + ( dy * dy ) ) < 100 ) {
					trace("fugiu");
					marcadoRemocao = true;
					return
				}
				verificaCaminho();
			}
				
			calculaRotaAlvo()
			
			NU_veloABS += 0.1;
			if ( NU_veloABS > NU_veloMax ) NU_veloABS = NU_veloMax;

			var ajuste:Number = corrigeDirecao(NU_direAlvo);
			this.rotation += ajuste;
			NU_direcao = this.rotation *  Utils.GRAUS_TO_RADIANOS;
			NU_direY = Math.sin(NU_direcao);
			NU_direX = Math.cos(NU_direcao);
		}
		/**
		 * Calcula Rota
		 */
		private function verificaCaminho() {
			var caminho:Array =  faseAtor.mapa.caminho( new Point (this.x, this.y),  PT_PontoFuga , true);
			//geraQuadradosDebugCaminho(caminho);
			if (caminho.length < 3) {
				PT_objetivo = PT_PontoFuga;
			}
			else {
				PT_objetivo = faseAtor.mapa.convertePontoMapa(caminho[1]);
			}	
		}
		/**
		 * Calcula rota
		 */		
		private function calculaRotaAlvo() {
			var dx:Number = PT_objetivo.x - this.x;
			var dy:Number = PT_objetivo.y - this.y;		
			NU_direAlvo =  Math.atan2 ( dy, dx);
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
		
		public function colisaoPadrao(C:AtorBase) {
			var ret:Rectangle = Utils.colisaoIntersecao(this, C, faseAtor);
			if (ret == null) return;
			var dy:Number = ret.y - this.y;
			var dx:Number = ret.x - this.x;
			var ang:Number =  Math.atan2(dy, dx);
			var impact:Number = Math.max(NU_veloABS * 1.1,1);
			NU_impacY -= ( Math.sin(ang) * impact ) ;
			NU_impacX -= ( Math.cos(ang) * impact ) ;
			if (C is IlhaAtor) UI_colidiuIlha++;
			BO_colidiu = true;
		}
		/**
		 * 
		 * @param	_caminho
		 */
		private function geraQuadradosDebugCaminho(_caminho:Array) {
			var m:Sprite;
			var p:Point;
			var i:uint;
			for ( i = 0; i < VT_TEMP.length; i++) faseAtor.removeChild(VT_TEMP[i]);
			VT_TEMP = new Vector.<Sprite>;
			for (i = 0 ; i < _caminho.length ; i++) {
				m = faseAtor.mapa.geraSprite(0X00FF00);
				VT_TEMP.push(m);
				faseAtor.addChild(m);
				p = faseAtor.mapa.convertePontoMapa(_caminho[i]);
				m.x = p.x;
				m.y = p.y;
			}
		}
		/**
		 * calcula distancia do barco
		 */
		private function calculaDistanciaBarco() {	
			PT_alvo.x = AB_barcoHeroi.x;
			PT_alvo.y = AB_barcoHeroi.y;
			NU_distX = PT_alvo.x - this.x;
			NU_distY = PT_alvo.y - this.y;
			NU_distancia = Math.sqrt( ( NU_distX * NU_distX ) + ( NU_distY * NU_distY ) );
		}
		
		public function get capturar():Boolean 
		{
			return BO_capturar;
		}
		
	}
}