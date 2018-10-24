package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

public class Slot extends Sprite {
    private const UI_ITEM_SIZE:int = 80;

    public function Slot(_equipmentSlot:Boolean = true) {
        this.ui_itemSlotBitmap = new Bitmap(TextureRedrawer.redraw(AssetLibrary.getImageFromSet("slotsNormal", _equipmentSlot ? 0 : 1), this.UI_ITEM_SIZE * 1.5, false, 0));
        this.ui_itemBitmap = new Bitmap();

        addChild(this.ui_itemSlotBitmap);
        addChild(this.ui_itemBitmap);
    }
    private var ui_itemSlotBitmap:Bitmap;
    private var ui_itemBitmap:Bitmap;

    public function draw(_itemType:int):void {
        if (_itemType == -1)
            return;

        var size:int = this.UI_ITEM_SIZE;
        var item:XML = ObjectLibrary.xmlLibrary_[_itemType];
        var file:String = String(new XML(item.Texture).File);
        var index:int = int(new XML(item.Texture).Index);
        var bitmapData:BitmapData = AssetLibrary.getImageFromSet(file, index);

        if (Parameters.itemTypes16.indexOf(_itemType) != -1 || bitmapData.height == 16)
            size = (size * 0.5);

        bitmapData = TextureRedrawer.redraw(bitmapData, size, false, 0, true, 5);

        this.ui_itemBitmap.bitmapData = bitmapData;
        this.ui_itemBitmap.x = this.ui_itemSlotBitmap.width / 2 - this.ui_itemBitmap.width / 2;
        this.ui_itemBitmap.y = this.ui_itemSlotBitmap.height / 2 - this.ui_itemBitmap.height / 2;
    }
}
}
