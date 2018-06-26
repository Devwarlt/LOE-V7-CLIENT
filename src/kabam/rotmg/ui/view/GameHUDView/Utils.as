package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.parameters.Parameters;

public class Utils {
    public static function trimNumber(_arg1:Number, _arg2:int):Number {
        return Math.round(_arg1 * Math.pow(10, _arg2)) / Math.pow(10, _arg2);
    }

    public static function characterStatusMediatorAction(_arg1:Boolean):void {
        Parameters.data_.displayCharacterStatusMediator = _arg1;
        Parameters.save();
    }

    public static function connectionMediatorAction(_arg1:Boolean):void {
        Parameters.data_.displayConnectionMediator = _arg1;
        Parameters.save();
    }

    public static function gameStatusMediatorAction(_arg1:Boolean):void {
        Parameters.data_.displayGameStatusMediator = _arg1;
        Parameters.save();
    }
}
}
