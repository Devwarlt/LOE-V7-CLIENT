package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

import kabam.rotmg.ui.view.GameHUDView.HUDView;

public class ConfirmLogoutGameUI extends Dialog {
    private var hudView:HUDView;

    public function ConfirmLogoutGameUI(_hudView:HUDView) {
        this.hudView = _hudView;
        this.hudView.gameSprite.player.IsDoingLogout = true;
        this.hudView.logoutSignal.dispatch(false);

        super("Logout", "Are you sure you want to logout?", "Yes", "No", null, Dialog.ORANGE);

        this.addEventListener(Dialog.LEFT_BUTTON, this.doLogout);
        this.addEventListener(Dialog.RIGHT_BUTTON, this.cancelLogout);
    }

    private function doLogout(event:Event):void {
        this.hudView.gameSprite.player.IsDoingLogout = false;
        this.hudView.gameSprite.closed.dispatch();

        stage.focus = null;

        parent.removeChild(this);
    }

    private function cancelLogout(event:Event):void {
        this.hudView.gameSprite.player.IsDoingLogout = false;
        this.hudView.logoutSignal.dispatch(true);

        parent.removeChild(this);
        parent.filters = [];
    }
}
}
