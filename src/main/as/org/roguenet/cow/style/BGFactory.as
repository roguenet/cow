package org.roguenet.cow.style {

public class BGFactory {
    public function BGFactory (name :String, factory :Function) {
        _name = name;
        _factory = factory
    }

    public function get name () :String { return _name; }
    public function get factory () :Function { return _factory; }

    protected var _name :String;
    protected var _factory :Function;
}
}
