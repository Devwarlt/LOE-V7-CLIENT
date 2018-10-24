package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.ui.BaseSimpleText;

import flash.display.Sprite;
import flash.geom.Point;
import flash.system.System;
import flash.utils.setInterval;

import kabam.rotmg.ui.view.GameHUDView.HUDView;

public class GameStatusGameUI extends GameUIScreen {
    private static const UI_GAME_STATUS_MEDIATOR_TTL:int = 2000;
    private static const UI_GAME_STATUS_MEDIATOR_LABEL_SPACE:Point = new Point(16, 6);
    private static const UI_GAME_STATUS_MEDIATOR_FPS_LABEL_POSITION:Point = new Point(UI_GAME_STATUS_MEDIATOR_LABEL_SPACE.x, 0);
    private static const UI_GAME_STATUS_MEDIATOR_MEMORY_USAGE_LABEL_POSITION:Point = new Point(UI_GAME_STATUS_MEDIATOR_FPS_LABEL_POSITION.x, UI_GAME_STATUS_MEDIATOR_LABEL_SPACE.y);
    private static const UI_GAME_STATUS_MEDIATOR_FPS_LABEL_FPS_MEASURE:String = "{FPS_MEASURE}";
    private static const UI_GAME_STATUS_MEDIATOR_FPS_LABEL_TEXT:String = "<b>FPS: </b> " + UI_GAME_STATUS_MEDIATOR_FPS_LABEL_FPS_MEASURE;
    private static const UI_GAME_STATUS_MEDIATOR_MEMORY_LABEL_MEMORY_USAGE_MEASURE:String = "{MEMORY_USAGE_MEASURE}";
    private static const UI_GAME_STATUS_MEDIATOR_MEMORY_LABEL_TEXT:String = "<b>Memory: </b> " + UI_GAME_STATUS_MEDIATOR_MEMORY_LABEL_MEMORY_USAGE_MEASURE + " Mb";

    public function GameStatusGameUI(_hudView:HUDView) {
        super(_hudView);
    }
    private var ui_gameStatusMediatorSprite:Sprite;
    private var ui_gameStatusMediatorFPSLabel:BaseSimpleText;
    private var ui_gameStatusMediatorFPSMeasure:int;
    private var ui_gameStatusMediatorMemoryUsageLabel:BaseSimpleText;
    private var ui_gameStatusMediatorMemoryUsageMeasure:int;

    override public function drawUI():void {
        this.ui_gameStatusMediatorSprite = new Sprite();

        this.ui_gameStatusMediatorFPSMeasure = 0;

        this.ui_gameStatusMediatorMemoryUsageMeasure = 0;

        this.ui_gameStatusMediatorFPSLabel = new BaseSimpleText(12, 0xE8E8E8, false, 96, 0);
        this.ui_gameStatusMediatorFPSLabel.selectable = false;
        this.ui_gameStatusMediatorFPSLabel.border = false;
        this.ui_gameStatusMediatorFPSLabel.mouseEnabled = true;
        this.ui_gameStatusMediatorFPSLabel.htmlText = "<b>FPS:</b> --";
        this.ui_gameStatusMediatorFPSLabel.useTextDimensions();

        this.ui_gameStatusMediatorMemoryUsageLabel = new BaseSimpleText(12, 0xE8E8E8, false, 96, 0);
        this.ui_gameStatusMediatorMemoryUsageLabel.selectable = false;
        this.ui_gameStatusMediatorMemoryUsageLabel.border = false;
        this.ui_gameStatusMediatorMemoryUsageLabel.mouseEnabled = true;
        this.ui_gameStatusMediatorMemoryUsageLabel.htmlText = "<b>Memory:</b> -- Mb";
        this.ui_gameStatusMediatorMemoryUsageLabel.useTextDimensions();
    }

    override public function setUI():void {
        this.ui_gameStatusMediatorFPSLabel.x = UI_GAME_STATUS_MEDIATOR_FPS_LABEL_POSITION.x;
        this.ui_gameStatusMediatorFPSLabel.y = UI_GAME_STATUS_MEDIATOR_FPS_LABEL_POSITION.y;

        this.ui_gameStatusMediatorMemoryUsageLabel.x = UI_GAME_STATUS_MEDIATOR_MEMORY_USAGE_LABEL_POSITION.x;
        this.ui_gameStatusMediatorMemoryUsageLabel.y = UI_GAME_STATUS_MEDIATOR_MEMORY_USAGE_LABEL_POSITION.y * 2;
    }

    override public function outlineUI():void {
        this.ui_gameStatusMediatorFPSLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_gameStatusMediatorMemoryUsageLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_gameStatusMediatorSprite.addChild(this.ui_gameStatusMediatorFPSLabel);
        this.ui_gameStatusMediatorSprite.addChild(this.ui_gameStatusMediatorMemoryUsageLabel);

        addChild(this.ui_gameStatusMediatorSprite);
    }

    override public function eventsUI():void {
        setInterval(this.onFPSMeasureUpdate, UI_GAME_STATUS_MEDIATOR_TTL);
        setInterval(this.onMemoryUsageMeasureUpdate, UI_GAME_STATUS_MEDIATOR_TTL);
    }

    override public function destroy():void {
        removeChild(this.ui_gameStatusMediatorSprite);
    }

    private function onFPSMeasureUpdate():void {
        try {
            this.ui_gameStatusMediatorFPSMeasure = int(stage.frameRate);

            this.ui_gameStatusMediatorFPSLabel.htmlText =
                    UI_GAME_STATUS_MEDIATOR_FPS_LABEL_TEXT
                            .replace(UI_GAME_STATUS_MEDIATOR_FPS_LABEL_FPS_MEASURE, this.ui_gameStatusMediatorFPSMeasure);
        }
        catch (error:Error) {
        }
    }

    private function onMemoryUsageMeasureUpdate():void {
        try {
            this.ui_gameStatusMediatorMemoryUsageMeasure = int(System.privateMemory / (1024 * 1024));

            this.ui_gameStatusMediatorMemoryUsageLabel.htmlText =
                    UI_GAME_STATUS_MEDIATOR_MEMORY_LABEL_TEXT
                            .replace(UI_GAME_STATUS_MEDIATOR_MEMORY_LABEL_MEMORY_USAGE_MEASURE, this.ui_gameStatusMediatorMemoryUsageMeasure);
        }
        catch (error:Error) {
        }
    }
}
}
