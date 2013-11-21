package org.roguenet.framed.style {

import aspire.util.Enum;

public class Ternary extends Enum {
    public static const TRUE :Ternary = new Ternary("TRUE");
    public static const FALSE :Ternary = new Ternary("FALSE");
    public static const UNKNOWN :Ternary = new Ternary("UNKNOWN");
    finishedEnumerating(Ternary);

    public static function values () :Array {
        return Enum.values(Ternary);
    }

    public static function valueOf (name :String) :Ternary {
        return Enum.valueOf(Ternary, name) as Ternary;
    }

    /* @private */
    public function Ternary (name :String) {
        super(name);
    }
}
}
