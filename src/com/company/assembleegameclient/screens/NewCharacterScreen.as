package com.company.assembleegameclient.screens {
import flash.display.Sprite;

import org.osflash.signals.Signal;

public class NewCharacterScreen extends Sprite {
    public function NewCharacterScreen() {
        super();
        this.selected = new Signal(int);
    }
    public var selected:Signal;

    public function initialize(_arg1:int):void {
        this.selected.dispatch(_arg1);
    }
}
}
