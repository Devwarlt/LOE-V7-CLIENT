package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

public class CTTSend extends IncomingMessage {

    public var CTTSendMessage:String;

    public function CTTSend(_arg1:uint, _arg2:Function) {
        super(_arg1, _arg2);
    }

    override public function parseFromInput(_arg1:IDataInput):void {
        this.CTTSendMessage = _arg1.readUTF();
    }

    override public function toString():String {
        return (formatToString("FAILURE", "CTTSendMessage"));
    }


}
}
