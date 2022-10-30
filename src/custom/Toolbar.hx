package custom;

import haxe.ui.containers.VBox;

@:build(haxe.ui.macros.ComponentMacros.build("assets/toolbar.xml"))
class Toolbar extends VBox {
	public function new() {
		super();
	}
}
