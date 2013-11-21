package org.roguenet.framed.style {

public class Skin {
    public static const NONE :Skin = new Skin(null);

    public function Skin (value :Object) {
        _name = value == null ? null : (value is String ? value as String : value.name);
        _scale = value == null || value is String || !value.hasOwnProperty("scale") ?
            true : value.scale as Boolean;
    }

    public function get name () :String {
        return _name;
    }

    public function get scale () :Boolean {
        return _scale;
    }

    protected var _name :String;
    protected var _scale :Boolean;
}
}
