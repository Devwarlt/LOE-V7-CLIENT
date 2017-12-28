package com.company.assembleegameclient.screens.charrects {
import com.company.rotmg.graphics.StarGraphic;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class CharacterRect extends Sprite {

    public static const WIDTH:int = 419;
    public static const HEIGHT:int = 59;

    public var color:uint;
    public var overColor:uint;
    private var box:Shape;
    protected var taglineClassIcon:Sprite;
    protected var taglineClassText:TextFieldDisplayConcrete;
    protected var taglineFameIcon:Bitmap;
    protected var taglineFameText:TextFieldDisplayConcrete;
    protected var classNameText:TextFieldDisplayConcrete;
    protected var className:StringBuilder;
    protected var tagLineExpIcon:Bitmap;
    protected var taglineExpText:TextFieldDisplayConcrete;
    public var selectContainer:Sprite;

    public function CharacterRect() {
        this.box = new Shape();
        super();
    }

    protected static function makeDropShadowFilter():Array {
        return ([new DropShadowFilter(0, 0, 0, 1, 8, 8)]);
    }


    public function init():void {
        tabChildren = false;
        this.makeBox();
        this.makeContainer();
        this.makeClassNameText();
        this.addEventListeners();
    }

    private function addEventListeners():void {
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    public function makeBox():void {
        this.drawBox(false);
        addChild(this.box);
    }

    protected function onMouseOver(_arg1:MouseEvent):void {
        this.drawBox(true);
    }

    protected function onRollOut(_arg1:MouseEvent):void {
        this.drawBox(false);
    }

    private function drawBox(_arg1:Boolean):void {
        this.box.graphics.clear();
        this.box.graphics.beginFill(((_arg1) ? this.overColor : this.color));
        this.box.graphics.drawRect(0, 0, WIDTH, HEIGHT);
        this.box.graphics.endFill();
    }

    public function makeContainer():void {
        this.selectContainer = new Sprite();
        this.selectContainer.mouseChildren = false;
        this.selectContainer.buttonMode = true;
        this.selectContainer.graphics.beginFill(0xFF00FF, 0);
        this.selectContainer.graphics.drawRect(0, 0, WIDTH, HEIGHT);
        addChild(this.selectContainer);
    }

    protected function makeClassNameText():void {
        this.classNameText = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF);
        this.classNameText.setBold(true);
        this.classNameText.setStringBuilder(this.className);
        this.classNameText.filters = makeDropShadowFilter();
        this.classNameText.x = CharacterRectConstants.LABELS_REFERENCE_X;
        this.classNameText.y = 4;
        this.selectContainer.addChild(this.classNameText);
    }

    protected function makeTagline(_arg1:StringBuilder, _arg2:StringBuilder = null, _arg3:StringBuilder = null, _arg4:Boolean = false):void {
        this.taglineClassIcon = new StarGraphic();
        this.taglineClassIcon.transform.colorTransform = _arg4 ? new ColorTransform((255 / 0xFF), (255 / 0xFF), (0 / 0xFF)) : new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
        this.taglineClassIcon.scaleX = 1.2;
        this.taglineClassIcon.scaleY = 1.2;
        this.taglineClassIcon.x = CharacterRectConstants.LABELS_REFERENCE_X;
        this.taglineClassIcon.y = 24;
        this.taglineClassIcon.filters = [new DropShadowFilter(0, 0, 0)];
        this.selectContainer.addChild(this.taglineClassIcon);
        this.taglineClassText = new TextFieldDisplayConcrete().setSize(14).setColor(_arg4 ? 0xFFFF00 : 0xB3B3B3);
        this.taglineClassText.setStringBuilder(_arg1);
        this.taglineClassText.filters = makeDropShadowFilter();
        this.taglineClassText.x = CharacterRectConstants.LABELS_REFERENCE_X + 2;
        this.taglineClassText.y = 24;
        this.selectContainer.addChild(this.taglineClassText);
        if (_arg2 != null) {
            this.taglineFameIcon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 30));
            this.taglineFameIcon.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
            this.taglineFameIcon.filters = [new DropShadowFilter(0, 0, 0)];
            this.taglineFameIcon.x = CharacterRectConstants.LABELS_REFERENCE_X + 108;
            this.taglineFameIcon.y = 24;
            this.selectContainer.addChild(this.taglineFameIcon);
            this.taglineFameText = new TextFieldDisplayConcrete().setSize(14).setColor(0xB3B3B3);
            this.taglineFameText.setStringBuilder(_arg2);
            this.taglineFameText.filters = makeDropShadowFilter();
            this.taglineFameText.x = CharacterRectConstants.LABELS_REFERENCE_X + 2 + 108;
            this.taglineFameText.y = 24;
            this.selectContainer.addChild(this.taglineFameText);
        }
        if (_arg3 != null) {
            this.tagLineExpIcon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 15));
            this.tagLineExpIcon.transform.colorTransform = new ColorTransform((179 / 0xFF), (179 / 0xFF), (179 / 0xFF));
            this.tagLineExpIcon.filters = [new DropShadowFilter(0, 0, 0)];
            this.tagLineExpIcon.x = CharacterRectConstants.LABELS_REFERENCE_X - 1;
            this.tagLineExpIcon.y = 40;
            this.selectContainer.addChild(this.tagLineExpIcon);
            this.taglineExpText = new TextFieldDisplayConcrete().setSize(14).setColor(0xB3B3B3);
            this.taglineExpText.setStringBuilder(_arg3);
            this.taglineExpText.filters = makeDropShadowFilter();
            this.taglineExpText.x = CharacterRectConstants.LABELS_REFERENCE_X + 1;
            this.taglineExpText.y = 40;
            this.selectContainer.addChild(this.taglineExpText);
        }
    }
}
}
