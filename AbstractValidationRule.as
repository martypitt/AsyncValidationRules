package com.inversion.model.validation
{
	import com.inversion.common.error.AbstractMethodError;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.resources.ResourceManager;
	
	import org.swizframework.Swiz;

	[Event(name="validationBegin" , type="com.inversion.model.validation.ValidationRuleEvent")]
	[Event(name="validationComplete" , type="com.inversion.model.validation.ValidationRuleEvent")]
	public class AbstractValidationRule extends EventDispatcher implements IValidationRule 
	{
		public function AbstractValidationRule()
		{
			Swiz.autowire( this );
		}
		[Bindable]
		private var _triggerEvent : String = FlexEvent.VALUE_COMMIT;

		public function get triggerEvent():String
		{
			return _triggerEvent;
		}

		public function set triggerEvent(value:String):void
		{
			if ( targetComponent )
			{
				targetComponent.removeEventListener( triggerEvent , onValidationTriggered );
			}
			_triggerEvent = value;
			if ( targetComponent && triggerEvent )
			{
				targetComponent.addEventListener( triggerEvent , onValidationTriggered );
			}
		}

		
		private var _errorMessage : String;
		
		private var _targets : Array
		[Bindable]
		public function get targetComponent() : UIComponent
		{
			if ( _targets && _targets.length > 0 )
			{
				return _targets[0] as UIComponent;
			} else {
				return null;
			}
		}
		public function set targetComponent( value : UIComponent ) : void
		{
			targetComponents = [value];
		}
		[Bindable]
		public function get targetComponents() : Array
		{
			return _targets
		}
		public function set targetComponents( value : Array ) : void
		{
			_targets = value;
			for each ( var component : UIComponent in targetComponents )
			{
				component.addEventListener( triggerEvent, onValidationTriggered );
			}
		}
		private var _pending : Boolean;
		protected function get pending() : Boolean
		{
			return _pending;
		}
		protected function set pending( value : Boolean ) : void
		{
			if ( value == pending ) return;
			_pending = value;
			var type : String = ( pending ) ? ValidationRuleEvent.VALIDATION_BEGIN : ValidationRuleEvent.VALIDATION_COMPLETE;
			dispatchEvent( new ValidationRuleEvent( type ) );
		}
		[Bindable("validationBegin")]
		[Bindable("validationComplete")]
		public function get isPending() : Boolean
		{
			return pending;
		}  
		[Bindable("validationComplete")]
		public function get errorMessage() : String
		{
			return _errorMessage;
		}
		private var _valid : Boolean;
		[Bindable("validationComplete")]
		public function get isValid() : Boolean
		{
			return _valid;
		}
		public function validate() : void
		{
			throw new AbstractMethodError();
		}
		protected function setValid() : void
		{
			_valid = true;
			_errorMessage = null;
			pending = false;
			dispatchValidationCompleteEvent();
		}
		protected function setInvalid( errorMessage : String ) : void
		{
			_valid = false;
			_errorMessage = errorMessage;
			pending = false;
			dispatchValidationCompleteEvent();
		}
		protected function setInvalidWithResourceMessage( bundle : String , resourceName : String ) : void
		{
			var message : String = ResourceManager.getInstance().getString( bundle , resourceName );
			setInvalid( message );
		} 
		private function dispatchValidationCompleteEvent() : void
		{
			dispatchEvent( new ValidationRuleEvent(ValidationRuleEvent.VALIDATION_COMPLETE) )
		}
		private function onValidationTriggered( event : Event ) : void
		{
			validate();
		}
	}
}