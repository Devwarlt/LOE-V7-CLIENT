package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.objects.Player;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.rotmg.ui.view.GameHUDView.GameBar;
import kabam.rotmg.ui.view.GameHUDView.HUDView;

import org.osflash.signals.Signal;

public class CharacterStatusGameUI extends GameUIScreen {
    private static const UI_CHARACTER_STATUS_MEDIATOR_SPACE:int = 12 * 2;
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL:String = "{LEVEL}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXP_LABEL:String = "{EXP}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_EXP_TEXT:String = "<b>Level:</b> " + UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL + "\t<b>Total EXP:</b> " + UI_CHARACTER_STATUS_MEDIATOR_EXP_LABEL;

    private var player:Player;

    /*var tween:GTween = new GTween(textField,2,{alpha:0, x: textField.x + 25, y: textField.y - 25},{swapValues:false, ease:Circular.easeIn}, {MotionBlurEnabled:true});
        tween.repeatCount = -1;*/

    private var ui_characterStatusMediatorSprite:Sprite;
    private var ui_characterStatusMediatorExperienceBar:GameBar;
    private var ui_characterStatusMediatorHealthPointsBar:GameBar;
    private var ui_characterStatusMediatorMagicPointsBar:GameBar;
    private var ui_characterStatusMediatorLevelAndExperienceLabel:BaseSimpleText;
    private var ui_characterStatusMediatorStatsUpdateSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdate:Timer;
    private var ui_characterStatusMediatorStatsLevel:int;
    private var ui_characterStatusMediatorStatsExperienceTotal:Number;
    private var ui_characterStatusMediatorStatsExperienceNextLevel:Number;
    private var ui_characterStatusMediatorStatsHealthPoints:int;
    private var ui_characterStatusMediatorStatsHealthPointsTotal:int;
    private var ui_characterStatusMediatorStatsMagicPoints:int;
    private var ui_characterStatusMediatorStatsMagicPointsTotal:int;

    public function CharacterStatusGameUI(_hudView:HUDView) {
        super(_hudView);
    }

    public function setPlayer(player:Player):void {
        this.hudView.gameSprite.player = this.player = player;

        this.ui_characterStatusMediatorStatsUpdateSignal.dispatch();
    }

    override public function drawUI():void {
        this.ui_characterStatusMediatorSprite = new Sprite();

        this.ui_characterStatusMediatorExperienceBar = new GameBar(100, 100, 12, 444, 0, GameBar.GREEN, "EXP", true);
        this.ui_characterStatusMediatorHealthPointsBar = new GameBar(100, 100, 24, 444, 0, GameBar.RED, "HP");
        this.ui_characterStatusMediatorMagicPointsBar = new GameBar(100, 100, 24, 444, 0, GameBar.BLUE, "MP");

        this.ui_characterStatusMediatorLevelAndExperienceLabel = new BaseSimpleText(14, 0xE8E8E8, false, 256, 0);
        this.ui_characterStatusMediatorLevelAndExperienceLabel.selectable = false;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.border = false;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.htmlText = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_EXP_TEXT;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.useTextDimensions();

        this.ui_characterStatusMediatorStatsUpdate = new Timer(200);

        this.ui_characterStatusMediatorStatsLevel = 0;
        this.ui_characterStatusMediatorStatsExperienceTotal = 0;
        this.ui_characterStatusMediatorStatsExperienceNextLevel = 0;
        this.ui_characterStatusMediatorStatsHealthPoints = 0;
        this.ui_characterStatusMediatorStatsHealthPointsTotal = 0;
        this.ui_characterStatusMediatorStatsMagicPoints = 0;
        this.ui_characterStatusMediatorStatsMagicPointsTotal = 0;

        this.ui_characterStatusMediatorStatsUpdateSignal = new Signal();
        this.ui_characterStatusMediatorStatsUpdateSignal.addOnce(this.asyncEventsUI);
    }

