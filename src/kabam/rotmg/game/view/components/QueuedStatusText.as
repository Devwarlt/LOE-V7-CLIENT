package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.GameObject;

import kabam.rotmg.text.view.stringBuilder.StringBuilder;

public class QueuedStatusText extends CharacterStatusText {

    public var list:QueuedStatusTextList;
    public var color:uint;
    public var lifetime:int;
    public var next:QueuedStatusText;
    public var stringBuilder:StringBuilder;

    public function QueuedStatusText(_arg1:GameObject, stringBuilder:StringBuilder, color:uint, lifetime:int, _arg5:int = 0) {
        this.stringBuilder = stringBuilder;
        this.color = color;
        this.lifetime = lifetime;
        super(_arg1, color, lifetime, _arg5);
        setStringBuilder(stringBuilder);
    }

    override public function dispose():void {
        this.list.shift();
    }


}
}
