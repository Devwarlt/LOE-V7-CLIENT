package kabam.rotmg.ui.view.GameHUDView {
public class PingStatus {
    private var _pingStatusLabel_:String;
    private var _pingStatusColor_:String;

    public function PingStatus(_statusLabel:String, _statusColor:String) {
        this._pingStatusLabel_ = _statusLabel;
        this._pingStatusColor_ = _statusColor;
    }

    public function pingStatusLabel_():String {
        return _pingStatusLabel_;
    }

    public function pingStatusColor_(_arg1:Boolean = true):String {
        return _pingStatusColor_.replace("#", _arg1 ? "#" : "0x");
    }
}
}
