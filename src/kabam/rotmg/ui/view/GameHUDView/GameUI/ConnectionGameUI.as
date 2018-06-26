package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.ui.BaseSimpleText;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.HTTPStatusEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.getTimer;
import flash.utils.setInterval;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.ui.view.GameHUDView.HUDView;
import kabam.rotmg.ui.view.GameHUDView.PingStatus;

public class ConnectionGameUI extends GameUIScreen {
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_RECEIVED:int = 200;
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_MAX_LATENCY:int = 5000;
    private static const UI_CONNECTION_MEDIATOR_PING_TTL:uint = 2000;
    private static const UI_CONNECTION_MEDIATOR_PING_LABEL_MEASURE:String = "{PING_MEASURE}";
    private static const UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS:String = "{PING_STATUS}";
    private static const UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS_COLOR:String = "{PING_STATUS_COLOR}";
    private static const UI_CONNECTION_MEDIATOR_PING_LABEL_TEXT:String = "[<font color='" + UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS_COLOR + "'>" + UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS + "</font>] <b>Ping:</b> " + UI_CONNECTION_MEDIATOR_PING_LABEL_MEASURE;
    private static const UI_CONNECTION_MEDIATOR_PING_LABEL_POSITION:Point = new Point(16, 0);
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_OFFLINE:PingStatus = new PingStatus("Offline", "#ff0900");
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_BAD:PingStatus = new PingStatus("Bad", "#ff0900");
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_NORMAL_1:PingStatus = new PingStatus("Normal", "#ff9a3c");
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_NORMAL_2:PingStatus = new PingStatus("Normal", "#fffc38");
    private static const UI_CONNECTION_MEDIATOR_PING_STATUS_GOOD:PingStatus = new PingStatus("Good", "#58fc00");

    private var ui_connectionMediatorPingSprite:Sprite;
    private var ui_connectionMediatorPingIndicator:Shape;
    private var ui_connectionMediatorPingLabel:BaseSimpleText;
    private var ui_connectionMediatorPingMeasure:int;
    private var ui_connectionMediatorPingLoader:URLLoader;
    private var ui_connectionMediatorPingAppEngineURL:String = StaticInjectorContext.getInjector().getInstance(ApplicationSetup).getAppEngineUrl();
    private var ui_connectionMediatorPingStart:Number;

    public function ConnectionGameUI(_hudView:HUDView) {
        super(_hudView);
    }

    override public function drawUI():void {
        this.ui_connectionMediatorPingSprite = new Sprite();

        this.ui_connectionMediatorPingIndicator = new Shape();

        var _local1:Graphics = this.ui_connectionMediatorPingIndicator.graphics;
        _local1.clear();
        _local1.beginFill(0, 1);
        _local1.drawRoundRect(0, 0, 16, 16, 32, 32);
        _local1.endFill();

        this.ui_connectionMediatorPingMeasure = 0;

        this.ui_connectionMediatorPingStart = 0;

        this.ui_connectionMediatorPingLabel = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
        this.ui_connectionMediatorPingLabel.selectable = false;
        this.ui_connectionMediatorPingLabel.border = false;
        this.ui_connectionMediatorPingLabel.mouseEnabled = true;
        this.ui_connectionMediatorPingLabel.htmlText = "[???] <b>Ping:</b> --";
        this.ui_connectionMediatorPingLabel.useTextDimensions();
    }

    override public function setUI():void {
        this.ui_connectionMediatorPingLabel.x = UI_CONNECTION_MEDIATOR_PING_LABEL_POSITION.x;
        this.ui_connectionMediatorPingLabel.y = UI_CONNECTION_MEDIATOR_PING_LABEL_POSITION.y / 2 - 1;
    }

