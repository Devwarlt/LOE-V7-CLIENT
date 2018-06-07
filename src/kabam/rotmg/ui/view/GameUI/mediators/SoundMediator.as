package kabam.rotmg.ui.view.GameUI.mediators {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import kabam.rotmg.ui.view.HUDView;

public class SoundMediator extends Sprite {
    private static const UI_SOUND_MEDIATOR_BUTTON_SPACE:int = 8;
    private static const UI_SOUND_MEDIATOR_BUTTON_HEIGHT:int = 16;
    private static const UI_SOUND_MEDIATOR_BUTTON_WIDTH:int = 120;
    private static const UI_SOUND_MEDIATOR_ON_BUTTON_POSITION:Point = new Point(0, 0);
    private static const UI_SOUND_MEDIATOR_OFF_BUTTON_POSITION:Point = new Point(UI_SOUND_MEDIATOR_ON_BUTTON_POSITION.x + UI_SOUND_MEDIATOR_BUTTON_WIDTH + UI_SOUND_MEDIATOR_BUTTON_SPACE, UI_SOUND_MEDIATOR_ON_BUTTON_POSITION.y);
    private static const UI_SOUND_MEDIATOR_LABEL_POSITION:Point = new Point(UI_SOUND_MEDIATOR_OFF_BUTTON_POSITION.x + UI_SOUND_MEDIATOR_BUTTON_WIDTH + UI_SOUND_MEDIATOR_BUTTON_HEIGHT, UI_SOUND_MEDIATOR_OFF_BUTTON_POSITION.y + UI_SOUND_MEDIATOR_BUTTON_SPACE / 2);

    private var ui_soundMediatorOnButton:DeprecatedTextButton;
    private var ui_soundMediatorOffButton:DeprecatedTextButton;
    private var ui_soundMediatorOnButtonSprite:Sprite;
    private var ui_soundMediatorOffButtonSprite:Sprite;
    private var ui_soundMediatorLabel:BaseSimpleText;

    public function SoundMediator() {
        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();

        this.updateButtons();
    }

    private function drawUI():void {
        this.ui_soundMediatorOnButton = new DeprecatedTextButton(UI_SOUND_MEDIATOR_BUTTON_HEIGHT, "On", UI_SOUND_MEDIATOR_BUTTON_WIDTH);

        this.ui_soundMediatorOffButton = new DeprecatedTextButton(UI_SOUND_MEDIATOR_BUTTON_HEIGHT, "Off", UI_SOUND_MEDIATOR_BUTTON_WIDTH);

        this.ui_soundMediatorOnButtonSprite = new Sprite();

        this.ui_soundMediatorOffButtonSprite = new Sprite();

        this.ui_soundMediatorLabel = new BaseSimpleText(12, 0xE8E8E8, false, 800, 0);
        this.ui_soundMediatorLabel.selectable = false;
        this.ui_soundMediatorLabel.border = false;
        this.ui_soundMediatorLabel.mouseEnabled = true;
        this.ui_soundMediatorLabel.htmlText = "<b>Sound:</b> turn game volume enabled or disabled.";
        this.ui_soundMediatorLabel.useTextDimensions();
    }

    private function setUI():void {
        this.ui_soundMediatorOnButtonSprite.x = UI_SOUND_MEDIATOR_ON_BUTTON_POSITION.x;
        this.ui_soundMediatorOnButtonSprite.y = UI_SOUND_MEDIATOR_ON_BUTTON_POSITION.y;

        this.ui_soundMediatorOffButtonSprite.x = UI_SOUND_MEDIATOR_OFF_BUTTON_POSITION.x;
        this.ui_soundMediatorOffButtonSprite.y = UI_SOUND_MEDIATOR_OFF_BUTTON_POSITION.y;

        this.ui_soundMediatorLabel.x = UI_SOUND_MEDIATOR_LABEL_POSITION.x;
        this.ui_soundMediatorLabel.y = UI_SOUND_MEDIATOR_LABEL_POSITION.y;
    }

    private function outlineUI():void {
        this.ui_soundMediatorOnButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_soundMediatorOffButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_soundMediatorLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    private function addUI():void {
        this.ui_soundMediatorOnButtonSprite.addChild(this.ui_soundMediatorOnButton);

        this.ui_soundMediatorOffButtonSprite.addChild(this.ui_soundMediatorOffButton);

        addChild(this.ui_soundMediatorOnButtonSprite);
        addChild(this.ui_soundMediatorOffButtonSprite);
        addChild(this.ui_soundMediatorLabel);
    }

    private function eventsUI():void {
        this.ui_soundMediatorOnButton.addEventListener(MouseEvent.CLICK, this.soundEnabled);

        this.ui_soundMediatorOffButton.addEventListener(MouseEvent.CLICK, this.soundDisabled);
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

    private function soundAction(_arg1:Boolean, _arg2:Boolean = false):void {
        this.ui_soundMediatorOnButtonSprite.mouseEnabled = !_arg1;
        this.ui_soundMediatorOnButtonSprite.mouseChildren = !_arg1;
        this.ui_soundMediatorOnButton.setEnabled(_arg1, true);

        this.ui_soundMediatorOffButtonSprite.mouseEnabled = _arg1;
        this.ui_soundMediatorOffButtonSprite.mouseChildren = _arg1;
        this.ui_soundMediatorOffButton.setEnabled(!_arg1, true);

        if (!_arg2) {
            Parameters.data_.sound = _arg1;
            Parameters.save();
        }

        Music.setPlayMusic(_arg1);

        SFX.setPlaySFX(_arg1);
        SFX.setSFXVolume(_arg1 ? 1 : 0);
    }

    private function updateButtons():void {
        this.soundAction(Parameters.data_.sound, true);
    }
}
}
