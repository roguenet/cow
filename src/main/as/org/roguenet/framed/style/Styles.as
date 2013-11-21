package org.roguenet.framed.style {

public class Styles {
    public function Styles (classes :Vector.<String>, styles :Object = null) {
        _classes = classes;

        if (styles == null) styles = {};
        _width = value(styles, "width", int.MIN_VALUE);
        _height = value(styles, "height", int.MIN_VALUE);

        _top = value(styles, "top", int.MIN_VALUE);
        _right = value(styles, "right", int.MIN_VALUE);
        _bottom = value(styles, "bottom", int.MIN_VALUE);
        _left = value(styles, "left", int.MIN_VALUE);

        _background = value(styles, "background", null);

        _upSkin = value(styles, "upSkin", null);
        _downSkin = value(styles, "downSkin", null);
    }

    public function get width () :int { return _width; }
    public function get height () :int { return _height; }

    public function get absoluteLayout () :Boolean {
        return top > int.MIN_VALUE || right > int.MIN_VALUE || bottom > int.MIN_VALUE ||
            left > int.MIN_VALUE;
    }
    public function get top () :int { return _top; }
    public function get right () :int { return _right; }
    public function get bottom () :int { return _bottom; }
    public function get left () :int { return _left; }

    public function get background () :String { return _background; }

    public function get upSkin () :String { return _upSkin; }
    public function get downSkin () :String { return _downSkin; }

    internal function appliesTo (classes :Vector.<String>) :Boolean {
        for each (var className :String in classes)
            if (_classes.indexOf(className) >= 0) return true;
        return false;
    }

    internal function copyTo (other :Styles) :void {
        if (_width > int.MIN_VALUE) other._width = _width;
        if (_height > int.MIN_VALUE) other._height = _height;

        if (_top > int.MIN_VALUE) other._top = _top;
        if (_right > int.MIN_VALUE) other._right = _right;
        if (_bottom > int.MIN_VALUE) other._bottom = _bottom;
        if (_left > int.MIN_VALUE) other._left = _left;

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

    protected var _top :int;
    protected var _right :int;
    protected var _bottom :int;
    protected var _left :int;

    protected var _background :String;

    protected var _upSkin :String;
    protected var _downSkin :String;
}
}
