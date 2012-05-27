package TangoGames.Atores 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class AtorAnimacao extends MovieClip 
	{
		private var SC_canal:SoundChannel;
		private var SD_som:Sound;
		public function AtorAnimacao( _som:Sound = null) 
		{
			var ultFr:uint = totalFrames -1;
			addFrameScript(ultFr, ultimoFrame);
			if (_som != null) {
				SD_som = _som;
				addFrameScript(0, primeiroFrame);
			}
		}
		private function primeiroFrame():void 
		{	SC_canal = SD_som.play(0);
		}		

		private function ultimoFrame():void 
		{	stop();
			parent.removeChild(this);
		}		
	}

}