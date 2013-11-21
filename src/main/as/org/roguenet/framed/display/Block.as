package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;

import org.roguenet.framed.style.Styles;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class Block extends LayoutSpriteObject {
    public function addComponent (comp :HasLayout) :Block {
        _components[_components.length] = comp;
        _isValid.value = false;

        if (comp is GameObject)
            addObject(GameObject(comp), comp is DisplayComponent ? _sprite : null);

        comp.regs.add(comp.isValid.connect(conditionalInvalidate));
        comp.container = this;
        return this;
    }

    override public function layout (sizeHint :Point) :Point {
        if (_isValid.value) return _size.clone();

        var styles :Styles = this.styles;
        if (styles != null && styles.width >= 0) sizeHint.x = styles.width;
        if (styles != null && styles.height >= 0) sizeHint.y = styles.height;
        var minWidth :int = 0;
        var minHeight :int = 0;
        var curY :int = 0;
        for each (var comp :HasLayout in _components) {
            var size :Point = comp.layout(sizeHint.clone());

            var absolutePosition :Boolean = false;
            if (comp is DisplayComponent) {
                var display :DisplayObject = DisplayComponent(comp).display;
                var compStyles :Styles = comp.styles;
                display.x = 0;
                display.y = curY;
                if (compStyles.left > int.MIN_VALUE) {
                    display.x += compStyles.left;
                    absolutePosition = true;
                } else if (compStyles.right > int.MIN_VALUE) {
                    display.x = sizeHint.x - size.x + compStyles.right;
                    absolutePosition = true;
                    // don't stretch our container to accommodate children that have placed
                    // themselves outside of our bounds
                    minWidth = Math.min(sizeHint.x, sizeHint.x + compStyles.right);
                }
                if (compStyles.top > int.MIN_VALUE) {
                    display.y += compStyles.top;
                    absolutePosition = true;
                } else if (compStyles.bottom > int.MIN_VALUE) {
                    display.y = sizeHint.y - size.y + compStyles.bottom;
                    absolutePosition = true;
                    // don't stretch our container to accommodate children that have placed
                    // themselves outside of our bounds
                    minHeight = Math.min(sizeHint.y, sizeHint.y + compStyles.bottom);
                }
            }

            // expand the minWidth, but keep the available width the same for future comp layout
            if (!absolutePosition) {
                minWidth = Math.max(minWidth, size.x);
                minHeight = Math.max(minHeight, curY + size.y);
                sizeHint.y = Math.max(0, sizeHint.y - size.y);
                curY = curY + size.y;
            }
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
                _background = Frame.createStyleDisplay(this, _bgName);
                if (_background != null) _sprite.addChildAt(_background, 0);
            }
        }
        if (_background != null) {
            _background.width = minWidth;
            _background.height = minHeight;
            if (_background is Sprite) Sprite(_background).flatten();
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
