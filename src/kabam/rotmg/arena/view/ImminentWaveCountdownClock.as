package kabam.rotmg.arena.view {
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;

import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.StaticTextDisplay;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;

import org.osflash.signals.Signal;

public class ImminentWaveCountdownClock extends Sprite {
    public const close:Signal = new Signal();
    private var countDownContainer:Sprite = new Sprite();
    private var countdownStringBuilder:StaticStringBuilder = new StaticStringBuilder();
    private var waveTimer:Timer = new Timer(1000);
    private var waveStartContainer:Sprite = new Sprite();
    private var waveStartTimer:Timer = new Timer(1500, 1);

    public function ImminentWaveCountdownClock() {
        super();
        this.waveAsset = new ImminentWaveCountdownClock_WaveAsset();
        this.waveStartContainer.addChild(this.waveAsset);
        this.waveText = new StaticTextDisplay();
        this.waveText.setSize(18).setBold(true).setColor(16567065);
        this.waveText.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_WAVE));
        this.waveText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
        this.waveText.x = ((this.waveAsset.width / 2) - (this.waveText.width / 2));
        this.waveText.y = (((this.waveAsset.height / 2) - (this.waveText.height / 2)) - 15);
        this.waveStartContainer.addChild(this.waveText);
        this.nextWaveText = new StaticTextDisplay();
        this.nextWaveText.setSize(20).setBold(true).setColor(0xCCCCCC);
        this.nextWaveText.setStringBuilder(new LineBuilder().setParams(TextKey.ARENA_COUNTDOWN_CLOCK_NEXT_WAVE));
        this.nextWaveText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
        this.countDownContainer.addChild(this.nextWaveText);
        this.countdownText = new StaticTextDisplay();
        this.countdownText.setSize(42).setBold(true).setColor(0xCCCCCC);
        this.countdownText.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
        this.countdownText.y = this.nextWaveText.height;
        this.countdownText.x = ((this.nextWaveText.width / 2) - (this.countdownText.width / 2));
        this.countdownText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
        this.countDownContainer.addChild(this.countdownText);
        this.waveNumberText = new StaticTextDisplay();
        this.waveNumberText.setSize(40).setBold(true).setColor(16567065);
        this.waveNumberText.y = ((this.waveText.y + this.waveText.height) - 5);
        this.waveNumberText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 2)];
        this.waveStartContainer.addChild(this.waveNumberText);
    }

    private var nextWaveText:StaticTextDisplay;
    private var countdownText:StaticTextDisplay;
    private var waveAsset:Bitmap;
    private var waveText:StaticTextDisplay;
    private var waveNumberText:StaticTextDisplay;
    private var count:int = 5;
    private var waveNumber:int = -1;

    private function init():void {
        mouseChildren = false;
        mouseEnabled = false;
        this.waveTimer.addEventListener(TimerEvent.TIMER, this.updateCountdownClock);
        this.waveTimer.start();
    }

    public function destroy():void {
        this.waveTimer.stop();
        this.waveTimer.removeEventListener(TimerEvent.TIMER, this.updateCountdownClock);
        this.waveStartTimer.stop();
        this.waveStartTimer.removeEventListener(TimerEvent.TIMER, this.cleanup);
    }

    public function show():void {
        addChild(this.countDownContainer);
        this.init();
        this.center();
    }

    public function setWaveNumber(_arg1:int):void {
        this.waveNumber = _arg1;
        this.waveNumberText.setStringBuilder(new StaticStringBuilder(this.waveNumber.toString()));
        this.waveNumberText.x = ((this.waveAsset.width / 2) - (this.waveNumberText.width / 2));
    }

    private function center():void {
        x = (300 - (width / 2));
        y = ((contains(this.countDownContainer)) ? 138 : 87.5);
    }

    private function updateCountdownClock(_arg1:TimerEvent):void {
        if (this.count > 1) {
            this.count--;
            this.countdownText.setStringBuilder(this.countdownStringBuilder.setString(this.count.toString()));
            this.countdownText.x = ((this.nextWaveText.width / 2) - (this.countdownText.width / 2));
        }
        else {
            removeChild(this.countDownContainer);
            addChild(this.waveStartContainer);
            this.waveTimer.removeEventListener(TimerEvent.TIMER, this.updateCountdownClock);
            this.waveStartTimer.addEventListener(TimerEvent.TIMER, this.cleanup);
            this.waveStartTimer.start();
            this.center();
        }
    }

    private function cleanup(_arg1:TimerEvent):void {
        this.waveStartTimer.removeEventListener(TimerEvent.TIMER, this.cleanup);
        this.close.dispatch();
    }
}
}