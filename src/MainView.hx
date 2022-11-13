package;

import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    public function new() {
        super();
    	documentOptions.compass = pCompass;
		pCompass.markerInfoShown = (isShown: Bool) -> markerInfo.hidden = !isShown;
		pCompass.toolbar = toolbar;
	}
}
