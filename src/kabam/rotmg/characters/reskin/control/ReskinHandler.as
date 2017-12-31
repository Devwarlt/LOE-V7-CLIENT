package kabam.rotmg.characters.reskin.control {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.util.AnimatedChars;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.messaging.impl.outgoing.Reskin;

public class ReskinHandler {

    [Inject]
    public var model:GameModel;
    [Inject]
    public var classes:ClassesModel;

    public function execute(_arg1:Reskin):void {
        var _local2:Player;
        var _local3:int;
        var _local4:CharacterClass;
        _local2 = ((_arg1.player) || (this.model.player));
        _local3 = _arg1.skinID;
        _local4 = this.classes.getCharacterClass(_local2.objectType_);
        var _local5:CharacterSkin = _local4.skins.getSkin(_local3);
        _local2.skinId = _local3;
        _local2.skin = AnimatedChars.getAnimatedChar(_local5.template.file, _local5.template.index);
        _local2.isDefaultAnimatedChar = false;
    }


}
}
