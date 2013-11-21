package org.roguenet.framed.style {

import aspire.util.Log;

import flashbang.util.TextFieldBuilder;

import org.roguenet.framed.display.Frame;
import org.roguenet.framed.display.HasLayout;

import starling.display.DisplayObject;

public class Styles {
    public static function findFrame (comp :HasLayout) :Frame {
        while (comp != null && !(comp is Frame)) comp = comp.container;
        return comp == null ? null : Frame(comp);
    }

    public static function resolve (comp :HasLayout) :Styles {
        var frame :Frame = findFrame(comp);
        return frame == null ? null : frame.styleSheet.resolve(comp.classes);
    }

    public static function createDisplay (comp :HasLayout, name :String) :DisplayObject {
        var frame :Frame = findFrame(comp);
        return frame == null ? null : frame.styleSheet.createStyleDisplay(name);
    }

    public static function inherit (comp :HasLayout, name :String) :* {
        if (comp is Frame) return null;
        var styles :Styles = resolve(comp);
        if (styles.isDefined(name)) return styles[name];
        if (comp.container == null) {
            log.warning("Asked for inherited style of container without a parent", "comp", comp,
                "name", name);
            return null;
        }
        return inherit(comp.container, name);
    }


    public function Styles (classes :Vector.<String>, styles :Object = null) {
        _classes = classes;

        if (styles == null) styles = {};
        _width = value(styles, "width", int.MIN_VALUE);
        _height = value(styles, "height", int.MIN_VALUE);

        _top = value(styles, "top", int.MIN_VALUE);
        _right = value(styles, "right", int.MIN_VALUE);
        _bottom = value(styles, "bottom", int.MIN_VALUE);
        _left = value(styles, "left", int.MIN_VALUE);

        _background = skin(value(styles, "background", null));

        _upSkin = skin(value(styles, "upSkin", null));
        _downSkin = skin(value(styles, "downSkin", null));

        _inline = ternary(value(styles, "inline", null));

        _textBuilder = value(styles, "textBuilder", null);
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

    public function get background () :Skin { return _background; }

    public function get upSkin () :Skin { return _upSkin; }
    public function get downSkin () :Skin { return _downSkin; }

    public function get inline () :Ternary { return _inline; }

    public function get textBuilder () :TextFieldBuilder { return _textBuilder; }

    public function isDefined (name :String) :Boolean {
        if (INT_STYLES.indexOf(name) >= 0) return this[name] > int.MIN_VALUE;
        if (SKIN_STYLES.indexOf(name) >= 0) return this[name] != Skin.NONE;
        if (TERNARY_STYLES.indexOf(name) >= 0) return this[name] != Ternary.UNKNOWN;
        if (OBJECT_STYLES.indexOf(name) >= 0) return this[name] != null;
        throw new Error("Unable to determine definedness of style [" + name + "]");
    }

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

        if (_background != Skin.NONE) other._background = _background;

        if (_upSkin != Skin.NONE) other._upSkin = _upSkin;
        if (_downSkin != Skin.NONE) other._downSkin = _downSkin;

        if (_inline != Ternary.UNKNOWN) other._inline = _inline;

        if (_textBuilder != null) other._textBuilder = _textBuilder;
    }

    protected static function skin (obj :Object) :Skin {
        return obj == null ? Skin.NONE : new Skin(obj);
    }

    protected static function ternary (value :*) :Ternary {
        if (value === true) return Ternary.TRUE;
        if (value === false) return Ternary.FALSE;
        return Ternary.UNKNOWN;
    }

    protected static function value (obj :Object, name :String, def :*) :* {
        return obj.hasOwnProperty(name) ? obj[name] : def;
    }

    protected static const INT_STYLES :Vector.<String> =
        new <String>["width", "height", "top", "right", "bottom", "left"];
    protected static const SKIN_STYLES :Vector.<String> =
        new <String>["background", "upSkin", "downSkin"];
    protected static const TERNARY_STYLES :Vector.<String> =
        new <String>["inline"];
    protected static const OBJECT_STYLES :Vector.<String> =
        new <String>["textBuilder"];

    protected var _classes :Vector.<String>;

    protected var _width :int;
    protected var _height :int;

    protected var _top :int;
    protected var _right :int;
    protected var _bottom :int;
    protected var _left :int;

    protected var _background :Skin;

    protected var _upSkin :Skin;
    protected var _downSkin :Skin;

    protected var _inline :Ternary;

    protected var _textBuilder :TextFieldBuilder;

    private static const log :Log = Log.getLog(Styles);
}
}