    override public function outlineUI():void {
        this.ui_connectionMediatorPingIndicator.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.ui_connectionMediatorPingLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];
    }

    override public function addUI():void {
        this.ui_connectionMediatorPingSprite.addChild(this.ui_connectionMediatorPingIndicator);
        this.ui_connectionMediatorPingSprite.addChild(this.ui_connectionMediatorPingLabel);

        addChild(this.ui_connectionMediatorPingSprite);
    }

    override public function eventsUI():void {
        setInterval(this.onPingMeasureUpdate, UI_CONNECTION_MEDIATOR_PING_TTL);
    }

    private function onPingMeasureUpdate():void {
        try {
            var _pingStatus:PingStatus = this.getPingStatus();

            var _pingIndicator:Graphics = this.ui_connectionMediatorPingIndicator.graphics;
            _pingIndicator.clear();
            _pingIndicator.beginFill(uint(_pingStatus.pingStatusColor_(false)), 1);
            _pingIndicator.drawRoundRect(0, 0, 16, 16, 32, 32);
            _pingIndicator.endFill();

            this.ui_connectionMediatorPingLabel.htmlText =
                UI_CONNECTION_MEDIATOR_PING_LABEL_TEXT
                    .replace(UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS_COLOR, _pingStatus.pingStatusColor_() != "#000000" ? _pingStatus.pingStatusColor_() : "")
                    .replace(UI_CONNECTION_MEDIATOR_PING_LABEL_STATUS, _pingStatus.pingStatusLabel_())
                    .replace(UI_CONNECTION_MEDIATOR_PING_LABEL_MEASURE, _pingStatus.pingStatusLabel_() != "Offline" ? this.ui_connectionMediatorPingMeasure + " ms" : "--");
        }
        catch (error:Error) { }
    }

    public function setInvalidPing():void {
        this.ui_connectionMediatorPingLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onLoadStatus);

        this.ui_connectionMediatorPingMeasure = -1;
    }

    public function initializePing():void {
        this.ui_connectionMediatorPingLoader = new URLLoader();
        this.ui_connectionMediatorPingLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.onLoadStatus);

        this.startPing();
    }

    private function startPing():void {
        this.ui_connectionMediatorPingStart = getTimer();

        this.ui_connectionMediatorPingLoader.load(new URLRequest(this.ui_connectionMediatorPingAppEngineURL + "/ping/?i=" + Math.random()));
    }

    private function onLoadStatus(event:HTTPStatusEvent):void {
        if (event.status == UI_CONNECTION_MEDIATOR_PING_STATUS_RECEIVED) {
            this.ui_connectionMediatorPingMeasure = getTimer() - this.ui_connectionMediatorPingStart;

            this.ui_connectionMediatorPingStart = 0;

            this.startPing();
        }

        if (getTimer() - this.ui_connectionMediatorPingStart < UI_CONNECTION_MEDIATOR_PING_STATUS_MAX_LATENCY)
            this.startPing();
    }

    private function getPingStatus():PingStatus {
        if (this.ui_connectionMediatorPingMeasure != -1 && this.ui_connectionMediatorPingMeasure < 100)
            return UI_CONNECTION_MEDIATOR_PING_STATUS_GOOD;
        else if (this.ui_connectionMediatorPingMeasure >= 100 && this.ui_connectionMediatorPingMeasure < 250)
            return UI_CONNECTION_MEDIATOR_PING_STATUS_NORMAL_2;
        else if (this.ui_connectionMediatorPingMeasure >= 250 && this.ui_connectionMediatorPingMeasure < 500)
            return UI_CONNECTION_MEDIATOR_PING_STATUS_NORMAL_1;
        else if (this.ui_connectionMediatorPingMeasure >= 500 && this.ui_connectionMediatorPingMeasure < UI_CONNECTION_MEDIATOR_PING_STATUS_MAX_LATENCY)
            return UI_CONNECTION_MEDIATOR_PING_STATUS_BAD;
        else if (this.ui_connectionMediatorPingMeasure == -1)
            return UI_CONNECTION_MEDIATOR_PING_STATUS_OFFLINE;
        else
            return new PingStatus("???", "#000000");
    }

    override public function destroy():void {
        this.ui_connectionMediatorPingLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.onLoadStatus);

        removeChild(this.ui_connectionMediatorPingSprite);
    }
}
}
