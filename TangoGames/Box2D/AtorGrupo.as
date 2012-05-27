package TangoGames.Box2D 
{
	import Box2D.Collision.b2Bound;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class AtorGrupo
	{
		protected var _AtoresPartes:Vector.<AtorParte>;
		protected var _Juncoes:Vector.<b2Joint>;
		protected var _AtoresID: Array;		
		protected var _PontoRef: Point;
		
		//Marca para remover
		private var _marcadoRemover:Boolean;
		
		//controle de animação
		private var _animacao:Boolean;
		private var _animacaoPrincipal: MovieClip;
		
		public function AtorGrupo( Ponto: Point , Animacao:Boolean = false , AnimacaoPrincipal:MovieClip = null ) 
		{
			_PontoRef = Ponto;
			_AtoresPartes =  new Vector.<AtorParte>;
			_AtoresID = new Array();
			_Juncoes = new Vector.<b2Joint>;
			_animacao = Animacao;
			_animacaoPrincipal = AnimacaoPrincipal;
			if (_animacao) {
				Mundo.displayPai.addChild(_animacaoPrincipal);
				//_animacaoPrincipal.alpha = 0.1;
				_animacaoPrincipal.x = _PontoRef.x;
				_animacaoPrincipal.y = _PontoRef.y;
			}
		}
		
		public function animacaoTObox2D():void {
			if (_animacao) {
				animacao = false
				Mundo.displayPai.removeChild(_animacaoPrincipal);
				for each ( var ator:AtorParte in _AtoresPartes ) {
					ator.animacaoTObox2D();
				}
				geraJuncoes();
			}
		}

		public function box2DTOanimacao():void {
			if (!_animacao) {
				animacao = true
				removeJuncoes();
				Mundo.displayPai.addChild(_animacaoPrincipal);
				for each ( var ator:AtorParte in _AtoresPartes ) {
					ator.box2DTOanimacao();
				}
			}
		}
		
		protected  function geraJuncoes():void {
			//deve ser preenchido pela classe derivada
		}
		
		protected  function removeJuncoes():void {
			for each (var j:b2Joint in _Juncoes) {
				Mundo.simMundo.DestroyJoint(j);
			}
		}

		
		public function adicionaAtor( CorpoFisico:b2Body, CorpoVisual:DisplayObject, PontoDesloc: Point , ID:String , Animacao:MovieClip ):void {
			var ator:AtorParte = new AtorParte( CorpoFisico , CorpoVisual , this , PontoDesloc, ID , _animacao, Animacao );
			_AtoresPartes.push(ator);
			_AtoresID[ ID ]= _AtoresPartes.length - 1;
     	}
		
		public function AtorParteID(ID:String):AtorParte {
			return _AtoresPartes[ _AtoresID[ ID ] ];
		}
		
		public function get ListaAtores():Vector.<AtorParte> 
		{
			return _AtoresPartes;
		}
		
		public function get marcadoRemover():Boolean 
		{
			return _marcadoRemover;
		}
		
		public function set marcadoRemover(value:Boolean):void 
		{
			_marcadoRemover = value;
		}
		
		public function get animacao():Boolean 
		{
			return _animacao;
		}
		
		public function set animacao(value:Boolean):void 
		{
			_animacao = value;
		}
		
		public function get animacaoPrincipal():MovieClip 
		{
			return _animacaoPrincipal;
		}
		
		public function set animacaoPrincipal(value:MovieClip):void 
		{
			_animacaoPrincipal = value;
		}
		
		//*********************************************************************************************
		//***************          GERA JUNÇÕES                                       *****************
 		//*********************************************************************************************
		protected function geraJuncaoPartes( ParteA_ID:String, ParteB_ID:String, jd:b2RevoluteJointDef = null ):void {
			var AtorA:AtorParte =  AtorParteID( ParteA_ID );
			var BA:b2Body = AtorA.corpoFisico;
			var AtorB:AtorParte =  AtorParteID( ParteB_ID );
			var BB:b2Body = AtorB.corpoFisico;
			if (jd == null ) jd = geraJuncaoRevolutionPadrao( BA , BB );
			jd.bodyA = BA;
			jd.bodyB = BB;
			var rj:b2Joint = Mundo.simMundo.CreateJoint(jd);
			_Juncoes.push(rj);
		}
		
		protected function geraJuncaoRevolutionPadrao( A:b2Body , B:b2Body  ):b2RevoluteJointDef {
			var jd:b2RevoluteJointDef= new b2RevoluteJointDef();
			jd.enableLimit = false;
			jd.referenceAngle = 0;
			jd.localAnchorA.Set( 0 , 0 );
			jd.localAnchorB.Set( 0 , 0 );
			return jd;
		}
		
		//*********************************************************************************************
		//***************          GERA PARTES PADRÃO                                *****************
 		//*********************************************************************************************
		
		
		protected function geraPartesRetangular( ID:String, PontoRelativo:Point, Largura: Number , Altura:Number , densidade: Number, atrito: Number, elasticidade: Number, grupofiltro:int = 0 , corpovisual: DisplayObject =  null, AnimacaoMC: MovieClip = null):void {
			var fd:b2FixtureDef = new b2FixtureDef();
			var box:b2PolygonShape = new b2PolygonShape();
			box.SetAsBox( (Largura / 2) / Mundo.PP , ( Altura /2 ) / Mundo.PP );
			fd.shape = box;
			fd.density = densidade;
			fd.friction = atrito;
			fd.restitution = elasticidade;
			if (grupofiltro != 0) fd.filter.groupIndex = grupofiltro;  // valores negativos iguais ignoram contato
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.position.Set( (_PontoRef.x + PontoRelativo.x) / Mundo.PP , (_PontoRef.y + PontoRelativo.y) / Mundo.PP) ;
			var bo:b2Body = Mundo.simMundo.CreateBody( bd );
			bo.CreateFixture(fd);
			if ( corpovisual == null ) corpovisual = geraSpriteRetangulo(Largura, Altura);		
			adicionaAtor( bo , corpovisual , PontoRelativo , ID , AnimacaoMC); 
		}

		protected function geraPartesCircular( ID:String, PontoRelativo:Point, Raio:Number , densidade: Number, atrito: Number, elasticidade: Number, grupofiltro:int = 0 , corpovisual: DisplayObject =  null, AnimacaoMC: MovieClip = null):void {
			var fd:b2FixtureDef = new b2FixtureDef();
			var box:b2CircleShape = new b2CircleShape();
			box.SetRadius( Raio / Mundo.PP);
			fd.shape = box;
			fd.density = densidade;
			fd.friction = atrito;
			fd.restitution = elasticidade;
			if (grupofiltro != 0) fd.filter.groupIndex = grupofiltro;  // valores negativos iguais ignoram contato
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.position.Set( (_PontoRef.x + PontoRelativo.x) / Mundo.PP , (_PontoRef.y + PontoRelativo.y) / Mundo.PP) ;
			var bo:b2Body = Mundo.simMundo.CreateBody( bd );
			bo.CreateFixture(fd);
			if ( corpovisual == null ) corpovisual =  geraSpriteCirculo(Raio);
			adicionaAtor( bo , corpovisual , PontoRelativo , ID , AnimacaoMC); 
		}

		protected function geraPartesPoligonal( ID:String, PontoRelativo:Point, ListaFormas:Array , densidade: Number, atrito: Number, elasticidade: Number, grupofiltro:int = 0 , corpovisual: DisplayObject =  null, AnimacaoMC: MovieClip = null):void {
			var fd:b2FixtureDef = new b2FixtureDef();
			fd.density = densidade;
			fd.friction = atrito;
			fd.restitution = elasticidade;
			if (grupofiltro != 0) fd.filter.groupIndex = grupofiltro;  // valores negativos iguais ignoram contato
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			bd.position.Set( (_PontoRef.x + PontoRelativo.x) / Mundo.PP , (_PontoRef.y + PontoRelativo.y) / Mundo.PP) ;
			var bo:b2Body = Mundo.simMundo.CreateBody( bd );
			criaCorpoFisicoCoord( bo , fd , ListaFormas);
			if ( corpovisual == null ) corpovisual =  geraSpritePoligonal(ListaFormas);
			adicionaAtor( bo , corpovisual , PontoRelativo , ID , AnimacaoMC );
		}

		protected function criaCorpoFisicoCoord( bo:b2Body , fd:b2FixtureDef, ListaFormas:Array ):void  {
			for each ( var ListaPontos:Array in ListaFormas)
			{
				var fisicaDef:b2FixtureDef = new b2FixtureDef
				if (ListaPontos.length != 1) {
					var novoFormatDef1:b2PolygonShape = new b2PolygonShape();
					var verts:Vector.<b2Vec2> = new Vector.<b2Vec2>;
					for each (var vertice:Point in ListaPontos) {	
						verts.push(new b2Vec2(vertice.x / Mundo.PP, vertice.y / Mundo.PP));
					}
					novoFormatDef1.SetAsVector(verts, ListaPontos.length);
					fd.shape = novoFormatDef1;
					bo.CreateFixture(fd);
				}
				else {
					//circulo
					var novoFormatDef2:b2CircleShape = new b2CircleShape( Point(ListaPontos[0]).y / Mundo.PP );
					fd.shape = novoFormatDef2;
					bo.CreateFixture(fd);
				}
			}
		}
		
		//*********************************************************************************************
		//***************                           GERA SPRITES                      *****************
 		//*********************************************************************************************
		private function geraSpriteRetangulo(largura:Number, altura:Number):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1, 0X0000FF, 1);
			sp.graphics.beginFill(0X0000FF, 1);
			sp.graphics.drawRect(-largura / 2, -altura / 2, largura, altura);
			sp.graphics.endFill();
			return sp;
		}
		
		private function geraSpriteCirculo(raio:Number):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(0, 0XFFFFFF, 0);
			sp.graphics.beginFill(0X0000FF, 1);
			sp.graphics.drawCircle(0 , 0 , raio);
			sp.graphics.endFill();
			return sp;
		}
		
		private function geraSpritePoligonal(pListaFormasVertices:Array = null):Sprite
		{
			var visual:Sprite = new Sprite;
			var pontoini: Point;
			visual.graphics.lineStyle(1, 0x1FDF2F);
			for each ( var listaPontos:Array in pListaFormasVertices)
			{
				if (listaPontos.length!=1) {
					pontoini = listaPontos[0];
					visual.graphics.moveTo(pontoini.x , pontoini.y);
					visual.graphics.beginFill(0x1AD723);
					for each ( var novoPonto:Point in listaPontos)
					{
						visual.graphics.lineTo ( novoPonto.x , novoPonto.y);
					}
					visual.graphics.lineTo(pontoini.x , pontoini.y);
					visual.graphics.endFill();
				}
				else {
					pontoini = listaPontos[0];
					visual.graphics.beginFill(0x1AD723);
					visual.graphics.drawCircle( 0, 0, pontoini.y);
					visual.graphics.endFill();					
				}
			}
			return visual;
		}
		
		//destroi objeto retira do flash e do box2d
		public function destroi():void {
			for each (var j:b2Joint in _Juncoes) {
				Mundo.simMundo.DestroyJoint(j);
			}
			for each ( var a:AtorParte in _AtoresPartes) {
				a.destroi();
			}
			if (_animacao) Mundo.displayPai.removeChild(_animacaoPrincipal);
		}
	}
}