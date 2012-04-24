package Fases.FaseCasteloElementos 
{
	import Fases.FaseCastelo;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.sampler.NewObjectSample;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import TangoGames.Fases.FaseHUD;
	import TangoGames.Fases.FaseHUDInterface;
	
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class WavesFaseHUD extends FaseHUD implements FaseHUDInterface 
	{
		private var TF_waves:TextField;
		private var SP_ProximaWave:Sprite;
		private var SP_ProximaWaveMask:Sprite;
		private var FB_faseCastelo: FaseCastelo;
		private var UI_wave:uint;
		private var UI_relogio:uint;
		
		public function WavesFaseHUD(_fase:FaseCastelo) 
		{
			super();
			FB_faseCastelo = _fase;
			var formato:TextFormat = new TextFormat;
			formato.size = 12;
			formato.bold = true;
			formato.color = 0x000000;
			formato.font =  Font(new FontMenu()).fontName;
			SP_ProximaWave = criaCirculo(10);
			SP_ProximaWaveMask = new Sprite();
			TF_waves =  new TextField;
			TF_waves.defaultTextFormat = formato;
			TF_waves.text = "WAVES 00 / 00"
			this.addChild(TF_waves);
			TF_waves.autoSize = TextFieldAutoSize.RIGHT;
			this.addChild(SP_ProximaWave);
			SP_ProximaWave.x = TF_waves.width + SP_ProximaWave.width;
			SP_ProximaWave.y = TF_waves.height / 2;
			this.addChild(SP_ProximaWaveMask);
			SP_ProximaWaveMask.x = TF_waves.width + SP_ProximaWave.width;
			SP_ProximaWaveMask.y = TF_waves.height / 2;
			SP_ProximaWave.mask = SP_ProximaWaveMask;
		}
		
		/* INTERFACE TangoGames.Fases.FaseHUDInterface */
		
		public function inicializa():void 
		{
			this.y = stage.stageHeight - this.height - 7 ;			
			this.x = stage.stageWidth - this.width - 10;
			reinicializa();
		}
		
		public function reinicializa():void 
		{   UI_wave = 99;
			UI_relogio = 360;
		}
		
		public function update(e:Event):void 
		{
			if (UI_wave != FB_faseCastelo.contaWaves) {
				UI_wave = FB_faseCastelo.contaWaves;
				TF_waves.text = "WAVES " + UI_wave.toString() + " / " + FB_faseCastelo.totalWaves.toString();
			}
			var perc:Number = FB_faseCastelo.tempoWave / FB_faseCastelo.proxiWave ;
			
			if (UI_relogio != perc && perc >= 0 && perc <= 1) {
				UI_relogio = perc;
				SP_ProximaWaveMask.graphics.clear();
				SP_ProximaWaveMask.graphics.beginFill(0);
				drawPieMask(SP_ProximaWaveMask.graphics, perc, 10, 0, 0, (-(Math.PI) / 2), 3);
				SP_ProximaWaveMask.graphics.endFill();

				//this.removeChild(SP_ProximaWave);
				//criaCirculo(SP_ProximaWave,10, UI_relogio);
				//this.addChild(SP_ProximaWave);
				//SP_ProximaWave.x = 
				//SP_ProximaWave.y = TF_waves.height / 2;
			}
			parent.setChildIndex(this, parent.numChildren - 1);
		}
		
		public function remove():void 
		{
			
		}
		

		function criaCirculo(raio:Number):Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0XE00000);
			sp.graphics.drawCircle(0, 0, 10);
			sp.graphics.endFill();
			return sp;
		}
		
		function drawPieMask(graphics:Graphics, percentage:Number, radius:Number = 10, x:Number = 0, y:Number = 0, rotation:Number = 0, sides:int = 6):void {
			// graphics should have its beginFill function already called by now
			graphics.moveTo(x, y);
			if (sides < 3) sides = 3; // 3 sides minimum
			// Increase the length of the radius to cover the whole target
			radius /= Math.cos(1/sides * Math.PI);
			// Shortcut function
			var lineToRadians:Function = function(rads:Number):void {
				graphics.lineTo(Math.cos(rads) * radius + x, Math.sin(rads) * radius + y);
			};
			// Find how many sides we have to draw
			var sidesToDraw:int = Math.floor(percentage * sides);
			for (var i:int = 0; i <= sidesToDraw; i++)
				lineToRadians((i / sides) * (Math.PI * 2) + rotation);
			// Draw the last fractioned side
			if (percentage * sides != sidesToDraw)
				lineToRadians(percentage * (Math.PI * 2) + rotation);
		}
	}
}