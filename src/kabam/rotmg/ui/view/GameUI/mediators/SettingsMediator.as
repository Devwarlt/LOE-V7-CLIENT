package kabam.rotmg.ui.view.GameUI.mediators {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import kabam.rotmg.ui.view.GameUI.HUDView;
import kabam.rotmg.ui.view.GameUI.UIs.ConnectionGameUI;
import kabam.rotmg.ui.view.GameUI.UIs.RegularOption;

public class SettingsMediator extends Sprite {
    private static const UI_OPTION_SPACE:int = 24;
    private static const UI_SOUND_MEDIATOR_OPTION_POSITION:Point = new Point(0, 0);
    private static const UI_CONNECTION_MEDIATOR_OPTION_POSITION:Point = new Point(UI_SOUND_MEDIATOR_OPTION_POSITION.x, UI_SOUND_MEDIATOR_OPTION_POSITION.y + UI_OPTION_SPACE * 2);

    private var hudView:HUDView;
    private var ui_soundMediatorOption:RegularOption;
    private var ui_connectionMediatorOption:RegularOption;

    public function SettingsMediator(_hudView:HUDView) {
        this.hudView = _hudView;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();

        this.updateButtons();
    }

    private function drawUI():void {
        this.ui_soundMediatorOption = new RegularOption("Sound", "turn game volume enabled or disabled", UI_SOUND_MEDIATOR_OPTION_POSITION);

        this.ui_connectionMediatorOption = new RegularOption("Connection", "show modal mediator UI with ping latency", UI_CONNECTION_MEDIATOR_OPTION_POSITION);
    }

    private function setUI():void { }

    private function outlineUI():void { }

    private function addUI():void {
        addChild(this.ui_soundMediatorOption);
        addChild(this.ui_connectionMediatorOption);
    }

    private function eventsUI():void {
        this.ui_soundMediatorOption.ui_OnButton.addEventListener(MouseEvent.CLICK, this.soundEnabled);
        this.ui_soundMediatorOption.ui_OffButton.addEventListener(MouseEvent.CLICK, this.soundDisabled);

        this.ui_connectionMediatorOption.ui_OnButton.addEventListener(MouseEvent.CLICK, this.connectionEnabled);
        this.ui_connectionMediatorOption.ui_OffButton.addEventListener(MouseEvent.CLICK, this.connectionDisabled);
    }

    private function soundEnabled(event:MouseEvent):void {
        HUDView.debug("Button 'ui_soundMediatorOnButton' has been clicked.");
        HUDView.debug("Sound enabled.");

        this.soundAction(true);
    }

    private function soundDisabled(event:MouseEvent):void {
        HUDView.debug("Button 'ui_soundMediatorOffButton' has been clicked.");
        HUDView.debug("Sound disabled.");

        this.soundAction(false);
    }

    private function connectionEnabled(event:MouseEvent):void {
        HUDView.debug("Button 'ui_connectionMediatorOnButton' has been clicked.");
        HUDView.debug("Connection enabled.");

        this.connectionAction(true);
    }

    private function connectionDisabled(event:MouseEvent):void {
        HUDView.debug("Button 'ui_connectionMediatorOffButton' has been clicked.");
        HUDView.debug("Connection disabled.");

        this.connectionAction(false);
    }

    private function soundAction(_arg1:Boolean, _arg2:Boolean = false):void {
        this.ui_soundMediatorOption.ui_OnButtonSprite.mouseEnabled = !_arg1;
        this.ui_soundMediatorOption.ui_OnButtonSprite.mouseChildren = !_arg1;
        this.ui_soundMediatorOption.ui_OnButton.setEnabled(_arg1, true);

        this.ui_soundMediatorOption.ui_OffButtonSprite.mouseEnabled = _arg1;
        this.ui_soundMediatorOption.ui_OffButtonSprite.mouseChildren = _arg1;
        this.ui_soundMediatorOption.ui_OffButton.setEnabled(!_arg1, true);

        if (!_arg2) {
            Parameters.data_.sound = _arg1;
            Parameters.save();
        }

        Music.setPlayMusic(_arg1);

        SFX.setPlaySFX();
        SFX.setSFXVolume();
    }

    private function connectionAction(_arg1:Boolean, _arg2:Boolean = false):void {
        this.ui_connectionMediatorOption.ui_OnButtonSprite.mouseEnabled = !_arg1;
        this.ui_connectionMediatorOption.ui_OnButtonSprite.mouseChildren = !_arg1;
        this.ui_connectionMediatorOption.ui_OnButton.setEnabled(_arg1, true);

        this.ui_connectionMediatorOption.ui_OffButtonSprite.mouseEnabled = _arg1;
        this.ui_connectionMediatorOption.ui_OffButtonSprite.mouseChildren = _arg1;
        this.ui_connectionMediatorOption.ui_OffButton.setEnabled(!_arg1, true);

        if (!_arg2)
            this.hudView.updateConnectionGameUI(_arg1);
    }

    private function updateButtons():void {
        this.soundAction(Parameters.data_.sound, true);
        this.connectionAction(Parameters.data_.displayConnectionMediator, true);
    }
}
}
