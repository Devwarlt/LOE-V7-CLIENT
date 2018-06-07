package kabam.rotmg.ui.view.GameUI {
import flash.geom.Point;

import kabam.rotmg.ui.view.GameUI.mediators.SoundMediator;

public class SettingsGameUI extends GameUIScreen {
    /*
    * [OVERVIEW] Settings options:
    * - Sound:
    *       Turn game sounds enabled (on) or disabled (off);
    * - Connection:
    *       Show modal mediator UI with:
    *           -> Ping Latency:
    *               - red circle indicator: latency above 500 ms;
    *               - orange circle indicator: latency between 250 to 499 ms;
    *               - yellow circle indicator: latency between 100 to 249 ms;
    *               - green circle indicator: latency under 99 ms.
    * - Game Status:
    *       Show modal mediator UI with:
    *           -> 'FPS': show number of frames per second rendered;
    *           -> 'Memory Usage': show memory used by client instance before crash notification*.
    *           // TODO: implement 'Crash Notification'. It's Quality of Life feature.
    * - Character Analytics:
    *       Show modal mediator UI with:
    *           -> 'Character Level': display label 'level' and current level of character into bottom UI shape;
    *           -> 'Character Experience': display a bottom big bar with percentage completed in current level and experience remain until next level;
    *           -> 'Character Health Points': display the current health points of character using following structure '{CURRENT_HEALTH_POINTS}/{MAX_HEALTH_POINTS}' and also fit half size of 'Character Experience Bar' in the bottom left corner of game UI;
    *           -> 'Character Magic Points': display the current magic points of character using following structure '{CURRENT_MAGIC_POINTS}/{MAX_MAGIC_POINTS}' and also fit half size of 'Character Experience Bar' in the bottom right corner of game UI;
    *           // TODO: implement 'Experience Analytics'. It's Quality of Life feature.
    * */

    private static const UI_SETTINGS_SOUND_MEDIATOR_POSITION:Point = new Point(32, 64);

    private var ui_settingsSoundMediator:SoundMediator;

    public function SettingsGameUI() {
        super("Settings");
    }

    override protected function drawExtraUI():void {
        this.ui_settingsSoundMediator = new SoundMediator();
    }

    override protected function setExtraUI():void {
        this.ui_settingsSoundMediator.x = UI_SETTINGS_SOUND_MEDIATOR_POSITION.x;
        this.ui_settingsSoundMediator.y = UI_SETTINGS_SOUND_MEDIATOR_POSITION.y;
    }

    override protected function addExtraUI():void {
        addChild(this.ui_settingsSoundMediator);
    }
}
}
