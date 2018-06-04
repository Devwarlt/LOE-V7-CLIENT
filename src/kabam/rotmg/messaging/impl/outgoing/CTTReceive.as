package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.ByteArray;
import flash.utils.IDataOutput;

public class CTTReceive extends OutgoingMessage {

    public var CTTAuth:String = "";

    public function CTTReceive(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.CTTAuth);
    }

    override public function toString():String {
        return (formatToString("CTTReceive", "CTTAuth"));
    }


}
}
