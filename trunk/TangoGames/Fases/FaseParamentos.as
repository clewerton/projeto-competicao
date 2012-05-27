package TangoGames.Fases 
{
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Proxy;
	
	dynamic public class FaseParamentos extends Proxy
	{
		private var UI_faseID:uint;
		private var UI_nivel:uint;
		private var OB_paramentros:Object
		
		/**
		 * Paramentros da  fase
		 * @param	_faseID
		 * ID fase
		 * @param	_nivel
		 * Nivel da fase
		 * @param	_param
		 * referencia do objeto com os parametros.
		 */
		public function FaseParamentos( _faseID:uint , _nivel:uint) 
		{   
			if (Class(getDefinitionByName(getQualifiedClassName(this))) == FaseParamentos ) {
				throw (new Error("FaseParamentos: Esta classe não pode ser instanciada diretamente"))
			}
			UI_faseID = _faseID;
			UI_nivel  = _nivel;
			OB_paramentros =  new Object();
		}
		
		public function get faseID():uint 
		{
			return UI_faseID;
		}
		
		public function get nivel():uint 
		{
			return UI_nivel;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void 
		{
			OB_paramentros[name] = value;
		}
		
		override flash_proxy function getProperty(name:*):* 
		{
			return OB_paramentros[name];
		}
	}

}