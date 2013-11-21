package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.util.Listeners;

import org.roguenet.framed.style.Styles;

import react.BoolView;

public interface HasLayout {
    function get container () :HasLayout;
    function set container (value :HasLayout) :void;

    function get classes () :Vector.<String>;

    function get isValid () :BoolView;

    // most HasLayouts will be GameObjects, and get this for free
    function get regs () :Listeners;

    // layout-related styles, with potential default overrides per class
    function get absoluteLayout () :Boolean;
    function get top () :int;
    function get right () :int;
    function get bottom () :int;
    function get left () :int;
    function get inline () :Boolean;

    function layout (sizeHint :Point) :Point;
}
}
