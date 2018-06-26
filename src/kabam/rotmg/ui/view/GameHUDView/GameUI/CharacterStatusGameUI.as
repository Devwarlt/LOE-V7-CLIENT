package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Sign;
import com.company.ui.BaseSimpleText;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import kabam.rotmg.ui.view.GameHUDView.GameBar;
import kabam.rotmg.ui.view.GameHUDView.HUDView;
import kabam.rotmg.ui.view.GameHUDView.Utils;

import org.osflash.signals.Signal;

public class CharacterStatusGameUI extends GameUIScreen {
    private static const UI_CHARACTED_STATUS_MEDIATOR_SIZE:Point = new Point(HUDView.WIDTH, HUDView.HEIGHT);
    private static const UI_CHARACTER_STATUS_MEDIATOR_SPACE:int = 12;
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION:Point = new Point(4, UI_CHARACTER_STATUS_MEDIATOR_SPACE * 12);
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_LEVEL:String = "{LEVEL}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_TEXT:String = "<b>Level:</b> " + UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_LEVEL;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_FILL_COLOR:int = int("#ff1200".replace("#", "0x"));
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR:int = int("#353535".replace("#", "0x"));
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH:int = UI_CHARACTED_STATUS_MEDIATOR_SIZE.x - 12;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT:int = UI_CHARACTER_STATUS_MEDIATOR_SPACE;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION:Point = new Point(4, UI_CHARACTER_STATUS_MEDIATOR_SPACE * 15);
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_NEXT_LEVEL:String = "{EXPERIENCE_NEXT_LEVEL}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_TOTAL:String = "{EXPERIENCE_TOTAL}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_PERCENT:String = "{EXPERIENCE_PERCENT}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_TEXT:String = "<b>EXP:</b> " + UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_TOTAL + "<b>/</b>" + UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_NEXT_LEVEL + " (<b>" + UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_PERCENT + "%</b>)";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION:Point = new Point(4, UI_CHARACTER_STATUS_MEDIATOR_SPACE * 13 + 4);

    private var player:Player;

    /*var tween:GTween = new GTween(textField,2,{alpha:0, x: textField.x + 25, y: textField.y - 25},{swapValues:false, ease:Circular.easeIn}, {MotionBlurEnabled:true});
        tween.repeatCount = -1;*/

    private var ui_characterStatusMediatorSprite:Sprite;
    private var ui_characterStatusMediatorLevelLabel:BaseSimpleText;
    private var ui_characterStatusMediatorExperienceLabel:BaseSimpleText;
    private var ui_characterStatusMediatorExperienceBar:GameBar;
    private var ui_characterStatusMediatorExperienceBarShape:Shape;
    private var ui_characterStatusMediatorStatsUpdate:Timer;
    private var ui_characterStatusMediatorStatsLevel:int;
    private var ui_characterStatusMediatorStatsExperienceTotal:Number;
    private var ui_characterStatusMediatorStatsExperienceNextLevel:Number;
    private var ui_characterStatusMediatorStatsExperiencePercent:int;
    private var ui_characterStatusMediatorStatsHealthPoints:int;
    private var ui_characterStatusMediatorStatsHealthPointsTotal:int;
    private var ui_characterStatusMediatorStatsMagicPoints:int;
    private var ui_characterStatusMediatorStatsMagicPointsTotal:int;
    private var ui_characterStatusMediatorStatsUpdateLevelSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdateExperienceSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdateHealthPointsSignal:Signal;
    private var ui_characterStatusMediatorStatsUpdateMagicPointsSignal:Signal;

    public function CharacterStatusGameUI(_hudView:HUDView, _player:Player) {
        this.player = _player;

        super(_hudView);
    }

    override public function drawUI():void {
        this.ui_characterStatusMediatorSprite = new Sprite();

        this.ui_characterStatusMediatorLevelLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorLevelLabel.selectable = false;
        this.ui_characterStatusMediatorLevelLabel.border = false;
        this.ui_characterStatusMediatorLevelLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorLevelLabel.htmlText = "<b>Level:</b> 0";
        this.ui_characterStatusMediatorLevelLabel.useTextDimensions();

        this.ui_characterStatusMediatorExperienceLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorExperienceLabel.selectable = false;
        this.ui_characterStatusMediatorExperienceLabel.border = false;
        this.ui_characterStatusMediatorExperienceLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorExperienceLabel.htmlText = "<b>EXP:</b> 0<b>/</b>0 (<b>0%</b>)";
        this.ui_characterStatusMediatorExperienceLabel.useTextDimensions();

        this.ui_characterStatusMediatorExperienceBarShape = new Shape();
        this.ui_characterStatusMediatorExperienceBarShape.graphics.clear();
        this.ui_characterStatusMediatorExperienceBarShape.graphics.clear();
        this.ui_characterStatusMediatorExperienceBarShape.graphics.drawRect(0, 0, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT);
        this.ui_characterStatusMediatorExperienceBarShape.graphics.beginFill(UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR, 0.75);
        this.ui_characterStatusMediatorExperienceBarShape.graphics.endFill();

        this.ui_characterStatusMediatorExperienceBar = new GameBar(50, 100, 12, 12, 0, GameBar.RED);

        this.ui_characterStatusMediatorStatsUpdate = new Timer(200);

        this.ui_characterStatusMediatorStatsLevel = this.player.level_;

        this.ui_characterStatusMediatorStatsExperienceTotal = this.player.exp_;

        this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.nextLevelExp_;

        this.ui_characterStatusMediatorStatsExperiencePercent = Utils.trimNumber(this.ui_characterStatusMediatorStatsExperienceTotal / this.ui_characterStatusMediatorStatsExperienceNextLevel, 2);

        this.ui_characterStatusMediatorStatsHealthPoints = this.player.hp_;

        this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.maxHP_;

        this.ui_characterStatusMediatorStatsMagicPoints = this.player.mp_;

        this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.maxMP_;

        this.ui_characterStatusMediatorStatsUpdateLevelSignal = new Signal(int);
        this.ui_characterStatusMediatorStatsUpdateLevelSignal.add(this.onLevelUpdate);

        this.ui_characterStatusMediatorStatsUpdateExperienceSignal = new Signal(Number, Number, int);
        this.ui_characterStatusMediatorStatsUpdateExperienceSignal.add(this.onExperienceUpdate);

        this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal = new Signal(int, int);
        this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal.add(this.onHealthUpdate);

        this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal = new Signal(int, int);
        this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal.add(this.onMagicUpdate);
    }

