package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.objects.SpriteObject;

import org.roguenet.framed.style.Styles;
import org.roguenet.framed.style.Ternary;

import react.BoolValue;
import react.BoolView;

public class LayoutSpriteObject extends SpriteObject implements HasLayout {
    public function get container () :HasLayout { return _container; }
    public function set container (value :HasLayout) :void {
        _container = value;
        _isValid.value = false;
    }

    public function get isValid () :BoolView { return _isValid; }

    public function get classes () :Vector.<String> { return _classes; }

    public function get absoluteLayout () :Boolean { return styles.absoluteLayout; }
    public function get top () :int { return styles.top; }
    public function get right () :int { return styles.right; }
    public function get bottom () :int { return styles.bottom; }
    public function get left () :int { return styles.left; }
    public function get inline () :Boolean {
        // default false, absolutes are not inline.
        return !absoluteLayout && styles.inline == Ternary.TRUE;
    }

    public function addClass (className :String) :LayoutSpriteObject {
        _classes[_classes.length] = className;
        _isValid.value = false;
        _styles = null;
        return this;
    }

    public function layout (sizeHint :Point) :Point { throw new Error("abstract"); }

    protected function get styles () :Styles {
        if (_styles == null) _styles = Styles.resolve(this);
        return _styles;
    }

    protected var _container :HasLayout;
    protected var _isValid :BoolValue = new BoolValue(true);
    protected var _classes :Vector.<String> = new <String>[];
    protected var _styles :Styles;
}
}
