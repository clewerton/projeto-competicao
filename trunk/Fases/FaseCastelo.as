package Fases 
{

	import Fases.FaseCasteloElementos.CasteloAtor;
	import Fases.FaseCasteloElementos.CasteloFaseHUD;
	import Fases.FaseCasteloElementos.InimigoAtor;
	import Fases.FaseCasteloElementos.PontuacaoHUD;
	import Fases.FaseCasteloElementos.TiroAtor;
	import Fases.FaseCasteloElementos.WavesFaseHUD;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Fases.FaseBase;
	import TangoGames.Fases.FaseEvent;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseInterface;
	
	/**
	 * Fase Castelo
	 * @author ...
	 */
	public class FaseCastelo extends FaseBase implements FaseInterface
	{
		//variaves 
		private var casteloAtor:CasteloAtor;
		
		//controle de inimigos
		//private var UI_contador:uint;
		private var UI_inimigosQTD:uint;
		private var UI_inimigosQTDMAX:uint;
		
		//variaveis de HUD
		private var FH_casteloHUD:CasteloFaseHUD
		private var FH_wavesHUD:WavesFaseHUD;
		private var FH_pontosHUD:PontuacaoHUD;
		
		//controle de waves
		private var UI_totalWaves:uint;
		private var UI_contaWaves:int;
		private var UI_tempoWave:int;
		private var UI_proxiWave:int;
		private var UI_maxIniWave:int;
		
		//pontuacao
		private var UI_pontos:uint;
		private var OB_pontuacao:Pontuacao;
		
		//musica de fundo
		private var SC_canalMusica: SoundChannel;
		private var SC_canalEfeitos: SoundChannel;
		private var SD_musica: Sound;
		private var SD_ataque: Sound;
		private var ST_musicaTr: SoundTransform;
		
		/**
		 * construtora da Class FaseCastelo
		 * @param	_main
		 * referencia ao objeto principal do jogo
		 * @param	_nivel
		 * Número do nível da fase
		 */
		public function FaseCastelo(_main:DisplayObjectContainer, _nivel:int) 
		{
			super(_main, _nivel);
		}

		/**************************************************************************
		*     métodos implementados da Interfase FaseInterfase         
		* ************************************************************************/
		
		public function inicializacao():Boolean {
			
			//selecão do nível de dificuldade
			switch (nivel) 	{
				case 1:
					this.addChildAt(new FundoFase01,0);
					UI_inimigosQTDMAX = 5;
					UI_maxIniWave = 3;
					UI_totalWaves = 5;
					UI_proxiWave = 300;
				break;
				case 2:
					this.addChildAt(new FundoFase02,0);
					UI_inimigosQTDMAX = 10;
					UI_maxIniWave = 6;
					UI_totalWaves = 8;
					UI_proxiWave = 300;
				break;
				case 3:
					this.addChildAt(new FundoFase03,0);
					UI_inimigosQTDMAX = 20;
					UI_maxIniWave = 9;
					UI_totalWaves = 12;
					UI_proxiWave = 360;
				break;
				default:
			}
			
			//inicializa ator castelo
			casteloAtor = new CasteloAtor();			
			casteloAtor.x = stage.stageWidth / 2;
			casteloAtor.y = stage.stageHeight / 2;
			adicionaAtor(casteloAtor);
			
			//adiiona evento de controle para ator removido
			this.addEventListener(FaseEvent.ATOR_REMOVIDO, manipulaAtorRemovido, false, 0, true);
			
			//inicializa HUD Castelo
			FH_casteloHUD = new CasteloFaseHUD(casteloAtor);
			adicionaHUD(FH_casteloHUD);
			
			//inicializa HUD waves
			FH_wavesHUD =  new WavesFaseHUD(this);
			adicionaHUD(FH_wavesHUD);

			//inicializa HUD Pontos
			FH_pontosHUD =  new PontuacaoHUD(this);
			adicionaHUD(FH_pontosHUD);
			
			//controle de waves de inimigos
			UI_inimigosQTD = 0;

			//Controle de pontuacao
			OB_pontuacao = new Pontuacao();	
			
			//musica da fase
			SC_canalMusica = new SoundChannel;
			SC_canalEfeitos = new SoundChannel;
			SD_musica = new MusicaFase;
			SD_ataque = new SomAtaque;

			//SOM
			SC_canalMusica = SD_musica.play(0, int.MAX_VALUE);
			ST_musicaTr = new SoundTransform(0.05);
			SC_canalMusica.soundTransform = ST_musicaTr;

			this.addEventListener(FaseEvent.FASE_CONTINUA, manipulaContinuaFase, false,0, true)
			
			return true;
			
		}
		
		public function reiniciacao():void {
			UI_pontos = 0; 
			UI_contaWaves = 0
			//UI_contador = 0;
			UI_tempoWave = 0;
			//remove inimigos
			for each ( var ator:AtorBase in Atores) if (ator is InimigoAtor) ator.marcadoRemocao = true;
			//controle de pontuação
			OB_pontuacao = new Pontuacao();	
			
			//SOM
			SC_canalMusica = SD_musica.play(0, int.MAX_VALUE);
			ST_musicaTr = new SoundTransform(0.05);
			SC_canalMusica.soundTransform = ST_musicaTr;
			
		}
		
		private function manipulaAtorRemovido(e:FaseEvent):void 
		{
			if (e.ator is InimigoAtor) {
				UI_inimigosQTD --;
				var ini:InimigoAtor = InimigoAtor(e.ator);
				if (ini.danoCritico) {
					OB_pontuacao.qtdHeartHit += 1;
					UI_pontos += 100;
					
				}
				else {
					UI_pontos += 10;
				}
			}
			else if (e.ator is TiroAtor) {
				var tiro:TiroAtor = TiroAtor(e.ator);
				if (tiro.acertou) OB_pontuacao.qtdGoodHit++;
				else OB_pontuacao.qtdMissHit++;
			}
		}
			
		public function update(e:Event):void {
			if (casteloAtor.vidaAtual <= 0) {
				SC_canalMusica.stop();
				terminoFase();
				return;
			}
			if (pressTecla(Keyboard.P)) {
				pausaFase();
				return;
			}
			if (FH_pontosHUD.pause) {
				FH_pontosHUD.pause = false;
				pausaFase();
				return;				
			}
			geraInimigos();
		}
				
		public function remocao():void {
			SC_canalMusica.stop();
			this.removeEventListener(FaseEvent.ATOR_REMOVIDO, manipulaAtorRemovido);			
		}
		
		public function colisao(C1:AtorBase, C2:AtorBase):void {
			if (C1 is InimigoAtor) {
				if (C2 is CasteloAtor )  {
					InimigoAtor(C1).baterCastelo();
					return;
				}
				else if (C2 is InimigoAtor) {
					InimigoAtor(C1).esbarrou(InimigoAtor(C2));
					return
				}
			}
			if (C1 is TiroAtor && C2 is InimigoAtor) {
				InimigoAtor(C2).foiAtingido(TiroAtor(C1));
				return;
			}
			if (C1 is TiroAtor) {
				C1.marcadoRemocao = true;
				return;
			}
			//trace(C1 + " colidiu com " + C2);
		}
		
		/***************************************************************************
		 * controle das waves
		 * ************************************************************************/
		private function geraInimigos():void 
		{
			if ( UI_inimigosQTD == 0 ) nivelMusica(false);
			else nivelMusica(true);

			if ( UI_contaWaves < UI_totalWaves) {
				UI_tempoWave++;
				if (UI_tempoWave >= UI_proxiWave) geraWaves();
			}
			else if (UI_inimigosQTD <= 0) {
				SC_canalMusica.stop();
				concluidaFase();			
			}
		}
		/**
		 * reduz e aumenta o volume da musica
		 * @param	_aumenta
		 */
		private function nivelMusica(_aumenta:Boolean) {
			if (_aumenta) {
				ST_musicaTr.volume += 0.001
				if ( ST_musicaTr.volume > 1 ) ST_musicaTr.volume = 1
			}
			else {
				ST_musicaTr.volume -= 0.01
				if ( ST_musicaTr.volume < 0.05 ) ST_musicaTr.volume = 0.05;
			}
			SC_canalMusica.soundTransform = ST_musicaTr;
		}
		
		private function geraWaves():void {
			SC_canalEfeitos = SD_ataque.play(0);
			UI_contaWaves ++;
			UI_tempoWave = 0;
			var sort:uint = Math.floor(Math.random() * 4);
			var ini:InimigoAtor;
			var i:uint = 0;
			while (i < UI_maxIniWave ) {
				i++;
				ini = new InimigoAtor(casteloAtor);
				sorteiaInimigo(ini, sort);
				if ( i % 3 == 0) sort = Math.floor(Math.random() * 4);
				adicionaAtor(ini );
				UI_inimigosQTD ++;
			}
		}
		
		private function sorteiaInimigo(ini:InimigoAtor,sort:uint):void {

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
		}
		
		private function manipulaContinuaFase(e:FaseEvent):void 
		{
			
		}

		
		public function get contaWaves():int 
		{
			return UI_contaWaves;
		}
		
		public function get totalWaves():uint 
		{
			return UI_totalWaves;
		}
		
		public function get tempoWave():int 
		{
			return UI_tempoWave;
		}
		
		public function get proxiWave():int 
		{
			return UI_proxiWave;
		}
		
		public function get pontos():uint 
		{
			return UI_pontos;
		}
		public function get percentualCastelo():Number
		{
			return casteloAtor.percentualVida();
		}
		public function get acertosTiros():uint
		{
			return OB_pontuacao.qtdGoodHit;
		}
		public function get errosTiros():uint
		{
			return OB_pontuacao.qtdMissHit;
		}
		public function get heartHits():uint {
			return OB_pontuacao.qtdHeartHit;
		}
	}
}

internal class Pontuacao {
	public var qtdHeartHit :uint = 0;
	public var qtdMissHit  :uint  = 0;
	public var qtdGoodHit  :uint  = 0;
	public function Pontuacao() {}
}
