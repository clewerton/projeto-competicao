package Fases.FaseCasteloElementos 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import TangoGames.Atores.AtorBase;
	import TangoGames.Atores.AtorEvent;
	import TangoGames.Atores.AtorInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class TiroAtor extends AtorBase implements AtorInterface {
		private var SP_tiro:Sprite;
		private var NU_velX:Number;
		private var NU_velY:Number;
		private var NU_veloc:Number;
		private var NU_angulo:Number;
		private var PT_ptini:Point;
		private var PT_direcao:Point;
		private var SP_ponta:Sprite;
		
		//distancia percorrida pelo tiro
		private var NU_distancia:Number;
		
		//tiro certo
		private var BO_acertou:Boolean;

		//dano do tiro
		private var NU_danoMax:Number;
		private var NU_alcanceEfetivo:uint;
		
		
		public function TiroAtor(_ptini:Point, _direcao:Point) 
		{
			PT_ptini = _ptini;
			PT_direcao = _direcao;
			SP_tiro = criaFecha();
			SP_ponta = criaPontaFecha();
			super(SP_tiro);
			this.addChild(SP_ponta);
			SP_ponta.x = 10;
			SP_ponta.y = -1;
			hitObject = SP_ponta;
		}
		
		public function inicializa():void {

			NU_distancia = 0;
			NU_veloc = 10;
			NU_danoMax = 100;
			NU_alcanceEfetivo = 400;
			BO_acertou = false;
			this.x = PT_ptini.x;
			this.y = PT_ptini.y;
			calcularRota();
			reinicializa();
		}
		
		public function reinicializa():void {
		}
		
		public function update(e:Event):void {
			this.x += NU_velX;
			this.y += NU_velY;
			NU_distancia += NU_veloc;
			if (NU_distancia > 500) marcadoRemocao = true;
		}
		
		override public function hitTestAtor(atorAlvo:AtorBase):Boolean {
			if (hitObject.hitTestObject(atorAlvo.hitObject)) {
				if (atorAlvo is CasteloAtor && NU_distancia < 60 ) return false;
				if (testeHitShapeAtor(atorAlvo)) return true;
			}
			return false

		}
		
		public function remove():void {
		}
		
		private function calcularRota():void {
			NU_angulo = Math.atan2(PT_direcao.y - this.y , PT_direcao.x - this.x);
			NU_velX =  Math.cos(NU_angulo) * NU_veloc;
			NU_velY =  Math.sin(NU_angulo) * NU_veloc;
			this.rotation = ( NU_angulo * 180 ) / Math.PI;
		}
		
		private function criaPontaFecha():Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle();
			sp.graphics.beginFill( 0XFEADF, 0);
			sp.graphics.drawRect(0, 0, 3, 3);
			sp.graphics.endFill();
			return sp;
		}

		
		private function criaFecha():Sprite {
			var sp:Sprite = new Sprite(); 
			sp.graphics.lineStyle(1, 0X000000);
			sp.graphics.moveTo(-10, 0);		
			sp.graphics.lineTo(10, 0);
			sp.graphics.moveTo(7, 3);
			sp.graphics.lineTo(10, 0);
			sp.graphics.moveTo(7, -3);
			sp.graphics.lineTo(10, 0);
			return sp;
		}
		
		public function criaFechaFragmento():Sprite {
			var sp:Sprite = new Sprite(); 
			sp.graphics.lineStyle(1, 0X000000);
			sp.graphics.moveTo(-5, 0);		
			sp.graphics.lineTo(15, 0);
			return sp;
		}
		
		public function get angulo():Number 
		{
			return NU_angulo;
		}
		
		public function get dano():Number 
		{	if (NU_distancia > NU_alcanceEfetivo) return 0;
			var dano:Number = NU_danoMax * ( ( NU_alcanceEfetivo - NU_distancia ) / NU_alcanceEfetivo ) ;
			return dano;
		}
		
		public function get distancia():Number 
		{
			return NU_distancia;
		}
		
		public function get alcanceEfetivo():uint 
		{
			return NU_alcanceEfetivo;
		}
		
		public function get ponta():Sprite 
		{
			return SP_ponta;
		}
		
		public function get acertou():Boolean 
		{
			return BO_acertou;
		}
		
		public function set acertou(value:Boolean):void 
		{
			BO_acertou = value;
		}
	}
	
}