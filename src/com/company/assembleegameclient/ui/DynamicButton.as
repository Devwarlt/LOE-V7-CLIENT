package com.company.assembleegameclient.ui {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class DynamicButton extends Sprite {

    public var bitmap_:Bitmap;
    private var in_:BitmapData;
    private var out_:BitmapData;
    private var label_:DeprecatedClickableText;

    public function DynamicButton(_labelSize:int, _labelText:String, _in:BitmapData, _out:BitmapData) {
        this.bitmap_ = new Bitmap(_in);
        this.in_ = _in;
        this.out_ = _out;
        this.label_ = new DeprecatedClickableText(_labelSize, true, _labelText, false);
        this.label_.x = this.bitmap_.x + this.bitmap_.width / 4;
        this.label_.y = this.bitmap_.y + this.bitmap_.height / 4;

        addChild(this.bitmap_);
        addChild(this.label_);

        addEventListener(MouseEvent.MOUSE_OVER, HoverOver);
        addEventListener(MouseEvent.MOUSE_OUT, HoverOut);
    }

    private function HoverOver(_arg1:MouseEvent):void {
        this.bitmap_.bitmapData = this.out_;
    }

    private function HoverOut(_arg1:MouseEvent):void {
        this.bitmap_.bitmapData = this.in_;
    }
}
}