package Fases.FaseCasteloElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorEvent;
	import TangoGames.Atores.AtorInterface;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseEvent;
	import TangoGames.Utils;
	
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
		private var CA_alvo:CasteloAtor;
		private var BO_pausa:Boolean;
		private var NU_vida:Number;
		private var BO_morreu:Boolean;
		private var UI_valorHit: uint;
		private var NU_impacX:Number;
		private var NU_impacY:Number;
		
		//dano critico
		private var MC_efeitoDanoCritico:MovieClip;
		private var BO_danoCritico:Boolean;

		//efeitos sonoros
		private var SC_canal:SoundChannel;
		private var SD_HitCritico: Sound;
		private var VT_somHIT:Vector.<Sound>;
		
		public function InimigoAtor(alvoCastelo:CasteloAtor) 
		{
			MC_Inimigo = new InimigoMaca;
			super(MC_Inimigo);
			CA_alvo = alvoCastelo;
			MC_Inimigo.stop();
			//hitObject = MC_Inimigo.hitbox;
		}
		public function inicializa():void {
			//gerarEventoStage = true;
			//this.addEventListener(AtorEvent.ATOR_SAIU_STAGE, onEntraSaia, false, 0, true);
			//this.addEventListener(AtorEvent.ATOR_TOCOU_STAGE, onEntraSaia, false, 0, true);
			//this.addEventListener(AtorEvent.ATOR_VOLTOU_STAGE, onEntraSaia, false, 0, true);
			//this.addEventListener(AtorEvent.ATOR_VOLTOU_TODO_STAGE, onEntraSaia, false, 0, true);
			
			//velocidade do inimigo
			NU_veloc = 2;
			//valor da vida
			NU_vida = 100; 
			//valor do dano no castelo
			UI_valorHit = 20;
			
			faseAtor.addEventListener(FaseEvent.FASE_PAUSA, onFasePausa, false, 0, true);
			
			//vetor de hitteste dos inimigos
			adcionaClassehitGrupo(CasteloAtor);
			adcionaClassehitGrupo(InimigoAtor);
			
			//efeito som
			SC_canal = new SoundChannel;
			SD_HitCritico = new SomMorte;
			VT_somHIT = new Vector.<Sound>;
			VT_somHIT.push(new SomHit1);
			VT_somHIT.push(new SomHit2);
			VT_somHIT.push(new SomHit3);
			VT_somHIT.push(new SomHit4);
			VT_somHIT.push(new SomHit5);
			VT_somHIT.push(new SomHit6);
			VT_somHIT.push(new SomHit7);
			VT_somHIT.push(new SomHit8);
			
			
			reinicializa();
		}
		
		//private function onEntraSaia(e:AtorEvent):void {
			//trace (e.currentTarget + e.type);
		//}
		private function onFasePausa(e:Event):void 
		{
			BO_pausa = true;
			if (BO_ataca) MC_Inimigo.stop();
		}

		public function reinicializa():void {
			BO_danoCritico = false;
			BO_pausa = false;			
			BO_ataca = false;
			BO_morreu = false;
			NU_velX = 0;
			NU_velY = 0;
			NU_impacX = 0;
			NU_impacY = 0;
			calcularRota();
			
			//movimento de andar
			BO_avanca = true;
			iniciaAnima(MC_Inimigo, "andar");
		}
		
		public function update(e:Event):void {

			controleAnima();
			
			if (BO_danoCritico) {
				if (MC_efeitoDanoCritico.currentFrameLabel == "fim") {
					BO_morreu = true;
					marcadoRemocao = true;
				}
				return
			}
			this.x += NU_impacX;
			this.y += NU_impacY;
			if ( Math.abs(NU_impacX) > 0 || Math.abs(NU_impacY) > 0 ) {
				calcularRota();
				NU_impacX = 0;
				NU_impacY = 0;
				BO_avanca = true;
				BO_ataca = false;
				if (animacao != "andar") iniciaAnima( MC_Inimigo , "andar" );
			}
			if (BO_avanca) {
				this.x += NU_velX;
				this.y += NU_velY;
			}
			else if (BO_ataca) {
				if (BO_pausa) MC_Inimigo.play();
				if ( MC_Inimigo.currentFrameLabel == "bateu") {
					CA_alvo.acertouHit(UI_valorHit);
				}
			}
			BO_pausa = false;
			if (BO_morreu) marcadoRemocao = true;
		}
		public function remove():void { 
			
			//adiciona cena da morte
			
			if (BO_morreu) {
				var morto: InimigoMortoAtor = new InimigoMortoAtor(1);
				morto.x = this.x;
				morto.y = this.y;
				morto.rotation = MC_Inimigo.rotation;
				faseAtor.adicionaAtor(morto);
			}
			
			faseAtor.removeEventListener(FaseEvent.FASE_PAUSA, onFasePausa);
		}
		
		private function calcularRota():void {
			var ang:Number = Math.atan2(CA_alvo.y - this.y , CA_alvo.x - this.x);
			NU_velX =  Math.cos(ang) * NU_veloc;
			NU_velY =  Math.sin(ang) * NU_veloc;
			MC_Inimigo.rotation = ( ang * 180 ) / Math.PI;
		}
		
		public function baterCastelo():void {
			BO_avanca = false;
			BO_ataca = true;
			this.x -= NU_velX ;
			this.y -= NU_velY ;
			calcularRota();
			iniciaAnima(MC_Inimigo, "bater");
		}
		
		public function esbarrou(outro:InimigoAtor):void {
			var ang:Number = Math.atan2(outro.y - this.y , outro.x - this.x);
			NU_impacX +=  - Math.cos(ang) * NU_veloc;
			NU_impacY +=  - Math.sin(ang) * NU_veloc;
		}
		
		public function foiAtingido(tiro:TiroAtor) {
			//se tiro esta removido não faz nada
			if (tiro.marcadoRemocao) return;
			
			//marca pra remover tiro
			tiro.marcadoRemocao = true;
			tiro.acertou = true;
			
			if (BO_danoCritico) return;


			//verifica dano crítico
			var rt:Rectangle = tiro.ponta.getBounds(faseAtor);
			var dx:Number =  this.x - ( rt.left + ( rt.width  / 2 ) );
			var dy:Number =  this.y - ( rt.top  + ( rt.height / 2 ) );
			var dist:Number = Math.sqrt( ( dy * dy ) +  ( dy * dy) );
			//dano critico
			if ( dist < 2 ) {
				BO_danoCritico = true;
				MC_efeitoDanoCritico = new DanoCritico;
				addChild(MC_efeitoDanoCritico);
				NU_vida = 0;
				MC_Inimigo.stop();
				SC_canal = SD_HitCritico.play(0);
				return ;
			}
			
			//define impacto
			NU_impacX +=  Math.cos(tiro.angulo) * NU_veloc * 2;
			NU_impacY +=  Math.sin(tiro.angulo) * NU_veloc * 2;
			
			//trata fragmento do tiro
			var frag:Sprite = tiro.criaFechaFragmento();
			this.addChild(frag);
			frag.rotation =  ( ( tiro.angulo * 180 ) / Math.PI) + this.rotation ; 
			frag.rotation += Utils.Rnd( -10, 10);
			frag.x = tiro.x - this.x ;
			frag.y = tiro.y - this.y ;
			
			//atualiza o dano
			NU_vida -= tiro.dano;
			if (NU_vida <= 0) BO_morreu = true;
			var i:uint  = Utils.Rnd(0,7)
			SC_canal = VT_somHIT[ i ].play(0);
		}
		
		public function get valorHit():uint 
		{
			return UI_valorHit;
		}
		
		public function get danoCritico():Boolean 
		{
			return BO_danoCritico;
		}
		
	
	}
}