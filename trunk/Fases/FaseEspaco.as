package Fases 
{
	import Fases.FaseEspacoElementos.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * ...
	 * @author Diogo Honorato
	 */
	public class FaseEspaco extends FaseBase implements FaseInterface
	{
		
		private var VGHitmeteoro:Vector.<Class> = new Vector.<Class>;
		
		
		private var naveHeroi:HeroiAtor;
		private var numStars:int = 80;
		private var MC_estrelas:MovieClip;
		private var AR_estrelas:Array = new Array;
		public var AR_Meteoros:Array;
		private var contInimigos:int = 120;
		private var MC_meteoroInimigo:MeteoroAtor;
		
		private var HUD:TextField;
		private var HUD_Formatacao:TextFormat;
		
		public function FaseEspaco(_main:DisplayObjectContainer, Nivel:int) 
		{
			super(_main, Nivel);
			this.addChild(new BackGroundSpaco);
			
			HUD = new TextField();
			HUD_Formatacao = new TextFormat();
			
		}
		public function reiniciacao():void {
			
			naveHeroi.x = naveHeroi.width;
			naveHeroi.y = stage.stageHeight / 2;
			
			HUD.text = ("LIFE:" + naveHeroi.NU_Life + "%");
			
		//remove inimigos
			for each ( var ator:AtorBase in Atores) if (ator is MeteoroAtor) ator.marcadoRemocao = true;
			
			
			contInimigos = 120;
		}
		public function inicializacao():Boolean {
			
			VGHitmeteoro.push(HeroiAtor);
			
			naveHeroi = new HeroiAtor();
			naveHeroi.x = naveHeroi.width;
			naveHeroi.y = stage.stageHeight / 2;
			
			adicionaAtor(naveHeroi);
			
			HUD_Formatacao.color = "0xFFFFFF";
			HUD_Formatacao.size = 30;
			HUD_Formatacao.font = "Arial";
			HUD.defaultTextFormat = HUD_Formatacao;
			
			//HUD.text = naveHeroi.NU_Life;
			HUD.autoSize = TextFieldAutoSize.CENTER;
			HUD.text = ("LIFE:" + naveHeroi.NU_Life + "%");
			HUD.width = 100;
			HUD.x = stage.stageWidth / 2 - HUD.width / 2;
			HUD.y = 12;
			HUD.selectable = false;
			
			
			
			this.addChild(HUD);
			
			
			
			for (var i:int = 0; i < numStars; i++)
			{
				MC_estrelas = new Estrelas(stage)
				this.addChildAt(MC_estrelas, 1);
				
				AR_estrelas.push(MC_estrelas);
			}
			
			return true;
		}
			
			
		public function update(e:Event):void {
			if (pressTecla(Keyboard.P)) {
				pausaFase();
				return;
			}
			geraInimigos();
			HUD.text = ("LIFE:" + naveHeroi.NU_Life + "%");
			
			for (var i:int; i < AR_estrelas.length; i++) {
				AR_estrelas[i].update();
			}
			
			
			
			
			
		}
		
		private function geraInimigos():void 
		{
			contInimigos --;
			if (contInimigos <= 0) {
				
				if ( nivel == 1) {
					contInimigos = 120; // 5 segundos para cada respaw
					
					MC_meteoroInimigo = new MeteoroAtor(nivel);
					MC_meteoroInimigo.y = (stage.stageHeight - stage.stageHeight / 9) * Math.random();
					MC_meteoroInimigo.x = stage.stageWidth + MC_meteoroInimigo.width;
					adicionaAtor(MC_meteoroInimigo, VGHitmeteoro);
					//AR_Meteoros.push(MC_meteoroInimigo);
				}
				else if ( nivel == 2) {
					contInimigos = 72;
					
					MC_meteoroInimigo = new MeteoroAtor(nivel);
					MC_meteoroInimigo.y = (stage.stageHeight - stage.stageHeight / 9) * Math.random();
					MC_meteoroInimigo.x = stage.stageWidth + MC_meteoroInimigo.width;
					adicionaAtor(MC_meteoroInimigo, VGHitmeteoro);
					//AR_Meteoros.push(MC_meteoroInimigo);
				}
				else if ( nivel == 3) {
					contInimigos = 72;
					
					MC_meteoroInimigo = new MeteoroAtor(nivel);
					MC_meteoroInimigo.y = (stage.stageHeight - stage.stageHeight / 9) * Math.random();
					MC_meteoroInimigo.x = stage.stageWidth + MC_meteoroInimigo.width;
					adicionaAtor(MC_meteoroInimigo, VGHitmeteoro);
					//AR_Meteoros.push(MC_meteoroInimigo);
				}
				if (((MC_meteoroInimigo.y + MC_meteoroInimigo.height / 2) >= stage.stageHeight) || ((MC_meteoroInimigo.y - MC_meteoroInimigo.height / 2) <= 0)) {
						MC_meteoroInimigo.y = stage.stageHeight / 2;
				}
				
			}
			
			
		}
		
		public function remocao():void { };
		
		public function colisao(C1:AtorBase, C2:AtorBase):void {
			trace(C1 + " colidiu com " + C2);
			if (C1 is MeteoroAtor && C2 is HeroiAtor) {
				var danoValor:Number;
				danoValor = 10 * (nivel)/2;
				
				naveHeroi.foiAtingido(danoValor);
			}
			
		}
		
		
	}
}