package {
import kabam.rotmg.core.StaticInjectorContext;

import robotlegs.bender.framework.api.ILogger;
import robotlegs.bender.framework.impl.Logger;

public class Log {
    [Inject]
    private static var log:Logger = StaticInjectorContext.getInjector().getInstance(ILogger);

    public static function Info(text:String, params:Array = null):void {
        log.info(text, params);
    }

    public static function Warn(text:String, params:Array = null):void {
        log.warn(text, params);
    }

    public static function Error(text:String, params:Array = null):void {
        log.error(text, params);
    }

    public static function Fatal(text:String, params:Array = null):void {
        log.fatal(text, params);
    }
}
}