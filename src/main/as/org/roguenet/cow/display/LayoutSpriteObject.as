package org.roguenet.cow.display {

import flash.geom.Point;

import flashbang.objects.SpriteObject;

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

    public function addClass (className :String) :LayoutSpriteObject {
        _classes[_classes.length] = className;
        _isValid.value = false;
        return this;
    }

    public function layout (size :Point) :Point { throw new Error("abstract"); }

    protected var _container :HasLayout;
    protected var _isValid :BoolValue = new BoolValue(true);
    protected var _classes :Vector.<String> = new <String>[];
}
}
