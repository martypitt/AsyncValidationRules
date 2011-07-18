package com.inversion.model.validation
{
	import flash.events.Event;
	
	public class ValidationRuleEvent extends Event
	{
		public static const VALIDATION_BEGIN : String = "validationBegin";
		public static const VALIDATION_COMPLETE : String = "validationComplete";
		public function ValidationRuleEvent(type:String)
		{
			super(type);
		}
		override public function clone():Event
		{
			return new ValidationRuleEvent(type);
		}
	}
}