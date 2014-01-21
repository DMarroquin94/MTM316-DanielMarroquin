package 
{
	import flash.display.MovieClip;
	import flash.xml.*;
	import flash.net.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.*;
	import flash.display.Sprite;
	
	public class Thing extends MovieClip
	{
		var Master_MC: MovieClip;
		var myXML:XML;
		var comfirmXML:XML;
		var GETDATES:int = 7;
		var dayNum:int = new Date().day;
		var days:Array;
		
		var textLocation:TextField;
		var text:TextField;
		var button:Sprite = new Sprite();
		
		var Dates:Array = new Array(GETDATES);
		var InstancesMC:Array = new Array(GETDATES);
		
		var match:Boolean;
		
		var locationState: Array;
		
		public function processXML(e: Event): void {
			myXML = new XML(e.target.data);
			setStage();
		}

		public function Thing(): void {
			
			var myLoader:URLLoader = new URLLoader();
			
			myLoader.load(new URLRequest("http://api.openweathermap.org/data/2.5/forecast/daily?q=Salt+Lake+City,UT&mode=xml&units=imperial&cnt=7&nocache="+ new Date().getTime()));
			myLoader.addEventListener(Event.COMPLETE, processXML);
		
		}
		
		public function setStage(): void {
			Master_MC = new MasterMC;
			addChild(Master_MC);
			days = [
				"Sunday",
				"Monday", 
				"Tuesday",
				"Wednesday",
				"Thursday",
				"Friday",
				"Saturday"
			];			
			
			Master_MC.Location.text = myXML.location.name;
			CreateButton();
			SetWeekUp();
			
			Master_MC.addEventListener(Event.ENTER_FRAME, MasterMCPlaying);
			
			Master_MC.x = 0;
			Master_MC.y = 0;			
		
		}
		
		function MasterMCPlaying(e:Event): void {
			UpdateTime();
		}
		
		function SetWeekUp(): void {
			
			var clips: Array = new Array(GETDATES);
			
			clips[0] = Master_MC.Day1;
			clips[1] = Master_MC.Day2;
			clips[2] = Master_MC.Day3;
			clips[3] = Master_MC.Day4;
			clips[4] = Master_MC.Day5;
			clips[5] = Master_MC.Day6;
			clips[6] = Master_MC.Day7;
			
			SetUpArray(clips);
			SetUpToday();
			
		}
		
		function SetUpToday() {			
			
			
			var today:TextFormat = new TextFormat();
			today.size = 25;
			today.bold = false;
			today.font = "Comic Sans MS"
			today.color = 0x000099;			
			
			text = new TextField();		     //Button
			text.defaultTextFormat = today;
			text.wordWrap = true;
			text.height = 50;
			text.width = 150;
			text.x = 420;
			text.y = 100;
			text.text = Master_MC.Day1.Day.text;
			addChild(text);
			
			var today2:TextFormat = new TextFormat();
			today2.size = 22;
			today2.bold = false;
			today2.font = "Comic Sans MS"
			today2.color = 0xFFFFFF;
			
			var date = new TextField();
			date.defaultTextFormat = today2;
			date.height = 50;
			date.width = 125;
			date.x = 440;
			date.y = 135;
			date.text = Master_MC.Day1.Date.text;
			addChild(date); 
			
			var highs = new TextField();
			highs.defaultTextFormat = today2;
			highs.height = 50;
			highs.width = 150;
			highs.x = 400;
			highs.y = 165;
			highs.text = Master_MC.Day1.Highs.text;
			addChild(highs); 
			
			var lows = new TextField();
			lows.defaultTextFormat = today2;
			lows.height = 50;
			lows.width = 150;
			lows.x = 400;
			lows.y = 200;
			lows.text = Master_MC.Day1.Lows.text;
			addChild(lows); 
			
			var code = new TextField();
			code.defaultTextFormat = today2;
			code.height = 50;
			code.width = 150;
			code.x = 405;
			code.y = 235;
			code.text = Master_MC.Day1.Code.text;
			addChild(code);
			
			Master_MC.Day1.Day.text = "";
			Master_MC.Day1.Date.text = "";
			Master_MC.Day1.Highs.text = "";
			Master_MC.Day1.Lows.text = "";
			Master_MC.Day1.Code.text = "";
		}
		
		function SetUpArray(clips:Array): void {	
			for (var i:int = 0; i < 7; i++) {
				if (myXML.forecast.time[i].@day.substr(8, 2) == new Date().date) {
					for (var j:int = 0; j < 7; i++, j++) {
						if (i == 7)
							i = 0;
						
						InstancesMC[i] = clips[j];    
						
						if (myXML.forecast.time[i].symbol.@number < 233 && myXML.forecast.time[i].symbol.@number > 199) // Thunderstorm 
							InstancesMC[i].gotoAndStop(6); 
				/*		else if (myXML.forecast.time[i].symbol.@number == 500 || myXML.forecast.time[i].symbol.@number == 501) // light rain 
							InstancesMC[i].gotoAndStop(10); */
						else if (myXML.forecast.time[i].symbol.@number < 523 && myXML.forecast.time[i].symbol.@number > 510) // hard rain
							InstancesMC[i].gotoAndStop(4);
				/*		else if (myXML.forecast.time[i].symbol.@number < 332 && myXML.forecast.time[i].symbol.@number > 299) // drizzle
							InstancesMC[i].gotoAndStop(9) */
						else if (myXML.forecast.time[i].symbol.@number < 622 && myXML.forecast.time[i].symbol.@number > 599) // snow
							InstancesMC[i].gotoAndStop(5);
						else if (myXML.forecast.time[i].symbol.@number == 800) // sunny 
							InstancesMC[i].gotoAndStop(1);
						else if (myXML.forecast.time[i].symbol.@number == 801)// && myXML.forecast.time[i].symbol.@number > 800) //cloud codes
							InstancesMC[i].gotoAndStop(2);
					/*	else if (myXML.forecast.time[i].symbol.@number == 802) // scattered clouds
							InstancesMC[i].gotoAndStop(7);
						else if(myXML.forecast.time[i].symbol.@number == 803) // broken clouds
							InstancesMC[i].gotoAndStop(8); */
 						else if(myXML.forecast.time[i].symbol.@number < 742 || myXML.forecast.time[i].symbol.@number > 700) // fog
							InstancesMC[i].gotoAndStop(3);
						
						SetUpDay(InstancesMC[i]);
						InstancesMC[i].Date.text = myXML.forecast.time[i].@day.substr(5, 5);
						InstancesMC[i].Highs.text = "highs: " + myXML.forecast.time[i].temperature.@max + "F";
						InstancesMC[i].Lows.text = "Lows: " + myXML.forecast.time[i].temperature.@min + "F";
						InstancesMC[i].Code.text = myXML.forecast.time[i].symbol.@name;
					}
					break;
				}
			}	
		}
		
		function SetUpDay(clip:MovieClip): void {
				for(var count:int = 0; count < GETDATES; count++) {
		
				if (dayNum > 6)
					dayNum = 0;
				
				clip.Day.text = days[dayNum];
				dayNum++;
				
				break;
			}
		}
		
		function UpdateTime(): void {
			var minute: int;
			var AM: Boolean;
			
			var hour: String;
			var second: String;
			var ampm: String;
		
			if (new Date().hours - 11 > 0) {
				ampm = "PM"; hour = new Date().hours+ "";
				if (new Date().hours - 12 > 0)
					hour = new Date().hours - 12 + "";
			}
			else {
				ampm= "AM";
				hour = new Date().hours + "";
			}
			
			if (new Date().seconds > 9)
				second = new Date().seconds + "";
			else 
				second = "0" + new Date().seconds;
			
			if (new Date().minutes > 9)
				Master_MC.CurrentTime.text = hour + ":" + new Date().minutes + ":" + second + " " + ampm; 
			else
				Master_MC.CurrentTime.text = hour + ":0" + new Date().minutes + ":" + second + " " + ampm;
		}
		
		function CreateButton(): void {
		
			var tf:TextFormat = new TextFormat();
			//tf.size = 12;
			tf.bold = false;
			tf.font = "Arial"
			tf.color = 0x000099;			
			
			textLocation = new TextField();		     //Button
			textLocation.type = TextFieldType.INPUT; // text.
			textLocation.defaultTextFormat = tf;
			textLocation.border = true;
			textLocation.borderColor = 0x000099;
			textLocation.wordWrap = true;
			textLocation.height = 25;
			textLocation.width = 150;
			textLocation.x = 190;
			textLocation.y = 560;
			
			//text.text.align.CENTER;
			addChild(textLocation);
			
			button.graphics.clear();
			button.graphics.beginFill(0xD4D4D4); // Grey color
			button.graphics.drawRoundRect(365, 560, 80, 25, 10, 10); //x, y, width, height, ellipseW, ellipseH
			
			button.graphics.endFill();
			
			var tf2:TextFormat = new TextFormat();
			//tf.size = 12;
			tf2.bold = false;
			tf2.font = "Arial"
			tf2.color = 0x000099;
			tf2.bold = true;
			
			var buttonText: TextField = new TextField();
			buttonText.defaultTextFormat = tf2;
			buttonText.text = "Submit";
			buttonText.x = 382;
			buttonText.y = 562;
			//buttonText.= 0xE1ECED;
			buttonText.selectable = false;
			button.addEventListener(MouseEvent.CLICK, ButtonPressed);
			
			button.addChild(buttonText);
			
			addChild(button);
		}
		
		function ButtonPressed(event:MouseEvent): void {
			var mySharedObject:SharedObject = SharedObject.getLocal("republicofcode");
			mySharedObject.data.location = textLocation.text;
			mySharedObject.flush();
		
			 
			locationState = textLocation.text.split(", ");			 
			var state: String = locationState[1];
			
			var comfirmCity:URLLoader = new URLLoader();
			comfirmCity.load(new URLRequest("http://api.sba.gov/geodata/primary_city_links_for_state_of/"+state+".xml"));
			comfirmCity.addEventListener(Event.COMPLETE, ComfirmXML);
		}
		
		public function ComfirmXML(event: Event): void {
			comfirmXML  = new XML(event.target.data);
			match = false;
		
			for (var size:int = 0; size < comfirmXML.@count; size++) {
				
				if (comfirmXML.site[size].name.contains(locationState[0]))
					match = true;
			}
			
			if (match) {
				removeChild(text);
				removeChild(button);
				removeChild(Master_MC);
				
				var myLoader:URLLoader = new URLLoader();
				
				myLoader.load(new URLRequest("http://api.openweathermap.org/data/2.5/forecast/daily?q="+ textLocation.text +"&mode=xml&units=imperial&cnt=7&nocache="+ new Date().getTime()));
				myLoader.addEventListener(Event.COMPLETE, processXML);
			} else {
				trace("City not found in that state!");
			}
		}
	}
}