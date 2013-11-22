package org.roguenet.framed.display {

import flash.geom.Point;
import flash.geom.Rectangle;

import flashbang.components.DisplayComponent;
import flashbang.core.GameObject;

import org.roguenet.framed.style.Skin;
import org.roguenet.framed.style.Styles;

import starling.display.DisplayObject;

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
        if (_isValid.value) return _size;

        var styles :Styles = this.styles;
        sizeHint = sizeHint.clone();
        if (styles.width >= 0) sizeHint.x = styles.width;
        if (styles.height >= 0) sizeHint.y = styles.height;
        var minWidth :int = 0;
        var minHeight :int = 0;
        var absolutes :Vector.<HasLayout> = new <HasLayout>[];
        var padTop :int = styles.paddingTop > 0 ? styles.paddingTop : 0;
        var padRight :int = styles.paddingRight > 0 ? styles.paddingRight : 0;
        var padBot :int = styles.paddingBottom > 0 ? styles.paddingBottom : 0;
        var padLeft :int = styles.paddingLeft > 0 ? styles.paddingLeft : 0;
        sizeHint.x -= padRight + padLeft;
        sizeHint.y -= padTop + padBot;
        var curY :int = padTop;
        for each (var comp :HasLayout in _components) {
            if (comp.absoluteLayout) {
                absolutes[absolutes.length] = comp;
                continue;
            }

            var size :Point = comp.layout(sizeHint);
            if (comp is DisplayComponent) {
                var display :DisplayObject = DisplayComponent(comp).display;
                display.x = padLeft;
                display.y = curY;
            }

            // expand the minWidth, but keep the available width the same for future comp layout
            minWidth = Math.max(minWidth, size.x + padLeft + padRight);
            minHeight = Math.max(minHeight, curY + size.y);
            sizeHint.y = Math.max(0, sizeHint.y - size.y);
            curY = curY + size.y;
        }
        minHeight += padBot;

        // always report our styled width and height, if set
        if (styles.width >= 0) minWidth = styles.width;
        if (styles.height >= 0) minHeight = styles.height;

        // absolutes get laid out after we know our real size.
        if (absolutes.length > 0) {
            for each (comp in absolutes) {
                var width :int = 0;
                var height :int = 0;
                // only give a size hint > 0 if a layout has both left and right set.
                if (comp.left > int.MIN_VALUE && comp.right > int.MIN_VALUE)
                    width = minWidth - comp.left + comp.right;
                if (comp.top > int.MIN_VALUE && comp.bottom > int.MIN_VALUE)
                    height = minHeight - comp.top + comp.bottom;

                size = comp.layout(new Point(width, height));
                if (comp is DisplayComponent) {
                    display = DisplayComponent(comp).display;
                    if (comp.left > int.MIN_VALUE) display.x = comp.left;
                    else if (comp.right > int.MIN_VALUE)
                        display.x = minWidth - size.x + comp.right;
                    else display.x = 0;
                    if (comp.top > int.MIN_VALUE) display.y = comp.top;
                    else if (comp.bottom > int.MIN_VALUE)
                        display.y = minHeight - size.y + comp.bottom;
                    else display.y = 0;
                }
            }
        }

        if (styles.background != _bgSkin) {
            if (_background != null) {
                _background.removeFromParent();
                _background = null;
            }
            _bgSkin = styles.background;
            if (_bgSkin.name != null) {
                _background = Styles.createDisplay(this, _bgSkin.name);
                if (_background != null) _sprite.addChildAt(_background, 0);
            }
        }
        if (_background != null)
            _bgSkin.layout(_background, new Rectangle(0, 0, minWidth, minHeight));

        _isValid.value = true;
        return _size = new Point(minWidth, minHeight);
    }

    protected function conditionalInvalidate (value :Boolean) :void {
        if (value) _isValid.value = false;
    }

    protected var _components :Vector.<HasLayout> = new <HasLayout>[];

    protected var _size :Point = new Point(0, 0);
    protected var _background :DisplayObject;
    protected var _bgSkin :Skin;
}
}
