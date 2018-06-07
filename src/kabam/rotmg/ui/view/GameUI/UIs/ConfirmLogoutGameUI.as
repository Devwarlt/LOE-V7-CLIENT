package kabam.rotmg.ui.view.GameUI.UIs {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

public class ConfirmLogoutGameUI extends Dialog {
    private var gameSprite:GameSprite;

    public function ConfirmLogoutGameUI(_gameSprite:GameSprite) {
        this.gameSprite = _gameSprite;
        this.gameSprite.player.IsDoingLogout = true;

        super("Logout", "Are you sure you want to logout?", "Yes", "No", null, Dialog.ORANGE);

        this.addEventListener(Dialog.LEFT_BUTTON, this.doLogout);
        this.addEventListener(Dialog.RIGHT_BUTTON, this.cancelLogout);
    }

    private function doLogout(event:Event):void {
        this.gameSprite.player.IsDoingLogout = false;

        stage.focus = null;

        parent.removeChild(this);

        this.gameSprite.closed.dispatch();
    }

    private function cancelLogout(event:Event):void {
        this.gameSprite.player.IsDoingLogout = false;

        parent.filters = [];

        parent.removeChild(this);
    }
}
}
