package org.roguenet.cow.style {

public class Styles {
    public function Styles (classes :Vector.<String>, styles :Object = null) {
        _classes = classes;

        if (styles == null) styles = {};
        _width = value(styles, "width", -1);
        _height = value(styles, "height", -1);
        _background = value(styles, "background", null);
    }

    public function get width () :int { return _width; }
    public function get height () :int { return _height; }
    public function get background () :String { return _background; }

    internal function appliesTo (classes :Vector.<String>) :Boolean {
        for each (var className :String in classes)
            if (_classes.indexOf(className) >= 0) return true;
        return false;
    }

    internal function copyTo (other :Styles) :void {
        if (_width >= 0) other._width = _width;
        if (_height >= 0) other._height = _height;
        if (_background != null) other._background = _background;
    }

    protected static function value (obj :Object, name :String, def :*) :* {
        return obj.hasOwnProperty(name) ? obj[name] : def;
    }

    protected var _classes :Vector.<String>;
    protected var _width :int;
    protected var _height :int;
    protected var _background :String;
}
}
