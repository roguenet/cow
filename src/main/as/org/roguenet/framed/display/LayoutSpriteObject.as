package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.objects.SpriteObject;

import org.roguenet.framed.style.Styles;

import react.BoolValue;
import react.BoolView;

public class LayoutSpriteObject extends SpriteObject implements HasLayout {
    public function get container () :HasLayout { return _container; }
    public function set container (value :HasLayout) :void {
        _container = value;
        _isValid.value = false;
    }

    public function get isValid () :BoolView { return _isValid; }

    public function get styles () :Styles {
        if (_styles == null) _styles = Frame.resolveStyles(this);
        return _styles;
    }

    public function get classes () :Vector.<String> { return _classes; }

    public function addClass (className :String) :LayoutSpriteObject {
        _classes[_classes.length] = className;
        _isValid.value = false;
        _styles = null;
        return this;
    }

    public function layout (sizeHint :Point) :Point { throw new Error("abstract"); }

    protected var _container :HasLayout;
    protected var _isValid :BoolValue = new BoolValue(true);
    protected var _classes :Vector.<String> = new <String>[];
    protected var _styles :Styles;
}
}
