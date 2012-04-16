package TangoGames.Menus 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Classe auxiliar para criar vetor de opções de Menu
	 * @author Arthur Figueirdo
	 */
	public class MenuOpcao extends Sprite {
		private var ST_titulo: String;
		private var IN_valorRetorno: uint;
		private var TF_opcaoTextField: TextField ;
		private var DO_opcaoDisplay: DisplayObject;
		private var FU_ProximoMenu: Function;
		private var BO_ativo:Boolean;
		private var UI_faseID: uint;
		private var BO_faseControle:Boolean;
	
		/**
		* Cria uma opção de menu
		* @param	titulo
		* Titulo que será usado na opção do menu
		* @param	valoRetorno
		* Valor que será retornado pelo evento correspondente a opção do menu selecionada
		* @param	display
		* Objeto que será apresentado na tela como opção de menu
		*/
		public function MenuOpcao(titulo:String, valoRetorno:uint, prxMenu: Function = null, display: DisplayObject = null) {
			UI_faseID = 0;
			BO_faseControle = false;
			BO_ativo = true;
			ST_titulo = titulo;
			TF_opcaoTextField =  new TextField ;
			DO_opcaoDisplay = display;
			IN_valorRetorno = valoRetorno;
			FU_ProximoMenu = prxMenu;
			//Cria textfield do menu
			if (display == null) {
				criaTextField();
			}
			else {
				this.addChild(DO_opcaoDisplay);
			}
			this.buttonMode = true;
		}
		/**
		* Titulo usado na opção do menu
		*/
		public function get titulo():String {
			return ST_titulo;
		}
		/**
		* Valor retornado pelo evento quando selecionado
		*/
		public function get valorRetorno():uint {
			return IN_valorRetorno;
		}
		/**
		* Valor retornado pelo evento quando selecionado
		*/
		public function set valorRetorno(value:uint):void 
		{
			IN_valorRetorno = value;
		}

		/**
		 * TextField usado pala opção de menu
		*/
		public function get opcaoTextField():TextField {
			return TF_opcaoTextField;
		}
		/**
		 * Atualizado TextFormat usados na opção do menu
		 */
		public function set formato(value:TextFormat):void {
			//var text:String = TF_opcaoTextField.text;
			TF_opcaoTextField.defaultTextFormat = value;
			TF_opcaoTextField.text = ST_titulo;
		}
		/**
		 * Recupera TextFormat usados na opção do menu
		 */
		public function get formato():TextFormat 
		{
			return TF_opcaoTextField.getTextFormat() ;
		}
		
		public function get opcaoDisplay():DisplayObject 
		{
			return DO_opcaoDisplay;
		}
		
		public function get ProximoMenu():Function 
		{
			return FU_ProximoMenu;
		}
		
		public function get ativo():Boolean 
		{
			return BO_ativo;
		}
		
		public function set ativo(value:Boolean):void 
		{
			BO_ativo = value;
		}
		
		public function get faseID():uint 
		{
			return UI_faseID;
		}
		
		public function set faseID(value:uint):void 
		{
			UI_faseID = value;
		}
		
		public function get faseControle():Boolean 
		{
			return BO_faseControle;
		}
		
		public function set faseControle(value:Boolean):void 
		{
			BO_faseControle = value;
		}
		
			
		private function criaTextField():void {
			TF_opcaoTextField.selectable = false;
			TF_opcaoTextField.autoSize = TextFieldAutoSize.LEFT;
			TF_opcaoTextField.mouseEnabled = false;
			TF_opcaoTextField.text = ST_titulo;
			this.addChild( TF_opcaoTextField );
			DO_opcaoDisplay = TF_opcaoTextField;
		}	
	}
}