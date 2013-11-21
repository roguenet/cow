package org.roguenet.framed.display {

import aspire.util.Log;

import flash.geom.Point;

import flashbang.util.TextFieldBuilder;

import org.roguenet.framed.style.Styles;
import org.roguenet.framed.style.Ternary;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;

public class Text extends LayoutSpriteObject {
    public function Text (text :String) :void {
        this.text = text;
    }

    public function get text () :String { return _text; }
    public function set text (value :String) :void {
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
        var builder :TextFieldBuilder = styles.textBuilder;
        if (builder == null) builder = Styles.inherit(container, "textBuilder");
        if (builder == null) {
            log.warning("Text requires a textBuilder style");
            _isValid.value = true;
            return _size = new Point(0, 0);
        }

        var field :TextField = builder.build();
        var maxWidth :int = styles.width >= 0 ? styles.width : sizeHint.x;
        field.width = maxWidth;
        // only set our field height if we have a style for it, otherwise let the text declare our
        // height
        if (styles.height >= 0) field.height = styles.height;
        field.autoSize = TextFieldAutoSize.VERTICAL;
        field.text = _text;
        // if we're multiline, declare that we've taken the full width we laid out with.;
        var multiline :Boolean = field.height > TextField.getBitmapFont(field.fontName).lineHeight;
        _size = new Point(multiline ? maxWidth : field.textBounds.width, field.height);
        if (_size.x != field.width) field.width = _size.x; // resize the field down if it's too big

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
