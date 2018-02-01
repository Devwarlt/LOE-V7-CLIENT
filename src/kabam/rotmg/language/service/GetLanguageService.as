package kabam.rotmg.language.service {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;

import kabam.lib.tasks.BaseTask;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.language.model.LanguageModel;
import kabam.rotmg.language.model.StringMap;

import robotlegs.bender.framework.api.ILogger;

public class GetLanguageService extends BaseTask {

    private static const LANGUAGE:String = "LANGUAGE";

    [Inject]
    public var logger:ILogger;
    [Inject]
    public var model:LanguageModel;
    [Inject]
    public var strings:StringMap;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var client:AppEngineClient;
    protected var appEngineUrl:String = StaticInjectorContext.getInjector().getInstance(ApplicationSetup).getAppEngineUrl();
    private var language:String;

    override protected function startTask():void {
        this.language = this.model.getLanguageFamily();
        this.client.complete.addOnce(this.onComplete);
        this.client.setMaxRetries(3);
        this.logger.info("[Production: " + Parameters.IS_PRODUCTION.toString() + "] Attempt to connect to " + this.appEngineUrl + " to obtain language string '" + this.language + "'.");
        this.client.sendRequest("/app/getLanguageStrings", {"languageType": this.language});
    }

    private function onComplete(_arg1:Boolean, _arg2:*):void {
        this.logger.info(("String response from GetLanguageStrings: " + _arg2));
        if (_arg1) {
            this.onLanguageResponse(_arg2);
        }
        else {
            this.onLanguageError();
        }
        completeTask(_arg1, _arg2);
    }

    private function onLanguageResponse(_arg1:String):void {
        var _local3:Array = [];
        this.strings.clear();
        try {
            var _local2:Object = JSON.parse(_arg1);
            for each (_local3 in _local2) {
                this.strings.setValue(_local3[0], _local3[1], _local3[2]);
            }
        } catch (e:Error) {
            this.logger.error(e.getStackTrace());
        }
    }

    private function onLanguageError():void {
        this.strings.setValue("ok", "ok", this.model.getLanguageFamily());
        var _local1:ErrorDialog = new ErrorDialog((("Unable to load language [" + this.language) + "]"));
        this.openDialog.dispatch(_local1);
        completeTask(false);
    }


}
}
