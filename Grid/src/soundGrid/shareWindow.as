package soundGrid 
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.*;
	import soundGrid.scaleButton;
	import soundGrid.shareSongLoadEvent;
	
	public class shareWindow extends Sprite 
	{
		private var _shape:Shape;
		
		private var _songField:TextField;
		private var _titleField:TextField;
		private var _closeText:TextField;
		private var _loadText:TextField;
		
		private var _formatting:TextFormat;
		
		private var _closeButton:scaleButton;
		private var _loadButton:scaleButton;
		//private var _songField:TextField;
		
		
		public function shareWindow()
		{
			super();
			_shape = new Shape();
			
			_shape = new Shape();
			_shape.graphics.beginFill(0x000033);
			_shape.graphics.drawRect(0, 0, 350, 320);
			_shape.visible = true;
			this.addChild(_shape);
			
			_formatting = new TextFormat("_sans", 20);
			_formatting.color = 0xFFFFFF;
			_formatting.align = "center";
			
			
			_titleField = new TextField();
			_loadText = new TextField();
			_closeText = new TextField();
			
			_loadText.defaultTextFormat = _formatting;
			_closeText.defaultTextFormat = _formatting;
			
			_titleField.defaultTextFormat = _formatting;
			_titleField.text = ("This is your sharecode.\nReplace this with another\nsharecode and press load");
			
			_titleField.x = 130;
			_titleField.y = 7;
			
			_titleField.textColor = 0xFFFFFF;
			_titleField.autoSize = TextFieldAutoSize.CENTER;
			
			
			_titleField.visible = true;
			this.addChild(_titleField);
			
			_songField = new TextField();
			_songField.defaultTextFormat = _formatting;
			_songField.background = true;
			_songField.backgroundColor = 0x5555AA;
			_songField.textColor = 0xFFFFFF;
			_songField.x = 7;
			_songField.y = 84;
			_songField.width = 333;
			_songField.height = 146;
			_songField.type = TextFieldType.INPUT;
			
			
			
			_songField.border = true;
			_songField.borderColor = 0xFFFFFF;
			_songField.wordWrap = true;
			_songField.visible = true;
			this.addChild(_songField);
			
			_loadText.text = "Load Song!";
			_closeText.text = "Close";
			
			
			
			_loadText.textColor = 0xFFFFFF;
			_closeText.textColor = 0xFFFFFF;
			
			_closeText.x = 40;
			_closeText.y = 265;
			_closeText.visible = true;
			this.addChild(_closeText);
			
			_loadText.x = 220;
			_loadText.y = 265;
			_loadText.visible = true;
			this.addChild(_loadText);
			
			_closeButton = new scaleButton;
			_closeButton.x = 30; 
			_closeButton.y = 250;
			
			_closeButton.width = 120;
			_closeButton.height = 56;
			_closeButton.alpha = 0.25;
			_closeButton.visible = true;
			
			
			_closeButton.addEventListener(MouseEvent.CLICK, closeClicked);
			this.addChild(_closeButton);
			
			_loadButton = new scaleButton;
			_loadButton.x = 212; 
			_loadButton.y = 250;
			
			_loadButton.width = 120;
			_loadButton.height = 56;
			_loadButton.alpha = 0.25;
			_loadButton.visible = true;
			_loadButton.addEventListener(MouseEvent.CLICK, loadClicked);
			this.addChild(_loadButton);
			
			
			
			
			
		}
		
		private function closeClicked(e:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function loadClicked(e:MouseEvent):void
		{
			this.visible = false;
			dispatchEvent(new shareSongLoadEvent(_songField.text));
		}
		
		
		public function setText(outputShareCode:String):void
		{
			_songField.text = outputShareCode;
		}
		
	}

}