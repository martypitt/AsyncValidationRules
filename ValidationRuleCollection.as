package com.inversion.model.validation
{
	import com.adobe.utils.DictionaryUtil;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;
	import mx.validators.Validator;

	[DefaultProperty("validationRules")]
	[Event(name="validationComplete",type="com.inversion.model.validation.ValidationRuleEvent")]
	public class ValidationRuleCollection extends EventDispatcher
	{
		public function ValidationRuleCollection()
		{
		}

		private var _validationRules:Array;

		[Bindable]
		public function get validationRules():Array
		{
			return _validationRules;
		}

		public function set validationRules(value:Array):void
		{
			_validationRules=[]
			for each (var validationRule:Object in value)
			{
				if (validationRule is Validator)
				{
					var validationRule=new ValidatorDecorator(validationRule as Validator);
				}
				validationRule.addEventListener(ValidationRuleEvent.VALIDATION_COMPLETE, onValidationComplete)
				_validationRules.push(validationRule);
			}
		}

		[Bindable("validationComplete")]
		public function get isValid():Boolean
		{
			for each (var validationRule:IValidationRule in validationRules)
			{
				if (!validationRule.isValid)
					return false;
				if (validationRule.isPending)
					return false;
			}
			return true;
		}

		private function onValidationComplete(event:ValidationRuleEvent):void
		{
			updateErrorTips();
			dispatchEvent(event);
		}

		private function updateErrorTips():void
		{
			var components:Dictionary=new Dictionary(true);
			for each (var validationRule:IValidationRule in validationRules)
			{
				var target:UIComponent=validationRule.targetComponent as UIComponent;
				if (!target)
					continue;
				var errors:Array=components[target];
				if (!errors)
					errors=[];
				if (!validationRule.isValid)
				{
					var valiationRuleMessage:String=validationRule.errorMessage;
					if (valiationRuleMessage)
						errors.push(validationRule.errorMessage);
				}
				components[target]=errors;
			}
			var keys:Array=DictionaryUtil.getKeys(components);
			for each (var component:UIComponent in keys)
			{
				var messages:Array=components[component] as Array;
				var message:String=null;
				for each (var errorMessage:String in messages)
				{
					if (!message)
					{
						message=errorMessage;
					}
					else
					{
						message+="\n" + errorMessage;
					}
				}
				if (message)
				{
					ErrorTipManager.showErrorTip(component,message)
				} else {
					ErrorTipManager.hideErrorTip(component,true);
				}
			}
		}

	}
}