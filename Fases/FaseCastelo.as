package Fases 
{
	import Fases.FaseCasteloElementos.Castelo;
	import Fases.FaseCasteloElementos.InimigoAtor;
	import fl.motion.AnimatorBase;
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
	public class FaseCastelo extends FaseBase implements FaseInterface
	{
		private var casteloAtor:Castelo;
		private var UI_contador:uint;
		public function FaseCastelo(_main:DisplayObjectContainer, Nivel:int) 
		{
			super(_main, Nivel);
			this.addChild(new BackGroundCastelo);
			
		}
		public function reiniciacao():void {
			UI_contador = 0;
			//remove inimigos
			for each ( var ator:AtorBase in Atores) if (ator is InimigoAtor) ator.marcadoRemocao = true;
		}
		public function inicializacao():Boolean {
			casteloAtor = new Castelo();			
			casteloAtor.x = stage.stageWidth / 2;
			casteloAtor.y = stage.stageHeight / 2;
			adicionaAtor(casteloAtor);
			return true;
		}
			
		public function update(e:Event):void {
			if (pressTecla(Keyboard.P)) {
				pausaFase();
				return;
			}
			geraInimigos();
		}
		
		private function geraInimigos():void 
		{
			UI_contador += 1;
			if ( UI_contador > 60) {
				if  ( ( ( Math.random() * 100 ) >  98  ) || ( UI_contador > 600 ) ) {
					UI_contador = 0;
					var ini:InimigoAtor = new InimigoAtor(casteloAtor)
					var sort:uint = Math.floor(Math.random() * 4);
					switch (sort) 
					{
						case 0 :
							ini.x = ( Math.random() * ( stage.stageWidth + 10) ) - 5;
							ini.y = -ini.height;
						break;
						case 1 :
							ini.x = ( Math.random() * ( stage.stageWidth + 10) ) - 5 ;
							ini.y = stage.stageHeight + ini.height;
						break;
						case 2 :
							ini.x = -ini.width;
							ini.y = ( Math.random() * ( stage.stageHeight + 10) ) - 5 ;
						break;
						case 3 :
							ini.x = stage.stageWidth + ini.width;
							ini.y = ( Math.random() * ( stage.stageHeight + 10) ) - 5 ;
						break;
						default:
					} 
					var VG:Vector.<Class> = new Vector.<Class>;
					VG.push(Castelo);
					adicionaAtor(ini, VG );
				}
			}
		}
		
		public function remocao():void {};
		
		public function colisao(C1:AtorBase, C2:AtorBase) {
			if (C1 is InimigoAtor && C2 is Castelo )  {
				 InimigoAtor(C1).baterCastelo();
			}
		}
	}

}