package org.roguenet.framed.display {

import flash.geom.Point;

import org.roguenet.framed.style.Skin;
import org.roguenet.framed.style.Styles;

import react.SignalView;
import react.UnitSignal;

import starling.display.DisplayObject;
import starling.events.Touch;

public class Button extends Block {
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
        if (_up != null) _up.visible = _state == ButtonState.UP;
        if (_down != null) _down.visible = _state == ButtonState.DOWN;
    }

    override public function layout (sizeHint :Point) :Point {
        if (_isValid.value) return super.layout(sizeHint);

        var size :Point = super.layout(sizeHint);
        var styles :Styles = this.styles;
        if (styles == null) return size;

        var upSkin :Skin = ButtonState.UP.skin(styles);
        if (upSkin != _upSkin) {
            _upSkin = upSkin;
            if (_up != null) _up.removeFromParent();
            if (_upSkin.name != null) _up = Frame.createStyleDisplay(this, _upSkin.name);
        }
        if (_up != null) {
            if (_up.parent != _sprite) _sprite.addChildAt(_up, _background == null ? 0 : 1);
            if (_upSkin.scale) {
                _up.width = size.x;
                _up.height = size.y;
            }
        }

        var downSkin :Skin = ButtonState.DOWN.skin(styles);
        if (downSkin != _downSkin) {
            _downSkin = downSkin;
            if (_down != null) _down.removeFromParent();
            if (_downSkin.name != null) _down = Frame.createStyleDisplay(this, _downSkin.name);
        }
        if (_down != null) {
            if (_down.parent != _sprite) _sprite.addChildAt(_down, _background == null ? 0 : 1);
            if (_downSkin.scale) {
                _down.width = size.x;
                _down.height = size.y;
            }
        }

        updateSkin();
        return size;
    }

    protected var _clicked :UnitSignal = new UnitSignal();
    protected var _clickTouchId :int = -1;
    protected var _state :ButtonState = ButtonState.UP;
    protected var _upSkin :Skin, _downSkin :Skin;
    protected var _up :DisplayObject, _down :DisplayObject;
}
}
