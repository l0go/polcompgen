package components;

import haxe.ui.Toolkit;
import haxe.ui.ToolkitAssets;
import haxe.ui.dragdrop.DragManager;
import haxe.ui.components.Image;
import haxe.ui.components.Canvas;
import haxe.ui.graphics.ComponentGraphics;
import haxe.ui.containers.dialogs.Dialogs.FileInfo;
import haxe.ui.events.MouseEvent;

class Compass extends Canvas {
	public var cursorX: Float = -10;
	public var cursorY: Float = -10;
	public var markers: Array<Marker> = [];
	public var absolute: haxe.ui.containers.Absolute;
	public var toolbar: Toolbar;

    public function new() {
        super();
        absolute = new haxe.ui.containers.Absolute();
		absolute.width = width;
		absolute.height = height;
		this.addComponent(absolute);
		frame();
	}

    private function frame() {
        componentGraphics.clear();
       	// Totalitarian Left 
        drawGrid(componentGraphics, 0, 0, 200, 200, 20, 0x4d1e1e, 0xD34949);
		// Totalitarian Right
		drawGrid(componentGraphics, 200, 0, 200, 200, 20, 0x212b4d, 0x3B5DC9);
		// Libertarian Left 
        drawGrid(componentGraphics,	0, 200, 200, 200, 20, 0x247540, 0x38B764);
		// Libertarian Right
		drawGrid(componentGraphics, 200, 200, 200, 200, 20, 0xef7d57, 0xffcd75);

		// Cursor
		componentGraphics.fillStyle(0xff0000);
		componentGraphics.strokeStyle(0x00000);
		componentGraphics.circle(cursorX, cursorY, 7);

		drawMarkers();
		Toolkit.callLater(frame);
    }
   
	public function addMarker(title: String, x: Int, y: Int) {
		var marker = new Marker(title, x, y);
		marker.titleID = 'label-${markers.length + 1}';
		markers.push(marker);
		drawMarkerLabel(marker);
	}
	
	public function editMarker(title: String, x: Int, y: Int) {
		var marker = markers.filter(marker -> marker.x == x || marker.y == y)[0];
		// remove old title
		absolute.removeComponent(absolute.findComponent(marker.titleID));
		marker.title = title;
		drawMarkerLabel(marker);
	}
	
	public function removeMarker(x: Int, y: Int) {
		var marker = markers.filter(marker -> marker.x == x && marker.y == y)[0];
		absolute.removeComponent(absolute.findComponent(marker.titleID));
		// remove the marker from the array, basically by doing the opposite of finding it like the above
		markers = markers.filter(marker -> (marker.x != x || marker.y != y));
	}

    private function drawGrid(graphics:ComponentGraphics, px:Float, py:Float, cx:Float, cy:Float, gridSize:Float, gridColor: Int, bgColor: Int) {
        var size = .5;
        #if haxeui_heaps 
        size = 1;
        #end
		graphics.fillStyle(bgColor);
		graphics.rectangle(px, py, cx, cy);
        graphics.strokeStyle(gridColor, size);
		for (x in 0...Std.int((cx / gridSize)) + 1) {
            graphics.moveTo(px + (x * gridSize), py);
            graphics.lineTo(px + (x * gridSize), cy+py);
        }
        
        for (y in 0...Std.int((cy / gridSize)) + 1) {
            graphics.moveTo(px, py+(y * gridSize));
            graphics.lineTo(cx+px, py+(y * gridSize));
        }
    }

	private function drawMarkers() {
		for (marker in markers) {
			componentGraphics.fillStyle(0xff0000);
			componentGraphics.strokeStyle(0x00000);
			componentGraphics.circle(marker.x, marker.y, 7);
		}
	}

	private function drawMarkerLabel(marker: Marker) {
		var label = new haxe.ui.components.Label();
		absolute.addComponent(label);
		label.htmlText = marker.title;
		label.left = marker.x;
		label.top = marker.y;
		label.customStyle = {
			color: 0xffffff,
			fontSize: 20
		};
		label.id = marker.titleID;
	}

	public function doesMarkerExist(x: Int, y: Int): Bool {
		return markers.filter(marker -> marker.x == x && marker.y == y).length != 0;
	}
	
	public function drawImage(file: FileInfo) {
		var image = new Image();
		DragManager.instance.registerDraggable(image, {
			dragBounds: new haxe.ui.geom.Rectangle(0, 0, width, height)
		});
		ToolkitAssets.instance.imageFromBytes(file.bytes, function(imageInfo) {
			if (imageInfo != null) {
				try {
					image.resource = imageInfo.data;
				} catch (_) {}
			}
		});
		absolute.addComponent(image);
	}
	
	@:bind(this, MouseEvent.MOUSE_DOWN)
	function onPress(_) {
		var cursorX = Std.int(cursorX);
		var cursorY = Std.int(cursorY);
		switch (toolbar.buttons.selectedIndex) {
			case (0): // Add
				if (doesMarkerExist(cursorX, cursorY)) return;
				var dialog = new AddMarker();
				dialog.showDialog();
				dialog.onFinish = (title: String) -> {
					addMarker(title, cursorX, cursorY);
					markerInfoShown(false);
				};
			case (1): // Edit
				if (!doesMarkerExist(cursorX, cursorY)) return;
				var dialog = new AddMarker(false);
				dialog.showDialog();
				dialog.onFinish = (title: String) -> {
					editMarker(title, cursorX, cursorY);
				}
			case (2): // Remove
				removeMarker(cursorX, cursorY);
				if (markers.length == 0) markerInfoShown(true);
		}
	}
	// Should be redefined in the main view in order to hide/show the text that states how to add markers
	public var markerInfoShown: (isShown: Bool) -> Void;

	// Have cursor follow mouse
	@:bind(this, MouseEvent.MOUSE_OVER)
	function mousOverCallback(e: MouseEvent) {
		cursorX = Math.round(e.localX / 20) * 20;
		cursorY = Math.round(e.localY / 20) * 20;
	}

	// Used to hide cursor
	@:bind(this, MouseEvent.MOUSE_OUT)
	function mouseOutCallback(e: MouseEvent) {
		cursorX = cursorY = -10;
	}
}
