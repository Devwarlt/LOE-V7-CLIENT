package loader {
import flash.geom.Rectangle;

import mx.geom.RoundedRectangle;
import mx.preloaders.*;

public class ProgressBar extends DownloadProgressBar
{
    public function ProgressBar()
    {
        super();

        DOWNLOAD_PERCENTAGE = 1;
        MINIMUM_DISPLAY_TIME = 10;

        initializingLabel = "Loading...";

        labelFormat.color = 0xFFFFFF;
        percentFormat.color = 0xFFFFFF;

        showLabel = true;
        showPercentage = true;
    }

    // x, y, width, height
    //(14, 40, 154, 4)
    override protected function get barFrameRect():RoundedRectangle
    { return new RoundedRectangle(14, 40, 360, 8); }

    //(14, 39, 154, 6, 0)
    override protected function get barRect():RoundedRectangle
    { return new RoundedRectangle(14, 39, 360, 10, 0); }

    //(0, 0, 182, 60, 4)
    override protected function get borderRect():RoundedRectangle
    { return new RoundedRectangle(0, 0, 386, 60, 4); }

    //x, y, width, height
    //(108, 4, 34, 16)
    override protected function get percentRect():Rectangle
    { return new Rectangle(314, 4, 34, 16); }
}
}