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
    //private var ui_characterStatusMediatorHealthPointsBar:GameBar;
    //private var ui_characterStatusMediatorMagicPointsBar:GameBar;
    private var ui_characterStatusMediatorLevelAndExperienceLabel:BaseSimpleText;
    private var ui_characterStatusMediatorStatsUpdateSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdate:Timer;
    private var ui_characterStatusMediatorStatsLevel:int;
    private var ui_characterStatusMediatorStatsExperienceTotal:Number;
    private var ui_characterStatusMediatorStatsExperienceNextLevel:Number;
    //private var ui_characterStatusMediatorStatsHealthPoints:int;
    //private var ui_characterStatusMediatorStatsHealthPointsTotal:int;
    //private var ui_characterStatusMediatorStatsMagicPoints:int;
    //private var ui_characterStatusMediatorStatsMagicPointsTotal:int;

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
        //this.ui_characterStatusMediatorHealthPointsBar = new GameBar(100, 100, 12, 444, 0, GameBar.RED, "HP");
        //this.ui_characterStatusMediatorMagicPointsBar = new GameBar(100, 100, 12, 444, 0, GameBar.BLUE, "MP");

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
        //this.ui_characterStatusMediatorStatsHealthPoints = 0;
        //this.ui_characterStatusMediatorStatsHealthPointsTotal = 0;
        //this.ui_characterStatusMediatorStatsMagicPoints = 0;
        //this.ui_characterStatusMediatorStatsMagicPointsTotal = 0;

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

        //this.ui_characterStatusMediatorHealthPointsBar.x = x_;
        //this.ui_characterStatusMediatorHealthPointsBar.y = this.ui_characterStatusMediatorExperienceBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;

        //this.ui_characterStatusMediatorMagicPointsBar.x = x_;
        //this.ui_characterStatusMediatorMagicPointsBar.y = this.ui_characterStatusMediatorHealthPointsBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelAndExperienceLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
        //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorHealthPointsBar);
        //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorMagicPointsBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorLevelAndExperienceLabel);

        addChild(this.ui_characterStatusMediatorSprite);
    }

    override public function eventsUI():void {
        this.ui_characterStatusMediatorStatsUpdate.addEventListener(TimerEvent.TIMER, this.onStatsUpdate);
    }

    override public function destroy():void {
        this.ui_characterStatusMediatorStatsUpdate.stop();
        this.ui_characterStatusMediatorStatsUpdate.removeEventListener(TimerEvent.TIMER, this.onStatsUpdate);

        removeChild(this.ui_characterStatusMediatorSprite);
    }

    private function asyncEventsUI():void {
        this.onceStatsUpdate();
    }

    private function onceStatsUpdate():void {
        //this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorExperienceBar);
        //this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorHealthPointsBar);
        //this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorMagicPointsBar);

        this.ui_characterStatusMediatorStatsLevel = this.player.charLvl;
        this.ui_characterStatusMediatorStatsExperienceTotal = this.player.charEXP;
        this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.charNextEXP;
        //this.ui_characterStatusMediatorStatsHealthPoints = this.player.charHP;
        //this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.charMaxHP;
        //this.ui_characterStatusMediatorStatsMagicPoints = this.player.charMP;
        //this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.charMaxMP;

        this.ui_characterStatusMediatorLevelAndExperienceLabel.htmlText = this.getLvlEXP;

        this.redrawExpGameBar();

        //this.ui_characterStatusMediatorHealthPointsBar = this.getHPGameBar;
        //this.ui_characterStatusMediatorMagicPointsBar = this.getMPGameBar;

        //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
        //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorHealthPointsBar);
        //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorMagicPointsBar);

        //this.ui_characterStatusMediatorStatsUpdate.start();
    }

    private function onStatsUpdate(event:TimerEvent):void {
        if (!level) {
            this.ui_characterStatusMediatorStatsLevel = this.player.charLvl;
            this.ui_characterStatusMediatorLevelAndExperienceLabel.htmlText = this.getLvlEXP;
        }

        if (!exp || !nextExp)
            this.redrawGameBar(EXPERIENCE_GAME_BAR);

        //if (!hp || !maxHp)
        //    this.redrawGameBar(HEALTH_POINTS_GAME_BAR);

        //if (!mp || !maxMp)
        //    this.redrawGameBar(MAGIC_POINTS_GAME_BAR);
    }

    private static const EXPERIENCE_GAME_BAR:int = 0;
    private static const HEALTH_POINTS_GAME_BAR:int = 1;
    private static const MAGIC_POINTS_GAME_BAR:int = 2;

    private function redrawGameBar(gameBar:int):void {
        var x_:int = 144;
        var y_:int = 52;

        switch (gameBar) {
            case EXPERIENCE_GAME_BAR:
                this.ui_characterStatusMediatorStatsExperienceTotal = this.player.charEXP;
                this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.charNextEXP;

                this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorExperienceBar);

                this.ui_characterStatusMediatorExperienceBar = this.getEXPGameBar;

                this.ui_characterStatusMediatorExperienceBar.x = x_;
                this.ui_characterStatusMediatorExperienceBar.y = y_ + UI_CHARACTER_STATUS_MEDIATOR_SPACE - 12;

                this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
                break;
            case HEALTH_POINTS_GAME_BAR:
                //this.ui_characterStatusMediatorStatsHealthPoints = this.player.charHP;
                //this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.charMaxHP;

                //this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorHealthPointsBar);

                //this.ui_characterStatusMediatorHealthPointsBar = this.getHPGameBar;

                //this.ui_characterStatusMediatorHealthPointsBar.x = x_;
                //this.ui_characterStatusMediatorHealthPointsBar.y = this.ui_characterStatusMediatorExperienceBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;

                //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorHealthPointsBar);
                break;
            case MAGIC_POINTS_GAME_BAR:
                //this.ui_characterStatusMediatorStatsMagicPoints = this.player.charMP;
                //this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.charMaxMP;

                //this.ui_characterStatusMediatorSprite.removeChild(this.ui_characterStatusMediatorMagicPointsBar);

                //this.ui_characterStatusMediatorMagicPointsBar = this.getMPGameBar;

                //this.ui_characterStatusMediatorMagicPointsBar.x = x_;
                //this.ui_characterStatusMediatorMagicPointsBar.y = this.ui_characterStatusMediatorHealthPointsBar.y + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;

                //this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorMagicPointsBar);
                break;
        }
    }

    private function get getLvlEXP():String {
        return UI_CHARACTER_STATUS_MEDIATOR_LEVEL_EXP_TEXT
            .replace(UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL, this.ui_characterStatusMediatorStatsLevel)
            .replace(UI_CHARACTER_STATUS_MEDIATOR_EXP_LABEL, this.ui_characterStatusMediatorStatsExperienceTotal);
    }

    private function redrawExpGameBar():void {
        this.ui_characterStatusMediatorExperienceBar.redraw(this.ui_characterStatusMediatorStatsExperienceTotal, this.ui_characterStatusMediatorStatsExperienceNextLevel);
    }

    private function get getEXPGameBar():GameBar {
        return new GameBar(this.ui_characterStatusMediatorStatsExperienceTotal, this.ui_characterStatusMediatorStatsExperienceNextLevel, 12, 444, 0, GameBar.GREEN, "EXP", true);
    }

    //private function get getHPGameBar():GameBar {
    //    return new GameBar(this.ui_characterStatusMediatorStatsHealthPoints, this.ui_characterStatusMediatorStatsHealthPointsTotal, 12, 444, 0, GameBar.RED, "HP");
    //}

    //private function get getMPGameBar():GameBar {
    //    return new GameBar(this.ui_characterStatusMediatorStatsMagicPoints, this.ui_characterStatusMediatorStatsMagicPointsTotal, 12, 444, 0, GameBar.BLUE, "MP");
    //}

    private function get level():Boolean {
        return this.ui_characterStatusMediatorStatsLevel == this.player.charLvl;
    }

    private function get exp():Boolean {
        return this.ui_characterStatusMediatorStatsExperienceTotal == this.player.charEXP;
    }

    private function get nextExp():Boolean {
        return this.ui_characterStatusMediatorStatsExperienceNextLevel == this.player.charNextEXP;
    }

    //private function get hp():Boolean {
    //    return this.ui_characterStatusMediatorStatsHealthPoints == this.player.charHP;
    //}

    //private function get maxHp():Boolean {
    //    return this.ui_characterStatusMediatorStatsHealthPointsTotal == this.player.charMaxHP;
    //}

    //private function get mp():Boolean {
    //    return this.ui_characterStatusMediatorStatsMagicPoints == this.player.charMP;
    //}

    //private function get maxMp():Boolean {
    //    return this.ui_characterStatusMediatorStatsMagicPointsTotal == this.player.charMaxMP;
    //}
}
}
