package Fases.FaseCasteloElementos 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Fases.FaseEvent;
	
	/**
	 * Classe do castelo
	 * @author ...
	 */
	public class CasteloAtor extends AtorBase implements AtorInterface
	{
		private var MC_castelo:MovieClip;
		private var MC_heroi:MovieClip;
		private var VT_Torres:Vector.<MovieClip>;
		private var VT_TorresInf:Vector.<TorreInf>;	
		private var ST_posicaoHeroi:String ;
		
		//Controle de Movimentacao do Heroi dentro do castelo
		private var IN_destino:int;
		private var TO_torreDest:TorreInf;
		private var ST_destinoHeroi:String ;
		private var BO_calculaRota:Boolean;
		//private var BO_andandoParaCentro:Boolean;
		
		//Variaveis do Heroi do castelo
		private var BO_andandoParaDestino:Boolean;
		private var BO_subindoTorre:Boolean;
		private var BO_descendoTorre:Boolean;
		private var UI_sobeDescConta:uint;
		private var NU_heroiVeloc:Number;
		private var NU_heroiVelX:Number;
		private var NU_heroiVelY:Number;
		private var BO_heroiPodeAtirar:Boolean;
		private var PT_saidaTorre:Point;
		private var VG_TiroHeroi:Vector.<Class>;
		
		
		//Variaveis da animação do castelo
		private var BO_treme:Boolean;
		private var UI_contatreme:uint;
		private var BO_vibra:Boolean;
		private var PT_Posicao:Point;
		private var SP_Mira:Sprite;
		private var UI_qtdTorres:uint;
		private var UI_tempoMov:uint;
		
		//Variaveis da vida do castelo
		private var UI_vidaInicio:Number;
		private var IN_vidaAtual:Number;
		
		//efeitos sonoros
		private var SC_canal:SoundChannel;
		private var SD_somCrossbow:Sound;
		private var SD_somBatendo:Sound;
		
		
		/**
		 * Classe construtora
		 */
		public function CasteloAtor() {
			//MC_castelo = new CasteloBase();
			
			//movieClip do castelo
			MC_castelo = new MovieClip();
			super(MC_castelo);
			
			//movieClip do Heroi
			MC_heroi = new PersonagemTorre();
			this.addChild(MC_heroi);
			
			//efeito som
			SC_canal = new SoundChannel;
			SD_somCrossbow =  new Crossbow;
			SD_somBatendo =  new BatendoParede;	
		}
		
		/***************************************************************************
		 * Métodos publicos ou protegidos da Class
		 * ************************************************************************/
		/**
		 * Informa ao castelo que ele foi atingido
		 * @param	dano
		 */
		public function acertouHit(_dano:uint):void {
			BO_treme = true;
			UI_contatreme = 0;
			IN_vidaAtual -= _dano;
			SC_canal = SD_somBatendo.play(0);
		}
		
		public function percentualVida():Number {
			if (IN_vidaAtual <= 0) return 0;
			var p:Number = ( IN_vidaAtual / UI_vidaInicio ) * 100;
			return p;
		}
		
		public function get vidaAtual():Number 
		{
			return IN_vidaAtual;
		}

		/***************************************************************************
		 * Métodos Implementados da Interfase AtorInterfase
		 * ************************************************************************/
		/**
		 * metodo de inicialização chamada pela FaseBase
		 * o método adicionaAtor da FaseBase chama este método
		 */
		public function inicializa():void {
			registra_novo_Mouse_Icon("MiraJogo",desenha_Cursor_Mira());
			registra_novo_Mouse_Icon("SelTorre", desenha_Cursor_Torre());
			
			switch (faseAtor.nivel) 
			{
				case 1:
					MC_castelo = new CasteloFase1();
					figurino = MC_castelo;	
					UI_qtdTorres = 3;
					UI_vidaInicio = 1000;
				break;
				case 2:
					MC_castelo = new CasteloFase2();
					figurino = MC_castelo;	
					UI_qtdTorres = 4;
					UI_vidaInicio = 2000;
				break;
				case 3:
					MC_castelo = new CasteloFase3();
					figurino = MC_castelo;
					UI_qtdTorres = 5;
					UI_vidaInicio = 10000;
				break;

				default:
			}	
			MC_castelo.stop();

			//Velocidade do Heroi, quantidade de torres castelo, tempo de subida e descida dos heroi nas torres
			NU_heroiVeloc = 5;
			UI_tempoMov = 12;
			
			PT_Posicao = new Point ( this.x, this.y );
			VT_Torres = new Vector.<MovieClip>;
			VT_TorresInf = new Vector.<TorreInf>;
			
			var torre:String;
			var porta:String;
			var tInf:TorreInf;
			for (var i:uint = 1 ; i <= UI_qtdTorres ; i++) {
				torre = "torre" + i.toString();
				porta = "porta" + i.toString();
				tInf = new TorreInf(MovieClip(MC_castelo.getChildByName(torre)), MovieClip(MC_castelo.getChildByName(porta)));
				VT_Torres.push(tInf.MC_torre);
				VT_TorresInf.push(tInf);
			}
			//VT_Torres.push(MC_castelo.centro);
			
			faseAtor.addEventListener(MouseEvent.MOUSE_OVER, trocaCursor, false, 0, true);
			faseAtor.addEventListener(MouseEvent.MOUSE_OUT, trocaCursor, false, 0, true);
			faseAtor.addEventListener(MouseEvent.CLICK, clickMouse, false, 0, true);
			
			//vetor de hitgrupo do tiro do heroi
			VG_TiroHeroi = new Vector.<Class>;
			VG_TiroHeroi.push(InimigoAtor);
			VG_TiroHeroi.push(CasteloAtor);
			reinicializa();
		}
		/**
		 * metodo de reinicialização chamada pela FaseBase
		 * o método reinicializacao da FaseBase chama este método
		 */
		public function reinicializa():void {
			BO_heroiPodeAtirar = false;
			BO_treme = false;
			BO_vibra = false;
			IN_destino = -1;
			BO_andandoParaDestino = false;
			BO_subindoTorre = false;
			UI_sobeDescConta = 0;
			PT_saidaTorre = new Point(0, 0);
			MC_heroi.x = 0;
			MC_heroi.y = 0;
			ST_destinoHeroi = "";
			BO_calculaRota = false;
			ST_posicaoHeroi = "centro";
			NU_heroiVelX = 0;
			NU_heroiVelY = 0;
			MC_heroi.scaleX = 1;
			MC_heroi.scaleY = 1;
			MC_heroi.gotoAndStop("normal");
			IN_vidaAtual = UI_vidaInicio;
		}
		/**
		 * metodo de update  chamada pela FaseBase
		 * o método update da FaseBase chama este método
		 */
		public function update(e:Event):void {
			//controla ação de subir na torre
			if (BO_subindoTorre) {
				subidaTorre();
				return;
			}
			if (BO_descendoTorre) {
				descidaTorre();
				return;
			}
			
			//calcula rota nova
			if (BO_calculaRota) calcularRota();
			
			//controla situação andando para o destino
			if (BO_andandoParaDestino) andandoDestino ();
			
			//executa o efeito tremer
			if (BO_treme) efeitoTremer();
			
			if (BO_heroiPodeAtirar) miraMouse();
			
		}
		/**
		 * metodo de remove chamada pela FaseBase
		 * o método removeAtor da FaseBase chama este método
		 */
		public function remove():void {
			//Mouse.show();
			//parent.removeChild(SP_Mira);
			faseAtor.removeEventListener(MouseEvent.MOUSE_OVER, trocaCursor);
			faseAtor.removeEventListener(MouseEvent.MOUSE_OUT, trocaCursor);
			faseAtor.removeEventListener(MouseEvent.CLICK, clickMouse);
		}
		/**********************************************************************************
		 *  metodos privados da classe
		 * *******************************************************************************/
		/**
		 * ajusta a rotacao do Herio com o ponteiro do mouse
		 */
		private function miraMouse():void {
			var ang:Number = Math.atan2(faseAtor.mouseY - (this.y + MC_heroi.y) , faseAtor.mouseX - (this.x + MC_heroi.x) );
			MC_heroi.rotation = ang * 180 / Math.PI;
		}
		 
		/**
		 * ação da descida torre
		 */
		private function descidaTorre():void {
			UI_sobeDescConta ++;
			if ( UI_sobeDescConta > UI_tempoMov) {
				UI_sobeDescConta = 0
				BO_descendoTorre = false;
				MC_heroi.visible = true;
				MC_heroi.gotoAndPlay("andar");
			}
		}

		 /**
		 * ação da subida da torre
		 */
		private function subidaTorre():void {
			UI_sobeDescConta ++;
			if ( UI_sobeDescConta > UI_tempoMov ) {
				UI_sobeDescConta = 0
				BO_subindoTorre = false;
				MC_heroi.scaleX = 1.2;
				MC_heroi.scaleY = 1.2;
				BO_heroiPodeAtirar = true;
				MC_heroi.visible = true
				MC_heroi.gotoAndStop("ataque");
			}
		}
		/**
		 * efeito de tremer o castelo quando toma dano
		 */
		private function efeitoTremer():void {
			if (BO_vibra) {
				this.x = PT_Posicao.x;
				this.y = PT_Posicao.y;
				BO_vibra = false;
			}
			else {
				this.x += Math.random() * 3;
				this.y += Math.random() * 3;
				BO_vibra = true;
				UI_contatreme++;
			}
			if ( UI_contatreme > 3 ) {
				UI_contatreme = 0;
				BO_treme = false;
				BO_vibra = false;
			}
		}
		/**
		 * Trata Heroi andando para o Destino
		 */
		private function andandoDestino():void {
			MC_heroi.x += NU_heroiVelX;
			MC_heroi.y += NU_heroiVelY;
			if (MC_heroi.currentFrameLabel == "andarfim") MC_heroi.gotoAndPlay("andar");
			if (MC_heroi.hitTestObject(TO_torreDest.MC_porta)) {
				PT_saidaTorre = TO_torreDest.PT_porta;
				if (TO_torreDest.ST_destino == "centro") {
					PT_saidaTorre = new Point (0, 0) ;						
				}
				else {
					BO_subindoTorre = true;
					UI_sobeDescConta = 0;
					MC_heroi.visible = false;
				}
				NU_heroiVelX = 0;
				NU_heroiVelY = 0;
				MC_heroi.x = TO_torreDest.PT_torre.x;
				MC_heroi.y = TO_torreDest.PT_torre.y;
				BO_andandoParaDestino = false;
				ST_posicaoHeroi = TO_torreDest.ST_destino;
			}
		}
		/**
		 * calcula Rota 
		 */
		private function calcularRota():void {   
			if (!BO_andandoParaDestino) {
				if (ST_posicaoHeroi != "centro") {
					UI_sobeDescConta = 0;
					BO_descendoTorre = true;
					MC_heroi.visible = false;
				}
				MC_heroi.x = PT_saidaTorre.x;
				MC_heroi.y = PT_saidaTorre.y;
				MC_heroi.scaleX = 1;
				MC_heroi.scaleY = 1;
				BO_heroiPodeAtirar = false;
			}
			TO_torreDest = VT_TorresInf[IN_destino]; 
			var ang:Number = Math.atan2(TO_torreDest.PT_porta.y - MC_heroi.y , TO_torreDest.PT_porta.x - MC_heroi.x);
			NU_heroiVelX =  Math.cos(ang) * NU_heroiVeloc;
			NU_heroiVelY =  Math.sin(ang) * NU_heroiVeloc;
			MC_heroi.rotation = ang * 180 / Math.PI;
			BO_andandoParaDestino = true;
			BO_calculaRota = false;
		}
		/**
		 * Manipula Click do Mouse
		 * @param	e
		 */
		private function clickMouse(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				var index:int = VT_Torres.indexOf(MovieClip(e.target));
				if ( index >= 0 && index!=IN_destino) {
					IN_destino = index;
					BO_calculaRota = true;
					return;
				}
				if (MovieClip(e.target) == MC_castelo) return;
			}
			if (BO_heroiPodeAtirar) atiraHeroi();
		}
		/**
		 * Tiro do Heroi
		 */
		private function atiraHeroi():void 
		{
			SC_canal = SD_somCrossbow.play(0);
			var pontoDisparo:Point = new Point( this.x + MC_heroi.x, this.y + MC_heroi.y);
			var direcaoAlvo:Point = new Point( faseAtor.mouseX, faseAtor.mouseY);
			faseAtor.adicionaAtor(new TiroAtor( pontoDisparo, direcaoAlvo), VG_TiroHeroi);
		}
		/**
		 * controle do cursor
		 * @param	e
		 */
		private function trocaCursor(e:MouseEvent):void {	
			switch (e.type) 
			{
				case MouseEvent.MOUSE_OVER:
					var mstr:String = MouseCursor.AUTO;
					if (BO_heroiPodeAtirar) mstr = "MiraJogo";
					if (e.target is MovieClip) {
						if (MovieClip(e.target) == MC_castelo) mstr = MouseCursor.AUTO;
						if (VT_Torres.indexOf(MovieClip(e.target)) >= 0 ) mstr = "SelTorre";
					}
					Mouse.cursor = mstr;
				break;
				case MouseEvent.MOUSE_OUT:
					Mouse.cursor = MouseCursor.AUTO;
				break;
				default:
			}
		}
		
		/*******************************************************************
		*                   Tratamento do cursor
		********************************************************************/
		/**
		 * Desenha bitmap para o cursor de Mira para o mouse
		 * @return
		 * retorna a imagem bitmap para usar no mouse
		 */
		private function desenha_Cursor_Mira():Bitmap { 
			var spr:Sprite = new Sprite;
			spr.graphics.lineStyle(1,0x000000);
			spr.graphics.moveTo(1 , 16);
			//spr.graphics.beginFill(0x00FF00);
			spr.graphics.lineTo(31, 16);
			spr.graphics.moveTo(16 , 1);
			spr.graphics.lineTo(16, 31);
			spr.graphics.drawCircle( 16, 16, 14);
			spr.graphics.drawCircle(16, 16, 7);
			var b:BitmapData = new BitmapData(32, 32, true, 0x0);
			b.draw(spr);
			var bitmap:Bitmap = new Bitmap(b);
			return bitmap;
		}
		
		/**
		 * Desenha bitmap para o cursor seleçao de torre para o mouse
		 * @return
		 * retorna a imagem bitmap para usar no mouse
		 */		
		private function desenha_Cursor_Torre():Bitmap { 
			var spr:Sprite = new Sprite;
			with (spr.graphics) {
				lineStyle();
				beginFill(0x00FF66);
				drawRect(0, 10, 5, 10);
				moveTo(5, 10);
				lineTo(5, 7);
				lineTo(13, 16);
				lineTo(5, 23);
				lineTo(5, 20);
				endFill();
				beginFill(0x00FF66);
				drawRect(10, 0, 10, 5);
				moveTo(20, 5);
				lineTo(23, 5);
				lineTo(16, 13);
				lineTo(7, 5);
				lineTo(10, 5);
				endFill();
				beginFill(0x00FF66);
				drawRect(26, 10, 5, 10);
				moveTo(26, 20);
				lineTo(26, 23);
				lineTo(19, 16);
				lineTo(26, 7);
				lineTo(26, 10);
				endFill();
				beginFill(0x00FF66);
				drawRect(10,26, 10, 5);
				moveTo(10, 26);
				lineTo(7, 26);
				lineTo(16, 19);
				lineTo(23, 26);
				lineTo(20, 26);
				endFill();
			}
			var b:BitmapData = new BitmapData(32, 32, true, 0x0);
			b.draw(spr);
			var bitmap:Bitmap = new Bitmap(b);
			return bitmap;
		}

		/**
		 * Registra novo icone do mouse
		 * Este codigo só pode ser usado em versão superior igual a 10.2 do flash 
		 * @param	Nome
		 * @param	bitmapCursor
		 */
 		private function registra_novo_Mouse_Icon(Nome:String, bitmapCursor:Bitmap ):void {
			// Cria MouseCursorData object
			var cursorData:MouseCursorData = new MouseCursorData();
			// Especifica ponto de apontamento do mouse
			cursorData.hotSpot = new Point(16,16);
			// Informa o desenho bitmap do cursor para o vetor BitmapData
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			// A imagem do cursor deve ser 32x32 pixels ou menor, limite do SO
			var bitmap:Bitmap = bitmapCursor;
			// Colocar a Imagem do cursor no vetor da imagens
			bitmapDatas[0] = bitmap.bitmapData; 
			// Atribui a imagem bitmap para o MouseCursor object 
			cursorData.data = bitmapDatas; 
			// Registra o MouseCursorData do Mouse object como o nome 
			Mouse.registerCursor(Nome, cursorData); 
			// Para mudar o mouse basta atribuir o nome escolhido para a propriedade Mouse.cursor
			//Mouse.cursor = Nome;
		}
		
	}
}

import flash.display.MovieClip;
import flash.geom.Point;
import flash.geom.Rectangle;
/**
 * Classe com as informações das torres
 */
internal class TorreInf {
	public var MC_torre:MovieClip;
	public var MC_porta:MovieClip;
	public var ST_destino:String;
	public var PT_porta:Point;
	public var PT_torre:Point;
	public function TorreInf(_torre:MovieClip, _porta:MovieClip) {
		MC_torre = _torre;
		MC_porta = _porta;
		ST_destino =  MC_torre.name;
		PT_torre = calculaPontoCentral(MC_torre);
		PT_porta = calculaPontoCentral(MC_porta);
	}
	private function calculaPontoCentral(m:MovieClip):Point {
		var p:Point =  new Point;
		var rt:Rectangle = m.getBounds(m.parent);
		p.x = rt.left + ( rt.width / 2 );
		p.y = rt.top + ( rt.height / 2) ;
		return p;
	}
	
}