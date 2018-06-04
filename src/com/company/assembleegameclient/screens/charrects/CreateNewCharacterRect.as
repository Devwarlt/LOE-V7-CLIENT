package com.company.assembleegameclient.screens.charrects {
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class CreateNewCharacterRect extends CharacterRect {

    public function CreateNewCharacterRect(_arg1:PlayerModel) {
        super();
        super.className = new LineBuilder().setParams(TextKey.CREATE_NEW_CHARACTER_RECT_NEW_CHARACTER);
        super.color = 0x545454;
        super.overColor = 0x777777;
        super.init();
    }


}
}