    override public function setUI():void {
        this.ui_characterStatusMediatorLevelLabel.x = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.x;
        this.ui_characterStatusMediatorLevelLabel.y = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.y;

        this.ui_characterStatusMediatorExperienceLabel.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.x;
        this.ui_characterStatusMediatorExperienceLabel.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.y;

        this.ui_characterStatusMediatorExperienceBar.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.x;
        this.ui_characterStatusMediatorExperienceBar.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.y;

        this.ui_characterStatusMediatorExperienceBarShape.x = this.ui_characterStatusMediatorExperienceBar.x;
        this.ui_characterStatusMediatorExperienceBarShape.y = this.ui_characterStatusMediatorExperienceBar.y;
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_characterStatusMediatorExperienceLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBarShape);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorLevelLabel);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceLabel);

        addChild(this.ui_characterStatusMediatorSprite);
    }

    override public function eventsUI():void {
        this.ui_characterStatusMediatorStatsUpdate.addEventListener(TimerEvent.TIMER, this.onStatsUpdate);
        this.ui_characterStatusMediatorStatsUpdate.start();
    }

    override public function destroy():void {
        this.ui_characterStatusMediatorStatsUpdate.stop();
        this.ui_characterStatusMediatorStatsUpdate.removeEventListener(TimerEvent.TIMER, this.onStatsUpdate);

        removeChild(this.ui_characterStatusMediatorSprite);
    }

    private function onStatsUpdate(event:TimerEvent):void {
        if (this.ui_characterStatusMediatorStatsLevel != this.player.level_) {
            this.ui_characterStatusMediatorStatsLevel = this.player.level_;
            this.ui_characterStatusMediatorStatsUpdateLevelSignal.dispatch(this.ui_characterStatusMediatorStatsLevel);
        }

        if (this.ui_characterStatusMediatorStatsExperienceTotal != this.player.exp_ || this.ui_characterStatusMediatorStatsExperienceNextLevel != this.player.nextLevelExp_) {
            this.ui_characterStatusMediatorStatsExperienceTotal = this.player.exp_;
            this.ui_characterStatusMediatorStatsExperienceNextLevel = this.player.nextLevelExp_;
            this.ui_characterStatusMediatorStatsExperiencePercent = Utils.trimNumber(this.ui_characterStatusMediatorStatsExperienceTotal / this.ui_characterStatusMediatorStatsExperienceNextLevel, 2);
            this.ui_characterStatusMediatorStatsUpdateExperienceSignal.dispatch(this.ui_characterStatusMediatorStatsExperienceTotal, this.ui_characterStatusMediatorStatsExperienceNextLevel, this.ui_characterStatusMediatorStatsExperiencePercent);
        }

        if (this.ui_characterStatusMediatorStatsHealthPoints != this.player.hp_ || this.ui_characterStatusMediatorStatsHealthPointsTotal != this.player.maxHP_) {
            this.ui_characterStatusMediatorStatsHealthPoints = this.player.hp_;
            this.ui_characterStatusMediatorStatsHealthPointsTotal = this.player.maxHP_;
            this.ui_characterStatusMediatorStatsUpdateHealthPointsSignal.dispatch(this.ui_characterStatusMediatorStatsHealthPoints, this.ui_characterStatusMediatorStatsHealthPointsTotal);
        }

        if (this.ui_characterStatusMediatorStatsMagicPoints != this.player.mp_ || this.ui_characterStatusMediatorStatsMagicPointsTotal != this.player.maxMP_) {
            this.ui_characterStatusMediatorStatsMagicPoints = this.player.mp_;
            this.ui_characterStatusMediatorStatsMagicPointsTotal = this.player.maxMP_;
            this.ui_characterStatusMediatorStatsUpdateMagicPointsSignal.dispatch(this.ui_characterStatusMediatorStatsMagicPoints, this.ui_characterStatusMediatorStatsMagicPointsTotal);
        }
    }

    private function onLevelUpdate(_arg1:int):void {
        // TODO: implement update.
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
