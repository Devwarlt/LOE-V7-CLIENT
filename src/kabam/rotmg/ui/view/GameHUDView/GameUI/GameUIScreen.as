package kabam.rotmg.ui.view.GameHUDView.GameUI {
import flash.display.Sprite;

import kabam.rotmg.ui.view.GameHUDView.*;

public class GameUIScreen extends Sprite implements GameUIInterface {
    protected var hudView:HUDView;

    public function GameUIScreen(_hudView:HUDView) {
        this.hudView = _hudView;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();
    }

    public function drawUI():void { }

    public function setUI():void { }

    public function outlineUI():void { }

    public function addUI():void { }

    public function eventsUI():void { }

    public function destroy():void { }
}
}
