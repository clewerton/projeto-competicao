package Fases 
{
	import Fases.FaseEspacoElementos.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FaseEspaco extends FaseBase implements FaseInterface
	{
		private var naveHeroi:Heroi;
		private var numStars:int = 80;
		private var MC_estrelas:MovieClip;
		private var AR_estrelas:Array = new Array;
		public var AR_Meteoros:Array;
		private var contInimigos:int = 120;
		private var MC_meteoroInimigo:MeteoroAtor;
		
		public function FaseEspaco(_main:DisplayObjectContainer, Nivel:int) 
		{
			super(_main, Nivel);
			this.addChild(new BackGroundSpaco);
			
		}
		public function reiniciacao():void {
			
			naveHeroi.x = naveHeroi.width;
			naveHeroi.y = stage.stageHeight / 2;
			
			if (AR_Meteoros != null) {
				
				for (var i:int; i < AR_Meteoros.length; i++) {
					AR_Meteoros[i].marcadoRemocao = true;
				}
				
			}
			
			AR_Meteoros= new Array;
			contInimigos = 120;
			//for each ( var ator:AtorBase in Atores) if (ator is InimigoAtor) ator.marcadoRemocao = true;
		}
		public function inicializacao():Boolean {
						
			naveHeroi = new Heroi();
			naveHeroi.x = naveHeroi.width;
			naveHeroi.y = stage.stageHeight / 2;
			
			adicionaAtor(naveHeroi);
			
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
					adicionaAtor(MC_meteoroInimigo);
					AR_Meteoros.push(MC_meteoroInimigo);
				}
				else if ( nivel == 2) {
					contInimigos = 72;
					
					MC_meteoroInimigo = new MeteoroAtor(nivel);
					MC_meteoroInimigo.y = (stage.stageHeight - stage.stageHeight / 9) * Math.random();
					MC_meteoroInimigo.x = stage.stageWidth + MC_meteoroInimigo.width;
					adicionaAtor(MC_meteoroInimigo);
					AR_Meteoros.push(MC_meteoroInimigo);
				}
				else if ( nivel == 3) {
					contInimigos = 72;
					
					MC_meteoroInimigo = new MeteoroAtor(nivel);
					MC_meteoroInimigo.y = (stage.stageHeight - stage.stageHeight / 9) * Math.random();
					MC_meteoroInimigo.x = stage.stageWidth + MC_meteoroInimigo.width;
					adicionaAtor(MC_meteoroInimigo);
					AR_Meteoros.push(MC_meteoroInimigo);
				}
				
				
			}
			
			
		}
		
		public function remocao():void { };
		
		public function colisao(C1:AtorBase, C2:AtorBase) {
			trace(C1 + " colidiu com " + C2);
		}
		
		
	}
}