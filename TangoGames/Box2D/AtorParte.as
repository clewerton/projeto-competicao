package TangoGames.Box2D 
{
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Fixture;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import TangoGames.Utils.Mundo;
	import Box2D.Dynamics.b2Body;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	public class AtorParte extends Ator {
		
		private var _ID:String;
		private var _AtorGrupoPai: AtorGrupo;
		private var _PontoDesloc: Point; 
		private var _Animacao:Boolean;
		private var _AnimacaoMC:MovieClip;
		private var _AnimacaoMCLastX:Number;
		private var _AnimacaoMCLastY:Number;
		private var _AnimacaoMCLastRotation:Number;
		
		public function AtorParte( pCorpoFisico:b2Body , pCorpoVisual:DisplayObject , Pai: AtorGrupo , PontoDesloc:Point , ID:String = "", Animacao:Boolean = false, AnimacaoMovieClip:MovieClip = null ) {
			if (ID == "") ID = String(pCorpoFisico);
			_ID = ID;
			_AtorGrupoPai =  Pai;
			_PontoDesloc = PontoDesloc;
			_Animacao = Animacao;
			_AnimacaoMC = AnimacaoMovieClip;
			
			if (!_Animacao) Mundo.displayPai.addChild(pCorpoVisual);
			
			super(pCorpoFisico, pCorpoVisual);
			transformaSensor(Animacao);
			if ( Animacao && _AnimacaoMC != null ) {
				_AnimacaoMCLastX = _AtorGrupoPai.animacaoPrincipal.x + _AnimacaoMC.x - Mundo.DESLOC.x;
				_AnimacaoMCLastY = _AtorGrupoPai.animacaoPrincipal.y + _AnimacaoMC.y - Mundo.DESLOC.y;
				_AnimacaoMCLastRotation = _AnimacaoMC.rotation;
			}
		}
		
		public function transformaSensor(sensor:Boolean):void {
			for each (var fx:b2Fixture in corpoFisico.GetFixtureList()) {
				fx.SetSensor(sensor);
			}
			if (sensor) corpoFisico.SetType(b2Body.b2_staticBody);
			else corpoFisico.SetType(b2Body.b2_dynamicBody);
		}
		
		public function animacaoTObox2D():void {
			if (_Animacao) {
				_Animacao = false;
				transformaSensor(false);
				Mundo.displayPai.addChild(corpoVisual);
				super.atualiza();
			}
		}

		public function box2DTOanimacao():void {
			if (!_Animacao) {
				_Animacao = true;
				transformaSensor(true);
				Mundo.displayPai.removeChild(corpoVisual);
				if ( _AnimacaoMC != null ) sincronizaAnimacao() ;
			}
		}

		
		override public function atualiza():void 
		{
			if (_Animacao) atualizaAnimacao();
			else super.atualiza();
		}
		
		private function atualizaAnimacao():void {
			
			//Sincroniza posicao do Movieclip animacao com sensores Box2d
			if ( _AnimacaoMC != null ) {
				var x:Number = _AtorGrupoPai.animacaoPrincipal.x + _AnimacaoMC.x - Mundo.DESLOC.x;
				var y:Number = _AtorGrupoPai.animacaoPrincipal.y + _AnimacaoMC.y - Mundo.DESLOC.y;
				if ( _AnimacaoMCLastX != x || _AnimacaoMCLastY != y || _AnimacaoMCLastRotation != _AnimacaoMC.rotation ) sincronizaAnimacao();
			}
		}

		private function sincronizaAnimacao():void {
			//Sincroniza posicao do Movieclip animacao com sensores Box2d
			var x:Number = _AtorGrupoPai.animacaoPrincipal.x + _AnimacaoMC.x - Mundo.DESLOC.x;
			var y:Number = _AtorGrupoPai.animacaoPrincipal.y + _AnimacaoMC.y - Mundo.DESLOC.y;
			var pos:b2Vec2 = new b2Vec2( x  / Mundo.PP ,   y / Mundo.PP );
			var ang:Number = ( _AnimacaoMC.rotation  * Math.PI ) / 180;
			corpoFisico.SetPositionAndAngle( pos , ang );
			_AnimacaoMCLastX = x;
			_AnimacaoMCLastY = y; 
			_AnimacaoMCLastRotation = _AnimacaoMC.rotation;
		}
		
		
		public function get ID():String 
		{
			return _ID;
		}
		
		public function get AtorGrupoPai():AtorGrupo 
		{
			return _AtorGrupoPai;
		}
		
		public function get PontoDesloc():Point 
		{
			return _PontoDesloc;
		}
		
		public function get AnimacaoMC():MovieClip 
		{
			return _AnimacaoMC;
		}
		
		public function set AnimacaoMC(value:MovieClip):void 
		{
			_AnimacaoMC = value;
		}
		
		public function get Animacao():Boolean 
		{
			return _Animacao;
		}
		
		public function set Animacao(value:Boolean):void 
		{
			_Animacao = value;
		}
		
		
	}
}