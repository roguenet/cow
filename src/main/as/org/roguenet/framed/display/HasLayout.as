package org.roguenet.framed.display {

import flash.geom.Point;

import flashbang.util.Listeners;

import org.roguenet.framed.style.Styles;

import react.BoolView;

public interface HasLayout {
    function get container () :HasLayout;
    function set container (value :HasLayout) :void;

    function get classes () :Vector.<String>;

    function get styles () :Styles;

    function get isValid () :BoolView;

    // most HasLayouts will be GameObjects, and get this for free
    function get regs () :Listeners;

    function layout (sizeHint :Point) :Point;
}
}
