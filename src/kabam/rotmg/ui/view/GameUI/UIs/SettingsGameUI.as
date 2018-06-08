package kabam.rotmg.ui.view.GameUI.UIs {
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
import kabam.rotmg.ui.view.GameUI.*;
import kabam.rotmg.ui.view.GameUI.mediators.SettingsMediator;

public class SettingsGameUI extends GameUIScreen {
    /*
    * [OVERVIEW]
    * Settings options:
    *
    * - Sound:
    *       Turn game sounds enabled (on) or disabled (off);
    * - Connection:
    *       Show modal mediator UI with:
    *           -> Ping Latency:
    *               - red circle indicator: latency above 500 ms;
    *               - orange circle indicator: latency between 250 to 499 ms;
    *               - yellow circle indicator: latency between 100 to 249 ms;
    *               - green circle indicator: latency under 99 ms.
    * - Game Status:
    *       Show modal mediator UI with:
    *           -> 'FPS': show number of frames per second rendered;
    *           -> 'Memory Usage': show memory used by client instance before crash notification*.
    *           // TODO: implement 'Crash Notification'. It's Quality of Life feature.
    * - Character Analytics:
    *       Show modal mediator UI with:
    *           -> 'Character Level': display label 'level' and current level of character into bottom UI shape;
    *           -> 'Character Experience': display a bottom big bar with percentage completed in current level and experience remain until next level;
    *           -> 'Character Health Points': display the current health points of character using following structure '{CURRENT_HEALTH_POINTS}/{MAX_HEALTH_POINTS}' and also fit half size of 'Character Experience Bar' in the bottom left corner of game UI;
    *           -> 'Character Magic Points': display the current magic points of character using following structure '{CURRENT_MAGIC_POINTS}/{MAX_MAGIC_POINTS}' and also fit half size of 'Character Experience Bar' in the bottom right corner of game UI;
    *           // TODO: implement 'Experience Analytics'. It's Quality of Life feature.
    * */

    private static const UI_SETTINGS_SOUND_MEDIATOR_POSITION:Point = new Point(32, 64);

    private var ui_settingsSoundMediator:SettingsMediator;

    private var ui_settingsGameUIBackgroundOverlay_:Shape;
    private var ui_settingsGameUITitle_:TextFieldDisplayConcrete;
    private var ui_settingsGameUICloseButton_:DialogCloseButton;

    public function SettingsGameUI(_hudView:HUDView) {
        this.hudView = _hudView;

        this.ui_settingsGameUIBackgroundOverlay_ = new Shape();

        this.ui_settingsGameUITitle_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF);
        this.ui_settingsGameUITitle_.setTextWidth(800);
        this.ui_settingsGameUITitle_.setBold(true);
        this.ui_settingsGameUITitle_.setAutoSize(TextFieldAutoSize.CENTER);
        this.ui_settingsGameUITitle_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.ui_settingsGameUITitle_.setStringBuilder(new LineBuilder().setParams("Settings"));

        this.ui_settingsGameUICloseButton_ = PetsViewAssetFactory.returnCloseButton(800 - 56);

        super();
    }

    override public function drawUI():void {
        var _local1:Graphics = this.ui_settingsGameUIBackgroundOverlay_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
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

    private function onClose(event:MouseEvent):void {
        this.hudView.ui_settingsGameUI.visible = false;

        dispatchEvent(new Event(Event.COMPLETE));
    }

    override public function destroy():void {
        this.ui_settingsGameUICloseButton_.removeEventListener(MouseEvent.CLICK, this.onClose);

        removeChild(this.ui_settingsGameUIBackgroundOverlay_);
        removeChild(this.ui_settingsGameUITitle_);
        removeChild(this.ui_settingsGameUICloseButton_);
        removeChild(this.ui_settingsSoundMediator);
    }
}
}
