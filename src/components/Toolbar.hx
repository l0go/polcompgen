package components;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("assets/toolbar.xml"))
class Toolbar extends VBox {
	public function new() {
		super();
	}
}
