package org.roguenet.cow.display {

import flash.geom.Point;

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;

import org.roguenet.cow.style.Styles;

import starling.display.DisplayObject;

public class Block extends LayoutSpriteObject {
    public function addComponent (comp :HasLayout) :Block {
        _components[_components.length] = comp;
        _isValid.value = false;

        if (comp is GameObject)
            addObject(GameObject(comp), comp is DisplayComponent ? _sprite : null);

        comp.regs.add(comp.isValid.connect(conditionalInvalidate));
        return this;
    }

    override public function layout (availableSpace :Point) :Point {
        if (_isValid.value) _size.clone();

        var styles :Styles = Frame.resolveStyles(this);
        if (styles != null && styles.width >= 0) availableSpace.x = styles.width;
        if (styles != null && styles.height >= 0) availableSpace.y = styles.height;
        trace("CALCULATING BLOCK LAYOUT [" + styles + ", " + availableSpace + "]");
        var minWidth :int = 0;
        var minHeight :int = 0;
        for each (var comp :HasLayout in _components) {
            var pos :Point = new Point(minWidth, minHeight);
            var size :Point = comp.layout(availableSpace.clone());

            if (comp is DisplayComponent) {
                var display :DisplayObject = DisplayComponent(comp).display;
                display.x = pos.x;
                display.y = pos.y;
            }

            // expand the minWidth, but keep the available width the same for future comp layout
            minWidth = Math.max(minWidth, size.x);
            minHeight = Math.max(minHeight, pos.y + size.y);
            availableSpace.y = Math.max(0, availableSpace.y - size.y);
        }
        // always report our styled width and height, if set
        if (styles != null && styles.width >= 0) minWidth = styles.width;
        if (styles != null && styles.height >= 0) minHeight = styles.height;

        var bgName :String = styles == null ? null : styles.background;
        if (bgName != _bgName) {
            if (_background != null) {
                _background.removeFromParent();
                _background = null;
            }
            _bgName = bgName;
            if (_bgName != null) {
                _background = Frame.createBackground(this);
                if (_background != null) _sprite.addChildAt(_background, 0);
            }
        }
        if (_background != null) {
            _background.width = minWidth;
            _background.height = minHeight;
        }

        _isValid.value = true;
        return new Point(minWidth, minHeight);
    }

    protected function conditionalInvalidate (value :Boolean) :void {
        if (value) _isValid.value = false;
    }

    protected var _components :Vector.<HasLayout> = new <HasLayout>[];

    protected var _size :Point = new Point(0, 0);
    protected var _background :DisplayObject;
    protected var _bgName :String;
}
}
