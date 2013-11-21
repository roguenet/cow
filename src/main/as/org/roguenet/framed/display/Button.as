package org.roguenet.framed.display {

import flash.geom.Point;

import org.roguenet.framed.style.Styles;

import react.SignalView;
import react.UnitSignal;

import starling.display.DisplayObject;
import starling.events.Touch;

public class Button extends LayoutSpriteObject {
    public function get clicked () :SignalView { return _clicked; }

    override protected function added () :void {
        regs.add(touchBegan.connect(onTouchBegan));
        regs.add(touchMoved.connect(onTouchMoved));
        regs.add(touchEnded.connect(onTouchEnded));
    }

    protected function onTouchBegan (touch :Touch) :void {
        if (_clickTouchId >= 0) return;
        _clickTouchId = touch.id;
        setState(ButtonState.DOWN);
    }

    protected function onTouchMoved (touch :Touch) :void {
        if (_clickTouchId != touch.id) return;
        if (!contains(touch)) onTouchEnded(touch);
    }

    protected function onTouchEnded (touch :Touch) :void {
        if (_clickTouchId != touch.id) return;

        _clickTouchId = -1;
        setState(ButtonState.UP);

        if (contains(touch)) _clicked.emit();
    }

    protected function contains (touch :Touch) :Boolean {
        var loc :Point = touch.getLocation(_sprite.parent);
        return _sprite.bounds.contains(loc.x, loc.y);
    }

    protected function setState (state :ButtonState) :void {
        if (_state == state) return;
        _state = state;
        updateSkin();
    }

    protected function updateSkin () :void {
        if (_upSkin != null) _upSkin.visible = _state == ButtonState.UP;
        if (_downSkin != null) _downSkin.visible = _state == ButtonState.DOWN;
    }

    override public function layout (sizeHint :Point) :Point {
        var styles :Styles = Frame.resolveStyles(this);
        if (styles == null) {
            _isValid.value = true;
            return new Point(0, 0);
        }

        var size :Point = new Point(0, 0);
        if (_upSkin != null) _upSkin.removeFromParent();
        _upSkin = Frame.createStyleDisplay(this, ButtonState.UP.skinName(styles));
        if (_upSkin != null) {
            _sprite.addChild(_upSkin);
            size.x = Math.max(size.x, _upSkin.width);
            size.y = Math.max(size.y, _upSkin.height);
            _upSkin.visible = false;
        }

        if (_downSkin != null) _downSkin.removeFromParent();
        _downSkin = Frame.createStyleDisplay(this, ButtonState.DOWN.skinName(styles));
        if (_downSkin != null) {
            _sprite.addChild(_downSkin);
            size.x = Math.max(size.x, _downSkin.width);
            size.y = Math.max(size.y, _downSkin.height);
            _downSkin.visible = false;
        }

        updateSkin();
        return size;
    }

    protected var _clicked :UnitSignal = new UnitSignal();
    protected var _clickTouchId :int = -1;
    protected var _state :ButtonState = ButtonState.UP;
    protected var _upSkin :DisplayObject;
    protected var _downSkin :DisplayObject;
}
}
