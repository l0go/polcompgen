package components;

import haxe.ui.containers.dialogs.Dialog;

@:build(haxe.ui.macros.ComponentMacros.build("assets/marker-options.xml"))
class AddMarker extends Dialog {
	public function new(add: Bool = true) {
		super();
		buttons = DialogButton.CANCEL | if (add) "Add Marker" else "Edit Marker";
	}
	
	public var onFinish: String->Void;
	public override function validateDialog(button:DialogButton, fn:Bool->Void) {
		if (button == "Add Marker" || button == "Edit Marker") onFinish(name.text);
		fn(true);
	}
}
