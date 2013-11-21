package org.roguenet.framed.style {

public class DisplayFactory {
    public function DisplayFactory (name :String, factory :Function) {
        _name = name;
        _factory = factory
    }

    public function get name () :String { return _name; }
    public function get factory () :Function { return _factory; }

    protected var _name :String;
    protected var _factory :Function;
}
}
