package;

import js.lib.Promise;
import js.html.Element;
import js.html.CanvasElement;

typedef Options = {
	?allowTaint:Bool,
	?backgroundColor:String,
	?canvas:CanvasElement,
	?foreignObjectRendering:Bool,
	?imageTimeout:Int,
	?ignoreElements:Element->Bool,
	?logging:Bool,
	?onclone:Void->Void,
	?proxy:Bool,
	?removeContainer:Bool,
	?scale:Float,
	?useCORS:Bool,
	?width:Float,
	?height:Float,
	?x:Float,
	?y:Float,
	?scrollX:Float,
	?scrollY:Float,
	?windowWidth:Float,
	?windowHeight:Float
}

@:native('window')
extern class Html2Canvas {
	public static function html2canvas(element:Element, ?options:Options):Promise<CanvasElement>;
}
