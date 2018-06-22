package kabam.rotmg.ui.view.GameHUDView {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIHighResolutionBar_shapeEmbed_;

public class GameBar extends Sprite {
    public static const RED:ColorTransform = new ColorTransform(0xFF, 0x00, 0x00, 1, 0, 0, 0, 0);
    public static const GREEN:ColorTransform = new ColorTransform(0x00, 0xFF, 0x00, 1, 0, 0, 0, 0);
    public static const BLUE:ColorTransform = new ColorTransform(0x00, 0x00, 0xFF, 1, 0, 0, 0, 0);
    public static const YELLOW:ColorTransform = new ColorTransform(0xFF, 0xFF, 0x00, 1, 0, 0, 0, 0);
    public static const MAGENTA:ColorTransform = new ColorTransform(0xFF, 0x00, 0xFF, 1, 0, 0, 0, 0);
    public static const CYAN:ColorTransform = new ColorTransform(0x00, 0xFF, 0xFF, 1, 0, 0, 0, 0);
    public static const WHITE:ColorTransform = new ColorTransform(0xFF, 0xFF, 0xFF, 1, 0, 0, 0, 0);
    public static const BLACK:ColorTransform = new ColorTransform(0x00, 0x00, 0x00, 1, 0, 0, 0, 0);

    // Bar data:
    //  - width: 800px
    //  - height: 36px

    public function GameBar(min:Number, max:Number, height:Number, widthOffset:int, heightOffset:int, color:ColorTransform) {
        var sprite:Sprite = new Sprite();

        var bitmap:Bitmap = new Bitmap();
        bitmap.bitmapData = new NewUIHighResolutionBar_shapeEmbed_().bitmapData;

        var matrix:Matrix = new Matrix();
        matrix.scale((min / max) * ((bitmap.height - widthOffset) / bitmap.width), height / bitmap.height);

        var bitmapData:BitmapData = new BitmapData(bitmap.width - widthOffset, bitmap.height - heightOffset);
        bitmapData.draw(bitmap, matrix, null, null, null, true);

        sprite.addChild(new Bitmap(bitmapData, PixelSnapping.NEVER, true));
        sprite.transform.colorTransform = color;

        addChild(sprite);
    }
}
}
