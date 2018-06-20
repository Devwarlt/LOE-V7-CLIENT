package kabam.rotmg.core {
import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.impl.Context;

public class StaticInjectorContext extends Context {

    public static var playerType:String;
    public static var injector:Injector;

    public function StaticInjectorContext(webMain:WebMain) {
        if (!StaticInjectorContext.injector) {
            StaticInjectorContext.injector = this.injector;
            StaticInjectorContext.playerType = webMain.playerType;
        }
    }

    public static function getInjector():Injector {
        return (injector);
    }

    public static function get getPlayerType():String {
        return (playerType);
    }
}
}
