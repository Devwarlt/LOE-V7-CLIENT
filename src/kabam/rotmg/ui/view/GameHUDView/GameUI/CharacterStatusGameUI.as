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
        this.ui_characterStatusMediatorLevelLabel.htmlText = "<b>Level:</b> 0";
        this.ui_characterStatusMediatorLevelLabel.useTextDimensions();

        this.ui_characterStatusMediatorExperienceLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_characterStatusMediatorExperienceLabel.selectable = false;
        this.ui_characterStatusMediatorExperienceLabel.border = false;
        this.ui_characterStatusMediatorExperienceLabel.mouseEnabled = true;
        this.ui_characterStatusMediatorExperienceLabel.htmlText = "<b>EXP:</b> 0<b>/</b>0 (<b>0%</b>)";
        this.ui_characterStatusMediatorExperienceLabel.useTextDimensions();

        this.ui_characterStatusMediatorExperienceBar = new StatusBar(UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_WIDTH, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_HEIGHT, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_FILL_COLOR, UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_END_COLOR, null, false, true);
        this.ui_characterStatusMediatorExperienceBar.draw(1, 1, 0, 1);
    }

    override public function setUI():void {
        this.ui_characterStatusMediatorLevelLabel.x = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.x;
        this.ui_characterStatusMediatorLevelLabel.y = UI_CHARACTER_STATUS_MEDIATOR_LEVEL_LABEL_POSITION.y;

        this.ui_characterStatusMediatorExperienceLabel.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.x;
        this.ui_characterStatusMediatorExperienceLabel.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_LABEL_POSITION.y;

        this.ui_characterStatusMediatorExperienceBar.x = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.x;
        this.ui_characterStatusMediatorExperienceBar.y = UI_CHARACTER_STATUS_MEDIATOR_EXPERIENCE_BAR_POSITION.y;
    }

    override public function outlineUI():void {
        this.ui_characterStatusMediatorLevelLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_characterStatusMediatorExperienceLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_characterStatusMediatorSprite.addChild(this.ui_characterStatusMediatorExperienceBar);
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
