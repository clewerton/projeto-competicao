package TangoGames.Box2D 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.Contacts.b2NullContact;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class Mundo 
	{
		//Forca redesenho do mundo
		private static var _redesenha:Boolean = false;
		
		//Escala Global
		private static var _escala:Number = 1.0;
		
		//Simulador do Mundo Fisico
		private static var _simMundo:b2World;
		
		//Proporcção da representação do mundo: 1 metro igual 10 pixels (melhor taxa eh 30 pixels)
		private static var _PP:Number = 10;

		//Valor em segundos de duracao de um frame
		private static var _FS:Number = 1.0 / 30.0 ;

		//Deslocamento da camera em X e Y
		private static var _DESLOC:Point = new Point(0, 0);
		
		//Container principal
		private static var _displayPai:DisplayObjectContainer;
		
		//Controle de Teclas
		private static var _teclas:KeyObject;
		
		//Lista de Atores
		private static var _listaAtores:Vector.<Ator> = new Vector.<Ator>();
		
		//DebugDraw
		private static var _DebugDraw:Boolean = false;
		
		//Display invisível de todos move clips invisiveis
		private static var _noDisplay:Boolean = false;
		
		//Limites do Mundo
		private static const _limites:Point = new Point(1280, 960);
		
		public function Mundo() 
		{
			
		}
		
		static public function get simMundo():Box2D.Dynamics.b2World 
		{
			return _simMundo;
		}
		
		static public function set simMundo(value:Box2D.Dynamics.b2World):void 
		{
			_simMundo = value;
		}
		
		static public function get DESLOC():Point 
		{
			return _DESLOC;
		}
		
		static public function set DESLOC(value:Point):void 
		{
			_DESLOC = value;
		}
		
		static public function get displayPai():DisplayObjectContainer 
		{
			return _displayPai;
		}
		
		static public function get listaAtores():Vector.<Ator>
		{
			return _listaAtores;
		}
		
		static public function set listaAtores(value:Vector.<Ator>):void 
		{
			_listaAtores = value;
		}
		
		static public function get DebugDraw():Boolean 
		{
			return _DebugDraw;
		}
		
		static public function set DebugDraw(value:Boolean):void 
		{
			_DebugDraw = value;
		}
		
		static public function get noDisplay():Boolean 
		{
			return _noDisplay;
		}
		
		static public function set noDisplay(value:Boolean):void 
		{
			_noDisplay = value;
		}
		
		static public function get PP():Number 
		{
			return _PP;
		}
		
		static public function set PP(value:Number):void 
		{
			_PP = value;
		}
		
		static public function get FS():Number 
		{
			return _FS;
		}
		
		static public function set FS(value:Number):void 
		{
			_FS = value;
		}
		
		static public function get teclas():KeyObject 
		{
			return _teclas;
		}
		
		static public function set teclas(value:KeyObject):void 
		{
			_teclas = value;
		}
		
		static public function get redesenha():Boolean 
		{
			return _redesenha;
		}
		
		static public function set redesenha(value:Boolean):void 
		{
			_redesenha = value;
		}
		
		static public function get escala():Number 
		{
			return _escala;
		}
		
		static public function set escala(value:Number):void 
		{
			_escala = value;
		}
		
		static public function get limites():Point 
		{
			return _limites;
		}
		
		public static function iniMundo(pPai: DisplayObjectContainer, pGravidade:Number = 9.807 , pMundoContactListener:b2ContactListener = null):void
		{
			//define o vetor da forca da gravidade colocou a 9.807 metros por segundo (gravidade na lua 1/6 da terra, 1,64)
			var gravidade:b2Vec2 = new b2Vec2(0, pGravidade); // A class b2Vec é usada para criar representacao da forca vetorial do mundo box2d
			
			//define o comportamento da engine, se ela ira atuar sobre objetos que estajam em repouso (sleepingobjects - objectos sem velocidade e aceleracao) 
			var ignoraEmRepouso:Boolean = true;
			
			// Cria o mundo com os parametros criados
			_simMundo = new b2World( gravidade, ignoraEmRepouso);
			if (pMundoContactListener != null) _simMundo.SetContactListener(pMundoContactListener);
			
			//Display principal
			_displayPai = pPai;
			
			_listaAtores = new Vector.<Ator>([]);
			
			//Liga Modo Debug
			if (_DebugDraw)	fdebug_draw();
		}

		public static function passoMundo():void 
		{
			//Calcula um intervalo de tempo da simulacao fisica
			//if ( _teclas.isDown(Keyboard.K) ) 
			_simMundo.Step( _FS , 30 , 30);
			//_simMundo.ClearForces();
			if (_DebugDraw) {
				_simMundo.DrawDebugData();
			}
			
			//Atualiza a situacao simulacao na representacaodo flash
			var tAtor:Ator
			var listaRemover:Array = [];
			for each ( tAtor in _listaAtores)
			{
				tAtor.atualiza();
				if (tAtor.marcadoRemover) listaRemover.push(tAtor);
			}
			//Remove Atores marcados para remover
			for each ( tAtor in listaRemover)
			{
				tAtor.destroi();
			}
		}
		
		public static function fdebug_draw():void 
		{
			if (_displayPai == null) return;
			var m_sprite:Sprite;
			m_sprite = new Sprite();
			_displayPai.addChild(m_sprite);
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			var dbgSprite:Sprite = new Sprite();
			m_sprite.addChild(dbgSprite);
			dbgDraw.SetSprite(m_sprite); // was dbgDraw.m_sprite=m_sprite;
			dbgDraw.SetDrawScale(_PP); // was dbgDraw.m_drawScale=30;
			dbgDraw.SetAlpha(1); // was dbgDraw.m_alpha=1;
			dbgDraw.SetFillAlpha(0.5); // was dbgDraw.m_fillAlpha=0.5;
			dbgDraw.SetLineThickness(1); // was dbgDraw.m_lineThickness=1;
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit); // was dbgDraw.m_drawFlags=b2DebugDraw.e_shapeBit;
			_simMundo.SetDebugDraw(dbgDraw);
		}
		
		public static function Rnd(min:int, max:int):int {
			if (min <= max) 
			{
				return (min + Math.floor( Math.random() * (max - min + 1) ) );
			}
			else
			{
				throw ( new Error("ERRO valor nimimo maior que o máximo na chamada a fu~ção randomica") + max + "<" + min )
			}
		}
	}

}