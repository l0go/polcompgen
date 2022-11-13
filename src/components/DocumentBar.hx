package components;

import haxe.ui.ToolkitAssets;
import haxe.ui.containers.Frame;
import haxe.ui.dragdrop.DragManager;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs;
import haxe.ui.containers.dialogs.Dialogs.FileDialogTypes;
import haxe.ui.components.Image;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("assets/document-bar.xml"))
class DocumentBar extends Frame {
	public var compass: Compass;

	public function new() {
		super();
		#if !js
		exportButton.hidden = true;
		addImageButton.percentWidth = 100;
		#end
	}

	@:bind(exportButton, MouseEvent.MOUSE_DOWN)
	function export(_) {
		#if js
		Html2Canvas.html2canvas(compass.element).then((canvas: js.html.CanvasElement) -> {
			js.Browser.window.open(canvas.toDataURL());
		});
		#end
	}

	@:bind(addImageButton, MouseEvent.CLICK)
	private function addImage(_) {
		Dialogs.openFile(function(button, selectedFiles) {
			if (button == DialogButton.OK) {
				var image = new Image();
				DragManager.instance.registerDraggable(image, {
					dragBounds: new haxe.ui.geom.Rectangle(0, 0, compass.width, compass.height)
				});
				ToolkitAssets.instance.imageFromBytes(selectedFiles[0].bytes, function(imageInfo) {
					if (imageInfo != null) {
						try {
							image.resource = imageInfo.data;
						} catch (_) {}
					}
				});
				compass.absolute.addComponent(image);
			}
		}, {
			readContents: true,
			title: "Open Image File",
			readAsBinary: true,
			extensions: FileDialogTypes.IMAGES
		});
	}
}
