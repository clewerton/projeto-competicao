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
		
		public function FaseEspaco(_main:DisplayObjectContainer, Nivel:int) 
		{
			super(_main, Nivel);
			this.addChild(new BackGroundSpaco);
			
		}
		public function reiniciacao():void {
			
			naveHeroi.x = naveHeroi.width;
			naveHeroi.y = stage.stageHeight / 2;
		
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
			
		}
		
		public function remocao():void {};
		
	}

}