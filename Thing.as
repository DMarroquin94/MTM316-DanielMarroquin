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
		var button:Sprite;
		var buttonText: TextField;
		
		var once: int =  0;
		
		var tf:TextFormat;
		var tf2:TextFormat
		
		var today:TextFormat;		
			
		var today2:TextFormat;
		var date:TextField;
		var highs:TextField;
		var lows:TextField;
		var code:TextField;
		
		var buttonText2:TextField;
		
		var Dates:Array = new Array(GETDATES);
		var InstancesMC:Array = new Array(GETDATES);
		
		var match:Boolean;
		
		var locationState: Array;
		
		public function processXML(e: Event): void {
			myXML = new XML(e.target.data);
			setStage();
			Master_MC.LoadingText.visible = false;
		}

		public function Thing(): void {
			
			var myLoader:URLLoader = new URLLoader();
			
			days = [
				"Sunday",
				"Monday", 
				"Tuesday",
				"Wednesday",
				"Thursday",
				"Friday",
				"Saturday"
			];
			Master_MC = new MasterMC;
				
			
			myLoader.load(new URLRequest("http://api.openweathermap.org/data/2.5/forecast/daily?q=Salt+Lake+City,UT&mode=xml&units=imperial&cnt=7&nocache="+ new Date().getTime()));
			Master_MC.LoadingText.visible = true;
			myLoader.addEventListener(Event.COMPLETE, processXML);
			
		}
		
		public function setStage(): void {
			
		if (once == 0) 		{
			once++;
			Master_MC.Location.selectable = false;
				Master_MC.ErrorText.selectable = false;
				Master_MC.x = 0;
				Master_MC.y = 0;
				Master_MC.addEventListener(Event.ENTER_FRAME, MasterMCPlaying);
				addChild(Master_MC);
				CreateButton();
		}
				
			
			Master_MC.Location.text = myXML.location.name;
			Master_MC.ErrorText.visible = false;
				
			SetWeekUp();
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
		
		function SetUpToday(): void {			
			
			TodayDay();
			RestOfTheWeek();
			
			Master_MC.Day1.Day.text = "";
			Master_MC.Day1.Date.text = "";
			Master_MC.Day1.Highs.text = "";
			Master_MC.Day1.Lows.text = "";
			Master_MC.Day1.Code.text = "";
		}
		
		function TodayDay(): void {
			if (today == null) {
				today = new TextFormat();
				today.size = 30;
				today.bold = false;
				today.font = "Comic Sans MS"
				today.color = 0x000099;		
				today.align = TextFormatAlign.CENTER;
			}
			
			if (text == null) {
				text = new TextField();		     //Button
				text.defaultTextFormat = today;
				text.wordWrap = true;
				text.height = 50;
				text.width = 150;
				text.x = 400;
				text.y = 100;
				text.selectable = false;
				addChild(text);
			}
			
			text.text = Master_MC.Day1.Day.text;
			
			
		}
		
		function RestOfTheWeek(): void {
			if (today2 == null) {
				today2 = new TextFormat();
				today2.size = 28;
				today2.bold = false;
				today2.font = "Comic Sans MS"
				today2.color = 0xFFFFFF;
				today2.align = TextFormatAlign.CENTER;
			}
			
			if (date == null) {
				
				var datetf: TextFormat = new TextFormat();
				datetf.size = 18;
				datetf.bold = false;
				datetf.font = "Comic Sans MS"
				datetf.color = 0xFFFFFF;
				datetf.align = TextFormatAlign.CENTER
				
				date = new TextField();
				date.defaultTextFormat = datetf;
				date.height = 50;
				date.width = 150;
				date.x = 400;
				date.y = 140;
				date.selectable = false;
				addChild(date); 
			}
			
			date.text = Master_MC.Day1.Date.text;
			
			if (highs == null) {
				highs = new TextField();
				highs.defaultTextFormat = today2;
				highs.height = 50;
				highs.width = 150;
				highs.x = 400;
				highs.y = 155;
				highs.selectable = false;
				addChild(highs); 
			}
			
			highs.text = Master_MC.Day1.Highs.text;
			
			if (lows == null) {
			    lows = new TextField();
				lows.defaultTextFormat = today2;
				lows.height = 50;
				lows.width = 150;
				lows.x = 400;
				lows.y = 190;
				lows.selectable = false;
				addChild(lows); 
			}
			
			lows.text = Master_MC.Day1.Lows.text;
			
			if (code == null) {

				var codetf:TextFormat = new TextFormat();
				codetf.size = 22;
				codetf.bold = false;
				codetf.font = "Comic Sans MS"
				codetf.color = 0xFFFFFF;
				codetf.align = TextFormatAlign.CENTER
				
				
				code = new TextField();
				code.defaultTextFormat = codetf;
				code.height = 75;
				code.width = 150;
				code.x = 400;
				code.y = 225;
				code.multiline = true;
				code.selectable = false;
				addChild(code);
			}
			
			code.text = Master_MC.Day1.Code.text;
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
							InstancesMC[i].gotoAndStop(2);
						
						SetUpDay(InstancesMC[i]);
						
						var high:int = myXML.forecast.time[i].temperature.@max;
						var low:int = myXML.forecast.time[i].temperature.@min;
						
						InstancesMC[i].Date.text = myXML.forecast.time[i].@day.substr(5, 5);
						InstancesMC[i].Highs.text = "Highs: " + high + "F";
						InstancesMC[i].Lows.text = "Lows: " + low + "F";
						InstancesMC[i].Code.text = myXML.forecast.time[i].symbol.@name;
						
						InstancesMC[i].Day.selectable = false;
						InstancesMC[i].Date.selectable = false;
						InstancesMC[i].Highs.selectable = false;
						InstancesMC[i].Lows.selectable = false;
						InstancesMC[i].Code.selectable = false;
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
			
			Master_MC.CurrentTime.selectable = false;
		}
		
		function CreateButton(): void {
		
			if (tf == null) {
				tf = new TextFormat();
				tf.size = 15;
				tf.bold = false;
				tf.font = "Arial"
				tf.color = 0x000099;
				tf.align = TextFormatAlign.CENTER;
			}
			if (textLocation == null) {
				textLocation = new TextField();		     //Button
				textLocation.type = TextFieldType.INPUT; // text.
				textLocation.defaultTextFormat = tf;
				textLocation.border = true;
				textLocation.borderColor = 0x000099;
				textLocation.background = true;
				textLocation.backgroundColor = 0xFFFFFF;
				textLocation.wordWrap = true;
				textLocation.height = 23;
				textLocation.width = 150;
				textLocation.x = 355;
				textLocation.y = 562;
				
				addChild(textLocation); 
			}
			
			if (button == null) {
				button = new Sprite();	
				button.graphics.clear();
				button.graphics.beginFill(0xFFFFFF); // Grey color
				button.graphics.drawRoundRect(515, 562, 80, 23, 10, 10); //x, y, width, height, ellipseW, ellipseH
				button.graphics.endFill();
			}
			
			if (tf2 == null) {
				tf2  = new TextFormat();
				//tf.size = 12;
				tf2.bold = false;
				tf2.font = "Arial"
				tf2.color = 0x000099;
				tf2.bold = true;
			}
			
			if (buttonText == null) {
				buttonText = new TextField();
				buttonText.defaultTextFormat = tf2;
				buttonText.text = "Submit";
				buttonText.x = 532;
				buttonText.y = 564;

				buttonText.selectable = false;
			}
			
			button.addChild(buttonText);
			
			button.addEventListener(MouseEvent.CLICK, ButtonPressed);
			button.addEventListener(MouseEvent.MOUSE_OVER, MouseOverButton);
			button.addEventListener(MouseEvent.MOUSE_OUT, MouseOutofButton);
			button.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownonButton);
			button.addEventListener(MouseEvent.MOUSE_UP, MouseUponButton);
			addChild(button);
		}
	
		function MouseUponButton(event: MouseEvent): void {
			button.graphics.clear();
				button.graphics.beginFill(0x0000FF); // Grey color
				button.graphics.drawRoundRect(515, 562, 80, 23, 10, 10); //x, y, width, height, ellipseW, ellipseH
				button.graphics.endFill();
			
				var tf3: TextFormat= new TextFormat();
			tf3.color = 0xFFFFFF;
			//tf3.bold = false;
				tf3.font = "Arial";
			
			
				//buttonText2  = new TextField();
					tf3.size = 12;
				buttonText.x = 532;
				buttonText.y = 564;
				buttonText.defaultTextFormat = tf3;
				buttonText.text = "Submit";
				buttonText.selectable = false;
		}
		
		function MouseDownonButton(event:MouseEvent): void {
				button.graphics.clear();
				button.graphics.beginFill(0x000099); // Grey color
				button.graphics.drawRoundRect(518, 565, 70, 19, 10, 10); //x, y, width, height, ellipseW, ellipseH
				button.graphics.endFill();
			
				var tf4: TextFormat= new TextFormat();
				tf4.size = 10;
				buttonText.defaultTextFormat = tf4;
				buttonText.text = "Submit";
				buttonText.x = 532;
				buttonText.y = 566;

		}
		
		function MouseOutofButton(event:MouseEvent) : void {
				button.graphics.clear();
				button.graphics.beginFill(0xFFFFFF); // Grey color
				button.graphics.drawRoundRect(515, 562, 80, 23, 10, 10); //x, y, width, height, ellipseW, ellipseH
				button.graphics.endFill();
			
				buttonText.defaultTextFormat = tf2;
				buttonText.text = "Submit";
				buttonText.x = 532;
				buttonText.y = 564;

				buttonText.selectable = false;
		}		
		
		function MouseOverButton(event:MouseEvent): void {
				button.graphics.clear();
				button.graphics.beginFill(0x0000FF); // Grey color
				button.graphics.drawRoundRect(515, 562, 80, 23, 10, 10); //x, y, width, height, ellipseW, ellipseH
				button.graphics.endFill();
			
			//button.removeChild(buttonText);
				var tf3: TextFormat= new TextFormat();
			tf3.color = 0xFFFFFF;
			//tf3.bold = false;
				tf3.font = "Arial";
			
			
				//buttonText2  = new TextField();
				tf3.size = 12;
				buttonText.x = 532;
				buttonText.y = 564;
				buttonText.defaultTextFormat = tf3;
				buttonText.text = "Submit";
				buttonText.selectable = false;
			//button.addChild(buttonText2);
		}
		
		function ButtonPressed(event:MouseEvent): void {
			var mySharedObject:SharedObject = SharedObject.getLocal("republicofcode");
			mySharedObject.data.location = textLocation.text;
			mySharedObject.flush();
		
			locationState = textLocation.text.split(", ");			 
			var state: String = locationState[1];
			
			var comfirmCity:URLLoader = new URLLoader();
			if (state == null)
				Master_MC.ErrorText.visible = true;
			else {
				Master_MC.ErrorText.visible = false;
			comfirmCity.load(new URLRequest("http://api.sba.gov/geodata/primary_city_links_for_state_of/"+state+".xml"));
			comfirmCity.addEventListener(Event.COMPLETE, ComfirmXML);
			}
		}
		
		public function ComfirmXML(event: Event): void {
			comfirmXML  = new XML(event.target.data);
			match = false;
		
			for (var size:int = 0; size < comfirmXML.@count; size++) {
				var cityName:String = comfirmXML.site[size].name.toLowerCase();
				if (comfirmXML.site[size].name.contains(locationState[0]))
					match = true;
		
			}
			if (match ) {
				var myLoader:URLLoader = new URLLoader();
				
				myLoader.load(new URLRequest("http://api.openweathermap.org/data/2.5/forecast/daily?q="+ textLocation.text +"&mode=xml&units=imperial&cnt=7&nocache="+ new Date().getTime()));
				Master_MC.LoadingText.visible = true;
				myLoader.addEventListener(Event.COMPLETE, processXML);
				
				textLocation.text = "";
			} else {
				Master_MC.ErrorText.visible = true;
			}
		}
	}
}