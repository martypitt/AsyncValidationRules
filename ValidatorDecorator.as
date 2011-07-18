package com.inversion.model.validation
{
	import mx.core.UIComponent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	public class ValidatorDecorator extends AbstractValidationRule
	{
		private var validator : Validator;
		
		public function ValidatorDecorator(validator : Validator )
		{
			validator.addEventListener(ValidationResultEvent.VALID , onValidatorResult );
			validator.addEventListener(ValidationResultEvent.INVALID , onValidatorResult );
			this.targetComponent = validator.source as UIComponent;
			this.validator = validator;
		}
		
		private function onValidatorResult( event : ValidationResultEvent ) : void
		{
			if ( !targetComponent && validator.source != null )
			{
				targetComponent = validator.source as UIComponent;
			}
			if ( event.type == ValidationResultEvent.VALID )
			{
				setValid();
			} else {
				setInvalid( event.message );
			}
		}
		public override function validate():void
		{
			validator.validate();
		}
	}
}