package  
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Arthur Figueirdo
	 */
	public class BarcoHeroiUpgrades 
	{
		//Upgrade navio
		public static const UPGRADE_TIPO_NAVIO_NIVEL0	:uint = 0;
		public static const UPGRADE_TIPO_NAVIO_NIVEL1	:uint = 1;
		public static const UPGRADE_TIPO_NAVIO_NIVEL2	:uint = 2;

		//Upgrade navio vida
		public static const UPGRADE_VIDA_NAVIO_NIVEL0	:uint = 1000;
		public static const UPGRADE_VIDA_NAVIO_NIVEL1	:uint = 2000;
		public static const UPGRADE_VIDA_NAVIO_NIVEL2	:uint = 3000;

		//Upgrade canhão
		public static const UPGRADE_CANHOES_NIVEL0		:uint = 1;
		public static const UPGRADE_CANHOES_NIVEL1		:uint = 2;
		public static const UPGRADE_CANHOES_NIVEL2		:uint = 3;
		
		//Upgrade de tempo de recarga
		public static const UPGRADE_RECARGA_NIVEL0		:uint = 72;
		public static const UPGRADE_RECARGA_NIVEL1		:uint = 48;
		public static const UPGRADE_RECARGA_NIVEL2		:uint = 36;
		
		//Upgrate do tipo tiro
		public static const UPGRADE_TIRO_NIVEL0			:uint = 0;
		public static const UPGRADE_TIRO_NIVEL1			:uint = 1;
		public static const UPGRADE_TIRO_NIVEL2			:uint = 2;

		//Upgrate do tipo navio
		public static const UPGRADE_CASCO_NIVEL0		:uint =  500;
		public static const UPGRADE_CASCO_NIVEL1		:uint = 1000;
		public static const UPGRADE_CASCO_NIVEL2		:uint = 2000;
		
		//Upgrate de qtd de municao
		public static const UPGRADE_MUNICAO_NIVEL0		:uint =	 40;
		public static const UPGRADE_MUNICAO_NIVEL1		:uint =	 80;
		public static const UPGRADE_MUNICAO_NIVEL2		:uint = 120;

		//Upgrate de dano do tiro
		public static const UPGRADE_DANO_TIRO_NIVEL0	:uint =	 10;
		public static const UPGRADE_DANO_TIRO_NIVEL1	:uint =	 20;
		public static const UPGRADE_DANO_TIRO_NIVEL2	:uint =  30;

		//Upgrate de dano do tiro
		public static const UPGRADE_ALCANCE_TIRO_NIVEL0	:uint =	 250;
		public static const UPGRADE_ALCANCE_TIRO_NIVEL1	:uint =	 350;
		public static const UPGRADE_ALCANCE_TIRO_NIVEL2	:uint =  450;
		
		//armazena objetos
		private var SO_upgrades: SharedObject
		
		//niveis de upgrade
		private var UI_nivelNavio:uint;
		private var VT_nivelNavio:Vector.<ValoresNivel>;
		
		private var UI_nivelVela:uint;
		private var VT_nivelVela:Vector.<ValoresNivel>;
		
		private var UI_nivelCanhao:uint;
		private var VT_nivelCanhao:Vector.<ValoresNivel>;
		
		private var UI_nivelAlcanceTiro:uint;
		private var VT_nivelAlcanceTiro:Vector.<ValoresNivel>;

		
		private var UI_nivelDanoTiro:uint;
		private var VT_nivelDanoTiro:Vector.<ValoresNivel>;

		private var UI_nivelFrequenciaTiro:uint;
		private var VT_nivelFrequenciaTiro:Vector.<ValoresNivel>;

		
		private var UI_nivelCapacidadeMunicao:uint;
		private var VT_nivelCapacidadeMunicao:Vector.<ValoresNivel>;
		
		public function BarcoHeroiUpgrades() 
		{
			UI_nivelNavio 				=	0;
			UI_nivelVela				=   0;
			UI_nivelCanhao 				=	0;
			UI_nivelAlcanceTiro 		=	0;
			UI_nivelDanoTiro			=   0;
			UI_nivelFrequenciaTiro		=	0;
			UI_nivelCapacidadeMunicao	=	0;
			SO_upgrades = SharedObject.getLocal( "upgradesBarcoHeroi" );
			
			//configura custo e liberacaode upgrades
			configuraUpgrades();
			
			//carrega informacao armazenada
			carregaDados();
		}
		/**
		 * Carrega dados Salvos
		 */
		public function carregaDados():void {
			if (SO_upgrades.data.gamedata != undefined)
				for (var upnome in SO_upgrades.data.gamedata) this[upnome] = SO_upgrades.data.gamedata[upnome];
		}
		/**
		 * configura dados dos niveis
		 */
		private function configuraUpgrades():void {
			VT_nivelNavio 				= new Vector.<ValoresNivel>;
			VT_nivelVela				= new Vector.<ValoresNivel>;
			VT_nivelCanhao				= new Vector.<ValoresNivel>;
			VT_nivelAlcanceTiro			= new Vector.<ValoresNivel>;
			VT_nivelDanoTiro			= new Vector.<ValoresNivel>;
			VT_nivelFrequenciaTiro		= new Vector.<ValoresNivel>;
			VT_nivelCapacidadeMunicao	= new Vector.<ValoresNivel>;
			
			//configura upgrades navio ( custo, fase Liberada)
			VT_nivelNavio.push(				new ValoresNivel(	  0 ,	0 ))
			VT_nivelNavio.push(				new ValoresNivel( 20000	, 	2 ))
			VT_nivelNavio.push(				new ValoresNivel( 50000	, 	5 ))

			//configura upgrades vela ( custo, fase Liberada)
			VT_nivelVela.push(				new ValoresNivel(0, 0))
			VT_nivelVela.push(				new ValoresNivel(0, 0))
			VT_nivelVela.push(				new ValoresNivel(0, 0))

			//configura upgrades canhao ( custo, fase Liberada)
			VT_nivelCanhao.push(			new ValoresNivel(0, 0))
			VT_nivelCanhao.push(			new ValoresNivel(0, 0))
			VT_nivelCanhao.push(			new ValoresNivel(0, 0))

			//configura upgrades alcance ( custo, fase Liberada)
			VT_nivelAlcanceTiro.push(		new ValoresNivel(0, 0))
			VT_nivelAlcanceTiro.push(		new ValoresNivel(0, 0))
			VT_nivelAlcanceTiro.push(		new ValoresNivel(0, 0))

			//configura upgrades dano ( custo, fase Liberada)
			VT_nivelDanoTiro.push(			new ValoresNivel(0, 0))
			VT_nivelDanoTiro.push(			new ValoresNivel(0, 0))
			VT_nivelDanoTiro.push(			new ValoresNivel(0, 0))
			
			//configura upgrades frequencia ( custo, fase Liberada)
			VT_nivelFrequenciaTiro.push(	new ValoresNivel(0, 0))
			VT_nivelFrequenciaTiro.push(	new ValoresNivel(0, 0))
			VT_nivelFrequenciaTiro.push(	new ValoresNivel(0, 0))

			//configura upgrades capaciade de municao( custo, fase Liberada)
			VT_nivelCapacidadeMunicao.push(	new ValoresNivel(0, 0))
			VT_nivelCapacidadeMunicao.push(	new ValoresNivel(0, 0))
			VT_nivelCapacidadeMunicao.push(	new ValoresNivel(0, 0))
		}
		
		public function custoUpgrade(_nomeUp:String, _nivel:uint):uint {
			var nomeVT:String = "VT_" + _nomeUp
			var VT:Vector.<ValoresNivel> = this[nomeVT]
			return VT[_nivel].custo;
		}
		public function faseLiberaUpgrade(_nomeUp:String, _nivel:uint):uint {
			var nomeVT:String = "VT_" + _nomeUp
			var VT:Vector.<ValoresNivel> = this[nomeVT]
			return VT[_nivel].faseLibera;
		}
		
		/**
		 * Salva dados carregados
		 */
		public function salvaDados():void {
			SO_upgrades.data.gamedata = {
				nivelNavio				:UI_nivelNavio,
				nivelVela				:UI_nivelVela,
				nivelCanhao				:UI_nivelCanhao,
				nivelAlcance			:UI_nivelAlcanceTiro,
				nivelDanoTiro			:UI_nivelDanoTiro,
				nivelFrequencia			:UI_nivelFrequenciaTiro,
				nivelCapacidadeMunicao	:UI_nivelCapacidadeMunicao
			}
			SO_upgrades.flush();
		}
		
		/**
		 * Valores dos upgrades
		 */
		public function get tipoNavio():uint
		{
			var prop:String = "UPGRADE_TIPO_NAVIO_NIVEL" + UI_nivelNavio;
			return BarcoHeroiUpgrades[prop];
		}
		public function get qtdCanhoes():uint
		{
			var prop:String = "UPGRADE_CANHOES_NIVEL" + UI_nivelCanhao;
			return BarcoHeroiUpgrades[prop];
		}
		public function get tempoRecarga():uint
		{
			var prop:String = "UPGRADE_RECARGA_NIVEL" + UI_nivelFrequenciaTiro;
			return BarcoHeroiUpgrades[prop];
		}
		public function get vidaNavio():uint
		{
			var prop:String = "UPGRADE_VIDA_NAVIO_NIVEL" + UI_nivelNavio;
			return BarcoHeroiUpgrades[prop];
		}
		public function get capacidadeMunicao():uint
		{
			var prop:String = "UPGRADE_MUNICAO_NIVEL" + UI_nivelCapacidadeMunicao;
			return BarcoHeroiUpgrades[prop];
		}
		public function get alcanceTiro():uint
		{
			var prop:String = "UPGRADE_ALCANCE_TIRO_NIVEL" + UI_nivelAlcanceTiro;
			return BarcoHeroiUpgrades[prop];
		}
		public function get danoTiro():uint
		{
			var prop:String = "UPGRADE_DANO_TIRO_NIVEL" + UI_nivelDanoTiro;
			return BarcoHeroiUpgrades[prop];
		}
		
		
		/**
		 * Propriedades de upgrade
		 */
		public function get nivelNavio():uint 
		{
			return UI_nivelNavio;
		}
		
		public function set nivelNavio(value:uint):void 
		{
			UI_nivelNavio = value;
		}
		
		public function get nivelVela():uint 
		{
			return UI_nivelVela;
		}
		
		public function set nivelVela(value:uint):void 
		{
			UI_nivelVela = value;
		}
		
		public function get nivelCanhao():uint 
		{
			return UI_nivelCanhao;
		}
		
		public function set nivelCanhao(value:uint):void 
		{
			UI_nivelCanhao = value;
		}
		
		public function get nivelAlcanceTiro():uint 
		{
			return UI_nivelAlcanceTiro;
		}
		
		public function set nivelAlcanceTiro(value:uint):void 
		{
			UI_nivelAlcanceTiro = value;
		}
		
		public function get nivelFrequenciaTiro():uint 
		{
			return UI_nivelFrequenciaTiro;
		}
		
		public function set nivelFrequenciaTiro(value:uint):void 
		{
			UI_nivelFrequenciaTiro = value;
		}
		
		public function get nivelCapacidadeMunicao():uint 
		{
			return UI_nivelCapacidadeMunicao;
		}
		
		public function set nivelCapacidadeMunicao(value:uint):void 
		{
			UI_nivelCapacidadeMunicao = value;
		}
		
		public function get nivelDanoTiro():uint 
		{
			return UI_nivelDanoTiro;
		}
		
		public function set nivelDanoTiro(value:uint):void 
		{
			UI_nivelDanoTiro = value;
		}	
	}
}

internal class ValoresNivel {
	public var custo:uint;
	public var faseLibera:uint;
	public function ValoresNivel(_custo:uint, _fase:uint) {
		custo 		= _custo;
		faseLibera 	= _fase; 
	}
}