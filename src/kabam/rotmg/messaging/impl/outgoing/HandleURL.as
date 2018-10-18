package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.WorldPosData;

public class HandleURL extends OutgoingMessage {
    public var domain_:String;

    public function HandleURL(_arg1:uint, _arg2:Function) {
        this.domain_ = "";
        super(_arg1, _arg2);
    }

    override public function writeToOutput(_arg1:IDataOutput):void {
        _arg1.writeUTF(this.domain_);
    }

    override public function toString():String {
        return (formatToString("HandleURL", "domain_"));
    }


}
}
