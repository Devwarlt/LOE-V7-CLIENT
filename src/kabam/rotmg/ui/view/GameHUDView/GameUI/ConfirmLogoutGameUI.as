package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

import kabam.rotmg.ui.view.GameHUDView.HUDView;

public class ConfirmLogoutGameUI extends Dialog {
    public function ConfirmLogoutGameUI(_hudView:HUDView) {
        super("Logout", "Are you sure you want to logout?", "Yes", "No", null, Dialog.ORANGE);

        this.hudView = _hudView;
        this.hudView.logoutSignal.dispatch(false);
        this.hudView.gameSprite.player.IsDoingLogout = true;

        this.addEventListener(Dialog.LEFT_BUTTON, this.doLogout);
        this.addEventListener(Dialog.RIGHT_BUTTON, this.cancelLogout);
    }

    private var hudView:HUDView;

    private function doLogout(event:Event):void {
        stage.focus = null;

        parent.removeChild(this);

        this.hudView.gameSprite.player.IsDoingLogout = false;
        this.hudView.gameSprite.closed.dispatch();
    }

    private function cancelLogout(event:Event):void {
        parent.filters = [];
        parent.removeChild(this);

        this.hudView.logoutSignal.dispatch(true);
        this.hudView.gameSprite.player.IsDoingLogout = false;
    }
}
}
