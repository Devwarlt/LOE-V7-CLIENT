package kabam.rotmg.chat.control {
import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.build.api.BuildData;
import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.ui.model.HUDModel;

public class ParseChatMessageCommand {

    [Inject]
    public var data:String;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var addTextLine:AddTextLineSignal;
    [Inject]
    public var client:AppEngineClient;
    [Inject]
    public var account:WebAccount;
    [Inject]
    public var buildData:BuildData;
    [Inject]
    public var dailyLoginModel:DailyLoginModel;


    public function execute():void {
        this.hudModel.gameSprite.gsc_.playerText(this.data);
    }

}
}
