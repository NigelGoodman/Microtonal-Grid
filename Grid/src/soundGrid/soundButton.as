package soundGrid 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author 
	 */
	public class soundButton extends SimpleButton
	{
		
		private var _shape:Shape;
		public var stateBool:Boolean;
		
		public function soundButton(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) 
		{
			_shape = new Shape();
			
			_shape = new Shape();
			_shape.graphics.beginFill(0xFFFFFF);
			_shape.graphics.drawRect(0, 0, 30, 30);
			_shape.visible = true;
			stateBool = false;
			this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
			
			super(_shape, _shape, _shape, _shape);	
			
			addEventListener(MouseEvent.CLICK, clicked);
			addEventListener(MouseEvent.MOUSE_OVER, painted);
		}
		
		private function clicked(e:MouseEvent):void
		{
			stateBool = !stateBool;
			if (stateBool == false)
			{
				//this.alpha = 0.5;
				this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
			}
			else
			{
				this.transform.colorTransform = new ColorTransform(0, 1, 0, 1, 0, 0, 0, 0);
				//this.alpha = 0.5;
			}
			
		}
		
		private function painted(e:MouseEvent):void
		{
			if (e.buttonDown == true)
			{
				stateBool = !stateBool;
				if (stateBool == false)
				{
					//this.alpha = 0.5;
					this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
				}
				else
				{
					this.transform.colorTransform = new ColorTransform(0, 1, 0, 1, 0, 0, 0, 0);
					//this.alpha = 0.5;
				}
			}
			
		}
		
		public function returnState():Boolean
		{
			return stateBool;
		}
		
		public function setState(inputState:Boolean):void
		{
			stateBool = inputState;
			
			if (stateBool == false)
			{
				//this.alpha = 0.5;
				this.transform.colorTransform = new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0);
			}
			else
			{
				this.transform.colorTransform = new ColorTransform(0, 1, 0, 1, 0, 0, 0, 0);
				//this.alpha = 0.5;
			}
		}
	}

}