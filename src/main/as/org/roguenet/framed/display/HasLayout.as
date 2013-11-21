package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.util.Listeners;

import react.BoolView;

public interface HasLayout {
    function get container () :HasLayout;
    function set container (value :HasLayout) :void;

    function get classes () :Vector.<String>;

    function get isValid () :BoolView;

    // most HasLayouts will be GameObjects, and get this for free
    function get regs () :Listeners;

    function layout (availableSpace :Point) :Point;
}
}