    override public function setUI():void {
        var x_:int = 144;
        var y_:int = 52;

        this.ui_characterStatusMediatorLevelAndExperienceLabel.x = x_ + 4;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.y = y_ - 16;

        this.ui_characterStatusMediatorExperienceBar.x = x_;
        this.ui_characterStatusMediatorExperienceBar.y = y_ + UI_CHARACTER_STATUS_MEDIATOR_SPACE - 12;

        this.ui_characterStatusMediatorHealthPointsBar.x = x_;
        this.ui_characterStatusMediatorHealthPointsBar.y = this.ui_characterStatusMediatorExperienceBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;

        this.ui_characterStatusMediatorMagicPointsBar.x = x_;
        this.ui_characterStatusMediatorMagicPointsBar.y = this.ui_characterStatusMediatorHealthPointsBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelAndExperienceLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorHealthPointsBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorMagicPointsBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorLevelAndExperienceLabel);

        addChild(this.ui_characterStatusMediatorSprite);
    }

    override public function eventsUI():void {
        this.ui_characterStatusMediatorStatsUpdate.addEventListener(TimerEvent.TIMER, this.onStatsUpdateMonitor);
    }

    override public function destroy():void {
        this.ui_characterStatusMediatorStatsUpdate.stop();
        this.ui_characterStatusMediatorStatsUpdate.removeEventListener(TimerEvent.TIMER, this.onStatsUpdateMonitor);

        removeChild(this.ui_characterStatusMediatorSprite);
    }

    private function asyncEventsUI():void {
        this.ui_characterStatusMediatorStatsUpdate.start();
    }

    private function onStatsUpdateMonitor(event:TimerEvent):void {
        if (!level)
            this.refreshLvlExpLabel();

        if (!exp || !nextExp)
            this.refreshEXPGameBar();

        if (!hp || !maxHp)
            this.refreshHPGameBar();

        if (!mp || !maxMp)
            this.refreshMPGameBar();
    }

    private function refreshLvlExpLabel():void {
        this.ui_characterStatusMediatorStatsLevel = this.player.charLvl;
        this.ui_characterStatusMediatorLevelAndExperienceLabel.htmlText =
            UI_CHARACTER_STATUS_MEDIATOR_LEVEL_EXP_TEXT
                .replace(UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL, this.ui_characterStatusMediatorStatsLevel)
                .replace(UI_CHARACTER_STATUS_MEDIATOR_EXP_LABEL, this.ui_characterStatusMediatorStatsExperienceTotal);
    }

    private function refreshEXPGameBar():void {
        this.ui_characterStatusMediatorStatsExperienceTotal = this.player.charEXP;
        this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.charNextEXP;
        this.ui_characterStatusMediatorExperienceBar.redraw(this.ui_characterStatusMediatorStatsExperienceTotal, this.ui_characterStatusMediatorStatsExperienceNextLevel);
    }

    private function refreshHPGameBar():void {
        this.ui_characterStatusMediatorStatsHealthPoints = this.player.charHP;
        this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.charMaxHP;
        this.ui_characterStatusMediatorHealthPointsBar.redraw(this.ui_characterStatusMediatorStatsHealthPoints, this.ui_characterStatusMediatorStatsHealthPointsTotal);
    }

    private function refreshMPGameBar():void {
        this.ui_characterStatusMediatorStatsMagicPoints = this.player.charMP;
        this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.charMaxMP;
        this.ui_characterStatusMediatorMagicPointsBar.redraw(this.ui_characterStatusMediatorStatsMagicPoints, this.ui_characterStatusMediatorStatsMagicPointsTotal);
    }

    private function get level():Boolean {
        return this.ui_characterStatusMediatorStatsLevel == this.player.charLvl;
    }

    private function get exp():Boolean {
        return this.ui_characterStatusMediatorStatsExperienceTotal == this.player.charEXP;
    }

    private function get nextExp():Boolean {
        return this.ui_characterStatusMediatorStatsExperienceNextLevel == this.player.charNextEXP;
    }

    private function get hp():Boolean {
        return this.ui_characterStatusMediatorStatsHealthPoints == this.player.charHP;
    }

    private function get maxHp():Boolean {
        return this.ui_characterStatusMediatorStatsHealthPointsTotal == this.player.charMaxHP;
    }

    private function get mp():Boolean {
        return this.ui_characterStatusMediatorStatsMagicPoints == this.player.charMP;
    }

    private function get maxMp():Boolean {
        return this.ui_characterStatusMediatorStatsMagicPointsTotal == this.player.charMaxMP;
    }
}
}
