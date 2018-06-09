package kabam.rotmg.ui.view.GameHUDView.GameUI {
import kabam.rotmg.ui.view.GameHUDView.*;

import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.geom.Point;

public class RegularOption extends Sprite {
    private static const UI_BUTTON_SPACE:int = 8;
    private static const UI_BUTTON_HEIGHT:int = 16;
    private static const UI_BUTTON_WIDTH:int = 90;

    private var ui_Label:BaseSimpleText;

    public var ui_OnButton:DeprecatedTextButton;
    public var ui_OffButton:DeprecatedTextButton;
    public var ui_OnButtonSprite:Sprite;
    public var ui_OffButtonSprite:Sprite;

    public function RegularOption(_optionName:String, _optionDescription:String, _position:Point) {
        this.ui_OnButton = new DeprecatedTextButton(UI_BUTTON_HEIGHT, "On", UI_BUTTON_WIDTH);

        this.ui_OffButton = new DeprecatedTextButton(UI_BUTTON_HEIGHT, "Off", UI_BUTTON_WIDTH);

        this.ui_OnButtonSprite = new Sprite();

        this.ui_OffButtonSprite = new Sprite();

        this.ui_Label = new BaseSimpleText(12, 0xE8E8E8, false, 800, 0);
        this.ui_Label.selectable = false;
        this.ui_Label.border = false;
        this.ui_Label.mouseEnabled = true;
        this.ui_Label.htmlText = "<b>" + _optionName + ":</b> " + _optionDescription + ".";
        this.ui_Label.useTextDimensions();

        this.ui_OnButtonSprite.x = _position.x;
        this.ui_OnButtonSprite.y = _position.y;

        this.ui_OffButtonSprite.x = this.ui_OnButtonSprite.x + UI_BUTTON_WIDTH + UI_BUTTON_SPACE;
        this.ui_OffButtonSprite.y = _position.y;

        this.ui_Label.x = this.ui_OffButtonSprite.x + UI_BUTTON_WIDTH + UI_BUTTON_HEIGHT;
        this.ui_Label.y = _position.y + UI_BUTTON_SPACE / 2;

        this.ui_OnButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_OffButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_Label.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_OnButtonSprite.addChild(this.ui_OnButton);

        this.ui_OffButtonSprite.addChild(this.ui_OffButton);

        addChild(this.ui_OnButtonSprite);
        addChild(this.ui_OffButtonSprite);
        addChild(this.ui_Label);
    }
}
}
