package kabam.rotmg.ui.view.GameHUDView.GameUI {
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextFieldAutoSize;

import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.GameHUDView.*;

public class SettingsGameUI extends GameUIScreen {
    private static const UI_SETTINGS_SOUND_MEDIATOR_POSITION:Point = new Point(32, 64);

    public function SettingsGameUI(_hudView:HUDView) {
        this.ui_settingsGameUIBackgroundOverlay_ = new Shape();

        this.ui_settingsGameUITitle_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF);
        this.ui_settingsGameUITitle_.setTextWidth(800);
        this.ui_settingsGameUITitle_.setBold(true);
        this.ui_settingsGameUITitle_.setAutoSize(TextFieldAutoSize.CENTER);
        this.ui_settingsGameUITitle_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.ui_settingsGameUITitle_.setStringBuilder(new LineBuilder().setParams("Settings"));

        this.ui_settingsGameUICloseButton_ = PetsViewAssetFactory.returnCloseButton(800 - 56);

        super(_hudView);
    }
    private var ui_settingsSoundMediator:SettingsMediator;
    private var ui_settingsGameUIBackgroundOverlay_:Shape;
    private var ui_settingsGameUITitle_:TextFieldDisplayConcrete;
    private var ui_settingsGameUICloseButton_:DialogCloseButton;

    override public function drawUI():void {
        var _local1:Graphics = this.ui_settingsGameUIBackgroundOverlay_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.9);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();

        this.ui_settingsSoundMediator = new SettingsMediator(this.hudView);
    }

    override public function setUI():void {
        this.ui_settingsGameUITitle_.y = 8;

        this.ui_settingsGameUICloseButton_.x = 800 - this.ui_settingsGameUICloseButton_.width - 4;
        this.ui_settingsGameUICloseButton_.y = 4;

        this.ui_settingsSoundMediator.x = UI_SETTINGS_SOUND_MEDIATOR_POSITION.x;
        this.ui_settingsSoundMediator.y = UI_SETTINGS_SOUND_MEDIATOR_POSITION.y;
    }

    override public function addUI():void {
        addChild(this.ui_settingsGameUIBackgroundOverlay_);
        addChild(this.ui_settingsGameUITitle_);
        addChild(this.ui_settingsGameUICloseButton_);
        addChild(this.ui_settingsSoundMediator);
    }

    override public function eventsUI():void {
        this.ui_settingsGameUICloseButton_.addEventListener(MouseEvent.CLICK, this.onClose);
    }

    override public function destroy():void {
        this.ui_settingsGameUICloseButton_.removeEventListener(MouseEvent.CLICK, this.onClose);

        removeChild(this.ui_settingsGameUIBackgroundOverlay_);
        removeChild(this.ui_settingsGameUITitle_);
        removeChild(this.ui_settingsGameUICloseButton_);
        removeChild(this.ui_settingsSoundMediator);
    }

    private function onClose(event:MouseEvent):void {
        //this.hudView.ui_settingsGameUI.visible = false;

        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
