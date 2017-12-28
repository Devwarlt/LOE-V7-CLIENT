package kabam.rotmg.errors.control {
import flash.events.ErrorEvent;

import robotlegs.bender.framework.api.ILogger;

public class LogErrorCommand {

    [Inject]
    public var logger:ILogger;
    [Inject]
    public var event:ErrorEvent;
    private var debug_:Boolean = true;

    public function execute():void {
        if (((this.event["error"]) && ((this.event["error"] is Error))))
            this.logErrorObject(this.event["error"]);
    }

    private function logErrorObject(error:Error):void {
        if (this.debug_) {
            var _errorID:int = error.errorID;
            var _errorMessage:String = error.message;
            var _errorName:String = error.name;
            var _errorStackTrace:String = error.getStackTrace();
            var _error:String = error.toString();
            this.logger.error("[" + _errorName + "] Error " + _errorID + ": " + _errorMessage + " (" + _error + ").");
            if (_errorStackTrace != null)
                this.logger.error(_errorStackTrace);
        } else {
            this.logger.error(error.message);
            this.logger.error(error.getStackTrace());
        }
    }


}
}
