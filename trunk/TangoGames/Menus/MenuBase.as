package TangoGames.Menus 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * Menu básico para construção de opções
	 * @author Arthur Figueiredo
	 */
	public class MenuBase extends MovieClip {
		
		private var ST_ID_Menu:String;
		private var SPR_Fundo:Sprite;
		private var AR_OpcaoMenu:Array;
		private var VET_Opcoes:Vector.<MenuOpcao>;
		private var BO_efeitoMouse:Boolean = true;
		
		private var TF_formatacao:TextFormat;
		private var FT_fonte:Font;
		
		private	var GF_filt:GlowFilter;
		private	var GF_filt_select:GlowFilter;
		private	var DS_filt_shadow:DropShadowFilter;
		private	var DS_filt_shadow_select:DropShadowFilter;
		private var BF_filt_blur: BlurFilter;
		
		private var BO_semFundo		:Boolean;

		/**
		 * MenuBase é uma classe de apoio para construção de Menus
		 * @param	_idMenu
		 * Texto usado para identificação do menu
		 * @param	_fundo
		 * Sprite que será colocado como fundo no Menu
		 */ 
		public function MenuBase(_idMenu:String,_fundo:Sprite=null) {
			this.ID_Menu = _idMenu;
			this.SPR_Fundo = _fundo;			
			TF_formatacao = new TextFormat;
			TF_formatacao.size = 50;
			TF_formatacao.bold = true;
			TF_formatacao.color = 0xFFFFFF;
			FT_fonte = new Font;
			
			//FT_fonte.fontName = "Arial";
			TF_formatacao.font = FT_fonte.fontName;
			
			VET_Opcoes = new Vector.<MenuOpcao>;
			
			configuraEfeitos();
			
			addEventListener(Event.ADDED_TO_STAGE, adicionadoStage, false, 0, true);
			
			BO_semFundo = false;
		}
		
		/***************************************************************************
		 *    Área dos métodos privados da classe
		 * ************************************************************************/
		/**
		 * manipula evento de adicionado no stage
		 * @param	e
		 * referencia do objeto do evento gerado
		 */
		private function adicionadoStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, adicionadoStage);
			if (!BO_semFundo) {
				if (SPR_Fundo == null) SPR_Fundo =  geraSprite(stage.stageWidth, stage.stageHeight, 0X0000FF, 1);
				this.addChildAt (SPR_Fundo, 0);
			}
			construirMenu();
			addEventListener(Event.REMOVED_FROM_STAGE, removidoStage);
		}
		
		/**
		 * manipula evento de removido no stage
		 * @param	e
		 * referencia do objeto do evento gerado
		 */		
		private function removidoStage(e:Event):void {
			destruirMenu();
			if (!BO_semFundo) this.removeChild(SPR_Fundo);
			removeEventListener(Event.REMOVED_FROM_STAGE, removidoStage);
			addEventListener(Event.ADDED_TO_STAGE, adicionadoStage, false, 0, true);
		}
		
		/**
		 * metodo auxilia a construção das opções do menu do menu
		 */
		private function construirMenu():void {
			for each (var op:MenuOpcao in VET_Opcoes ) {
				this.addChild( op);
				posicionaOpcao(op);
				op.addEventListener(MouseEvent.CLICK, manipulaEventoMouse, false, 0, true);
				op.addEventListener(MouseEvent.MOUSE_OVER, manipulaEventoMouse, false, 0, true);
				op.addEventListener(MouseEvent.MOUSE_OUT, manipulaEventoMouse, false, 0, true);
				if (BO_efeitoMouse) {
					if (op.ativo) op.opcaoDisplay.filters = [GF_filt, DS_filt_shadow];
					else op.opcaoDisplay.filters = [ GF_filt, DS_filt_shadow,BF_filt_blur ];
				}
			}
		}
		
		/**
		 * metodo auxilia a destruir as opções do menu
		 */	
		private function destruirMenu():void {
			
			for each (var op:MenuOpcao in VET_Opcoes) {
				op.removeEventListener(MouseEvent.CLICK, manipulaEventoMouse);
				op.removeEventListener(MouseEvent.MOUSE_OVER,manipulaEventoMouse);
				op.removeEventListener(MouseEvent.MOUSE_OUT, manipulaEventoMouse);
				this.removeChild(op);
			}
		}
		
		/**
		 * Metodo auxliar para configura os efeitos
		 */
		private function configuraEfeitos() {
			GF_filt = new GlowFilter;  
			GF_filt_select = new GlowFilter;  
			DS_filt_shadow = new DropShadowFilter;  
			DS_filt_shadow_select = new DropShadowFilter;  
			BF_filt_blur = new BlurFilter;

			
			GF_filt.color = 0x00000;
			GF_filt.blurX = 7;  
			GF_filt.blurY = 7;  
			
			GF_filt_select.color = 0x00000;
			GF_filt_select.blurX = 14;  
			GF_filt_select.blurY = 14;  
			
			DS_filt_shadow.blurX = 4;  
			DS_filt_shadow.blurY = 4;  
			DS_filt_shadow.alpha = .4;  
			
			DS_filt_shadow_select.blurX = 2;  
			DS_filt_shadow_select.blurY = 2;  
			DS_filt_shadow_select.alpha = .2;  
			
			BF_filt_blur.blurX = 2;
			BF_filt_blur.blurY = 2;
			BF_filt_blur.quality = BitmapFilterQuality.HIGH;
		}
		
		/**
		 * manipula eventos do mouse
		 * @param	e
		 * referencia do objeto do evento gerado
		 */
		private function manipulaEventoMouse(e:MouseEvent):void {
			var op:MenuOpcao = MenuOpcao(e.currentTarget)
			switch (e.type) {
				case MouseEvent.CLICK:
					dispatchEvent(new MenuEvent(MenuEvent.OPCAO_SELECIONADA, op.valorRetorno,op));
					break;
				case MouseEvent.MOUSE_OVER:
					if (efeitoMouse) { aplicaEfeitoMouse(op,true);}
					dispatchEvent(new MenuEvent(MenuEvent.OPCAO_MOUSE_OVER, op.valorRetorno,op));
					break;
				case MouseEvent.MOUSE_OUT:
					if (efeitoMouse) { aplicaEfeitoMouse(op, false); }
					dispatchEvent(new MenuEvent(MenuEvent.OPCAO_MOUSE_OUT, op.valorRetorno,op));
					break;
				default:
			}
		}
		
		/**
		 * Liga e desliga o efeito do mouse over 
		 * @param	op
		 * Objeto MenuOpcao que o efeito será aplicado 
		 * @param	onoff
		 * flag que indica se aplica o efeito true = sim / false = nao
		 */
		protected function aplicaEfeitoMouse(op:MenuOpcao,onoff:Boolean):void {
			if (onoff) {
				if ( op.ativo ) {
					op.opcaoDisplay.filters = [GF_filt_select, DS_filt_shadow_select];
					op.opcaoDisplay.scaleX = 1.05;
					op.opcaoDisplay..scaleY = 1.05;
				}
				else {
					Mouse.cursor = MouseCursor.ARROW;
				}
			}
			else {
				if ( op.ativo ) {
					op.opcaoDisplay.filters = [GF_filt, DS_filt_shadow];
					op.opcaoDisplay.scaleX = 1.0;
					op.opcaoDisplay.scaleY = 1.0;
				}
				else {
					Mouse.cursor = MouseCursor.AUTO;
				}
			}
		}
		 
		private function geraSprite(_largura:uint,_altura:uint,_cor:uint,_alpha:Number):Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle();
			sp.graphics.beginFill(_cor, _alpha)
			sp.graphics.drawRect(0, 0, _largura, _altura);
			sp.graphics.endFill();
			return sp;
		}
		
		/***************************************************************************
		 *    Área dos métodos protegidos da classe
		 * ************************************************************************/
		/**
		 * posiciona as opções na tela do menu
		 * pode ser sobrescrita
		 * @param	_op
		 * referencia do objeto MenuOpcao que sera posicionada;
		 */
		protected function posicionaOpcao(_op:MenuOpcao):void {
			var i:uint = VET_Opcoes.indexOf(_op) + 1;
			_op.x = ( stage.stageWidth - _op.width ) / 2;
			_op.y = ( ( stage.stageHeight - _op.height ) / (VET_Opcoes.length + 1) ) * i;
		}
		
		/***************************************************************************
		 *    Área dos métodos publicos da classe
		 * ************************************************************************/
		/**
		 * Adiciona uma opção de menu
		 * @param 	Titulo
		 * Titulo que será apresentado na tela
		 * @param	valorRetorno
		 * Valor de retorno do evento quando a opção é selecionada 
		 * @param	proximomenu
		 * Função que constroi/define o próximo menu que será chamado por esta opção 
		 * @param	displayObj
		 * Objeto que será apresentado na tela representando a opção do menu (MovieClip, Sprite, etc)
		 */
		public function adicionaOpcao(Titulo:String, valorRetorno:uint, proximomenu:Function = null, displayObj: DisplayObject = null , ativo:Boolean = true):void {
			var op:MenuOpcao = new MenuOpcao(Titulo, valorRetorno, proximomenu, displayObj);
			op.ativo = ativo;
			VET_Opcoes.push(op);
			op.formato = TF_formatacao;
		}
		
		/**
		 * Adiciona uma opção de menu representando um nível da uma fase
		 * @param   faseID
		 * número do ID da fase
		 * @param 	Titulo
		 * Titulo que será apresentado na tela
		 * @param	valorRetorno
		 * Valor de retorno do evento quando a opção é selecionada 
		 * @param	proximomenu
		 * Função que constroi/define o próximo menu que será chamado por esta opção 
		 * @param	displayObj
		 * Objeto que será apresentado na tela representando a opção do menu (MovieClip, Sprite, etc)
		 */
		public function adicionaOpcaoNiveisFase(faseID:uint,Titulo:String, valorRetorno:uint, proximomenu:Function = null, displayObj: DisplayObject = null , ativo:Boolean = true):void {
			var op:MenuOpcao = new MenuOpcao(Titulo, valorRetorno, proximomenu, displayObj);
			op.faseControle = true;
			op.faseID = faseID;
			op.ativo = ativo;
			VET_Opcoes.push(op);
			op.formato = TF_formatacao;
		}
		
		public function limpaOpcoes():void {
			VET_Opcoes = new Vector.<MenuOpcao>;
		}

		/***************************************************************************
		 *    Propriedade visíveis da Classe
		 * ************************************************************************/
		
		/**
		 * fonte utilizado pelas opções do menu
		 */
		public function get fonte():Font { return FT_fonte; }
		
		/**
		 * fonte utilizado pelas opções do menu
		 */		
		public function set fonte(value:Font):void {
			FT_fonte = value;
			TF_formatacao.font = FT_fonte.fontName;
			formatacao = TF_formatacao;
		}

		/**
		 * objeto usado para formatação das opções do menu
		 */
		public function get formatacao():TextFormat { return TF_formatacao; }

		/**
		 * objeto usado para formatação das opções do menu
		 */		
		public function set formatacao(value:TextFormat):void {
			TF_formatacao = value;
			for each(var op:MenuOpcao in VET_Opcoes) { op.formato = TF_formatacao; }
		}
		
		/**
		 * Flag que controla o efeito visual automático das opções 
		 */
		public function get efeitoMouse():Boolean { return BO_efeitoMouse; }
		
		/**
		 * Flag que controla o efeito visual automático das opções 
		 */		
		public function set efeitoMouse(value:Boolean):void { BO_efeitoMouse = value; }
		
		/**
		 * Texto informado como identificador no Menu 
		 */
		public function get ID_Menu():String { return ST_ID_Menu; }
		
		/**
		 * Texto informado como identificador no Menu 
		 */
		public function set ID_Menu(value:String):void { ST_ID_Menu = value; }
		
		public function get fundo():Sprite 
		{
			return SPR_Fundo;
		}
		
		public function get semFundo():Boolean 
		{
			return BO_semFundo;
		}
		
		public function set semFundo(value:Boolean):void 
		{
			BO_semFundo = value;
		}
	}
}