package org.roguenet.framed.display {

import aspire.util.Enum;

import org.roguenet.framed.style.Skin;
import org.roguenet.framed.style.Styles;

public class ButtonState extends Enum {
    public static const UP :ButtonState = new ButtonState("UP", "upSkin");
    public static const DOWN :ButtonState = new ButtonState("DOWN", "downSkin");
    finishedEnumerating(ButtonState);

    public static function values () :Array {
        return Enum.values(ButtonState);
    }

    public static function valueOf (name :String) :ButtonState {
        return Enum.valueOf(ButtonState, name) as ButtonState;
    }

    public function skin (styles :Styles) :Skin { return styles[_skin]; }

    /* @private */
    public function ButtonState (name :String, skin :String) {
        super(name);
        _skin = skin;
    }

    protected var _skin :String;
}
}
