package soundGrid 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author ...
	 */
	public class scaleButton extends SimpleButton 
	{
		private var _shape:Shape;
		
		public function scaleButton(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) 
		{
			_shape = new Shape();
			
			_shape = new Shape();
			_shape.graphics.beginFill(0xFFFFFF);
			_shape.graphics.drawRect(0, 0, 23.55, 12.45);
			
			_shape.visible = true;
						
			super(_shape, _shape, _shape, _shape);	
		}
		
	}

}