package org.roguenet.framed.style {

public class Styles {
    public function Styles (classes :Vector.<String>, styles :Object = null) {
        _classes = classes;

        if (styles == null) styles = {};
        _width = value(styles, "width", -1);
        _height = value(styles, "height", -1);
        _background = value(styles, "background", null);
        _upSkin = value(styles, "upSkin", null);
        _downSkin = value(styles, "downSkin", null);
    }

    public function get width () :int { return _width; }
    public function get height () :int { return _height; }
    public function get background () :String { return _background; }
    public function get upSkin () :String { return _upSkin; }
    public function get downSkin () :String { return _downSkin; }

    internal function appliesTo (classes :Vector.<String>) :Boolean {
        for each (var className :String in classes)
            if (_classes.indexOf(className) >= 0) return true;
        return false;
    }

    internal function copyTo (other :Styles) :void {
        if (_width >= 0) other._width = _width;
        if (_height >= 0) other._height = _height;
        if (_background != null) other._background = _background;
        if (_upSkin != null) other._upSkin = _upSkin;
        if (_downSkin != null) other._downSkin = _downSkin;
    }

    protected static function value (obj :Object, name :String, def :*) :* {
        return obj.hasOwnProperty(name) ? obj[name] : def;
    }

    protected var _classes :Vector.<String>;
    protected var _width :int;
    protected var _height :int;
    protected var _background :String;
    protected var _upSkin :String;
    protected var _downSkin :String;
}
}
