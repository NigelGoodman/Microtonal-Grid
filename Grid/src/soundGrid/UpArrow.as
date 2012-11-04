package soundGrid 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author sd
	 */
	public class UpArrow extends SimpleButton 
	{
		//measurements : 10 width, 13 height
		private var _shape:Shape;
		
		public function UpArrow(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) 
		{
			
			_shape = new Shape();
			_shape.graphics.beginFill(0x00FF00);
			_shape.graphics.moveTo(0, 13);
			_shape.graphics.lineTo(5, 0);
			_shape.graphics.lineTo(10, 13);
			_shape.graphics.lineTo(0, 13);
			
			_shape.visible = true;
			super(_shape, _shape, _shape, _shape);
			
		}
		
	}

}