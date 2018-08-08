package kabam.rotmg.ui.view.GameHUDView.GameUI {
import com.company.assembleegameclient.objects.Player;

import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextFieldAutoSize;

import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.GameHUDView.*;

public class CharacterInfoGameUI extends GameUIScreen {
    private static const UI_CHARACTER_INFO_POSITION:Point = new Point(32, 64);

    private var ui_characterInfoMediator:CharacterInfoMediator;

    private var ui_characterInfoGameUIBackgroundOverlay_:Shape;
    private var ui_characterInfoGameUITitle_:TextFieldDisplayConcrete;
    private var ui_characterInfoGameUICloseButton_:DialogCloseButton;

    public function CharacterInfoGameUI(_hudView:HUDView) {
        this.ui_characterInfoGameUIBackgroundOverlay_ = new Shape();

        this.ui_characterInfoGameUITitle_ = new TextFieldDisplayConcrete().setSize(18).setColor(0xFFFFFF);
        this.ui_characterInfoGameUITitle_.setTextWidth(800);
        this.ui_characterInfoGameUITitle_.setBold(true);
        this.ui_characterInfoGameUITitle_.setAutoSize(TextFieldAutoSize.CENTER);
        this.ui_characterInfoGameUITitle_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.ui_characterInfoGameUITitle_.setStringBuilder(new LineBuilder().setParams("Character Info"));

        this.ui_characterInfoGameUICloseButton_ = PetsViewAssetFactory.returnCloseButton(800 - 56);

        super(_hudView);
    }

    public function setPlayer(player:Player):void {
        this.ui_characterInfoMediator.setPlayer(player);
    }

    override public function drawUI():void {
        var _local1:Graphics = this.ui_characterInfoGameUIBackgroundOverlay_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.9);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();

        this.ui_characterInfoMediator = new CharacterInfoMediator(this.hudView);
    }

    override public function setUI():void {
        this.ui_characterInfoGameUITitle_.y = 8;

        this.ui_characterInfoGameUICloseButton_.x = 800 - this.ui_characterInfoGameUICloseButton_.width - 4;
        this.ui_characterInfoGameUICloseButton_.y = 4;

        this.ui_characterInfoMediator.x = UI_CHARACTER_INFO_POSITION.x;
        this.ui_characterInfoMediator.y = UI_CHARACTER_INFO_POSITION.y;
    }

    override public function addUI():void {
        addChild(this.ui_characterInfoGameUIBackgroundOverlay_);
        addChild(this.ui_characterInfoGameUITitle_);
        addChild(this.ui_characterInfoGameUICloseButton_);
        addChild(this.ui_characterInfoMediator);
    }

    override public function eventsUI():void {
        this.ui_characterInfoGameUICloseButton_.addEventListener(MouseEvent.CLICK, this.onClose);
    }

    private function onClose(event:MouseEvent):void {
        this.hudView.ui_characterInfoGameUI.visible = false;

        dispatchEvent(new Event(Event.COMPLETE));
    }

    override public function destroy():void {
        this.ui_characterInfoGameUICloseButton_.removeEventListener(MouseEvent.CLICK, this.onClose);

        removeChild(this.ui_characterInfoGameUIBackgroundOverlay_);
        removeChild(this.ui_characterInfoGameUITitle_);
        removeChild(this.ui_characterInfoGameUICloseButton_);
        removeChild(this.ui_characterInfoMediator);
    }
}
}
