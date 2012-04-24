package TangoGames.Utils 
{
	import Box2D.Collision.Shapes.b2EdgeChainDef;
	import Box2D.Collision.Shapes.b2EdgeShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class Superfices extends Ator {
		
		public function Superfices( pPosicao:Point ,  pListaVertices:Array )  {
			
			var visual:Sprite = desenhaCorpoVisual(pListaVertices);
			
			var corpo:b2Body = criaLimiteFisico( pPosicao, pListaVertices);
			
			Mundo.displayPai.addChild(visual);
			
			super( corpo , visual );
			
		}
		
		override public function atualiza():void	{
			if ( Mundo.redesenha ) atualizaVisual();
			
			atualizaEspecifico();
			
		}	
		
		protected function desenhaCorpoVisual(pListaVertices:Array = null, altura:Number = 10):Sprite {
			var visual:Sprite = new Sprite;
			var pontoini: Point;
			var pontofim: Point;
			var maxY:Number = 0;
			visual.graphics.lineStyle(1, 0x1FDF2F);
			pontoini = pListaVertices[0];
			visual.graphics.moveTo(pontoini.x , pontoini.y);
			maxY = pontoini.y;
			visual.graphics.beginFill(0x1AD723);
			var ponto:Point;
			for ( var i:uint = 1; i < pListaVertices.length; i++) {
				ponto = pListaVertices[i];
				visual.graphics.lineTo ( ponto.x , ponto.y);
				pontofim = ponto;
				if (ponto.y > maxY) maxY = ponto.y;
			}
			visual.graphics.lineTo ( pontofim.x , maxY + altura);
			visual.graphics.lineTo ( pontoini.x , maxY + altura);
			visual.graphics.lineTo ( pontoini.x , pontoini.y);
			visual.graphics.endFill();
			return visual;
		}
		 
		protected function criaLimiteFisico( pPosicao:Point, pListaVertices:Array ,  pAtrito:Number = 0.5, pElast:Number = 0):b2Body
		{			
			var forma:b2PolygonShape;
			var fisicaDef:b2FixtureDef;
			var bd:b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_staticBody
			bd.position.Set( pPosicao.x / Mundo.PP , pPosicao.y / Mundo.PP )
			var corpo:b2Body = Mundo.simMundo.CreateBody(bd);
			var p1:Point;
			var p2:Point;
			for (var i:uint = 1; i < pListaVertices.length; i++) {
				p1 = pListaVertices[i - 1];
				p2 = pListaVertices[i];
				forma = new b2PolygonShape();
				forma.SetAsEdge(new b2Vec2( p1.x / Mundo.PP, p1.y / Mundo.PP) , new b2Vec2( p2.x / Mundo.PP , p2.y / Mundo.PP ) )
				fisicaDef = new b2FixtureDef()
				fisicaDef.shape = forma;
				fisicaDef.friction = pAtrito ;
				fisicaDef.restitution = pElast ;
				fisicaDef.density = 0 ;
				corpo.CreateFixture(fisicaDef);
			}
			return corpo;
		}	
	}
}