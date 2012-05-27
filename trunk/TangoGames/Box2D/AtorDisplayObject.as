package TangoGames.Box2D 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class AtorDisplayObject extends Ator 
	{	
		protected var autoCirculo:Boolean = false;
		
		//Funcao construtora deve ser chamada super na contrução do filho
		public function AtorDisplayObject( pCorpoVisual:DisplayObject = null, pPosicao:Point = null, pVelocidade:Point = null, pDinamico:Boolean = false, pListaFormasVertices:Array = null, pAtrito:Number = 0.4, pDensidade:Number = 1.0, pElast:Number = 0.1) {
			if (pPosicao == null) pPosicao = new Point( Mundo.displayPai.stage.stageWidth / 2, Mundo.displayPai.stage.stageHeight / 2) ;
			
			if (pVelocidade == null) pVelocidade = new Point( 0, 0);
			
			if (pListaFormasVertices == null) pListaFormasVertices = new Array();
			
			//Cria corpo visual
			var tCorpoVisual:DisplayObject = criaCorpoVisual(pCorpoVisual, pListaFormasVertices);
			
			Mundo.displayPai.addChild(tCorpoVisual);
			
			//Cria corpo mundo fisico
			var tCorpoFisico:b2Body = criaCorpoFisico(pDinamico, pPosicao, pListaFormasVertices , tCorpoVisual,  pAtrito, pDensidade, pElast);
			
			//Adiciona velocidade
			tCorpoFisico.SetLinearVelocity(new b2Vec2(pVelocidade.x / Mundo.PP, pVelocidade.y / Mundo.PP ) );
			
			//Chama o metodo de criacao da clase superior, cria a relacao da bola fisica com a bola visual com a classe Ator
			super(tCorpoFisico, tCorpoVisual);
			
		}
		
		//Cria o display grafico do Ator, pode ser sobrescrita pelo filho para construcao especifica
		protected function criaCorpoVisual(pCorpoVisual:DisplayObject, pListaFormasVertices:Array ):DisplayObject
		{
			if (pCorpoVisual == null) return desenhaCorpoVisual(pListaFormasVertices);		
			return pCorpoVisual;
		}
		
		private function desenhaCorpoVisual(pListaFormasVertices:Array = null):Sprite
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
		
		protected function criaCorpoFisico( pDinamico:Boolean, pPosicao:Point, pArrayCoordenadas:Array = null,  pCorpoVisual:DisplayObject = null, pAtrito:Number = 0.4, pDensidade:Number = 1.0, pElast:Number = 0.1):b2Body
		{			
			if ( pArrayCoordenadas.length > 0 ) return criaCorpoFisicoCoord( pDinamico, pPosicao, pArrayCoordenadas,  pAtrito, pDensidade, pElast);
			
			//Gera definicao do corpo
			var corpoDef:b2BodyDef = new b2BodyDef;
			if (pDinamico) corpoDef.type = b2Body.b2_dynamicBody;
			corpoDef.position.Set( pPosicao.x / Mundo.PP , pPosicao.y / Mundo.PP );

			//Gera o corpo
			var corpo:b2Body = Mundo.simMundo.CreateBody(corpoDef);
			
			corpo.CreateFixture( criaFixtureDef( pAtrito, pDensidade, pElast, pCorpoVisual) );
			
			return corpo;
		}
		
		protected function criaFormaDef( pCorpoVisual:DisplayObject = null ):b2Shape
		{  
			var FormatDef:b2Shape;
			if (!autoCirculo) {
				var FormatDef1:b2PolygonShape = new b2PolygonShape();
				FormatDef1.SetAsBox( ( pCorpoVisual.width ) / 2 / Mundo.PP, ( pCorpoVisual.height ) / 2 / Mundo.PP);
				FormatDef = FormatDef1;
			}
			else {
				var FormatDef2:b2CircleShape = new b2CircleShape();
				FormatDef2.SetRadius( ( ( pCorpoVisual.height ) / 2) / Mundo.PP);
				FormatDef = FormatDef2;
			}
			
			return FormatDef;
		}
		
		protected function criaFixtureDef ( pAtrito:Number, pDensidade:Number, pElast:Number, pCorpoVisual:DisplayObject = null ):b2FixtureDef
		{
			//Gera definicao fisica do corpo
			var fisicaDef:b2FixtureDef = new b2FixtureDef;
			fisicaDef.shape = criaFormaDef( pCorpoVisual );
			fisicaDef.friction = pAtrito;
			fisicaDef.restitution = pElast;
			fisicaDef.density = pDensidade;
			return fisicaDef;
		}
		
		protected function criaCorpoFisicoCoord( pDinamico:Boolean, pPosicao:Point, pArrayCoordenadas:Array,  pAtrito:Number = 1.0, pDensidade:Number = 1.0, pElast:Number = 0.0):b2Body
		{
			//Gera um array de formatos
			var todosDefs:Vector.<b2FixtureDef> = new Vector.<b2FixtureDef>();
			
			for each ( var ListaPontos:Array in pArrayCoordenadas)
			{
				var fisicaDef:b2FixtureDef = new b2FixtureDef
				if (ListaPontos.length != 1) {
					var novoFormatDef1:b2PolygonShape = new b2PolygonShape();
					var verts:Vector.<b2Vec2> = Vector.<b2Vec2>([]);
					for each (var vertice:Point in ListaPontos) {	
						verts.push(new b2Vec2(vertice.x / Mundo.PP, vertice.y / Mundo.PP));
					}
					novoFormatDef1.SetAsVector(verts, ListaPontos.length);
					fisicaDef.shape = novoFormatDef1;
				}
				else {
					//circulo
					var novoFormatDef2:b2CircleShape = new b2CircleShape( Point(ListaPontos[0]).y / Mundo.PP );
					fisicaDef.shape = novoFormatDef2;
				}
				//Gera definicao fisica do corpo
				fisicaDef.friction = pAtrito ;
				fisicaDef.restitution = pElast ;
				fisicaDef.density = pDensidade ;
				//guarda na lista
				todosDefs.push(fisicaDef);
			}
			//Gera definicao do corpo
			var corpoDef:b2BodyDef = new b2BodyDef;
			if (pDinamico) corpoDef.type = b2Body.b2_dynamicBody;								//Define que o corpo vai sofrer a influencia da gravidade
			corpoDef.position.Set( pPosicao.x / Mundo.PP , pPosicao.y / Mundo.PP );
			
			//Gera o corpo
			var corpo:b2Body = Mundo.simMundo.CreateBody(corpoDef);
			for each ( var fd:b2FixtureDef in todosDefs )
			{
				corpo.CreateFixture(fd);
			}
			
			return corpo;
		}
		
		static public function deslocaCentroForma( pCentro:Point, pArrayCoordenadas:Array): Array
		{
			var novoArray:Array = new Array();
			var novaForma:Array;
			var novoPonto:Point;
			for each ( var listaPontos:Array in pArrayCoordenadas)
			{
				novaForma = new Array();
				for each ( var ponto:Point in listaPontos)
				{
					novaForma.push( new Point ( ponto.x - pCentro.x, ponto.y - pCentro.y));
				}
				novoArray.push(novaForma);
			}
			return novoArray;
		}
		
		static public function deslocaPonto( pCentro:Point, pPonto: Point): Point
		{
			return new Point ( pPonto.x - pCentro.x, pPonto.y - pCentro.y);
		}

	}
}
