package org.roguenet.framed.display {

import aspire.util.Log;

import flash.geom.Point;

import flashbang.util.TextFieldBuilder;

import org.roguenet.framed.style.Styles;
import org.roguenet.framed.style.Ternary;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class Text extends LayoutSpriteObject {
    public function Text (text :String) :void {
        this.text = text;
    }

    public function get text () :String { return _text; }
    public function set text (value :String) {
        _text = value == null ? "" : value;
        _isValid.value = false;
    }

    override public function get inline () :Boolean {
        // default true
        return !absoluteLayout && styles.inline != Ternary.FALSE;
    }

    override public function layout (sizeHint :Point) :Point {
        if (_isValid.value) return _size;

        var styles :Styles = this.styles;
        if (styles.textBuilder == null) {
            log.warning("Text requires a textBuilder style");
            _isValid.value = true;
            return _size = new Point(0, 0);
        }

        var builder :TextFieldBuilder = styles.textBuilder;
        if (builder == null) builder = Frame.resolveInherited(container, "textBuilder");
        var field :TextField = builder.build();
        var maxWidth :int = styles.width >= 0 ? styles.width : sizeHint.x;
        field.width = maxWidth;
        field.autoSize = TextFieldAutoSize.VERTICAL;
        field.text = _text;
        // if we're multiline, declare that we've taken the full width we laid out with.;
        var multiline :Boolean = field.height > TextField.getBitmapFont(field.fontName).lineHeight;
        _size = new Point(multiline ? maxWidth : field.width, field.height);
        if (_size.x != field.textBounds.width && field.hAlign != HAlign.LEFT) {
            field.x = _size.x - field.textBounds.width; // right align
            if (field.hAlign == HAlign.CENTER) field.x /= 2; // center align
        }

        if (_field != null) _field.removeFromParent();
        _sprite.addChild(_field = field);
        return _size;
    }

    protected var _text :String;
    protected var _field :TextField;
    protected var _size :Point;

    private static const log :Log = Log.getLog(Text);
}
}
