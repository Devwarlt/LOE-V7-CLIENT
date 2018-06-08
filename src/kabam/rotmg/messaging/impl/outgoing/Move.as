package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.WorldPosData;

public class Move extends OutgoingMessage {
    public var position_:WorldPosData;

    public function Move(_arg1:uint, _arg2:Function) {
        this.position_ = new WorldPosData();
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        this.position_.writeToOutput(_arg1);
    }

    override public function toString():String {
        return (formatToString("MOVE", "position_"));
    }


}
}
