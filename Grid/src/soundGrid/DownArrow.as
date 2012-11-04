package soundGrid 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author sd
	 */
	public class DownArrow extends SimpleButton 
	{
		//measurements : 10 width, 13 height
		private var _shape:Shape;
		
		public function DownArrow(upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) 
		{
			
			_shape = new Shape();
			_shape.graphics.beginFill(0xFF0000);
			_shape.graphics.moveTo(0,0);
			_shape.graphics.lineTo(10, 0);
			_shape.graphics.lineTo(5, 13);
			_shape.graphics.lineTo(0, 0);
			
			_shape.visible = true;
			super(_shape, _shape, _shape, _shape);
			
		}
		
	}

}