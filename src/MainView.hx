package;

import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    public function new() {
        super();
    }

	@:bind(pCompass, MouseEvent.MOUSE_DOWN)
	function onPress(e: MouseEvent) {
		var cursorX = Std.int(pCompass.cursorX);
		var cursorY = Std.int(pCompass.cursorY);
		switch (toolbar.buttons.selectedIndex) {
			case (0): // Add
				if (pCompass.doesMarkerExist(cursorX, cursorY)) return;
				var dialog = new AddMarker();
				dialog.showDialog();
				dialog.onFinish = (title: String) -> {
					pCompass.addMarker(title, cursorX, cursorY);
					noMarkers.hidden = true;
				};
			case (1): // Edit
				if (!pCompass.doesMarkerExist(cursorX, cursorY)) return;
				var dialog = new AddMarker(false);
				dialog.showDialog();
				dialog.onFinish = (title: String) -> {
					pCompass.editMarker(title, cursorX, cursorY);
				}
			case (2): // Remove
				pCompass.removeMarker(cursorX, cursorY);
				if (pCompass.markers.length == 0) noMarkers.hidden = false;
		}
	}
}

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
