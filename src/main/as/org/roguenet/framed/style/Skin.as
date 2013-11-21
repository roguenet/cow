package org.roguenet.framed.style {

import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class Skin {
    public static const NONE :Skin = new Skin(null);

    public function Skin (value :Object) {
        _name = value == null ? null : (value is String ? value as String : value.name);

        if (value == null || value is String) {
            _scaleX = _scaleY = true;
        } else if (value.hasOwnProperty("scale")) {
            _scaleX = _scaleY = value.scale as Boolean;
        } else {
            _scaleX = value.hasOwnProperty("scaleX") ? value.scaleX : true;
            _scaleY = value.hasOwnProperty("scaleY") ? value.scaleY : true;
        }
    }

    public function get name () :String {
        return _name;
    }

    public function layout (disp :DisplayObject, bounds :Rectangle) :void {
        if (disp == null) return;

        disp.x = bounds.x;
        disp.y = bounds.y;
        if (_scaleX) disp.width = bounds.width;
        if (_scaleY) disp.height = bounds.height;
        if (disp is Sprite) Sprite(disp).flatten();
    }

    protected var _name :String;
    protected var _scaleX :Boolean;
    protected var _scaleY :Boolean;
}
}
