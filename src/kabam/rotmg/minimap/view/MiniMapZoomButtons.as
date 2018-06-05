package kabam.rotmg.minimap.view {
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIMinimapZoomIn_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIMinimapZoomOut_shapeEmbed_;

import org.osflash.signals.Signal;

public class MiniMapZoomButtons extends Sprite {
    public const zoom:Signal = new Signal(int);

    private var ui_zoomInIcon:Sprite;
    private var ui_zoomOutIcon:Sprite;
    private var zoomLevels:int;
    private var zoomLevel:int;

    private static const UI_MINIMAP_ZOOM_IN_POSITION:Point = new Point(24, 24);
    private static const UI_MINIMAP_ZOOM_OUT_POSITION:Point = new Point(24, 0);

    public function MiniMapZoomButtons() {
        this.zoomLevel = 0;
        this.makeZoomIn();
        this.makeZoomOut();
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

    private function makeZoomOut():void {
        var _local1:Bitmap = new Bitmap();
        _local1.bitmapData = new EmbeddedAssets_LoENewUIMinimapZoomOut_shapeEmbed_().bitmapData;
        _local1.filters = [TextureRedrawer.OUTLINE_FILTER];
        this.ui_zoomOutIcon = new Sprite();
        this.ui_zoomOutIcon.x = UI_MINIMAP_ZOOM_IN_POSITION.x;
        this.ui_zoomOutIcon.y = UI_MINIMAP_ZOOM_IN_POSITION.y;
        this.ui_zoomOutIcon.addChild(_local1);
        this.ui_zoomOutIcon.addEventListener(MouseEvent.CLICK, this.onZoomIn);
        addChild(this.ui_zoomOutIcon);
    }

    private function makeZoomIn():void {
        var _local1:Bitmap = new Bitmap();
        _local1.bitmapData = new EmbeddedAssets_LoENewUIMinimapZoomIn_shapeEmbed_().bitmapData;
        _local1.filters = [TextureRedrawer.OUTLINE_FILTER];
        this.ui_zoomInIcon = new Sprite();
        this.ui_zoomInIcon.x = UI_MINIMAP_ZOOM_OUT_POSITION.x;
        this.ui_zoomInIcon.y = UI_MINIMAP_ZOOM_OUT_POSITION.y;
        this.ui_zoomInIcon.addChild(_local1);
        this.ui_zoomInIcon.addEventListener(MouseEvent.CLICK, this.onZoomOut);
        addChild(this.ui_zoomInIcon);
    }

    private function onZoomOut(_arg1:MouseEvent):void {
        _arg1.stopPropagation();
        if (this.canZoomOut()) {
            this.zoom.dispatch(--this.zoomLevel);
        }
    }

    private function canZoomOut():Boolean {
        return ((this.zoomLevel > 0));
    }

    private function onZoomIn(_arg1:MouseEvent):void {
        _arg1.stopPropagation();
        if (this.canZoomIn()) {
            this.zoom.dispatch(++this.zoomLevel);
        }
    }

    private function canZoomIn():Boolean {
        return ((this.zoomLevel < (this.zoomLevels - 1)));
    }


}
}
