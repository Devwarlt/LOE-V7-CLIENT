package kabam.rotmg.ui.view.GameUI {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class GameUIScreen extends Sprite {
    private var gameUIBackgroundOverlay_:Shape;
    private var gameUITitle_:TextFieldDisplayConcrete;
    private var gameUICloseButton_:DialogCloseButton;

    public function GameUIScreen(_title:String) {
        this.gameUIBackgroundOverlay_ = new Shape();

        this.gameUITitle_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF);
        this.gameUITitle_.setTextWidth(800);
        this.gameUITitle_.setBold(true);
        this.gameUITitle_.setAutoSize(TextFieldAutoSize.CENTER);
        this.gameUITitle_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.gameUITitle_.setStringBuilder(new LineBuilder().setParams(_title));

        this.gameUICloseButton_ = PetsViewAssetFactory.returnCloseButton(800 - 56);

        this.drawUI();
        this.setUI();
        this.addUI();
        this.eventsUI();
    }

    private function drawUI():void {
        var _local1:Graphics = this.gameUIBackgroundOverlay_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();

        this.drawExtraUI();
    }

    protected function drawExtraUI():void { }

    private function setUI():void {
        this.gameUITitle_.y = 8;

        this.gameUICloseButton_.x = 800 - this.gameUICloseButton_.width - 4;
        this.gameUICloseButton_.y = 4;

        this.setExtraUI();
    }

    protected function setExtraUI():void { }

    private function addUI():void {
        addChild(this.gameUIBackgroundOverlay_);
        addChild(this.gameUITitle_);
        addChild(this.gameUICloseButton_);

        this.addExtraUI();
    }

    protected function addExtraUI():void { }

    private function eventsUI():void {
        this.gameUICloseButton_.addEventListener(MouseEvent.CLICK, this.onClose);

        this.eventsExtraUI();
    }

    protected function eventsExtraUI():void { }

    private function onClose(event:Event):void {
        parent.removeChild(this);

        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
