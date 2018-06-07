package kabam.rotmg.minimap.view {
import flash.display.Sprite;

import org.osflash.signals.Signal;

public class MiniMapZoomButtons extends Sprite {
    public const zoom:Signal = new Signal(int);
    private var zoomLevels:int;
    private var zoomLevel:int;

    public function MiniMapZoomButtons() {
        this.zoomLevel = 0;
    }

    public function setZoomLevel(_arg1:int):int {
        if (this.zoomLevels == 0) {
            return (this.zoomLevel);
        }
        if (_arg1 < 0) {
            _arg1 = 0;
        }
        else {
            if (_arg1 >= (this.zoomLevels - 1)) {
                _arg1 = (this.zoomLevels - 1);
            }
        }
        this.zoomLevel = _arg1;
        return (this.zoomLevel);
    }

    public function setZoomLevels(_arg1:int):int {
        this.zoomLevels = _arg1;
        if (this.zoomLevel >= this.zoomLevels) {
            this.zoomLevel = (this.zoomLevels - 1);
        }
        return (this.zoomLevels);
    }

}
}
