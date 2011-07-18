package com.inversion.model.validation
{
	import com.inversion.common.ResourceBundles;

	public class PasswordsMustMatchValidationRule extends AbstractValidationRule
	{
		public function PasswordsMustMatchValidationRule()
		{
			super();
		}
		
		[Bindable]
		public var password1 : String;
		[Bindable]
		public var password2 : String;
		
		public override function validate() : void
		{
			if ( password1 != password2 )
			{
				setInvalidWithResourceMessage( ResourceBundles.ERROR_MESSAGES , "PASSWORDS_MUST_MATCH" );
			}
			else
			{
				setValid();
			}
		}
	}
}