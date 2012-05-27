package TangoGames.Box2D
{
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class Ator extends EventDispatcher
	{	
		//Represantacao do corpo fisico na simulacao fisica do mundo
		private var _corpoFisico: b2Body;
		
		//Representacao visual do corpo na tela do Flash
		private var _corpoVisual: DisplayObject;
		private var _PPIni:Number;
		private var _escalaAtual:Number;
		
		
		//Marca para remover
		private var _marcadoRemover:Boolean;
		
		//Peso do corpo	
		//private var _peso:Number ;
		
		//Contole se saiu da Stage
		private var _tododentro:Boolean = false;
		private var _tocandostage:Boolean = false;
		private var _todofora:Boolean = false;
		
		//funcão de cosntrução
		public function Ator(pCorpoFisico:b2Body, pCorpoVisual:DisplayObject) {
			_escalaAtual = 1;
			_corpoFisico = pCorpoFisico;
			_corpoFisico.SetUserData(this);
			_corpoVisual = pCorpoVisual;
			atualizaVisual();
			Mundo.listaAtores.push(this);		
			//calculaPeso();
			if (Mundo.noDisplay) _corpoVisual.visible = false;
		}		
		//Atualiza a situação do corpo fisico no corpo visual
		//esta função é chamada no enter frame após da chamada do "step" do "world" do box2d
		//esta sendo chamada implicitamente quando usar a classe "mundo" e o método "passoMundo" no evento ENTER.FRAME de sua Engine
		public function atualiza():void	{
			if ( _corpoFisico.IsAwake() || Mundo.redesenha) atualizaVisual();
			
			geraEventoStage();
			
			atualizaEspecifico();
			
		}	
		
		//função que atualiza a informação da situação dos corpo na simulação dos box2d no displayobject do flash
		protected function atualizaVisual():void {
			//Atualiza a situacao da simulacao na representacaodo visual
			_corpoVisual.x = ( _corpoFisico.GetPosition().x * Mundo.PP ) - Mundo.DESLOC.x;
			_corpoVisual.y = ( _corpoFisico.GetPosition().y * Mundo.PP ) - Mundo.DESLOC.y;
			_corpoVisual.rotation = _corpoFisico.GetAngle() * 180 / Math.PI;
			//Se a proporcao mudou troca a proporcao da imagem
			if (_escalaAtual != Mundo.escala) {
				_corpoVisual.scaleX = Mundo.escala;
				_corpoVisual.scaleY = Mundo.escala;
				_escalaAtual = Mundo.escala;
			}
		}
		//esta função pode ser sobrescrita pela classe filha 
		protected function atualizaEspecifico():void {
			//utilizado pela classe derivada		
		}
		
		//*************************************************************************************************
		//********************           Propriedades visiveis da classe           ************************
		//*************************************************************************************************
		
		public function get corpoFisico():b2Body {
			return _corpoFisico;
		}
		
		public function get corpoVisual():DisplayObject {
			return _corpoVisual;
		}
		
		public function get marcadoRemover():Boolean {
			return _marcadoRemover;
		}
		
		public function set marcadoRemover(value:Boolean):void {
			_marcadoRemover = value;
		}
		
		public function get escalaAtual():Number {
			return _escalaAtual;
		}
		
		public function alteraDensidade(value:Number):void {
			_corpoFisico.GetFixtureList().SetDensity(value);
			_corpoFisico.ResetMassData();
		}
		
		//***********************************************************************************************
		//**********              gera evento para os limites do stage                 ******************
		//***********************************************************************************************
		private function geraEventoStage():void {
			if ( !_todofora && !_tocandostage && !_tododentro ) {
				testesaiuStage();
				if (_todofora) return;
				testeentrouTodoStage();
				if (_tododentro) return;
				testetocouStage();
				return;
			}
			
			if ( _todofora ) {
				testeentrouStage()
				return;
			}
			
			if ( _tododentro ) {
				testetocouStage();
				return;
			}
			
			if ( _tocandostage || _tododentro) testesaiuStage();
			
			if ( _tocandostage || _todofora ) testeentrouTodoStage();
			
		}
		
		private function testetocouStage() {
			if ( corpoVisual.y + corpoVisual.height / 2 > corpoVisual.stage.stageHeight ) {
				_tododentro = false;
				_tocandostage = true;
				_todofora = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
			if ( corpoVisual.y - corpoVisual.height / 2 < 0 ) {
				_tododentro = false;
				_tocandostage = true;
				_todofora = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
			if ( corpoVisual.x + corpoVisual.width / 2 > corpoVisual.stage.stageWidth  ) {
				_tododentro = false;
				_tocandostage = true;
				_todofora = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return
			}
			if ( corpoVisual.x - corpoVisual.width / 2 < 0  ) {
				_tododentro = false;
				_tocandostage = true;
				_todofora = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_TOCOU_STAGE));
				return;
			}
		}
		
		private function testesaiuStage() {
			if ( corpoVisual.y - corpoVisual.height / 2 > corpoVisual.stage.stageHeight ) {
				_todofora = true;
				_tocandostage = false;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( corpoVisual.y + corpoVisual.height / 2 < 0 ) {
				_todofora = true;
				_tocandostage = false;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( corpoVisual.x - corpoVisual.width / 2 > corpoVisual.stage.stageWidth  ) {
				_todofora = true;
				_tocandostage = false;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
			if ( corpoVisual.x + corpoVisual.width / 2 < 0  ) {
				_todofora = true;
				_tocandostage = false;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_SAIU_STAGE));
				return;
			}
		}
		
		private function testeentrouStage() {
			if ( ( corpoVisual.y - corpoVisual.height / 2 < corpoVisual.stage.stageHeight ) && ( corpoVisual.y - corpoVisual.height / 2 > 0 ) && ( corpoVisual.x - corpoVisual.width / 2 < corpoVisual.stage.stageWidth  ) && ( corpoVisual.x + corpoVisual.width / 2 > 0  ) )  {
				_todofora = false;
				_tocandostage = true;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( corpoVisual.y + corpoVisual.height / 2 > 0 ) && ( corpoVisual.y + corpoVisual.height / 2 < corpoVisual.stage.stageHeight ) && ( corpoVisual.x - corpoVisual.width / 2 < corpoVisual.stage.stageWidth  ) && ( corpoVisual.x + corpoVisual.width / 2 > 0  ) ) {
				_todofora = false;
				_tocandostage = true;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( corpoVisual.x - corpoVisual.width / 2 < corpoVisual.stage.stageWidth  ) && ( corpoVisual.x - corpoVisual.width / 2 > 0  ) && ( corpoVisual.y - corpoVisual.height / 2 < corpoVisual.stage.stageHeight ) && ( corpoVisual.y + corpoVisual.height / 2 > 0 ) ) {
				_todofora = false;
				_tocandostage = true;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}
			if ( ( corpoVisual.x + corpoVisual.width / 2 > 0  ) && ( corpoVisual.x + corpoVisual.width / 2 < corpoVisual.stage.stageWidth  ) && ( corpoVisual.y - corpoVisual.height / 2 < corpoVisual.stage.stageHeight ) && ( corpoVisual.y + corpoVisual.height / 2 > 0 ) ) {
				_todofora = false;
				_tocandostage = true;
				_tododentro = false;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_STAGE) );
				return;
			}			
		}
		
		private function testeentrouTodoStage() {
			if ( ( corpoVisual.y + corpoVisual.height / 2 < corpoVisual.stage.stageHeight ) && ( corpoVisual.y - corpoVisual.height / 2 > 0 ) && ( corpoVisual.x + corpoVisual.width / 2 < corpoVisual.stage.stageWidth  ) && ( corpoVisual.x - corpoVisual.width / 2 > 0  ) ) {
				_todofora = false;
				_tocandostage = false;
				_tododentro = true;
				dispatchEvent(new AtorEvent( AtorEvent.ATOR_VOLTOU_TODO_STAGE) );
			}
			
		}
		//destroi objeto retira do flash e do box2d
		public function destroi():void {
			//faz algo especifico
			destroiEspecifico();
			//retira o objeto da colecao do pai
			if (_corpoVisual.parent !=null)	_corpoVisual.parent.removeChild(_corpoVisual);
			//destroi o corpo do mundo simulacao fisica
			Mundo.simMundo.DestroyBody(_corpoFisico);
			//Tira da lista de Atores
			var index:int = Mundo.listaAtores.indexOf(this);
			if (index >= 0) Mundo.listaAtores.splice(index, 1);			
		}
		//metodo para ser sobrescrito pela classe derivada caso necessario
		protected function destroiEspecifico():void {
			//utilizado pela classe derivada
		}

		
	}

}