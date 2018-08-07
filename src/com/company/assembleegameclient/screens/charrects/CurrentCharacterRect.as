package com.company.assembleegameclient.screens.charrects {
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.rotmg.graphics.DeleteXGraphic;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.fortune.components.ItemWithTooltip;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class CurrentCharacterRect extends CharacterRect {

    public const selected:Signal = new Signal();
    public const deleteCharacter:Signal = new Signal();
    public const showToolTip:Signal = new Signal(Sprite);
    public const hideTooltip:Signal = new Signal();

    public function CurrentCharacterRect(_arg1:String, _arg2:CharacterClass, _arg3:SavedCharacter, _arg4:CharacterStats) {
        this.myPlayerToolTipFactory = new MyPlayerToolTipFactory();
        super();
        this.charName = _arg1;
        this.charType = _arg2;
        this.char = _arg3;
        this.charStats = _arg4;
        var _local5:String = _arg2.name;
        var _local6:int = _arg3.charXML_.Level;
        var _local7:int = _arg3.charXML_.NewPet;
        super.className = new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_DESCRIPTION, {
            "level": _local6,
            "className": "\t" + (_local6.toString().length == 1 ? "\t" : "") + _local5
        });
        super.color = 0x5C5C5C;
        super.overColor = 0x7F7F7F;
        super.init();
        this.makeTaglineText();
        this.makeDeleteButton();
        this.makeNewPetIcon(_local7);
        this.addEventListeners();
    }
    public var charName:String;
    public var charStats:CharacterStats;
    public var char:SavedCharacter;
    public var myPlayerToolTipFactory:MyPlayerToolTipFactory;
    private var toolTip_:MyPlayerToolTip = null;
    private var charType:CharacterClass;
    private var deleteButton:Sprite;
    private var icon:DisplayObject;
    private var newPetIcon:ItemWithTooltip;
    private var samplePetIcons:Array = [0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4705, 0x4706, 0x4707];

    public function setIcon(_arg1:DisplayObject):void {
        ((this.icon) && (selectContainer.removeChild(this.icon)));
        this.icon = _arg1;
        this.icon.x = 4;
        this.icon.y = 4;
        ((this.icon) && (selectContainer.addChild(this.icon)));
    }

    private function addEventListeners():void {
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        selectContainer.addEventListener(MouseEvent.CLICK, this.onSelect);
        this.deleteButton.addEventListener(MouseEvent.CLICK, this.onDelete);
    }

    private function makeNewPetIcon(_arg1:int):void {
        if (_arg1 == 0) {
            this.newPetIcon = new ItemWithTooltip(this.samplePetIcons[int(this.samplePetIcons.length * Math.random())], 64, false, true);
            this.newPetIcon.filters = [TextureRedrawer.matrixFilter(0x363636)];
        } else
            this.newPetIcon = new ItemWithTooltip(_arg1, 64, false, true);
        this.newPetIcon.x = 328;
        addChild(this.newPetIcon);
    }

    private function makeTaglineText():void {
        super.makeTagline(
            new LineBuilder().setParams(TextKey.CURRENT_CHARACTER_TAGLINEEXP, {
            "experience": Parameters.addComma(this.char.xp())
        }));
        taglineExpText.x = (taglineExpText.x + tagLineExpIcon.width);
    }

    private function makeDeleteButton():void {
        this.deleteButton = new DeleteXGraphic();
        this.deleteButton.addEventListener(MouseEvent.MOUSE_DOWN, this.onDeleteDown);
        this.deleteButton.x = (WIDTH - 40);
        this.deleteButton.y = ((HEIGHT - this.deleteButton.height) * 0.5);
        addChild(this.deleteButton);
    }

    private function removeToolTip():void {
        this.hideTooltip.dispatch();
    }

    override protected function onMouseOver(_arg1:MouseEvent):void {
        super.onMouseOver(_arg1);
        this.removeToolTip();
    }

    override protected function onRollOut(_arg1:MouseEvent):void {
        super.onRollOut(_arg1);
        this.removeToolTip();
    }

    private function onSelect(_arg1:MouseEvent):void {
        this.selected.dispatch(this.char);
    }

    private function onDelete(_arg1:MouseEvent):void {
        this.deleteCharacter.dispatch(this.char);
    }

    private function onRemovedFromStage(_arg1:Event):void {
        this.removeToolTip();
    }

    private function onDeleteDown(_arg1:MouseEvent):void {
        _arg1.stopImmediatePropagation();
        dispatchEvent(new DeleteCharacterEvent(this.char));
    }


}
}
