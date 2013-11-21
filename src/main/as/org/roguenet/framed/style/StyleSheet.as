package org.roguenet.framed.style {

import aspire.util.Map;
import aspire.util.Maps;

import starling.display.DisplayObject;

public class StyleSheet {
    public function StyleSheet (styles :Vector.<Styles>,
            displayFactories :Vector.<DisplayFactory> = null) {
        _styles = styles;

        if (displayFactories != null)
            for each (var factory :DisplayFactory in displayFactories)
                _displayFactories.put(factory.name, factory);
    }

    public function resolve (classes :Vector.<String>) :Styles {
        var key :String = getKey(classes);
        var style :Styles = _resolved.get(key);
        if (style != null) return style;

        style = new Styles(classes);
        for each (var block :Styles in _styles)
            if (block.appliesTo(classes)) block.copyTo(style);
        _resolved.put(key, style);
        return style;
    }

    public function createStyleDisplay (name :String) :DisplayObject {
        var factory :DisplayFactory = _displayFactories.get(name);
        return factory == null ? null : DisplayObject(factory.factory());
    }

    protected static function getKey (classes :Vector.<String>) :String {
        classes.sort(0);
        return classes.join("|");
    }

    protected var _styles :Vector.<Styles>;
    protected var _displayFactories :Map = Maps.newMapOf(String);
    protected var _resolved :Map = Maps.newMapOf(String);
}
}
