package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.geom.Point;

import kabam.rotmg.ui.view.GameHUDView.HUDView;

public class CharacterStatusGameUI extends GameUIScreen {
    private static const UI_CHARACTED_STATUS_MEDIATOR_SIZE:Point = new Point(HUDView.WIDTH, HUDView.HEIGHT);
    private static const UI_CHARACTER_STATUS_MEDIATOR_SPACE:int = 12;
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION:Point = new Point(UI_CHARACTED_STATUS_MEDIATOR_SIZE.x / 2, 0);
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_LEVEL:String = "{LEVEL}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_TEXT:String = "<b>Level</b> " + UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_LEVEL;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_FILL_COLOR:int = int("#ff492e".replace("#", "0x"));
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR:int = int("#353535".replace("#", "0x"));
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH:int = UI_CHARACTED_STATUS_MEDIATOR_SIZE.x;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT:int = UI_CHARACTED_STATUS_MEDIATOR_SIZE.y;
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION:Point = new Point(0, UI_CHARACTER_STATUS_MEDIATOR_SPACE);
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_PERCENT:String = "{EXPERIENCE_PERCENT}";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_TEXT:String = "<b>" + UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_EXPERIENCE_PERCENT + "%</b>";
    private static const UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION:Point = new Point(UI_CHARACTED_STATUS_MEDIATOR_SIZE.x / 2, 0);

    private var player:Player;

    private var ui_characterStatusMediatorSprite:Sprite;
    private var ui_characterStatusMediatorLevelLabel:BaseSimpleText;
    private var ui_characterStatusMediatorExperienceLabel:BaseSimpleText;
    private var ui_characterStatusMediatorExperienceBarBackground:StatusBar;
    private var ui_characterStatusMediatorExperienceBar:StatusBar;

    public function CharacterStatusGameUI(_hudView:HUDView, _player:Player) {
        this.player = _player;

        super(_hudView);
    }

    public static function characterStatusMediatorAction(_arg1:Boolean):void {
        Parameters.data_.displayCharacterStatusMediator = _arg1;
        Parameters.save();
    }

    override public function drawUI():void {
        this.ui_characterStatusMediatorSprite = new Sprite();

        this.ui_characterStatusMediatorLevelLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorLevelLabel.selectable = false;
        this.ui_characterStatusMediatorLevelLabel.border = false;
        this.ui_characterStatusMediatorLevelLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorLevelLabel.htmlText = "<b>Level:</b> --";
        this.ui_characterStatusMediatorLevelLabel.useTextDimensions();

        this.ui_characterStatusMediatorExperienceLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorExperienceLabel.selectable = false;
        this.ui_characterStatusMediatorExperienceLabel.border = false;
        this.ui_characterStatusMediatorExperienceLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorExperienceLabel.htmlText = "<b>0%</b>";
        this.ui_characterStatusMediatorExperienceLabel.useTextDimensions();

        /*this.ui_characterStatusMediatorExperienceBarBackground = new StatusBar(UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR, null);
        this.ui_characterStatusMediatorExperienceBarBackground.draw(1, 1, 0, 1);

        this.ui_characterStatusMediatorExperienceBar = new StatusBar(UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_FILL_COLOR, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR, null);
        this.ui_characterStatusMediatorExperienceBar.draw(this.player.exp_, this.player.nextLevelExp_, 0);*/
    }

    override public function setUI():void {
        this.ui_characterStatusMediatorLevelLabel.x = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.x;
        this.ui_characterStatusMediatorLevelLabel.y = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.y + 48;

        this.ui_characterStatusMediatorExperienceLabel.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.x;
        this.ui_characterStatusMediatorExperienceLabel.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.y + this.ui_characterStatusMediatorLevelLabel + UI_CHARACTER_STATUS_MEDIATOR_SPACE * 2;

        /*this.ui_characterStatusMediatorExperienceBarBackground.x = this.ui_characterStatusMediatorExperienceBar.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.x;
        this.ui_characterStatusMediatorExperienceBarBackground.y = this.ui_characterStatusMediatorExperienceBar.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.y + this.ui_characterStatusMediatorExperienceLabel.y;*/
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_characterStatusMediatorExperienceLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        /*this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBarBackground);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);*/
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorLevelLabel);
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceLabel);

        addChild(this.ui_characterStatusMediatorSprite);
    }

    override public function eventsUI():void {
        // TODO: implement experience bar update.
    }

    override public function destroy():void {
        removeChild(this.ui_characterStatusMediatorSprite);
    }
}
}
