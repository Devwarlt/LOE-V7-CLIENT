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
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_TEXT:String = "<b>Level</b> " + UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL;

    private var player:Player;

    /*var tween:GTween = new GTween(textField,2,{alpha:0, x: textField.x + 25, y: textField.y - 25},{swapValues:false, ease:Circular.easeIn}, {MotionBlurEnabled:true});
        tween.repeatCount = -1;*/

    private var ui_characterStatusMediatorSprite:Sprite;
    private var ui_characterStatusMediatorExperienceBar:GameBar;
    private var ui_characterStatusMediatorHealthPointsBar:GameBar;
    private var ui_characterStatusMediatorMagicPointsBar:GameBar;
    private var ui_characterStatusMediatorLevelLabel:BaseSimpleText;
    private var ui_characterStatusMediatorStatsUpdateSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdate:Timer;
    private var ui_characterStatusMediatorStatsLevel:int;
    //private var ui_characterStatusMediatorStatsExperienceTotal:Number;
    //private var ui_characterStatusMediatorStatsExperienceNextLevel:Number;
    //private var ui_characterStatusMediatorStatsExperiencePercent:int;
    //private var ui_characterStatusMediatorStatsHealthPoints:int;
    //private var ui_characterStatusMediatorStatsHealthPointsTotal:int;
    //private var ui_characterStatusMediatorStatsMagicPoints:int;
    //private var ui_characterStatusMediatorStatsMagicPointsTotal:int;
    private var ui_characterStatusMediatorStatsUpdateLevelSignal:Signal;
    //private var ui_characterStatusMediatorStatsUpdateExperienceSignal:Signal;
    //private var ui_characterStatusMediatorStatsUpdateHealthPointsSignal:Signal;
    //private var ui_characterStatusMediatorStatsUpdateMagicPointsSignal:Signal;

    public function CharacterStatusGameUI(_hudView:HUDView) {
        super(_hudView);
    }

    public function setPlayer(player:Player):void {
        this.player = player;

        this.ui_characterStatusMediatorStatsUpdateSignal.dispatch();
    }

    override public function drawUI():void {
        this.ui_characterStatusMediatorSprite = new Sprite();

        this.ui_characterStatusMediatorExperienceBar = new GameBar(100, 100, 12, 148, 0, GameBar.GREEN, "Experience", true);

        this.ui_characterStatusMediatorHealthPointsBar = new GameBar(100, 100, 24, 148, 0, GameBar.RED, "Health Points", true);

        this.ui_characterStatusMediatorMagicPointsBar = new GameBar(100, 100, 24, 148, 0, GameBar.BLUE, "Magic Points", true);

        this.ui_characterStatusMediatorLevelLabel = new BaseSimpleText(14, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorLevelLabel.selectable = false;
        this.ui_characterStatusMediatorLevelLabel.border = false;
        this.ui_characterStatusMediatorLevelLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorLevelLabel.htmlText = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_TEXT;
        this.ui_characterStatusMediatorLevelLabel.useTextDimensions();

        this.ui_characterStatusMediatorStatsUpdateSignal = new Signal();
        this.ui_characterStatusMediatorStatsUpdateSignal.addOnce(this.asyncEventsUI);

        this.ui_characterStatusMediatorStatsUpdate = new Timer(200);

        this.ui_characterStatusMediatorStatsLevel = 0;

        //this.ui_characterStatusMediatorStatsExperienceTotal = this.player.exp_;

        //this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.nextLevelExp_;

        //this.ui_characterStatusMediatorStatsExperiencePercent = Utils.trimNumber(this.ui_characterStatusMediatorStatsExperienceTotal / this.ui_characterStatusMediatorStatsExperienceNextLevel, 2);

        //this.ui_characterStatusMediatorStatsHealthPoints = this.player.hp_;

        //this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.maxHP_;

        //this.ui_characterStatusMediatorStatsMagicPoints = this.player.mp_;

        //this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.maxMP_;

        this.ui_characterStatusMediatorStatsUpdateLevelSignal = new Signal(int);
        this.ui_characterStatusMediatorStatsUpdateLevelSignal.add(this.onLevelUpdate);

        //this.ui_characterStatusMediatorStatsUpdateExperienceSignal = new Signal(Number, Number, int);
        //this.ui_characterStatusMediatorStatsUpdateExperienceSignal.add(this.onExperienceUpdate);

        //this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal = new Signal(int, int);
        //this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal.add(this.onHealthUpdate);

        //this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal = new Signal(int, int);
        //this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal.add(this.onMagicUpdate);
    }

    override public function setUI():void {
        var x_:int = 144;
        var y_:int = 52;

        this.ui_characterStatusMediatorExperienceBar.x = x_;
        this.ui_characterStatusMediatorExperienceBar.y = y_ + UI_CHARACTER_STATUS_MEDIATOR_SPACE - 12;

        this.ui_characterStatusMediatorHealthPointsBar.x = x_;
        this.ui_characterStatusMediatorHealthPointsBar.y = y_ + UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4;

        this.ui_characterStatusMediatorMagicPointsBar.x = x_;
        this.ui_characterStatusMediatorMagicPointsBar.y = y_ + (UI_CHARACTER_STATUS_MEDIATOR_SPACE + 4) * 2;

        this.ui_characterStatusMediatorLevelLabel.x = x_ + 4;
        this.ui_characterStatusMediatorLevelLabel.y = y_ - 16;
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorHealthPointsBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorMagicPointsBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorLevelLabel);

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
        this.ui_characterStatusMediatorStatsUpdate.start();
    }

    private function onStatsUpdate(event:TimerEvent):void {
        if (this.ui_characterStatusMediatorStatsLevel != this.player.level_) {
            this.ui_characterStatusMediatorStatsLevel = this.player.level_;
            this.ui_characterStatusMediatorStatsUpdateLevelSignal.dispatch(this.ui_characterStatusMediatorStatsLevel);
        }

        //if (this.ui_characterStatusMediatorStatsExperienceTotal != this.player.exp_ || this.ui_characterStatusMediatorStatsExperienceNextLevel != this.player.nextLevelExp_) {
        //    this.ui_characterStatusMediatorStatsExperienceTotal = this.player.exp_;
        //    this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.nextLevelExp_;
        //    this.ui_characterStatusMediatorStatsExperiencePercent = Utils.trimNumber(this.ui_characterStatusMediatorStatsExperienceTotal / this.ui_characterStatusMediatorStatsExperienceNextLevel, 2);
        //    this.ui_characterStatusMediatorStatsUpdateExperienceSignal.dispatch(this.ui_characterStatusMediatorStatsExperienceTotal, this.ui_characterStatusMediatorStatsExperienceNextLevel, this.ui_characterStatusMediatorStatsExperiencePercent);
        //}
//
        //if (this.ui_characterStatusMediatorStatsHealthPoints != this.player.hp_ || this.ui_characterStatusMediatorStatsHealthPointsTotal != this.player.maxHP_) {
        //    this.ui_characterStatusMediatorStatsHealthPoints = this.player.hp_;
        //    this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.maxHP_;
        //    this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal.dispatch(this.ui_characterStatusMediatorStatsHealthPoints, this.ui_characterStatusMediatorStatsHealthPointsTotal);
        //}
//
        //if (this.ui_characterStatusMediatorStatsMagicPoints != this.player.mp_ || this.ui_characterStatusMediatorStatsMagicPointsTotal != this.player.maxMP_) {
        //    this.ui_characterStatusMediatorStatsMagicPoints = this.player.mp_;
        //    this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.maxMP_;
        //    this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal.dispatch(this.ui_characterStatusMediatorStatsMagicPoints, this.ui_characterStatusMediatorStatsMagicPointsTotal);
        //}
    }

    private function onLevelUpdate(_arg1:int):void {
        this.ui_characterStatusMediatorLevelLabel.htmlText = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_TEXT.replace(UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL, _arg1);
    }

    private function onExperienceUpdate(_arg1:Number, _arg2:Number, _arg3:int):void {
        // TODO: implement update.
    }

    private function onHealthUpdate(_arg1:int, _arg2:int):void {
        // TODO: implement update.
    }

    private function onMagicUpdate(_arg1:int, _arg2:int):void {
        // TODO: implement update.
    }
}
}
