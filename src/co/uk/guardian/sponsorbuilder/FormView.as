package co.uk.guardian.sponsorbuilder{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.serialization.json.JSON;
	import flash.utils.ByteArray;
	import flash.events.TextEvent;
	import flash.net.FileFilter;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.events.MouseEvent;
	/**
	 * @author plcampbell
	 */
	public class FormView extends UIForm {
		
		private var _file:FileReference;
		private var _currentSponsorData:String;
		private var _updateSponsorData:String;
		private var _updateAdData:String;
		
		public function FormView() {
			init();
			textID.addEventListener(Event.CHANGE, onCampaignIDAdded);
		}
		
		private function init():void {
			stepper.gotoAndStop(1);
			buttonBrowse.enabled = false;
			buttonLoad.enabled = false;
			buttonAdvertDown.enabled = false;
			buttonGIFDown.enabled = false;
			buttonSponsorDown.enabled = false;
		}
		
		private function onCampaignIDAdded(event:Event):void {
			trace(textID.text, (textID.text as String).substr(0, Main.CAMPAIGN_ID_PREFIX.length)); // FUCKED UP?!
			//if( (textID.text as String).substr(0, Main.CAMPAIGN_ID_PREFIX.length) == Main.CAMPAIGN_ID_PREFIX ) {
			if( textID.text.length ) {
				// Viable campaign name!	
				stepper.gotoAndStop(2);
				buttonBrowse.enabled = true;
				buttonBrowse.addEventListener(MouseEvent.CLICK, onBrowseSponsorFile);	
			} else {
				init();
			}
		}
		
		private function onBrowseSponsorFile(event:MouseEvent):void {
			_file = new FileReference();
			_file.addEventListener(Event.SELECT, onSelectSponsorFile);
			buttonBrowse.addEventListener(MouseEvent.CLICK, onBrowseSponsorFile);
			textID.addEventListener(TextEvent.TEXT_INPUT, onCampaignIDAdded);
			try {
				_file.browse([new FileFilter("Sponsorship file", Main.AD_SPONSOR_FILENAME)]);
			} catch(error:Error) {
				trace(error);
			}
		}
		
		private function onSelectSponsorFile(event:Event):void {
			stepper.gotoAndStop(3);
			//
			buttonLoad.addEventListener(MouseEvent.CLICK, onUserOkLoad);
			buttonLoad.enabled = true;
			//
			textFile.text = _file.name;
		}
		
		private function onUserOkLoad(event:MouseEvent):void {
			buttonBrowse.removeEventListener(MouseEvent.CLICK, onUserOkLoad);
			//
			buttonBrowse.addEventListener(MouseEvent.CLICK, onBrowseSponsorFile);
			_file.addEventListener(Event.COMPLETE, onSponsorLoadComplete);
			try {
				_file.load();	
			} catch(error:Error) {
				trace(error);
			}
		}
		
		private function onSponsorLoadComplete(event:Event):void {
			stepper.gotoAndStop(4);
			_currentSponsorData = _file.data.readUTFBytes(_file.data.length);
			if( getSponsorData( textID.text ) && getAdData( textID.text ) ) {
				buttonAdvertDown.enabled = true;
				buttonAdvertDown.addEventListener(MouseEvent.CLICK, onExportAsset);
				buttonGIFDown.enabled = true;
				buttonGIFDown.addEventListener(MouseEvent.CLICK, onExportAsset);
				buttonSponsorDown.enabled = true;
				buttonSponsorDown.addEventListener(MouseEvent.CLICK, onExportAsset);
			}
		}
		
		private function getSponsorData(cID:String):Boolean {
			try {
				var json:Object = JSON.deserialize(_currentSponsorData);	
			} catch(error:Error) {
				trace(error);	
			}
			if(json) {
				var sponsor:Object;
				for(var i:Number = 0; i<json.sponsorships.length; i++) {
					//
					sponsor = json.sponsorships[i];
					if(sponsor.name == "Channel4") {
						var oldCID:String = sponsor.data.adverts[0].campaignID as String;
						if(oldCID && oldCID.length) {
							var reg:RegExp = new RegExp(oldCID, "g");
							var data:String= _currentSponsorData.concat(); // Dupe object
							var newData:String = data.replace(reg, cID);
							if(newData.length && newData.indexOf(cID) > -1) {
								_updateSponsorData = newData;
								return(true);
							}
						}
					}
				}
			}
			return(false);
		}
		
		private function onExportAsset(event:Event):void {
			var file:FileReference = new FileReference();
			var bytes:ByteArray = new ByteArray();
			switch(event.target) {
				case buttonAdvertDown :
					bytes.writeUTFBytes(_updateAdData);
					file.save(bytes, Main.AD_JSON_FILENAME);
					break;
				case buttonGIFDown:
					navigateToURL(new URLRequest(Main.AD_IMAGE_PATH));
					break;
				case buttonSponsorDown :
					bytes.writeUTFBytes(_updateSponsorData);
					file.save(bytes, Main.AD_SPONSOR_FILENAME);
					break;
			}
		}
		
		private function getAdData( cID:String ):Boolean {
			var adData:String = Main.AD_JSON;
			var newData:String = adData.replace(Main.AD_JSON_PATTERN, cID);
			if(newData.length && newData.indexOf(cID) > -1) { 
				_updateAdData = newData;
				return(true);
			}
			return(false);			
		}
		
		
	}
}
