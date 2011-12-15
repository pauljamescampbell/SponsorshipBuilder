package co.uk.guardian.sponsorbuilder{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		
		public static const AD_IMAGE_PATH:String = "https://sites.google.com/a/guardian.co.uk/creative-technology/tools/channel-4-sponsorship-builder/C4_slotad_Tonight_v4.gif";
		public static const AD_JSON:String = '{"type":"default","frameworkVersion":1,"background":"","size":"twoByOne","campaignID":"%%CAMP%%","views":{},"stack":[{"media":{"type":"image","reference":"%%CDN%%/RealMedia/ads/Creatives/%%CAMP%%/C4_slotad_Tonight_v4.gif"},"hotspots":[{"targetAd":"<%TARGETAD%>"}]}]}';
		public static const AD_JSON_FILENAME:String = "advert.json";
		public static const AD_SPONSOR_FILENAME:String = "sponsorship.json";
		public static const AD_JSON_PATTERN:RegExp = new RegExp("<%TARGETAD%>");
		public static const CAMPAIGN_ID_PREFIX:String = "GCE_";
		
		private var _form:FormView;
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			_form = new FormView();
			addChild(_form);
		}
	}
}
