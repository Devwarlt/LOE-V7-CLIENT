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
    public static const GRAY:ColorMatrixFilter = GetColor(0x69, 0x69, 0x69, 1);

    private static function GetColor(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:Number = 1):ColorMatrixFilter {
        var matrix:Array = [];
        matrix = matrix.concat([_arg1 / 0xFF, 0, 0, 0, 0]); // red
        matrix = matrix.concat([0, _arg2 / 0xFF, 0, 0, 0]); // green
        matrix = matrix.concat([0, 0, _arg3 / 0xFF, 0, 0]); // blue
        matrix = matrix.concat([0, 0, 0, _arg4, 0]); // alpha

        return new ColorMatrixFilter(matrix);
    }

    private function drawBackground():Bitmap {
        var bitmap:Bitmap = new Bitmap();
        bitmap.bitmapData = new NewUIHighResolutionBar_shapeEmbed_().bitmapData;

        var matrix:Matrix = new Matrix();
        matrix.scale(1, this.height_ / bitmap.height);

        var bitmapData:BitmapData = new BitmapData((bitmap.width - this.widthOffset_), bitmap.height - this.heightOffset_, true, 0x00000000);
        bitmapData.draw(bitmap, matrix, null, null, null, true);
        bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, (bitmap.width - this.widthOffset_), (bitmap.height - this.heightOffset_) * (this.height_ / bitmap.height)), new Point(), BLACK);

        var newBitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
        newBitmap.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        return newBitmap;
    }

    private function draw():Bitmap {
        var bitmap:Bitmap = new Bitmap();
        bitmap.bitmapData = new NewUIHighResolutionBar_shapeEmbed_().bitmapData;

        var matrix:Matrix = new Matrix();
        matrix.scale(1, this.height_ / bitmap.height);

        var bitmapData:BitmapData = new BitmapData((bitmap.width - this.widthOffset_) * (this.min_ / this.max_), bitmap.height - this.heightOffset_, true, 0x00000000);
        bitmapData.draw(bitmap, matrix, null, null, null, true);
        bitmapData.applyFilter(bitmapData, new Rectangle(0, 0, (bitmap.width - this.widthOffset_) * (this.min_ / this.max_), (bitmap.height - this.heightOffset_) * (this.height_ / bitmap.height)), new Point(), this.colorMatrix_);

        var newBitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, true);
        newBitmap.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

        return newBitmap;
    }

    public function redraw(min:int, max:int):void {
        this.min_ = min;
        this.max_ = max;

        if (this.max_ <= 0) {
            this.min_ = 1;
            this.max_ = 1;
        }

        this.middleText_.htmlText = this.getText;

        this.sprite_.removeChild(this.bitmapBackground_);
        this.sprite_.removeChild(this.bitmap_);

        this.bitmap_ = this.min_ <= 0 ? this.drawBackground() : this.draw();
        this.bitmapBackground_ = this.drawBackground();

        this.sprite_.addChild(this.bitmapBackground_);
        this.sprite_.addChild(this.bitmap_);
    }

    private function get getText():String {
        var nullInput:Boolean = false;

        if (this.max_ <= 0) {
            this.min_ = 1;
            this.max_ = 1;

            nullInput = true;
        }

        return nullInput ? (this.enablePercent_ ? "<b>0%</b>" : "0 / 0") : (this.enablePercent_ ? "<b>" + Parameters.formatValue((this.min_ / this.max_) * 100, 2) + "%</b>" : this.min_ + " / " + this.max_);
    }

    // Bar data:
    //  - width: 800px
    //  - height: 36px

    private var min_:Number;
    private var max_:Number;
    private var height_:Number;
    private var widthOffset_:int;
    private var heightOffset_:int;
    private var colorMatrix_:ColorMatrixFilter;
    private var text_:String;
    private var enablePercent_:Boolean;
    private var bitmap_:Bitmap;
    private var bitmapBackground_:Bitmap;
    private var topText_:BaseSimpleText;
    private var middleText_:BaseSimpleText;
    private var sprite_:Sprite;

    public function GameBar(min:Number, max:Number, height:Number, widthOffset:int, heightOffset:int, colorMatrix:ColorMatrixFilter, text:String = null, enablePercent:Boolean = false) {
        this.min_ = min > max ? max : min;
        this.max_ = max;
        this.height_ = height;
        this.widthOffset_ = widthOffset;
        this.heightOffset_ = heightOffset;
        this.colorMatrix_ = colorMatrix;
        this.text_ = text;
        this.enablePercent_ = enablePercent;
        this.sprite_ = new Sprite();

        addChild(this.sprite_);

        var nullInput:Boolean = false;

        if (this.max_ <= 0) {
            this.min_ = 1;
            this.max_ = 1;

            nullInput = true;
        }

        if (this.text_ != null) {
            this.topText_ = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
            this.topText_.selectable = false;
            this.topText_.border = false;
            this.topText_.mouseEnabled = true;
            this.topText_.htmlText = "<b>" + this.text_ + "</b>";
            this.topText_.useTextDimensions();
            this.topText_.x = 4;
            this.topText_.y = - 12;
            this.topText_.filters = [HUDView.UI_FILTERS_BLACK_OUTLINE];

            addChild(this.topText_);

            this.middleText_ = new BaseSimpleText(12, 0xE8E8E8, false, 128, 0);
            this.middleText_.selectable = false;
            this.middleText_.border = false;
            this.middleText_.mouseEnabled = true;
            this.middleText_.htmlText = this.getText;
            this.middleText_.useTextDimensions();
            this.middleText_.x = this.width + this.middleText_.textWidth / 2 + (this.enablePercent_ ? 24 : 0);
            this.middleText_.y = (this.height_ - this.middleText_.textHeight) / 4 - 12 / 4;

            addChild(this.middleText_);
        }

        this.bitmap_ = this.min_ <= 0 ? this.drawBackground() : this.draw();
        this.bitmapBackground_ = this.drawBackground();

        this.sprite_.addChild(this.bitmapBackground_);
        this.sprite_.addChild(this.bitmap_);
    }
}
}
