package com.inversion.model.validation
{
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;

	[Event(name="validationComplete" , type="com.inversion.model.validation.ValidationRuleEvent")]
	public interface IValidationRule extends IEventDispatcher
	{
		function validate() : void;
		function get errorMessage() : String;
		function get isValid() : Boolean;
		function get targetComponent() : UIComponent;
		function set targetComponent( value : UIComponent ) : void;
		function get isPending() : Boolean;
		
		
	}
}