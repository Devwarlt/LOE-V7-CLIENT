package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

public class PlayerHit extends OutgoingMessage {

    public var bulletId_:uint;
    public var objectId_:int;
    public var isShieldProtector:Boolean;

    public function PlayerHit(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeByte(this.bulletId_);
        _arg1.writeInt(this.objectId_);
        _arg1.writeBoolean(this.isShieldProtector);
    }

    override public function toString():String {
        return (formatToString("PLAYERHIT", "bulletId_", "objectId_", "isShieldProtector_"));
    }


}
}
