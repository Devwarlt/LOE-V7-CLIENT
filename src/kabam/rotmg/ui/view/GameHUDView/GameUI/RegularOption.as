package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.geom.Point;

import kabam.rotmg.ui.view.GameHUDView.*;

public class RegularOption extends Sprite {
    private static const UI_BUTTON_SPACE:int = 8;
    private static const UI_BUTTON_HEIGHT:int = 16;
    private static const UI_BUTTON_WIDTH:int = 90;

    private var ui_OptionName:String;
    private var ui_OptionDescription:String;
    private var ui_DrawButtons:Boolean;
    private var ui_Label:BaseSimpleText;

    public var ui_OnButton:DeprecatedTextButton;
    public var ui_OffButton:DeprecatedTextButton;
    public var ui_OnButtonSprite:Sprite;
    public var ui_OffButtonSprite:Sprite;

    private function get getText():String {
        return "<b>" + this.ui_OptionName + ":</b> " + this.ui_OptionDescription + (this.ui_DrawButtons ? "." : "");
    }

    public function setText(_optionDescription:String):void {
        this.ui_OptionDescription = _optionDescription;

        this.ui_Label.htmlText = this.getText;
    }

    public function RegularOption(_optionName:String, _optionDescription:String, _position:Point, _drawButtons:Boolean = true) {
        this.ui_OptionName = _optionName;
        this.ui_OptionDescription = _optionDescription;
        this.ui_DrawButtons = _drawButtons;

        this.ui_Label = new BaseSimpleText(12, 0xE8E8E8, false, 800, 0);
        this.ui_Label.selectable = false;
        this.ui_Label.border = false;
        this.ui_Label.mouseEnabled = true;
        this.ui_Label.htmlText = this.getText;
        this.ui_Label.useTextDimensions();
        this.ui_Label.x = this.ui_DrawButtons ? _position.x + UI_BUTTON_WIDTH * 2 + UI_BUTTON_HEIGHT * 2 : UI_BUTTON_HEIGHT;
        this.ui_Label.y = _position.y + UI_BUTTON_SPACE / 2;
        this.ui_Label.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        addChild(this.ui_Label);

        if (this.ui_DrawButtons) {
            this.ui_OnButton = new DeprecatedTextButton(UI_BUTTON_HEIGHT, "On", UI_BUTTON_WIDTH);

            this.ui_OffButton = new DeprecatedTextButton(UI_BUTTON_HEIGHT, "Off", UI_BUTTON_WIDTH);

            this.ui_OnButtonSprite = new Sprite();

            this.ui_OffButtonSprite = new Sprite();

            this.ui_OnButtonSprite.x = _position.x;
            this.ui_OnButtonSprite.y = _position.y;

            this.ui_OffButtonSprite.x = _position.x + UI_BUTTON_WIDTH + UI_BUTTON_SPACE;
            this.ui_OffButtonSprite.y = _position.y;

            this.ui_OnButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

            this.ui_OffButtonSprite.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

            this.ui_OnButtonSprite.addChild(this.ui_OnButton);

            this.ui_OffButtonSprite.addChild(this.ui_OffButton);

            addChild(this.ui_OnButtonSprite);
            addChild(this.ui_OffButtonSprite);
        }
    }
}
}
