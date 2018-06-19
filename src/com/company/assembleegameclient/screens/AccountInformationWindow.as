package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;

public class AccountInformationWindow extends Sprite {

    private var darkBox_:Shape;
    private var dialog_:Dialog;
    private var text_:String;
    private var viewBoard_:ViewBoard;
    private var client_:AppEngineClient;

    public function AccountInformationWindow() {
        this.darkBox_ = new Shape();
        var _local1:Graphics = this.darkBox_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();
        addChild(this.darkBox_);
        this.load();
    }

    private function load():void {
        this.client_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.client_.complete.addOnce(this.onAccountInformationComplete);
        this.client_.sendRequest("/account/accountInformation", StaticInjectorContext.getInjector().getInstance(WebAccount).getCredentials());
        this.dialog_ = new Dialog(null, "Loading...", null, null, null);
        addChild(this.dialog_);
        this.darkBox_.visible = false;
    }

    private function onAccountInformationComplete(_arg1:Boolean, _arg2:*):void {
        _arg1 ? this.showAccountInformation(_arg2) : this.reportError(_arg2);
    }

    private function showAccountInformation(_arg1:String):void {
        this.darkBox_.visible = true;
        removeChild(this.dialog_);
        this.text_ = _arg1;
        this.show();
    }

    private function reportError(_arg1:String):void {
        this.darkBox_.visible = true;
        removeChild(this.dialog_);
        this.text_ = "An unexpected error occurred: " + _arg1;
        this.show();
    }

    private function show():void {
        this.viewBoard_ = new ViewBoard(this.text_);
        this.viewBoard_.addEventListener(Event.COMPLETE, this.onViewComplete);
        addChild(this.viewBoard_);
    }

    private function onViewComplete(_arg1:Event):void {
        parent.removeChild(this);
    }
}
}

import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.ui.BaseSimpleText;
import com.company.util.GraphicsUtil;

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.text.model.TextKey;

class ViewBoard extends Sprite {

    public static const TEXT_WIDTH:int = 400;
    public static const TEXT_HEIGHT:int = 400;

    private var text_:String;
    public var w_:int;
    public var h_:int;
    private var boardText_:BaseSimpleText;
    private var mainSprite_:Sprite;
    private var scrollBar_:Scrollbar;
    private var closeButton_:DeprecatedTextButton;
    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x333333, 1);
    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, outlineFill_);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());

    private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE];

    public function ViewBoard(_arg1:String) {
        super();
        this.text_ = _arg1;
        this.mainSprite_ = new Sprite();
        var _local3:Shape = new Shape();
        var _local4:Graphics = _local3.graphics;
        _local4.beginFill(0);
        _local4.drawRect(0, 0, TEXT_WIDTH, TEXT_HEIGHT);
        _local4.endFill();
        this.mainSprite_.addChild(_local3);
        this.mainSprite_.mask = _local3;
        addChild(this.mainSprite_);
        this.boardText_ = new BaseSimpleText(16, 0xB3B3B3, false, TEXT_WIDTH, 0);
        this.boardText_.selectable = true;
        this.boardText_.border = false;
        this.boardText_.mouseEnabled = true;
        this.boardText_.multiline = true;
        this.boardText_.wordWrap = true;
        this.boardText_.htmlText = this.text_;
        this.boardText_.useTextDimensions();
        this.mainSprite_.addChild(this.boardText_);
        var _local6:Boolean = (this.boardText_.height > 400);
        if (_local6) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = (TEXT_WIDTH + 6);
            this.scrollBar_.y = 0;
            this.scrollBar_.setIndicatorSize(400, this.boardText_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH + ((_local6) ? 26 : 0));
        this.closeButton_ = new DeprecatedTextButton(14, TextKey.VIEW_GUILD_BOARD_CLOSE, 120);
        this.closeButton_.x = (this.w_ - 124);
        this.closeButton_.y = (TEXT_HEIGHT + 4);
        this.closeButton_.addEventListener(MouseEvent.CLICK, this.onClose);
        this.closeButton_.textChanged.addOnce(this.layoutBackground);
        addChild(this.closeButton_);
    }

    private function layoutBackground():void {
        this.h_ = ((TEXT_HEIGHT + this.closeButton_.height) + 8);
        x = ((800 / 2) - (this.w_ / 2));
        y = ((600 / 2) - (this.h_ / 2));
        graphics.clear();
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(-6, -6, (this.w_ + 12), (this.h_ + 12), 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onScrollBarChange(_arg1:Event):void {
        this.boardText_.y = (-(this.scrollBar_.pos()) * (this.boardText_.height - 400));
    }

    private function onClose(_arg1:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }
}