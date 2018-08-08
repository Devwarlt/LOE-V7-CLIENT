package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.objects.Player;

import flash.display.Sprite;
import flash.geom.Point;

import kabam.rotmg.ui.view.GameHUDView.GameUI.RegularOption;

import org.osflash.signals.Signal;

public class CharacterInfoMediator extends Sprite {
    private static const UI_LABEL_SPACE:int = 24;

    private var hudView:HUDView;
    private var player:Player;
    private var ui_characterInfoMediatorStatsUpdateSignal:Signal;
    private var ui_characterInfoNameMediatorOption:RegularOption;
    private var ui_characterInfoLevelMediatorOption:RegularOption;
    private var ui_characterInfoExperienceMediatorOption:RegularOption;
    private var ui_characterInfoHealthPointsMediatorOption:RegularOption;
    private var ui_characterInfoMagicPointsMediatorOption:RegularOption;
    private var ui_characterInfoAttackLevelMediatorOption:RegularOption;
    private var ui_characterInfoDefenseLevelMediatorOption:RegularOption;
    private var ui_characterInfoSpeedMediatorOption:RegularOption;

    public function CharacterInfoMediator(_hudView:HUDView) {
        this.hudView = _hudView;

        this.ui_characterInfoMediatorStatsUpdateSignal = new Signal();
        this.ui_characterInfoMediatorStatsUpdateSignal.addOnce(this.asyncEventsUI);
    }

    public function setPlayer(player:Player):void {
        this.hudView.gameSprite.player = this.player = player;

        this.ui_characterInfoMediatorStatsUpdateSignal.dispatch();
    }

    private function drawUI():void {
        this.ui_characterInfoNameMediatorOption = new RegularOption("Name", "\t\t" + player.name_, new Point(0, 0), false);
        this.ui_characterInfoLevelMediatorOption = new RegularOption("LVL", "\t\t\t" + player.charLvl, new Point(0, UI_LABEL_SPACE), false);
        this.ui_characterInfoExperienceMediatorOption = new RegularOption("EXP", "\t\t\t" + player.charEXP + " / <b>" + player.charNextEXP + "</b>", new Point(0, UI_LABEL_SPACE * 2), false);
        this.ui_characterInfoHealthPointsMediatorOption = new RegularOption("HP", "\t\t\t" + player.charHP + " / <b>" + player.charMaxHP + "</b>", new Point(0, UI_LABEL_SPACE * 3), false);
        this.ui_characterInfoMagicPointsMediatorOption = new RegularOption("MP", "\t\t\t" + player.charMP + " / <b>" + player.charMaxMP + "</b>", new Point(0, UI_LABEL_SPACE * 4), false);
        this.ui_characterInfoAttackLevelMediatorOption = new RegularOption("ATT", "\t\t\t" + player.charATTLvl, new Point(0, UI_LABEL_SPACE * 5), false);
        this.ui_characterInfoDefenseLevelMediatorOption = new RegularOption("DEF", "\t\t\t" + player.charDEFLvl, new Point(0, UI_LABEL_SPACE * 6), false);
        this.ui_characterInfoSpeedMediatorOption = new RegularOption("SPD", "\t\t\t" + player.charSPD, new Point(0, UI_LABEL_SPACE * 7), false);
    }

    private function setUI():void { }

    private function outlineUI():void { }

    private function addUI():void {
        addChild(this.ui_characterInfoNameMediatorOption);
        addChild(this.ui_characterInfoLevelMediatorOption);
        addChild(this.ui_characterInfoExperienceMediatorOption);
        addChild(this.ui_characterInfoHealthPointsMediatorOption);
        addChild(this.ui_characterInfoMagicPointsMediatorOption);
        addChild(this.ui_characterInfoAttackLevelMediatorOption);
        addChild(this.ui_characterInfoDefenseLevelMediatorOption);
        addChild(this.ui_characterInfoSpeedMediatorOption);
    }

    private function eventsUI():void { }

    private function asyncEventsUI():void {
        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();
    }
}
}
