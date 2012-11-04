package 
{
	// the way to calculate notes is the 
	//desired frequency = 2 ^ semitones/notes between one "octave" * the previous note(220 or 440)
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*; 
	import flash.media.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.utils.ByteArray;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import soundGrid.*;
	/**
	 * ...
	 * @author sd
	 */
	[Frame(factoryClass = "Preloader")]
	[SWF(width="800", height="600",  frameRate = 30, backgroundColor="#000033")]
	public class Main extends Sprite 
	{
		
		
		private var buttons:Vector.<Vector.<soundButton>>; 
		/*
		 * // a vector of soundButton vectors. Each vector is one chord,
			or point in time. each entry in it's soundButton vectors determines if a pitch is played.
		 *  buttons[0][2] is the thrid sound in the first chord.
		 * 
		 * */
		public var loadButton:scaleButton;
		public var saveButton:scaleButton;
		
		
		public var songSaveButton:scaleButton;
		
		public var tempoButton:scaleButton;
		public var pitchButton:scaleButton;
		
		public var scaleButtons:Vector.<SimpleButton>;
		public var offsetDisplays:Vector.<TextField>;
		
		public var toggleSound:Boolean = false;
		
		public var scaleText1:TextField;
		public var scaleText2:TextField;
		public var scaleText3:TextField;
		public var scaleText4:TextField;
		public var scaleText5:TextField;
		public var tempoText:TextField;
		public var pitchText:TextField;
		public var muteText:TextField;
		
		public var changingNotesDisplay:TextField;
		public var musicFormatDisplay:TextField;
		public var octaveDisplay:TextField;
		public var subdivisionDisplay:TextField;
		public var xDisplay:TextField;
		
		public var octaveSize:TextField;
		public var subdivisionsEdit:TextField;
		public var optionsDisplay:TextField;
		public var soundChangeDisplay:TextField;
		public var octaveEditSmall:TextField;
		public var subdivisionsDisplaySmall:TextField;
		public var shareDisplay:TextField;



		public var shareString:String;		
		
		public var fontMania:TextFormat;
		public var fontMania2:TextFormat;
		public var fontMania3:TextFormat;
		public var fontMania4:TextFormat;
		
		public var fontOfssets:TextFormat;
		
		public var shapely:Shape = new Shape();
		public var shapely1:Shape = new Shape();
		public var shapely2:Shape = new Shape();
		public var shapely3:Shape = new Shape();
		public var shapely4:Shape = new Shape();
		public var shapely5:Shape = new Shape();
		public var shapely6:Shape = new Shape();
		public var divisionLine:Shape = new Shape();
		
		public var notes:Vector.<Sound>;
		public var offsets:Vector.<int>;
		public var channels:SoundChannel;
		public var mySound:Sound = new Sound();
		public var soundChannel1:SoundChannel;
		
		
		private var greenArrows:Vector.<UpArrow>;
		private var redArrows:Vector.<DownArrow>;
		private var octaveUpArrow:UpArrow;
		private var subdivisionUpArrow:UpArrow;
		private var octaveDownArrow:DownArrow;
		private var subdivisionDownArrow:DownArrow;
		
		private var repeatChecker:int = 0;
		
		
		private var frequencies:Vector.<Number>;
		private var timbre:Number = 0.0;
		private var soundLength:int = 11025; //default 11025
		private var positionOfGrid:int = 0; 
		private var limiter:int = 0;
		private var limiterCheck:int = 3;
		private var key:Number = 220.0; //default - 440 (a)
		private var octave:int = 2; //(default  - 2 (western octaves)
		private var subdivisions:int = 12; //default - 12 (western subdivisions)
		
		private var muteButton:scaleButton;
		private var soundChangeButton:scaleButton;
		
		public var sharePop:shareWindow;
		
		private var toneOutput:XML;
		private var xmlByteArray:ByteArray; 
		private var xmlFileReference:FileReference;

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			
			stage.quality = StageQuality.LOW;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyPressed);
			
			tempoButton = new scaleButton;
			pitchButton = new scaleButton;
			octaveUpArrow = new UpArrow;
			subdivisionUpArrow = new UpArrow;
			octaveDownArrow = new DownArrow;
			subdivisionDownArrow = new DownArrow;
			
			
			toneOutput = new XML;
			xmlByteArray = new ByteArray; 
			xmlFileReference new FileReference;
			
			shapely = new Shape();
			
			shapely = new Shape();
			shapely.graphics.beginFill(0xFFFFFF);
			shapely.graphics.drawRect(0, 0, 30, 30);
			
			
			var someinterger:int = 650
			shapely1 = new Shape(); //backgrounds for options
			shapely1.graphics.beginFill(0x3F3F65);
			shapely1.graphics.drawRect(someinterger, 5, 800-655, 30);
			shapely1.visible = true;
			this.addChild(shapely1);
			
			
			shapely2 = new Shape();
			shapely2.graphics.beginFill(0x3F3F65);
			shapely2.graphics.drawRect(someinterger, 38, 800-655, 207);
			shapely2.visible = true;
			this.addChild(shapely2);
			
			shapely3 = new Shape();
			shapely3.graphics.beginFill(0x3F3F65);
			shapely3.graphics.drawRect(someinterger, 205+5+28+12, 800-655, 28);
			shapely3.visible = true;
			this.addChild(shapely3);
			
			shapely4 = new Shape();
			shapely4.graphics.beginFill(0x3F3F65);
			shapely4.graphics.drawRect(someinterger, 30+205+5+28+12, 800-655, 146);
			shapely4.visible = true;
			this.addChild(shapely4);
			
			shapely5 = new Shape();
			shapely5.graphics.beginFill(0x3F3F65);
			shapely5.graphics.drawRect(someinterger, 150+30+205+5+28+12, 800-655, 30);
			shapely5.visible = true;
			this.addChild(shapely5);
			
			shapely6 = new Shape();
			shapely6.graphics.beginFill(0x3F3F65);
			shapely6.graphics.drawRect(someinterger, 32+150+30+205+5+28+12, 800-655, 103);
			shapely6.visible = true;
			this.addChild(shapely6);
			
			
			
			scaleText1 = new TextField();
			scaleText2 = new TextField();
			scaleText3 = new TextField();
			scaleText4 = new TextField();
			scaleText5 = new TextField();
			pitchText = new TextField();
			tempoText = new TextField();
			muteText = new TextField();
			
			changingNotesDisplay = new TextField();
			musicFormatDisplay = new TextField();
			octaveDisplay = new TextField();
			subdivisionDisplay = new TextField();
			xDisplay = new TextField();
		
			octaveSize = new TextField();
			subdivisionsEdit = new TextField();
			optionsDisplay = new TextField();
			soundChangeDisplay = new TextField();
			octaveEditSmall = new TextField();
			subdivisionsDisplaySmall = new TextField();
			
			shareDisplay = new TextField();
			
			fontMania = new TextFormat("_sans", 13);
			fontMania2 = new TextFormat("_sans",20);
			fontMania3 = new TextFormat("_sans", 19);
			fontMania4 = new TextFormat("_sans", 60);
			fontOfssets = new TextFormat("_sans", 32);
			
			scaleText1.defaultTextFormat = fontMania;
			scaleText2.defaultTextFormat = fontMania;
			scaleText3.defaultTextFormat = fontMania;
			scaleText4.defaultTextFormat = fontMania;
			scaleText5.defaultTextFormat = fontMania;
			tempoText.defaultTextFormat = fontMania;
			pitchText.defaultTextFormat = fontMania;
			muteText.defaultTextFormat = fontMania;
			shareDisplay.defaultTextFormat = fontMania;
			
			changingNotesDisplay.defaultTextFormat = fontMania2;
			musicFormatDisplay.defaultTextFormat = fontMania2;
			octaveDisplay.defaultTextFormat = fontMania4;
			subdivisionDisplay.defaultTextFormat = fontMania3;
			xDisplay.defaultTextFormat = fontMania3;
		
			octaveSize.defaultTextFormat = fontMania;
			subdivisionsEdit.defaultTextFormat = fontMania;
			optionsDisplay.defaultTextFormat = fontMania2;
			soundChangeDisplay.defaultTextFormat = fontMania;
			octaveEditSmall.defaultTextFormat = fontMania;
			subdivisionsDisplaySmall.defaultTextFormat = fontMania;
			
			scaleText1.text = "Western 12 tone scales";
			scaleText2.text = "Bohlen–Pierce scales";
			scaleText3.text = "Arabian 24 tone scales";
			scaleText4.text = "Save";
			scaleText5.text = "Load";
			tempoText.text = "Change tempo";
			pitchText.text = "Change Pitch";
			muteText.text = "Mute/Unmute";
			shareDisplay.text = "Share";
			
			changingNotesDisplay.text = "Changing Notes";
			musicFormatDisplay.text = "Music Format";
			octaveDisplay.text = octave.toString();
			subdivisionDisplay.text = subdivisions.toString();
			xDisplay.text = "x";
			octaveSize.text = "Octave Size";
			subdivisionsEdit.text = subdivisions.toString();
			optionsDisplay.text = "Options";
			soundChangeDisplay.text = "Change Sound";
			octaveEditSmall.text = octave.toString();
			subdivisionsDisplaySmall.text = "Subdivisions";
			
			
			
			
			scaleText1.x = 655;
			scaleText1.y = 40;
			
			scaleText1.textColor = 0xFFFFFF;
			scaleText1.autoSize = TextFieldAutoSize.LEFT;
			
			scaleText1.visible = true;
			this.addChild(scaleText1);
			
			scaleText2.x = 655;
			scaleText2.y = 80;
			
			scaleText2.textColor = 0xFFFFFF;
			scaleText2.autoSize = TextFieldAutoSize.LEFT;
			
			scaleText2.visible = true;
			this.addChild(scaleText2);
			
			scaleText3.x = 655;
			scaleText3.y = 120;
			
			scaleText3.textColor = 0xFFFFFF;
			scaleText3.autoSize = TextFieldAutoSize.LEFT;
			
			scaleText3.visible = true;
			this.addChild(scaleText3);
			
			scaleText4.x = 655;
			scaleText4.y = 160;
			
			scaleText4.textColor = 0xFFFFFF;
			scaleText4.autoSize = TextFieldAutoSize.LEFT;
			
			scaleText4.visible = true;
			this.addChild(scaleText4);
			
			scaleText5.x = 655;
			scaleText5.y = 200;
			
			scaleText5.textColor = 0xFFFFFF;
			scaleText5.autoSize = TextFieldAutoSize.LEFT;
			
			scaleText5.visible = true;
			this.addChild(scaleText5);
			
			changingNotesDisplay.x = 652;
			changingNotesDisplay.y = 5;
			
			changingNotesDisplay.textColor = 0xFFFFFF;
			changingNotesDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			changingNotesDisplay.visible = true;
			this.addChild(changingNotesDisplay);
			
			musicFormatDisplay.x = 662;
			musicFormatDisplay.y = 250;
			
			musicFormatDisplay.textColor = 0xFFFFFF;
			musicFormatDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			musicFormatDisplay.visible = true;
			this.addChild(musicFormatDisplay);
			
			octaveDisplay.x = 690;
			octaveDisplay.y = 305;
			
			octaveDisplay.textColor = 0xFFFFFF;
			octaveDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			octaveDisplay.visible = true;
			this.addChild(octaveDisplay);
			
			subdivisionDisplay.x = 723;
			subdivisionDisplay.y = 301;
			
			subdivisionDisplay.textColor = 0xFFFFFF;
			subdivisionDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			subdivisionDisplay.visible = true;
			this.addChild(subdivisionDisplay);
			
			xDisplay.x = 730;
			xDisplay.y = 280;
			
			xDisplay.textColor = 0xFFFFFF;
			xDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			xDisplay.visible = true;
			this.addChild(xDisplay);
			
			octaveSize.x = 660;
			octaveSize.y = 370;
			
			octaveSize.textColor = 0xFFFFFF;
			octaveSize.autoSize = TextFieldAutoSize.LEFT;
			
			octaveSize.visible = true;
			this.addChild(octaveSize);
			
			octaveEditSmall.x = 742;
			octaveEditSmall.y = 370;
			
			octaveEditSmall.textColor = 0xFFFFFF;
			octaveEditSmall.autoSize = TextFieldAutoSize.LEFT;
			
			octaveEditSmall.visible = true;
			this.addChild(octaveEditSmall);
			
			subdivisionsEdit.x = 742;//////////////////////////////////
			subdivisionsEdit.y = 390;
			
			subdivisionsEdit.textColor = 0xFFFFFF;
			subdivisionsEdit.autoSize = TextFieldAutoSize.LEFT;
			
			subdivisionsEdit.visible = true;
			this.addChild(subdivisionsEdit);
			
			subdivisionsDisplaySmall.x = 659;
			subdivisionsDisplaySmall.y = 390;
			
			subdivisionsDisplaySmall.textColor = 0xFFFFFF;
			subdivisionsDisplaySmall.autoSize = TextFieldAutoSize.LEFT;
			
			subdivisionsDisplaySmall.visible = true;
			this.addChild(subdivisionsDisplaySmall);
			
			optionsDisplay.x = 686;
			optionsDisplay.y = 430;
			
			optionsDisplay.textColor = 0xFFFFFF;
			optionsDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			optionsDisplay.visible = true;
			this.addChild(optionsDisplay);
			
			pitchText.x = 658;
			pitchText.y = 493;
			
			tempoText.x = 658;
			tempoText.y = 468;
			
			tempoText.textColor = 0xFFFFFF;
			tempoText.autoSize = TextFieldAutoSize.LEFT;
			
			tempoText.visible = true;
			this.addChild(tempoText);
			
			pitchText.x = 658;
			pitchText.y = 493;
			
			pitchText.textColor = 0xFFFFFF;
			pitchText.autoSize = TextFieldAutoSize.LEFT;
			
			pitchText.visible = true;
			this.addChild(pitchText);
			
			soundChangeDisplay.x = 658;
			soundChangeDisplay.y = 517;
			
			soundChangeDisplay.textColor = 0xFFFFFF;
			soundChangeDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			soundChangeDisplay.visible = true;
			this.addChild(soundChangeDisplay);
			
			muteText.x = 658;
			muteText.y = 540;
			
			muteText.textColor = 0xFFFFFF;
			muteText.autoSize = TextFieldAutoSize.LEFT;
			
			muteText.visible = true;
			this.addChild(muteText);
			
			shareDisplay.x = 735;
			shareDisplay.y = 160;
			
			
			shareDisplay.textColor = 0xFFFFFF;
			shareDisplay.autoSize = TextFieldAutoSize.LEFT;
			
			shareDisplay.visible = true;
			this.addChild(shareDisplay);
			
		
			divisionLine = new Shape();
			divisionLine.graphics.lineStyle(1, 0xFFFFFF, 1);
			divisionLine.graphics.beginFill(0xFFFFFF);
			divisionLine.graphics.moveTo(0, 0);
			divisionLine.graphics.lineTo(21, 0);
			divisionLine.x = 727;
			divisionLine.y = 304;
			divisionLine.visible = true;
			this.addChild(divisionLine);
			
			
			loadButton = new scaleButton();
			saveButton = new scaleButton();
			
			scaleButtons = new Vector.<SimpleButton>;
			for (var k1:int = 0; k1 < 16; k1++)
			{
				scaleButtons.push(new scaleButton);
			}
			
			
			/*scaleButton1 = new SimpleButton(shapely1, shapely1, shapely1, shapely1);
			scaleButton2 = new SimpleButton(shapely2, shapely2, shapely2, shapely2);
			scaleButton3 = new SimpleButton(shapely3, shapely3, shapely3, shapely3);
			scaleButton4 = new SimpleButton(shapely4, shapely4, shapely4, shapely4);*/
			
			
			loadButton.x = 657;
			loadButton.y = 222;
			loadButton.visible = true;
			loadButton.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
			this.addChild(loadButton);
			loadButton.addEventListener(MouseEvent.CLICK, loadClicked);
			
			saveButton.x = 657;
			saveButton.y = 182;
			saveButton.visible = true;
			saveButton.transform.colorTransform = new ColorTransform(0, 1, 0, 1, 0, 0, 0, 0);
			this.addChild(saveButton);
			saveButton.addEventListener(MouseEvent.CLICK, saveClicked);
			
			songSaveButton = new scaleButton;
			songSaveButton.x = 735;
			songSaveButton.y = 182;
			songSaveButton.width = 50;
			songSaveButton.height = 50;
			songSaveButton.transform.colorTransform = new ColorTransform(1, 0, 1, 1, 0, 0, 0, 0);
			songSaveButton.visible = true;
			this.addChild(songSaveButton);
			songSaveButton.addEventListener(MouseEvent.CLICK, shareSongClicked);
			
			octaveDownArrow.x = 765;
			octaveDownArrow.y = 373;
			octaveDownArrow.visible = true;			
			this.addChild(octaveDownArrow);
			octaveDownArrow.addEventListener(MouseEvent.CLICK, downOctavePressed);
			
			octaveUpArrow.x = 780;
			octaveUpArrow.y = 372;
			octaveUpArrow.visible = true;			
			this.addChild(octaveUpArrow);
			octaveUpArrow.addEventListener(MouseEvent.CLICK, upOctavePressed);
			
			subdivisionDownArrow.x = 765;
			subdivisionDownArrow.y = 394;
			subdivisionDownArrow.visible = true;			
			this.addChild(subdivisionDownArrow);
			subdivisionDownArrow.addEventListener(MouseEvent.CLICK, downSubdivisionPressed);
			
			subdivisionUpArrow.x = 780;
			subdivisionUpArrow.y = 394;
			subdivisionUpArrow.visible = true;			
			this.addChild(subdivisionUpArrow);
			subdivisionUpArrow.addEventListener(MouseEvent.CLICK, upSubdivisionPressed);
			
			tempoButton.x = 757;
			tempoButton.y = 468+3;
			tempoButton.visible = true;
			tempoButton.transform.colorTransform = new ColorTransform(1, 1, 0, 1, 0, 0, 0, 0);
			this.addChild(tempoButton);
			tempoButton.addEventListener(MouseEvent.CLICK, clickedTempo);
			
			
			
			tempoButton.x = 757;
			tempoButton.y = 468+3;
			tempoButton.visible = true;
			tempoButton.transform.colorTransform = new ColorTransform(1, 1, 0, 1, 0, 0, 0, 0);
			this.addChild(tempoButton);
			tempoButton.addEventListener(MouseEvent.CLICK, clickedTempo);
			
			
			pitchButton.x = 757;
			pitchButton.y = 493+3;
			pitchButton.visible = true;
			pitchButton.transform.colorTransform = new ColorTransform(0, 1, 1, 1, 0, 0, 0, 0);
			this.addChild(pitchButton);
			pitchButton.addEventListener(MouseEvent.CLICK, clickedPitch);
			
			soundChangeButton = new scaleButton();
			soundChangeButton.x = 757;
			soundChangeButton.y = 520;
			soundChangeButton.visible = true;
			addChild(soundChangeButton);
			soundChangeButton.addEventListener(MouseEvent.CLICK, soundChangePressed);
			
			muteButton = new scaleButton();
			muteButton.x = 757;
			muteButton.y =  541+3;
			muteButton.visible = true;
			addChild(muteButton);
			muteButton.addEventListener(MouseEvent.CLICK, mutePressed);
			
			
			
			scaleButtons[0].x = 657;
			scaleButtons[0].y = 65;
			scaleButtons[0].visible = true;
			this.addChild(scaleButtons[0]);
			scaleButtons[0].addEventListener(MouseEvent.CLICK, setScalePentMaj);
			scaleButtons[0].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[0].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[1].x = scaleButtons[0].x + 35;
			scaleButtons[1].y = scaleButtons[0].y;
			scaleButtons[1].visible = true;
			this.addChild(scaleButtons[1]);
			scaleButtons[1].addEventListener(MouseEvent.CLICK, setScaleBlues);
			scaleButtons[1].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[1].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[2].x = scaleButtons[1].x + 35;
			scaleButtons[2].y = scaleButtons[0].y;
			scaleButtons[2].visible = true;
			this.addChild(scaleButtons[2]);
			scaleButtons[2].addEventListener(MouseEvent.CLICK, setScaleDminished);
			scaleButtons[2].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[2].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[3].x = scaleButtons[2].x + 35;
			scaleButtons[3].y = scaleButtons[0].y;
			scaleButtons[3].visible = true;
			this.addChild(scaleButtons[3]);
			scaleButtons[3].addEventListener(MouseEvent.CLICK, setScaleWholeTone);
			scaleButtons[3].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[3].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[4].x = 657;
			scaleButtons[4].y = 102;
			scaleButtons[4].visible = true;
			this.addChild(scaleButtons[4]);
			scaleButtons[4].addEventListener(MouseEvent.CLICK, setScaleLambdaPierce);
			scaleButtons[4].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[4].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[5].x = scaleButtons[4].x +35;
			scaleButtons[5].y = scaleButtons[4].y;
			scaleButtons[5].visible = true;
			this.addChild(scaleButtons[5]);
			scaleButtons[5].addEventListener(MouseEvent.CLICK, setScaleMoll1Pierce);
			scaleButtons[5].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[5].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[6].x = scaleButtons[5].x +35;
			scaleButtons[6].y = scaleButtons[4].y;
			scaleButtons[6].visible = true;
			this.addChild(scaleButtons[6]);
			scaleButtons[6].addEventListener(MouseEvent.CLICK, setScaleDur2Pierce);
			scaleButtons[6].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[6].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[7].x = scaleButtons[6].x + 35;
			scaleButtons[7].y = scaleButtons[4].y;
			scaleButtons[7].visible = true;
			this.addChild(scaleButtons[7]);
			scaleButtons[7].addEventListener(MouseEvent.CLICK, setScaleChromPierce);
			scaleButtons[7].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[7].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[8].x = 657 ;
			scaleButtons[8].y = 142;
			scaleButtons[8].visible = true;
			this.addChild(scaleButtons[8]);
			scaleButtons[8].addEventListener(MouseEvent.CLICK, setScaleArab24Bastanikar);
			scaleButtons[8].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[8].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[9].x = scaleButtons[8].x + 35;
			scaleButtons[9].y = scaleButtons[8].y;
			scaleButtons[9].visible = true;
			this.addChild(scaleButtons[9]);
			scaleButtons[9].addEventListener(MouseEvent.CLICK, setScaleArab24Sikah);
			scaleButtons[9].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[9].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			scaleButtons[10].x = scaleButtons[9].x + 35;
			scaleButtons[10].y = scaleButtons[8].y;
			scaleButtons[10].visible = true;
			this.addChild(scaleButtons[10]);
			scaleButtons[10].addEventListener(MouseEvent.CLICK, setScaleArab24RahatElArwah);
			scaleButtons[10].addEventListener(MouseEvent.ROLL_OVER, mouseOverButton);
			scaleButtons[10].addEventListener(MouseEvent.ROLL_OUT, mouseAwayButton);
			
			
			
			buttons = new Vector.<Vector.<soundButton>>; 
			notes = new Vector.<Sound>;
			channels = new SoundChannel;
			frequencies = new Vector.<Number>;
			offsets = new Vector.<int>;
			offsetDisplays = new Vector.<TextField>;
			redArrows = new Vector.<DownArrow>;
			greenArrows = new Vector.<UpArrow>;
			
			//grid creation.
			
			for (var j:int = 0; j < 16 ; j++)
			{
				buttons.push(new Vector.<soundButton>);
				
				for (var i:int = 0; i < 16 ; i++)
				{
					
					buttons[j].push(new soundButton());
					buttons[j][i].y = (561- (i * 37.5) + 5);
					buttons[j][i].x  = (j * 37.5) + 50;
					buttons[j][i].visible = true;
					buttons[j][i].alpha = 0.5
					this.addChild(buttons[j][i]);						
				}
				
				notes.push(new Sound());		
					
				offsets.push(j);
					
				frequencies.push(Math.pow(octave, (j) / subdivisions) * key);
					
				
				offsetDisplays.push(new TextField());
				offsetDisplays[j].x = 13;
				offsetDisplays[j].y = (561 - (j * 37.5)); 
				offsetDisplays[j].defaultTextFormat = fontOfssets;
				offsetDisplays[j].textColor = 0xFFFFFF;
				offsetDisplays[j].autoSize = TextFieldAutoSize.LEFT;
				offsetDisplays[j].text = j.toString();
				offsetDisplays[j].visible = true;
				this.addChild(offsetDisplays[j]);
				
				
				greenArrows.push(new UpArrow);
				greenArrows[j].x = 0;
				greenArrows[j].y = (565- (j * 37.5)); 
				greenArrows[j].visible = true;
				this.addChild(greenArrows[j]);
				greenArrows[j].addEventListener(MouseEvent.CLICK, upOffsetPressed);
				
				redArrows.push(new DownArrow);
				redArrows[j].x = 0;
				redArrows[j].y = (580- (j * 37.5)); 
				redArrows[j].visible = true;
				this.addChild(redArrows[j]);
				redArrows[j].addEventListener(MouseEvent.CLICK, downOffsetPressed);
				
					
			}
			trace("pentCall");
			pentatonicMajor();
			
			channels = new SoundChannel();
			//frequencies.reverse();
			
			/*buttons[0][0].setState(true);
			buttons[1][1].setState(true);
			buttons[2][0].setState(true);
			buttons[2][1].setState(true);
			buttons[3][2].setState(true);
			buttons[4][2].setState(true);
			buttons[4][0].setState(true);
			buttons[5][2].setState(true);
			buttons[5][1].setState(true);			
			buttons[6][6].setState(true);
			buttons[7][7].setState(true);
			buttons[8][8].setState(true);
			buttons[9][9].setState(true);
			buttons[10][10].setState(true);
			buttons[11][11].setState(true);
			buttons[12][12].setState(true);
			buttons[13][13].setState(true);
			buttons[14][14].setState(true);
			buttons[15][15].setState(true);*/
			
			buttons[0][0].setState(true);
			buttons[1][1].setState(true);
			buttons[2][2].setState(true);
			buttons[3][3].setState(true);
			buttons[4][4].setState(true);
			buttons[5][5].setState(true);
			buttons[6][6].setState(true);
			buttons[7][7].setState(true);
			buttons[8][8].setState(true);
			buttons[9][9].setState(true);
			buttons[10][10].setState(true);
			buttons[11][11].setState(true);
			buttons[12][12].setState(true);
			buttons[13][13].setState(true);
			buttons[14][14].setState(true);
			buttons[15][15].setState(true);
			
			//mySound.addEventListener(SampleDataEvent.SAMPLE_DATA,sineWaveGenerator);
			//mySound.play(0, 1);
			
			sharePop = new shareWindow();
			sharePop.x = 200;
			sharePop.y = 100;
			sharePop.visible = false;
			this.addChild(sharePop);
			sharePop.addEventListener(shareSongLoadEvent.CODE_EVENT, sharedSongLoad);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
		}
		
		
		private function clickedTempo(e:MouseEvent):void
		{
			//here
			if (limiterCheck == 10)
			{
				limiterCheck = 3;
			}
			else
			{
				limiterCheck = 10;
			}
			
		}
		
		private function clickedPitch(e:MouseEvent):void
		{
			
			//here
			if (key == 220.0)
			{
				key = 440.0;
				for (var xr:int = 0; xr < 16; xr++)
				{
					frequencies[xr] = frequencies[xr] * 2;
				}
			}
			else
			{
				key = 220.0;
				for (var xx:int = 0; xx < 16; xx++)
				{
					frequencies[xx] = frequencies[xx] / 2;
				}
			}
			
		}
		
		public function mutePressed(e:MouseEvent):void
		{	
			var transform:SoundTransform = channels.soundTransform;
			if (SoundMixer.soundTransform.volume == 0)
			{
				
				transform.volume = 1;
			}
			else
			{
				transform.volume = 0;
			}
			SoundMixer.soundTransform = transform;
		}
		
		public function  soundChangePressed(e:MouseEvent):void
		{	
			toggleSound = !toggleSound;
		}
		
		public function siteClicked(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://outlash.co.uk/"));
		}
		
		private function upOffsetPressed (e:MouseEvent):void
		{
			
			
			offsets[greenArrows.indexOf(e.target)] = offsets[greenArrows.indexOf(e.target)] +1;
			offsetsBecomeDisplays();
			freqFromOff();
		}
		
		private function downOffsetPressed (e:MouseEvent):void
		{
			
			
			offsets[redArrows.indexOf(e.target)] = offsets[redArrows.indexOf(e.target)] -1;
			offsetsBecomeDisplays();
			
			freqFromOff();
		}
		
		private function upOctavePressed (e:MouseEvent):void
		{
			
			
			octave++;
			
			freqFromOff();
			offsetsBecomeDisplays();
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			
		}
		
		private function downOctavePressed (e:MouseEvent):void
		{
			
			
			octave--;
			
			freqFromOff();
			offsetsBecomeDisplays();
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
		}
		
		private function upSubdivisionPressed (e:MouseEvent):void
		{
			trace("triggered");
			
			subdivisions++;
			
			freqFromOff();
			offsetsBecomeDisplays();
			
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
		}
		
		private function downSubdivisionPressed (e:MouseEvent):void
		{
			trace("triggered");
			
			subdivisions--;
			
			freqFromOff();
			offsetsBecomeDisplays();
			
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
		}
		
		private function mouseOverButton (e:MouseEvent):void
		{
			switch(scaleButtons.indexOf(e.target))
			{
				case 0:
				{
					scaleText1.text = "Pentatonic Major";
					break;
				}
				case 1:
				{
					scaleText1.text = "Blues";
					break;
				}
				case 2:
				{
					scaleText1.text = "Diminished";
					break;
				}
				case 3:
				{
					scaleText1.text = "Whole Tone";
					break;
				}
				case 4:
				{
					scaleText2.text = "Lambda Mode";
					break;
				}
				case 5:
				{
					scaleText2.text = "Moll 1";
					break;
				}
				case 6:
				{
					scaleText2.text = "Dur 2";
					break;
				}
				case 7:
				{
					scaleText2.text = "Chromatic";
					break;
				}
				case 8:
				{
					scaleText3.text = "Bastanikar";
					break;
				}
				case 9:
				{
					scaleText3.text = "Sikah";
					break;
				}
				case 10:
				{
					scaleText3.text = "Rahat El Arwah";
					break;
				}
				default:
				{
				
					break;
				}
			}
		}
		
		private function mouseAwayButton (e:MouseEvent):void
		{
			scaleText1.text = "Western 12 tone scales";
			scaleText2.text = "Bohlen–Pierce scales";
			scaleText3.text = "Arabian 24 tone scales";
			scaleText4.text = "Save";
			scaleText5.text = "Load";
		}
		
		
		
		
		private function setScalePentMaj(e:MouseEvent):void
		{
			//here
			octave = 2;
			subdivisions = 12;
			trace("pentmake");
			pentatonicMajor();
			offsetsBecomeDisplays();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			/*for (var vb:int = 0; vb < 16; vb++)
			{
				offsetDisplays[vb].text = offsets[vb].toString();
			}*/
			
		}
		
		private function offsetsBecomeDisplays():void
		{
			trace("GOODDAY");
			for (var vrt:int = 0; vrt < 16; vrt++)
			{
				offsetDisplays[vrt].text = (offsets[vrt] % subdivisions).toString();
				switch (Math.floor(offsets[vrt] / subdivisions))
				{
					case 0:
					{
						offsetDisplays[vrt].textColor = 0xFFFFFF;
						break;
					}
					case 1:
					{
						offsetDisplays[vrt].textColor = 0xFF5555;
						break;
					}
					case 2:
					{
						offsetDisplays[vrt].textColor = 0x55FF55;
						break;
					}
					case 3:
					{
						offsetDisplays[vrt].textColor = 0x5555FF;
						break;
					}
					case 4:
					{
						offsetDisplays[vrt].textColor = 0xFF55FF;
						break;
					}
					case 5:
					{
						offsetDisplays[vrt].textColor = 0x55FFFF;
						break;
					}
					case 6:
					{
						offsetDisplays[vrt].textColor = 0xFFFF55;
						break;
					}
					default:
					{
						offsetDisplays[vrt].textColor = 0xFF0000;
						break;
					}
					
				}
			}
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			
			subdivisionDisplay.text = subdivisions.toString();
			subdivisionsEdit.text = subdivisions.toString();
			
		}
		
		private function pentatonicMajor():void
		{
			
			trace("pent sett");
			offsets[0] = 0;
			offsets[1] = 2;
			offsets[2] =  4;
			offsets[3]= 7;
			offsets[4] =  9;
			offsets[5] = 12;
			
			offsets[6] = 2+subdivisions;
			offsets[7] = (4+subdivisions) ;
			offsets[8] = (7+subdivisions) ;
			offsets[9] = (9+subdivisions);
			offsets[10] = (12+subdivisions);
			
			offsets[11] = (2+subdivisions+subdivisions) ;
			offsets[12] = (4+subdivisions+subdivisions) ;
			offsets[13] = (7+subdivisions+subdivisions) ;
			offsets[14] = (9+subdivisions+subdivisions) ;
			offsets[15] = 12 + subdivisions + subdivisions;
			
			
			
			offsetsBecomeDisplays();
			
			freqFromOff();
		}
		
		private function freqFromOff():void
		{
			for (var hr:int = 0; hr < 16; hr++)
			{
				frequencies[hr] = (Math.pow(octave, (offsets[hr]) / subdivisions) * key);
			}
		}
		
		private function setScaleBlues(e:MouseEvent):void
		{
			//here
			octave = 2;
			subdivisions = 12;
			
			offsets[0] = 0;
			offsets[1] = 3;
			offsets[2] = 5 ;
			offsets[3] = 6;
			offsets[4] = 7;
			offsets[5] = 10;
			
			offsets[6] = 12;
			offsets[7] = 15;
			offsets[8] = 5 + subdivisions;
			offsets[9] = 6 + subdivisions;
			offsets[10] = 7 + subdivisions;
			
			offsets[11] = 10 + subdivisions;
			offsets[12] = 12 + subdivisions;
			offsets[13] = 3 + subdivisions + subdivisions;
			offsets[14] = 5 + subdivisions + subdivisions;
			offsets[15] = 6 + subdivisions + subdivisions;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleDminished(e:MouseEvent):void
		{
			//here
			octave = 2;
			subdivisions = 12;
			
			offsets[0] = 0;
			offsets[1] = 3;
			offsets[2] = 6;
			offsets[3] = 9;
			offsets[4] = 12;
			offsets[5] = 15;
			
			offsets[6] = 18;
			offsets[7] = 21;
			offsets[8] = 24;
			offsets[9] = 27;
			offsets[10] = 30;
			
			offsets[11] = 33;
			offsets[12] = 36;
			offsets[13] = 39;
			offsets[14] = 42;
			offsets[15] = 45;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleWholeTone(e:MouseEvent):void
		{
			//here
			octave = 2;
			subdivisions = 12;
			
			offsets[0] = 0;
			offsets[1] = 2;
			offsets[2] = 4;
			offsets[3] = 6;
			offsets[4] = 8;
			offsets[5] = 10;
			
			offsets[6] = 12;
			offsets[7] = 14;
			offsets[8] = 16;
			offsets[9] = 18;
			offsets[10] = 20;
			
			offsets[11] = 22;
			offsets[12] = 24;
			offsets[13] = 26;
			offsets[14] = 28;
			offsets[15] = 30;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleChromPierce(e:MouseEvent):void
		{
			octave = 3;
			subdivisions = 13;
			
			offsets[0] = 0;
			offsets[1] = 1;
			offsets[2] = 2;
			offsets[3] = 3;
			offsets[4] = 4;
			offsets[5] = 5;
			
			offsets[6] = 6;
			offsets[7] = 7;
			offsets[8] = 8;
			offsets[9] = 9;
			offsets[10] = 10;
			
			offsets[11] = 11;
			offsets[12] = 12;
			offsets[13] = 13;
			offsets[14] = 14;
			offsets[15] = 15;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleLambdaPierce(e:MouseEvent):void
		{
			octave = 3;
			subdivisions = 13;
			
			offsets[0] = 0;
			offsets[1] = 2;
			offsets[2] = 3;
			offsets[3] = 4;
			offsets[4] = 6;
			offsets[5] = 7;
			
			offsets[6] = 9;
			offsets[7] = 10;
			offsets[8] = 12;
			offsets[9] = 13;
			offsets[10] = 15;
			
			offsets[11] = 16;
			offsets[12] = 17;
			offsets[13] = 19;
			offsets[14] = 20;
			offsets[15] = 22;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleMoll1Pierce(e:MouseEvent):void
		{
			octave = 3;
			subdivisions = 13;
			
			offsets[0] = 0;
			offsets[1] = 1;
			offsets[2] = 3;
			offsets[3] = 4;
			offsets[4] = 6;
			offsets[5] = 7;
			
			offsets[6] = 9;
			offsets[7] = 10;
			offsets[8] = 12;
			offsets[9] = 13;
			offsets[10] = 14;
			
			offsets[11] = 16;
			offsets[12] = 17;
			offsets[13] = 19;
			offsets[14] = 20;
			offsets[15] = 22;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		/*
		private function setScaleMoll2Pierce(e:MouseEvent):void
		{
			octave = 3;
			subdivisions = 13;
			
			frequencies[0] = (Math.pow(octave, (0) / subdivisions) * key);
			frequencies[1] = (Math.pow(octave, (2) / subdivisions) * key);
			frequencies[2] = (Math.pow(octave, (3) / subdivisions) * key);
			frequencies[3] = (Math.pow(octave, (5) / subdivisions) * key);
			frequencies[4] = (Math.pow(octave, (6) / subdivisions) * key);
			frequencies[5] = (Math.pow(octave, (7) / subdivisions) * key);
			
			frequencies[6] = (Math.pow(octave, (9) / subdivisions) * key);
			frequencies[7] = (Math.pow(octave, (10) / subdivisions) * key);
			frequencies[8] = (Math.pow(octave, (12) / subdivisions) * key);
			frequencies[9] = (Math.pow(octave, (13) / subdivisions) * key);
			frequencies[10] = (Math.pow(octave,(15) / subdivisions) * key);
			
			frequencies[11] = (Math.pow(octave,(16) / subdivisions) * key);
			frequencies[12] = (Math.pow(octave,(18) / subdivisions) * key);
			frequencies[13] = (Math.pow(octave,(19) / subdivisions) * key);
			frequencies[14] = (Math.pow(octave,(20) / subdivisions) * key);
			frequencies[15] = (Math.pow(octave, (22) / subdivisions) * key);
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
		}*/
		
		private function setScaleDur2Pierce(e:MouseEvent):void
		{
			octave = 3;
			subdivisions = 13;
			
			offsets[0] = 0;
			offsets[1] = 2;
			offsets[2] = 3;
			offsets[3] = 4;
			offsets[4] = 6;
			offsets[5] = 7;
			
			offsets[6] = 9;
			offsets[7] = 10;
			offsets[8] = 11;
			offsets[9] = 13;
			offsets[10] = 15;
			
			offsets[11] = 16;
			offsets[12] = 17;
			offsets[13] = 19;
			offsets[14] = 20;
			offsets[15] = 22;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
		}
		
		private function setScaleArab24Bastanikar(e:MouseEvent):void
		{
			octave = 2;
			subdivisions = 24;
			
			offsets[0] = 0;
			offsets[1] = 3;
			offsets[2] = 7;
			offsets[3] = 10;
			offsets[4] = 13;
			offsets[5] = 15;
			
			offsets[6] = 21;
			offsets[7] = 23;
			offsets[8] = 0 + subdivisions;
			offsets[9] = 3 + subdivisions;
			offsets[10] = 7 + subdivisions;
			 
			offsets[11] = 10 + subdivisions;
			offsets[12] = 13 + subdivisions;
			offsets[13] = 15 + subdivisions;
			offsets[14] = 21 + subdivisions;
			offsets[15] = 23 + subdivisions;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
		}
		
		private function setScaleArab24Sikah(e:MouseEvent):void
		{
			octave = 2;
			subdivisions = 24;
			
			offsets[0] = 0;
			offsets[1] = 3;
			offsets[2] = 7;
			offsets[3] = 11;
			offsets[4] = 14;
			offsets[5] = 17;
			
			offsets[6] = 21;
			offsets[7] = 24;
			offsets[8] = 3 + subdivisions;
			offsets[9] = 7 + subdivisions;
			offsets[10] = 11 + subdivisions;
			
			offsets[11] = 14 + subdivisions;
			offsets[12] = 17 + subdivisions;
			offsets[13] = 21 + subdivisions;
			offsets[14] = 24 + subdivisions;
			offsets[15] = 27 + subdivisions;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleArab24RahatElArwah (e:MouseEvent):void
		{
			octave = 2;
			subdivisions = 24;
			
			offsets[0] = 0;
			offsets[1] = 3;
			offsets[2] = 7;
			offsets[3] = 9;
			offsets[4] = 15;
			offsets[5] = 17;
			
			offsets[6] = 21;
			offsets[7] = 24;
			offsets[8] = 3 + subdivisions;
			offsets[9] = 7 + subdivisions;
			offsets[10] = 9 + subdivisions;
			
			offsets[11] = 15 + subdivisions;
			offsets[12] = 17 + subdivisions;
			offsets[13] = 21 + subdivisions;
			offsets[14] = 24 + subdivisions;
			offsets[15] = 27 + subdivisions;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleArab17Chromatic (e:MouseEvent):void
		{
			octave = 2;
			subdivisions = 17;
			
			offsets[0] = 0;
			offsets[1] = 1;
			offsets[2] = 2;
			offsets[3] = 3;
			offsets[4] = 4;
			offsets[5] = 5;
			
			offsets[6] = 6;
			offsets[7] = 7;
			offsets[8] = 8;
			offsets[9] = 9;
			offsets[10] = 10;
			
			offsets[11] = 11;
			offsets[12] = 12;
			offsets[13] = 13;
			offsets[14] = 14;
			offsets[15] = 15;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function setScaleArab15ET (e:MouseEvent):void
		{
			octave = 2;
			subdivisions = 15;
			
			offsets[0] = 0;
			offsets[1] = 1;
			offsets[2] = 2;
			offsets[3] = 3;
			offsets[4] = 4;
			offsets[5] = 5;
			
			offsets[6] = 6;
			offsets[7] = 7;
			offsets[8] = 8;
			offsets[9] = 9;
			offsets[10] = 10;
			
			offsets[11] = 11;
			offsets[12] = 12;
			offsets[13] = 13;
			offsets[14] = 14;
			offsets[15] = 15;
			
			freqFromOff();
			
			octaveDisplay.text = octave.toString();
			octaveEditSmall.text = octave.toString();
			
			subdivisionsEdit.text = subdivisions.toString();
			subdivisionDisplay.text = subdivisions.toString();
			
			offsetsBecomeDisplays();
			
		}
		
		private function loadClicked(e:MouseEvent):void
		{
			//here
			inputScaleDegrees();
			
		}
		
		private function inputScaleDegrees():void
		{
			
			xmlFileReference = new FileReference;
			xmlFileReference.browse([new FileFilter("XML FILES ONLY", "*.xml")]);
			xmlFileReference.addEventListener(Event.SELECT, onFileSelected);
		}
		
		private function  onFileSelected(e:Event):void
		{
			
			xmlFileReference.addEventListener(Event.COMPLETE,onFileLoaded);
			xmlFileReference.load();
		}
		private function onFileLoaded(e:Event):void 
		{
			toneOutput = new XML(xmlFileReference.data);
			trace(toneOutput.toXMLString());
			updateToLoadedNotes();
			offsetsBecomeDisplays();
			loadSong();
			toneOutput = new XML();
			xmlFileReference = new FileReference();
			//frequencies.reverse();
		}
		
		private function updateToLoadedNotes():void
		{
			
			for (var g:int = 0; g < 16; g++)
			{
				
				
				offsets[g] = toneOutput.note[g];
				
			}
			octave = toneOutput.octave;
			subdivisions = toneOutput.subdivisions;
			
			trace("offsets : ",offsets.toString());
			
			
			//frequencies.reverse();
			/*for (var h:int = 0; h < 16; h++)
			{
				trace("c ",frequencies[h]);
				
			}*/
			freqFromOff();
		}
		
		private function loadSong():void
		{
			
			
			for (var h:int = 0; h < 16; h++)
			{
				var currentString:String = new String("");
				currentString = toneOutput.chord[h]; ///from xml
				var currentInt:int =  parseInt(currentString, 36);
				currentString = currentInt.toString(2);
				currentString = currentString.split("").reverse().join(""); //reverse string
				for (var j:int = 0; j < 16; j++)
				{
					if (currentString.length >= j - 1)
					{
						if (currentString.charAt(j) == "1")
						{
							buttons[h][j].setState(true);
						}
						else
						{
							buttons[h][j].setState(false);
						}
					}
					else
					{
						buttons[h][j].setState(false);
					}
				}
			}
		}
		
		private function saveClicked(e:MouseEvent):void
		{
			outputScaleDegrees();
		}
		
		private function outputScaleDegrees():void
		{
			toneOutput = new XML();
			toneOutput = <vase></vase>
			
			var scaleDegree:XML ;
			for (var g:int = 0; g < 16; g++)
			{
				scaleDegree = new XML(<note>{offsets[g]}</note>);
				toneOutput.appendChild(scaleDegree);
			}
			
			var donkeyOctave:XML;
			var donkeySubdivision:XML;
			var donkeySong:XML;
			
			donkeyOctave = new XML(<octave>{octave}</octave>);
			toneOutput.appendChild(donkeyOctave);
			
			donkeySubdivision = new XML(<subdivisions>{subdivisions}</subdivisions>);
			toneOutput.appendChild(donkeySubdivision);
			//toneOutput.item[0]
			
			/////////////////////////////////////// SONG SAVING
			var stringSave:String = new String("");
			
			for (var j:int = 0; j < 16; j++)
			{
				for (var i:int = 0; i < 16 ; i++)
				{
					stringSave = stringSave.concat(int(buttons[j][i].returnState()));
				}
				stringSave = stringSave.split("").reverse().join("");
				var intSave:int = parseInt(stringSave, 2);
			
				trace("String Binary :", stringSave);
				trace("Int base 10 :", intSave);
			
			
				stringSave = intSave.toString(36);
				donkeySong = new XML(<chord>{stringSave}</chord>);
				trace("String Base 36 :", stringSave);
				stringSave = "";
				intSave = 0;
			
				toneOutput.appendChild(donkeySong);
			}
			//intSave = parseInt(stringSave, 36);
			
			
			
			trace("String Base 36 :", stringSave);
			//////////////////////////////////////////Song saving completed
			xmlByteArray = new ByteArray();
			
			
			xmlByteArray.writeUTFBytes(toneOutput.toXMLString());
			xmlFileReference = new FileReference;
			xmlFileReference.save(xmlByteArray, 'myToneScale.xml');
		}
		
		
		
		
		
		private function onEnterFrame(event:Event):void
		{
					
			if (limiter   == 0) //10 is default.
			{
				repeatChecker = 0;
				checkCurrentChord();
				//trace("fresh meat");
			}
			limiter++;
			if (limiter > limiterCheck) //tick control. defualt - 10
			{
				limiter = 0;
				positionOfGrid++;
								
				for each(var buttonASpecific:soundButton in buttons[positionOfGrid-1])
				{
				buttonASpecific.alpha = 0.5;			
				
				}
			}
			if (positionOfGrid > 15)
			{
				positionOfGrid = 0;
			}
			for each(var buttonSpecific:soundButton in buttons[positionOfGrid])
			{
					
						buttonSpecific.alpha = 1.0;
					
				
			}
				
		}
		
		
		
		private function onKeyPressed(event:KeyboardEvent):void
		{
			
			if (event.keyCode == Keyboard.SPACE)
			{
				
					for (var j:int = 0; j < 16 ; j++)
					{			
						for (var i:int = 0; i < 16 ; i++)
						{				
							buttons[j][i].setState(false);							
						}
					}
						
				
			}
			if (event.keyCode == Keyboard.SHIFT)
			{
				buttons[0][0].setState(true);
				buttons[1][1].setState(true);
				buttons[2][2].setState(true);
				buttons[3][3].setState(true);
				buttons[4][4].setState(true);
				buttons[5][5].setState(true);
				buttons[6][6].setState(true);
				buttons[7][7].setState(true);
				buttons[8][8].setState(true);
				buttons[9][9].setState(true);
				buttons[10][10].setState(true);
				buttons[11][11].setState(true);
				buttons[12][12].setState(true);
				buttons[13][13].setState(true);
				buttons[14][14].setState(true);
				buttons[15][15].setState(true);
			}
		}
		
		private function checkCurrentChord():void
		{
			
			remoteSoundPlay();					
			
		}
		
		
		private function remoteSoundPlay():void
		{
			if (toggleSound == true)
			{
				notes[0].addEventListener(SampleDataEvent.SAMPLE_DATA,sineWaveGenerator);
			}
			else 
			{
				notes[0].addEventListener(SampleDataEvent.SAMPLE_DATA,squareWaveGenerator);
			}
			channels = notes[0].play();
			if (toggleSound == true)
			{
				notes[0].removeEventListener(SampleDataEvent.SAMPLE_DATA,sineWaveGenerator);
			}
			else 
			{
				notes[0].removeEventListener(SampleDataEvent.SAMPLE_DATA,squareWaveGenerator);
			}			
		}
		
		private function squareWaveGenerator(event:SampleDataEvent):void 
		{
			var lengthMaker:int = 4048;
			for ( var i:int = 0; i < lengthMaker; i++ ) //default 8192
			{
				var amp:Number = 0.05;
				var floatToWrite:Number = 0;
				for (var rw:int = 0; rw < 16 ; rw++)
				{
					//var attenuation:Number;
					//attenuation = (2500 - i) / 2500;
					if (buttons[positionOfGrid][rw].returnState() == true)
					{
						floatToWrite += Math.sin((i + event.position) * 2 * Math.PI * frequencies[rw] /44100) > 0 ? amp : -amp; 							
					}
				}
				
				if (i+event.position < soundLength)
				{
					event.data.writeFloat(floatToWrite);
					event.data.writeFloat(floatToWrite);
				}
				else
				{
					event.data.writeFloat(0);
					event.data.writeFloat(0);
				}
				
			}
			
		}	
		
		
		private function sineWaveGenerator(event:SampleDataEvent):void 
		{
			
			for ( var i:int = 0; i < 2500; i++ ) //default 8192
			{
				var floatToWrite:Number = 0;
				for (var rw:int = 0; rw < 16 ; rw++)
				{
					//var attenuation:Number;
					//attenuation = (2500 - i) / 2500;
					if (buttons[positionOfGrid][rw].returnState() == true)
					{
						
							
							floatToWrite += (Math.sin( Number(i + event.position) * (frequencies[rw] * 2 * Math.PI) / 44100)*0.25  );
							
					}
				}
				
				
				//channels.soundTransform = soundTransform.volume.toFixed(((2500 - i) / 2500));
				
				if (i+event.position < soundLength)
				{
					//frequencies[0] =  Math.abs(testButton.x - testButton2.x) ;
					event.data.writeFloat(floatToWrite);
					event.data.writeFloat(floatToWrite);
				}
				else
				{
					event.data.writeFloat(0);
					event.data.writeFloat(0);
				}
				
			}			
		}
		private function shareSongClicked(e:MouseEvent):void
		{
			sharePop.visible = !sharePop.visible;
			sharePop.setText(generateShareCode());
		}
		
		private function sharedSongLoad(e:shareSongLoadEvent):void
		{
			shareString = e.song;
			
			sharedSongToGrid();
			trace("THE NEX ", shareString);
		}
		
		private function sharedSongToGrid():void
		{
			
			var tempString:String = new String("");
			var odometer:int = new int(0);
			
			for (var r:int = 0; r < shareString.length; r++)
			{
				if (shareString.charAt(r) != ",")
				{
					tempString = tempString.concat(shareString.charAt(r));
				}
				else if (shareString.charAt(r) == ",")
				{
					var translationString:String = new String("");
					var translationInt:int = new int(0);
					//shove that bitch on the grid
					switch (odometer)
					{
						case 0:
						{
							trace("HURR",int(tempString));
							offsets[odometer] = int(tempString);
							break;
						}
						case 1:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 2:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 3:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 4:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 5:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 6:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 7:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 8:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 9:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 10:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 11:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 12:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 13:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 14:
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 15: // end of offsets
						{
							offsets[odometer] = int(tempString);
							break;
						}
						case 16: //octave
						{
							octave = int(tempString);
							break;
						}
						case 17: //subdivisions
						{
							subdivisions = int(tempString);
							break;
						}
						case 18: //chords
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var j:int = 0; j < 16; j++)
							{
								if (translationString.length >= j - 1)
								{
									if (translationString.charAt(j) == "1")
									{
										buttons[0][j].setState(true);
									}
									else
									{
										buttons[0][j].setState(false);
									}
								}
								else
								{
									buttons[0][j].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 19:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var w:int = 0; w < 16; w++)
							{
								if (translationString.length >= w - 1)
								{
									if (translationString.charAt(w) == "1")
									{
										buttons[1][w].setState(true);
									}
									else
									{
										buttons[1][w].setState(false);
									}
								}
								else
								{
									buttons[1][w].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							
							break;
						}
						case 20:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var a:int = 0; a < 16; a++)
							{
								if (translationString.length >= a - 1)
								{
									if (translationString.charAt(a) == "1")
									{
										buttons[2][a].setState(true);
									}
									else
									{
										buttons[2][a].setState(false);
									}
								}
								else
								{
									buttons[2][a].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 21:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var b:int = 0; b < 16; b++)
							{
								if (translationString.length >= b - 1)
								{
									if (translationString.charAt(b) == "1")
									{
										buttons[3][b].setState(true);
									}
									else
									{
										buttons[3][b].setState(false);
									}
								}
								else
								{
									buttons[3][b].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 22:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var c:int = 0; c < 16; c++)
							{
								if (translationString.length >= c - 1)
								{
									if (translationString.charAt(c) == "1")
									{
										buttons[4][c].setState(true);
									}
									else
									{
										buttons[4][c].setState(false);
									}
								}
								else
								{
									buttons[4][c].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 23:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var d:int = 0; d < 16; d++)
							{
								if (translationString.length >= d - 1)
								{
									if (translationString.charAt(d) == "1")
									{
										buttons[5][d].setState(true);
									}
									else
									{
										buttons[5][d].setState(false);
									}
								}
								else
								{
									buttons[5][d].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 24:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var e:int = 0; e < 16; e++)
							{
								if (translationString.length >= e - 1)
								{
									if (translationString.charAt(e) == "1")
									{
										buttons[6][e].setState(true);
									}
									else
									{
										buttons[6][e].setState(false);
									}
								}
								else
								{
									buttons[6][e].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 25:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var f:int = 0; f < 16; f++)
							{
								if (translationString.length >= f - 1)
								{
									if (translationString.charAt(f) == "1")
									{
										buttons[7][f].setState(true);
									}
									else
									{
										buttons[7][f].setState(false);
									}
								}
								else
								{
									buttons[7][f].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 26:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var g:int = 0; g < 16; g++)
							{
								if (translationString.length >= g - 1)
								{
									if (translationString.charAt(g) == "1")
									{
										buttons[8][g].setState(true);
									}
									else
									{
										buttons[8][g].setState(false);
									}
								}
								else
								{
									buttons[8][g].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 27:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var h:int = 0; h < 16; h++)
							{
								if (translationString.length >= h - 1)
								{
									if (translationString.charAt(h) == "1")
									{
										buttons[9][h].setState(true);
									}
									else
									{
										buttons[9][h].setState(false);
									}
								}
								else
								{
									buttons[9][h].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 28:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var aa:int = 0; aa < 16; aa++)
							{
								if (translationString.length >= aa - 1)
								{
									if (translationString.charAt(aa) == "1")
									{
										buttons[10][aa].setState(true);
									}
									else
									{
										buttons[10][aa].setState(false);
									}
								}
								else
								{
									buttons[10][aa].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 29:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var ab:int = 0; ab < 16; ab++)
							{
								if (translationString.length >= ab - 1)
								{
									if (translationString.charAt(ab) == "1")
									{
										buttons[11][ab].setState(true);
									}
									else
									{
										buttons[11][ab].setState(false);
									}
								}
								else
								{
									buttons[11][ab].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 30:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var ac:int = 0; ac < 16; ac++)
							{
								if (translationString.length >= ac - 1)
								{
									if (translationString.charAt(ac) == "1")
									{
										buttons[12][ac].setState(true);
									}
									else
									{
										buttons[12][ac].setState(false);
									}
								}
								else
								{
									buttons[12][ac].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 31:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var ad:int = 0; ad < 16; ad++)
							{
								if (translationString.length >= ad - 1)
								{
									if (translationString.charAt(ad) == "1")
									{
										buttons[13][ad].setState(true);
									}
									else
									{
										buttons[13][ad].setState(false);
									}
								}
								else
								{
									buttons[13][ad].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 32:
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var ae:int = 0; ae < 16; ae++)
							{
								if (translationString.length >= ae - 1)
								{
									if (translationString.charAt(ae) == "1")
									{
										buttons[14][ae].setState(true);
									}
									else
									{
										buttons[14][ae].setState(false);
									}
								}
								else
								{
									buttons[14][ae].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						case 33://end chords
						{
							translationString = tempString;
							translationInt = parseInt(translationString, 36);
							translationString = translationInt.toString(2);
							translationString = translationString.split("").reverse().join("");
							for (var af:int = 0; af < 16; af++)
							{
								if (translationString.length >= af - 1)
								{
									if (translationString.charAt(af) == "1")
									{
										buttons[15][af].setState(true);
									}
									else
									{
										buttons[15][af].setState(false);
									}
								}
								else
								{
									buttons[15][af].setState(false);
								}
							}
							translationString = ("");
							translationInt = 0;
							break;
						}
						default:
						{
							break;
						}
						
						
					}
					trace(tempString);
					odometer++;
					tempString = "";
				}
			}
			offsetsBecomeDisplays();
			freqFromOff();
			/*
			intSave = parseInt(stringSave, 36);
			
			stringSave = intSave.toString(2);
			trace(stringSave);

			stringSave = stringSave.split("").reverse().join("");*/
		
		}
	
		private function generateShareCode():String
		{
			shareString = new String("");
			for (var g:int = 0; g < 16; g++)
			{
				shareString = shareString.concat(offsets[g],",");
			}
			
			shareString = shareString.concat(octave, ",", subdivisions, ",");
				
			for (var j:int = 0; j < 16; j++)
			{
				var stringSave:String = new String("");
			
				for (var i:int = 0; i < 16 ; i++)
				{
					stringSave = stringSave.concat(int(buttons[j][i].returnState()));
				}
				stringSave = stringSave.split("").reverse().join("");
				var intSave:int = parseInt(stringSave, 2);
			
				trace("String Binary :", stringSave);
				trace("Int base 10 :", intSave);
				
			
				stringSave = intSave.toString(36);
			
				shareString = shareString.concat(stringSave, ",");
			}
			
			//intSave = parseInt(stringSave, 36);
			
			return shareString;
			/*trace("SHARESTIRN :", shareString);
			/*SHARE HERE*/
			
			/*
			
			
			trace("Int post paste : ", intSave);
			
			stringSave = intSave.toString(2);
			trace(stringSave);
			
			stringSave = stringSave.split("").reverse().join("");*/
			/*for (var j:int = 0; j < 16; j++)
			{
				if (stringSave.length >= j - 1)
				{
					if (stringSave.charAt(j) == "1")
					{
						buttons[0][j].setState(true);
					}
					elseson
					{
						buttons[0][j].setState(false);
					}
				}
			}*/
			
			
		}
		
		
		
		

	}

}