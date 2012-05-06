package Fases.Efeitos {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import TangoGames.Atores.AtorAnimacao;
	
	
	public class AvisoPontos extends AtorAnimacao {
		
		public function AvisoPontos(_pontos:int ) {
			
			var TF:TextField = TextField(this.valorpontos.pontos);
			TF.autoSize = TextFieldAutoSize.CENTER;
			if (_pontos >= 0 ) {
				TF.defaultTextFormat = new TextFormat("_sans", 32, 0X00FF00,true);
				TF.text = "+" + _pontos.toFixed(0);
				
			}
			else {
				TF.defaultTextFormat = new TextFormat("_sans", 32, 0XFF0000,true);
				TF.text = _pontos.toFixed(0);
			}
			
			// constructor code
		}
	}
	
}
