package org.roguenet.framed.display {

import aspire.util.Map;
import aspire.util.Maps;

import flash.geom.Point;
import flash.geom.Rectangle;

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
        for each (var state :ButtonState in ButtonState.values()) {
            var disp :DisplayObject = _skinDisplays.get(state);
            if (disp != null) disp.visible = _state == state;
        }
    }

    override public function layout (sizeHint :Point) :Point {
        if (_isValid.value) return super.layout(sizeHint);

        var size :Point = super.layout(sizeHint);
        var styles :Styles = this.styles;
        if (styles == null) return size;

        var skinBounds :Rectangle = new Rectangle(0, 0, size.x, size.y);
        for each (var state :ButtonState in ButtonState.values())
            setupSkin(state, styles, skinBounds);

        updateSkin();
        return size;
    }

    protected function setupSkin (state :ButtonState, styles :Styles, skinBounds :Rectangle) :void {
        var skin :Skin = _skins.get(state);
        var disp :DisplayObject = _skinDisplays.get(state);

        var newSkin :Skin = state.skin(styles);
        if (skin != newSkin) {
            _skins.put(state, skin = newSkin);
            if (disp != null) disp.removeFromParent();
            if (skin.name != null)
                _skinDisplays.put(state, disp = Frame.createStyleDisplay(this, skin.name));
        }
        if (disp != null) {
            if (disp.parent != _sprite) _sprite.addChildAt(disp, _background == null ? 0 : 1);
            skin.layout(disp, skinBounds);
        }
    }

    protected var _clicked :UnitSignal = new UnitSignal();
    protected var _clickTouchId :int = -1;
    protected var _state :ButtonState = ButtonState.UP;

    protected var _skinDisplays :Map = Maps.newMapOf(ButtonState); // <ButtonState, DisplayObject>
    protected var _skins :Map = Maps.newMapOf(ButtonState); // <ButtonState, Skin>
}
}
