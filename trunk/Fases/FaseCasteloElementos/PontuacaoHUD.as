package Fases.FaseCasteloElementos 
{
	import Fases.FaseCastelo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class PontuacaoHUD extends FaseHUD implements FaseHUDInterface 
	{
		private var UI_valorPontos:uint;
		private var TF_textoPontos:TextField;
		private var FB_faseCastelo: FaseCastelo;
		private var SB_pause: SimpleButton;
		private var BO_pause: Boolean;
		
		
		public function PontuacaoHUD(_fase:FaseCastelo) 
		{
			FB_faseCastelo = _fase;
			super();
			
			var formato:TextFormat = new TextFormat;
			formato.size = 18;
			formato.bold = true;
			formato.color = 0x000000;
			formato.font =  Font(new FontMenu()).fontName;
			
			TF_textoPontos =  new TextField;
			TF_textoPontos.defaultTextFormat = formato;
			TF_textoPontos.text = "999999"
			TF_textoPontos.autoSize = TextFieldAutoSize.RIGHT;
			TF_textoPontos.selectable = false;
			
			this.addChild(TF_textoPontos);
			
			SB_pause = new BotaoPausa;
			
			this.addChild(SB_pause);
			SB_pause.x = TF_textoPontos.width + SB_pause.width + 20 ;
			SB_pause.y = TF_textoPontos.height / 2;
			
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			
			this.y = 10;			
			this.x = stage.stageWidth - this.width -  SB_pause.width - 10 ;
			pause = false;
			reinicializa();
			SB_pause.addEventListener(MouseEvent.MOUSE_DOWN, onPauseClick, false, 0, true );
		}
		
		private function onPauseClick(e:MouseEvent):void 
		{
			BO_pause = true;
		}
		
		public function reinicializa():void 
		{
			UI_valorPontos = 0;
			TF_textoPontos.text = UI_valorPontos.toString();
			pause = false;
		}
		
		public function update(e:Event):void 
		{
			if (UI_valorPontos != FB_faseCastelo.pontos) {
				UI_valorPontos = FB_faseCastelo.pontos;
				TF_textoPontos.text = UI_valorPontos.toString();
			}
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		public function remove():void 
		{
			SB_pause.removeEventListener(MouseEvent.DOUBLE_CLICK, onPauseClick );
		}
		
		public function get pause():Boolean 
		{
			return BO_pause;
		}
		
		public function set pause(value:Boolean):void 
		{
			BO_pause = value;
		}
		
	}

}