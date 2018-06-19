package kabam.rotmg.chat.control {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;

import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.build.api.BuildData;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.dailyLogin.model.DailyLoginModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.text.model.TextKey;
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
        if (this.data.charAt(0) == "/") {
            var command:Array = this.data.substr(1, this.data.length).split(" ");
            switch (command[0]) {
                case "help":
                    this.SendHelp(TextKey.HELP_COMMAND);
                    return;
                case "props":
                    if (command[1] == "proj") {
                        if (command[2] == "" || command[2] == null) {
                            this.SendHelp("Usage:");
                            this.SendHelp("\t/props proj <object id>");
                            this.SendHelp("\tNote: '0x12AB' and '4779' are same values, but one is in hexadecimal and other in decimal value.");
                        }
                        else if (command[2] == "list"){
                            var appendList:String = null;
                            var countList:int = 0;
                            var list:Object = {};

                            if (command[3] == null || command[3] == "") {
                                this.SendHelp("Usage:");
                                this.SendHelp("\t/props proj list ('type', 'id' or 'total')");
                                return;
                            }

                            this.SendInfo("Projectile library (list):");

                            if (command[3] == "type") {
                                for each (list in ObjectLibrary.projectileObjectTypeLibrary_) {
                                    appendList = appendList + ", " + list.objectTypeHex;
                                    countList++;
                                }
                            } else if (command[3] == "id") {
                                for each (list in ObjectLibrary.projectileObjectTypeLibrary_) {
                                    appendList = appendList + ", " + list.objectId;
                                    countList++;
                                }
                            } else if (command[3] == "total") {
                                for each (list in ObjectLibrary.projectileObjectTypeLibrary_)
                                    countList++;
                            }
                            else {
                                this.SendHelp("Usage:");
                                this.SendHelp("\t/props proj list ('type', 'id' or 'total')");
                                return;
                            }

                            this.SendInfo(countList + " result" + (countList > 1 ? "s" : "") + " found.");

                            if (command[3] != "total")
                                this.SendInfo((countList == 0 ? "Empty" : "\t" + appendList) + ".");
                        }
                        else {
                            var _projectileData:Object = ObjectLibrary.projectileObjectTypeLibrary_[this.data.substr(12, this.data.length)];

                            if (_projectileData == null)
                                this.SendInfo("Projectile data is null for object type '" + this.data.substr(12, this.data.length) + "'.");
                            else {
                                this.SendInfo("Projectile data:");
                                this.SendInfo("\t- Type: " + _projectileData.objectTypeHex + " (" + _projectileData.objectTypeInt + ")");
                                this.SendInfo("\t- Id: " + _projectileData.objectId);
                                this.SendInfo("\t- Class: " + _projectileData.objectClass);
                                this.SendInfo("\t- Texture: ");
                                this.SendInfo("\t\t- File: " + _projectileData.textureFile);
                                this.SendInfo("\t\t- Index: " + _projectileData.textureIndex);
                            }
                        }
                    } else
                        this.SendHelp("Available commands: props (proj).");
                    return;
            }
        }
        this.hudModel.gameSprite.gsc_.playerText(this.data);
    }

    private function SendHelp(message:String):void {
        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, message));
    }

    private function SendInfo(message:String):void {
        this.addTextLine.dispatch(ChatMessage.make(Parameters.SERVER_CHAT_NAME, message));
    }

}
}
