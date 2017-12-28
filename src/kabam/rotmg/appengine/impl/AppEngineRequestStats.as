package kabam.rotmg.appengine.impl {
import kabam.lib.console.signals.ConsoleWatchSignal;

public class AppEngineRequestStats {

    private const nameMap:Object = {};

    [Inject]
    public var watch:ConsoleWatchSignal;


    public function recordStats(_arg1:String, _arg2:Boolean, _arg3:int):void {
        var _local4:StatsWatch = (this.nameMap[_arg1] = ((this.nameMap[_arg1]) || (new StatsWatch(_arg1))));
        _local4.addResponse(_arg2, _arg3);
        this.watch.dispatch(_local4);
    }


}
}

import kabam.lib.console.model.Watch;

class StatsWatch extends Watch {

    internal static const STATS_PATTERN:String = "[APPENGINE STATS] [0xFFEE00:{/x={MEAN}ms, ok={OK}/{COUNT}} {NAME}]";
    internal static const MEAN:String = "{MEAN}";
    internal static const COUNT:String = "{COUNT}";
    internal static const OK:String = "{OK}";
    internal static const NAME:String = "{NAME}";

    internal var count:int;
    internal var time:int;
    internal var mean:int;
    internal var ok:int;

    public function StatsWatch(_arg1:String) {
        super(_arg1, "");
        this.count = 0;
        this.ok = 0;
        this.time = 0;
    }

    public function addResponse(_arg1:Boolean, _arg2:int):void {
        ((_arg1) && (++this.ok));
        this.time = (this.time + _arg2);
        this.mean = (this.time / ++this.count);
        data = this.report();
    }

    internal function report():String {
        return (STATS_PATTERN.replace(MEAN, this.mean).replace(COUNT, this.count).replace(OK, this.ok).replace(NAME, name));
    }


}

