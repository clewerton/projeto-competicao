package Fases.FaseCasteloElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseEvent;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class InimigoAtor extends AtorBase implements AtorInterface 
	{
		private var MC_Inimigo:MovieClip;
		private var NU_veloc:Number;
		private var NU_velX:Number;
		private var NU_velY:Number;
		private var BO_avanca:Boolean;
		private var BO_ataca:Boolean;
		private var CA_alvo:Castelo
		private var BO_pausa:Boolean;
		private var NU_vida:Number;
		private var BO_morreu;
		
		public function InimigoAtor(alvoCastelo:Castelo) 
		{
			MC_Inimigo = new Inimigo1;
			super(MC_Inimigo);
			CA_alvo = alvoCastelo;
			MC_Inimigo.stop();
		}
		public function inicializa():void {
			hitObject = MC_Inimigo.hitbox;
			NU_veloc = 2;
			NU_vida = 100; 
			FaseBase(parent).addEventListener(FaseEvent.FASE_PAUSA, onFasePausa, false, 0, true);
			reinicializa();
			BO_pausa = false;
		}
		
		private function onFasePausa(e:Event):void 
		{
			BO_pausa = true;
			if (BO_ataca) MC_Inimigo.stop();
		}

		public function reinicializa():void {
			BO_pausa = false;			
			BO_avanca = true;
			BO_ataca = false;
			BO_morreu = false;
			NU_velX = 0;
			NU_velY = 0;
			calcularRota();
			MC_Inimigo.gotoAndStop("normal");
		}
		
		public function update(e:Event):void {
			if (BO_avanca) {
				this.x += NU_velX;
				this.y += NU_velY;
			}
			else if (BO_ataca) {
				if (BO_pausa) MC_Inimigo.play();
				if ( MC_Inimigo.currentFrameLabel == "bateu") {
					CA_alvo.acertouHit(1);
				}
			}
			BO_pausa = false;
			if (BO_morreu) marcadoRemocao = true;
		}
		public function remove():void { };
		
		private function calcularRota():void {
			var ang:Number = Math.atan2(CA_alvo.y - this.y , CA_alvo.x - this.x);
			NU_velX =  Math.cos(ang) * NU_veloc;
			NU_velY =  Math.sin(ang) * NU_veloc;
			MC_Inimigo.rotation = ( ang * 180 ) / Math.PI;
		}
		
		public function baterCastelo():void {
			BO_avanca = false;
			BO_ataca = true;
			this.x -= NU_velX;
			this.y -= NU_velY;
			MC_Inimigo.play();
		}
		
		public function foiAtingido(tiro:TiroAtor) {
			if (tiro.marcadoRemocao) return;
			var frag:Sprite = tiro.criaFechaFragmento();
			this.addChild(frag);
			frag.rotation =  ( ( tiro.angulo * 180 ) / Math.PI) + this.rotation ; 
			frag.x = tiro.x - this.x ;
			frag.y = tiro.y - this.y;
			//frag.x = - Math.cos(tiro.angulo) * (10 + ( Math.random() * 10));
			//frag.y = - Math.sin(tiro.angulo) * (10 +(  Math.random() * 10));
			tiro.marcadoRemocao = true;
			NU_vida -= tiro.dano;
			if (NU_vida <= 0) BO_morreu = true;
		}
		
	
	}
}