package Fases.FaseCasteloElementos 
{
	import fl.motion.AnimatorBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Fases.FaseEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Castelo extends AtorBase implements AtorInterface
	{
		private var MC_castelo:MovieClip;
		private var MC_heroi:MovieClip;
		private var VT_Torres:Vector.<MovieClip>;
		private var ST_posicaoHeroi:String ;
		private var MC_destino:MovieClip;
		private var ST_destinoHeroi:String ;
		private var BO_calculaRota:Boolean;
		//private var BO_andandoParaCentro:Boolean;
		
		//Variaveis do Heroi do castelo
		private var BO_andandoParaDestino:Boolean;
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
		
		public function Castelo() {
			MC_castelo = new CasteloBase();
			super(MC_castelo);
			
			MC_heroi = new PersonagemTorre();
			this.addChild(MC_heroi);
			
		}
		
		public function inicializa():void {
			registra_novo_Mouse_Icon("MiraJogo",desenha_Cursor_Mira());
			registra_novo_Mouse_Icon("SelTorre",desenha_Cursor_Torre());
			NU_heroiVeloc = 5;
			PT_Posicao = new Point ( this.x, this.y );
			VT_Torres = new Vector.<MovieClip>;
			VT_Torres.push(MC_castelo.Hitbox1);
			VT_Torres.push(MC_castelo.Hitbox2);
			VT_Torres.push(MC_castelo.Hitbox3);
			VT_Torres.push(MC_castelo.Hitbox4);
			VT_Torres.push(MC_castelo.Hitbox5);
			//VT_Torres.push(MC_castelo.centro);
			
			faseAtor.addEventListener(MouseEvent.MOUSE_OVER, trocaCursor, false, 0, true);
			faseAtor.addEventListener(MouseEvent.MOUSE_OUT, trocaCursor, false, 0, true);
			faseAtor.addEventListener(MouseEvent.CLICK, clickMouse, false, 0, true);
			
			//vetor de hitgrupo do tiro do heroi
			VG_TiroHeroi = new Vector.<Class>;
			VG_TiroHeroi.push(InimigoAtor);
			
			reinicializa();
		}
		
		private function clickMouse(e:MouseEvent):void 
		{
			if (e.target is MovieClip) {
				if (VT_Torres.indexOf(MovieClip(e.target)) >= 0) {
				MC_destino = MovieClip(e.target);
				ST_destinoHeroi = MovieClip(e.target).name;
				BO_calculaRota = true;
				return;
			}
			if (MovieClip(e.target) == MC_castelo) return;

				
			}
			if (BO_heroiPodeAtirar) atiraHeroi();
		}
		
		private function atiraHeroi():void 
		{
			var pontoDisparo:Point = new Point( this.x + MC_heroi.x, this.y + MC_heroi.y);
			var direcaoAlvo:Point = new Point( faseAtor.mouseX, faseAtor.mouseY);
			faseAtor.adicionaAtor(new TiroAtor( pontoDisparo, direcaoAlvo), VG_TiroHeroi);
		}
		
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

		public function reinicializa():void {
			BO_heroiPodeAtirar = false;
			BO_treme = false;
			BO_vibra = false;
			BO_andandoParaDestino = false;
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
		}
		
		public function update(e:Event):void {

			if (BO_calculaRota) calcularRota();
			
			if (BO_andandoParaDestino) {
				MC_heroi.x += NU_heroiVelX;
				MC_heroi.y += NU_heroiVelY;
				if (MC_heroi.hitTestObject(MC_destino)) {
					PT_saidaTorre = new Point (MC_heroi.x, MC_heroi.y);
					if (ST_destinoHeroi == "centro") {
						PT_saidaTorre = new Point (0, 0) ;						
					}
					else {
						MC_heroi.scaleX = 1.5;
						MC_heroi.scaleY = 1.5;
						BO_heroiPodeAtirar = true;
					}
					NU_heroiVelX = 0;
					NU_heroiVelY = 0;
					MC_heroi.x = MC_destino.x;
					MC_heroi.y = MC_destino.y;
					BO_andandoParaDestino = false;
					ST_posicaoHeroi = ST_destinoHeroi;
				}
			}
			if (BO_treme) {
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
				if ( UI_contatreme > 15 ) {
					UI_contatreme = 0;
					BO_treme = false;
					BO_vibra = false;
				}
			}
		}
		
		private function calcularRota():void {   
			if (!BO_andandoParaDestino) {
				MC_heroi.x = PT_saidaTorre.x;
				MC_heroi.y = PT_saidaTorre.y;
				MC_heroi.scaleX = 1;
				MC_heroi.scaleY = 1;
				BO_heroiPodeAtirar = false;
			}
			var ang:Number = Math.atan2(MC_destino.y - MC_heroi.y , MC_destino.x - MC_heroi.x);
			NU_heroiVelX =  Math.cos(ang) * NU_heroiVeloc;
			NU_heroiVelY =  Math.sin(ang) * NU_heroiVeloc;
			BO_andandoParaDestino = true;
			BO_calculaRota = false;
		}
		
		public function remove():void {
			//Mouse.show();
			//parent.removeChild(SP_Mira);
			faseAtor.removeEventListener(MouseEvent.MOUSE_OVER, trocaCursor);
			faseAtor.removeEventListener(MouseEvent.MOUSE_OUT, trocaCursor);
			faseAtor.removeEventListener(MouseEvent.CLICK, clickMouse);
		}
		
		public function acertouHit(dano:int):void {
			BO_treme = true;
			UI_contatreme = 0;
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