package com.company.assembleegameclient.ui {
import kabam.rotmg.text.view.TextFieldDisplayConcrete;

public class DeprecatedClickableText extends ClickableTextBase {

    public function DeprecatedClickableText(_arg1:int, _arg2:Boolean, _arg3:String, _arg4:Boolean = true) {
        super(_arg1, _arg2, _arg3, _arg4);
    }

    override protected function makeText():TextFieldDisplayConcrete {
        return (new TextFieldDisplayConcrete());
    }


}
}
