package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.BaseSimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIHighResolutionBar_shapeEmbed_;

public class GameBar extends Sprite {
    public static const RED:ColorMatrixFilter = GetColor(0xFF, 0x00, 0x00, 1);
    public static const GREEN:ColorMatrixFilter = GetColor(0x00, 0xFF, 0x00, 1);
    public static const BLUE:ColorMatrixFilter = GetColor(0x00, 0x00, 0xFF, 1);
    public static const YELLOW:ColorMatrixFilter = GetColor(0xFF, 0xFF, 0x00, 1);
    public static const MAGENTA:ColorMatrixFilter = GetColor(0xFF, 0x00, 0xFF, 1);
    public static const CYAN:ColorMatrixFilter = GetColor(0x00, 0xFF, 0xFF, 1);
    public static const WHITE:ColorMatrixFilter = GetColor(0xFF, 0xFF, 0xFF, 1);
    public static const BLACK:ColorMatrixFilter = GetColor(0x00, 0x00, 0x00, 1);
    public static const ORANGE:ColorMatrixFilter = GetColor(0xFF, 0xA5, 0x00, 1);

    private static function GetColor(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:Number = 1):ColorMatrixFilter {
        var matrix:Array = [];
        matrix = matrix.concat([_arg1 / 0xFF, 0, 0, 0, 0]); // red
        matrix = matrix.concat([0, _arg2 / 0xFF, 0, 0, 0]); // green
        matrix = matrix.concat([0, 0, _arg3 / 0xFF, 0, 0]); // blue
        matrix = matrix.concat([0, 0, 0, _arg4, 0]); // alpha

        return new ColorMatrixFilter(matrix);
    }

    private function drawBackground(height:Number, widthOffset:int, heightOffset:int):void {
        var bitmap:Bitmap = new Bitmap();
        bitmap.bitmapData = new NewUIHighResolutionBar_shapeEmbed_().bitmapData;

        var matrix:Matrix = new Matrix();
        matrix.scale(1, height / bitmap.height);

        var bitmapData:BitmapData = new BitmapData((bitmap.width - widthOffset), bitmap.height - heightOffset, true, 0x00000000);
        bitmapData.draw(bitmap, matrix, null, null, null, true);
        bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, (bitmap.width - widthOffset), (bitmap.height - heightOffset) * (height / bitmap.height)), new Point(), BLACK);

        var newBitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
        newBitmap.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        addChild(newBitmap);
    }

    // Bar data:
    //  - width: 800px
    //  - height: 36px

    public function GameBar(min:Number, max:Number, height:Number, widthOffset:int, heightOffset:int, colorMatrix:ColorMatrixFilter, text:String = null, enablePercent:Boolean = false) {
        var nullInput:Boolean = false;

        if (max <= 0) {
            min = 1;
            max = 1;

            nullInput = true;
        }

        var bitmap:Bitmap = new Bitmap();
        bitmap.bitmapData = new NewUIHighResolutionBar_shapeEmbed_().bitmapData;

        var matrix:Matrix = new Matrix();
        matrix.scale(1, height / bitmap.height);

        var bitmapData:BitmapData = new BitmapData((bitmap.width - widthOffset) * (min / max), bitmap.height - heightOffset, true, 0x00000000);
        bitmapData.draw(bitmap, matrix, null, null, null, true);
        bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, (bitmap.width - widthOffset) * (min / max), (bitmap.height - heightOffset) * (height / bitmap.height)), new Point(), colorMatrix);

        var newBitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
        newBitmap.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        this.drawBackground(height, widthOffset, heightOffset);

        addChild(newBitmap);

        if (text != null) {
            var topLabel:BaseSimpleText = new BaseSimpleText(14, 0xE8E8E8, false, 128, 0);
            topLabel.selectable = false;
            topLabel.border = false;
            topLabel.mouseEnabled = true;
            topLabel.htmlText = "<b>" + text + "</b>";
            topLabel.useTextDimensions();
            topLabel.x = 4;
            topLabel.y = - 12;
            topLabel.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

            var middleLabel:BaseSimpleText = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
            middleLabel.selectable = false;
            middleLabel.border = false;
            middleLabel.mouseEnabled = true;
            middleLabel.htmlText = enablePercent ? "<b>" + nullInput ? "0" : (Parameters.formatValue((min / max) * 100, 2)) + "%</b>" : ( nullInput ? "0 / 0" : min + " / " + max);
            middleLabel.useTextDimensions();
            middleLabel.x = newBitmap.width - 3 * middleLabel.htmlText.length / 2;
            middleLabel.y = (height - middleLabel.textHeight) / 4 - 12 / 4;

            addChild(topLabel);
            addChild(middleLabel);
        }
    }
}
}
