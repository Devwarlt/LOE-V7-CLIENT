package kabam.rotmg.ui.view.GameUI.UIs {
import flash.display.Sprite;

import kabam.rotmg.ui.view.GameUI.*;

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
