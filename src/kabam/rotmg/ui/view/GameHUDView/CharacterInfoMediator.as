package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.objects.Player;

import flash.display.Sprite;
import flash.geom.Point;

import kabam.rotmg.ui.view.GameHUDView.GameUI.EquipmentSlot;
import kabam.rotmg.ui.view.GameHUDView.GameUI.RegularOption;

import org.osflash.signals.Signal;

public class CharacterInfoMediator extends Sprite {
    private static const UI_LABEL_SPACE:int = 24;

    private static const UI_EQUIPMENTS_AMULET_INDEX:int = 0;
    private static const UI_EQUIPMENTS_HELMET_INDEX:int = 1;
    private static const UI_EQUIPMENTS_WEAPON_INDEX:int = 2;
    private static const UI_EQUIPMENTS_ARMOR_INDEX:int = 3;
    private static const UI_EQUIPMENTS_SHIELD_INDEX:int = 4;
    private static const UI_EQUIPMENTS_RING_INDEX:int = 5;
    private static const UI_EQUIPMENTS_TROUSERS_INDEX:int = 6;
    private static const UI_EQUIPMENTS_BOOTS_INDEX:int = 7;

    private static const UI_EQUIPMENTS_OFFSET:Point = new Point(448, 0);
    private static const UI_EQUIPMENTS_SLOT_SIZE:int = 56;

    private static const UI_EQUIPMENTS_AMULET_POSITION:Point = new Point(UI_EQUIPMENTS_OFFSET.x, UI_EQUIPMENTS_OFFSET.y);
    private static const UI_EQUIPMENTS_HELMET_POSITION:Point = new Point(UI_EQUIPMENTS_AMULET_POSITION.x + UI_EQUIPMENTS_SLOT_SIZE, UI_EQUIPMENTS_AMULET_POSITION.y);
    private static const UI_EQUIPMENTS_WEAPON_POSITION:Point = new Point(UI_EQUIPMENTS_AMULET_POSITION.x, UI_EQUIPMENTS_HELMET_POSITION.y + UI_EQUIPMENTS_SLOT_SIZE);
    private static const UI_EQUIPMENTS_ARMOR_POSITION:Point = new Point(UI_EQUIPMENTS_HELMET_POSITION.x, UI_EQUIPMENTS_WEAPON_POSITION.y);
    private static const UI_EQUIPMENTS_SHIELD_POSITION:Point = new Point(UI_EQUIPMENTS_ARMOR_POSITION.x + UI_EQUIPMENTS_SLOT_SIZE, UI_EQUIPMENTS_WEAPON_POSITION.y);
    private static const UI_EQUIPMENTS_RING_POSITION:Point = new Point(UI_EQUIPMENTS_WEAPON_POSITION.x, UI_EQUIPMENTS_WEAPON_POSITION.y + UI_EQUIPMENTS_SLOT_SIZE);
    private static const UI_EQUIPMENTS_TROUSERS_POSITION:Point = new Point(UI_EQUIPMENTS_RING_POSITION.x + UI_EQUIPMENTS_SLOT_SIZE, UI_EQUIPMENTS_RING_POSITION.y);
    private static const UI_EQUIPMENTS_BOOTS_POSITION:Point = new Point(UI_EQUIPMENTS_TROUSERS_POSITION.x, UI_EQUIPMENTS_TROUSERS_POSITION.y + UI_EQUIPMENTS_SLOT_SIZE);

    private var hudView:HUDView;
    private var player:Player;
    private var ui_characterInfoMediatorStatsUpdateSignal:Signal;
    private var ui_characterInfoNameMediatorOption:RegularOption;
    private var ui_characterInfoLevelMediatorOption:RegularOption;
    private var ui_characterInfoExperienceMediatorOption:RegularOption;
    private var ui_characterInfoHealthPointsMediatorOption:RegularOption;
    private var ui_characterInfoMagicPointsMediatorOption:RegularOption;
    private var ui_characterInfoAttackLevelMediatorOption:RegularOption;
    private var ui_characterInfoDefenseLevelMediatorOption:RegularOption;
    private var ui_characterInfoSpeedMediatorOption:RegularOption;
    private var ui_characterInfoEquipmentsSlot:Vector.<EquipmentSlot>;

    public function CharacterInfoMediator(_hudView:HUDView) {
        this.hudView = _hudView;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();
    }

    public function setPlayer(player:Player):void {
        this.hudView.gameSprite.player = this.player = player;

        this.ui_characterInfoMediatorStatsUpdateSignal.dispatch();
    }

    private function drawUI():void {
        this.ui_characterInfoMediatorStatsUpdateSignal = new Signal();
        this.ui_characterInfoMediatorStatsUpdateSignal.addOnce(this.asyncEventsUI);

        this.ui_characterInfoNameMediatorOption = new RegularOption("Name", "\t\t--", new Point(0, 0), false);
        this.ui_characterInfoLevelMediatorOption = new RegularOption("LVL", "\t\t\t--", new Point(0, UI_LABEL_SPACE), false);
        this.ui_characterInfoExperienceMediatorOption = new RegularOption("EXP", "\t\t\t-- / <b>--</b>", new Point(0, UI_LABEL_SPACE * 2), false);
        this.ui_characterInfoHealthPointsMediatorOption = new RegularOption("HP", "\t\t\t-- / <b>--</b>", new Point(0, UI_LABEL_SPACE * 3), false);
        this.ui_characterInfoMagicPointsMediatorOption = new RegularOption("MP", "\t\t\t-- / <b>--</b>", new Point(0, UI_LABEL_SPACE * 4), false);
        this.ui_characterInfoAttackLevelMediatorOption = new RegularOption("ATT", "\t\t\t--", new Point(0, UI_LABEL_SPACE * 5), false);
        this.ui_characterInfoDefenseLevelMediatorOption = new RegularOption("DEF", "\t\t\t--", new Point(0, UI_LABEL_SPACE * 6), false);
        this.ui_characterInfoSpeedMediatorOption = new RegularOption("SPD", "\t\t\t--", new Point(0, UI_LABEL_SPACE * 7), false);

        this.ui_characterInfoEquipmentsSlot = new Vector.<EquipmentSlot>(8);

        for (var i:int = 0; i < 8; i++) {
            var _local1:EquipmentSlot = new EquipmentSlot();

            switch (i) {
                case UI_EQUIPMENTS_AMULET_INDEX: _local1.x = UI_EQUIPMENTS_AMULET_POSITION.x; _local1.y = UI_EQUIPMENTS_AMULET_POSITION.y; break;
                case UI_EQUIPMENTS_HELMET_INDEX: _local1.x = UI_EQUIPMENTS_HELMET_POSITION.x; _local1.y = UI_EQUIPMENTS_HELMET_POSITION.y; break;
                case UI_EQUIPMENTS_WEAPON_INDEX: _local1.x = UI_EQUIPMENTS_WEAPON_POSITION.x; _local1.y = UI_EQUIPMENTS_WEAPON_POSITION.y; break;
                case UI_EQUIPMENTS_ARMOR_INDEX: _local1.x = UI_EQUIPMENTS_ARMOR_POSITION.x; _local1.y = UI_EQUIPMENTS_ARMOR_POSITION.y; break;
                case UI_EQUIPMENTS_SHIELD_INDEX: _local1.x = UI_EQUIPMENTS_SHIELD_POSITION.x; _local1.y = UI_EQUIPMENTS_SHIELD_POSITION.y; break;
                case UI_EQUIPMENTS_RING_INDEX: _local1.x = UI_EQUIPMENTS_RING_POSITION.x; _local1.y = UI_EQUIPMENTS_RING_POSITION.y; break;
                case UI_EQUIPMENTS_TROUSERS_INDEX: _local1.x = UI_EQUIPMENTS_TROUSERS_POSITION.x; _local1.y = UI_EQUIPMENTS_TROUSERS_POSITION.y; break;
                case UI_EQUIPMENTS_BOOTS_INDEX: _local1.x = UI_EQUIPMENTS_BOOTS_POSITION.x; _local1.y = UI_EQUIPMENTS_BOOTS_POSITION.y; break;
            }

            this.ui_characterInfoEquipmentsSlot[i] = _local1;
        }
    }

    private function setUI():void { }

    private function outlineUI():void { }

    private function addUI():void {
        addChild(this.ui_characterInfoNameMediatorOption);
        addChild(this.ui_characterInfoLevelMediatorOption);
        addChild(this.ui_characterInfoExperienceMediatorOption);
        addChild(this.ui_characterInfoHealthPointsMediatorOption);
        addChild(this.ui_characterInfoMagicPointsMediatorOption);
        addChild(this.ui_characterInfoAttackLevelMediatorOption);
        addChild(this.ui_characterInfoDefenseLevelMediatorOption);
        addChild(this.ui_characterInfoSpeedMediatorOption);

        for each (var j:EquipmentSlot in this.ui_characterInfoEquipmentsSlot)
            addChild(j);
    }

    private function eventsUI():void { }

    private function asyncEventsUI():void {
        this.ui_characterInfoNameMediatorOption.setText("\t\t\t" + player.name_);
        this.ui_characterInfoLevelMediatorOption.setText("\t\t\t" + player.charLvl);
        this.ui_characterInfoExperienceMediatorOption.setText("\t\t\t" + player.charEXP + " / <b>" + player.charNextEXP + "</b>");
        this.ui_characterInfoHealthPointsMediatorOption.setText("\t\t\t" + player.charHP + " / <b>" + player.charMaxHP + "</b>");
        this.ui_characterInfoMagicPointsMediatorOption.setText("\t\t\t" + player.charMP + " / <b>" + player.charMaxMP + "</b>");
        this.ui_characterInfoAttackLevelMediatorOption.setText("\t\t\t" + player.charATTLvl);
        this.ui_characterInfoDefenseLevelMediatorOption.setText("\t\t\t" + player.charDEFLvl);
        this.ui_characterInfoSpeedMediatorOption.setText("\t\t\t" + player.charSPD);

        for (var k:int = 0; k < this.ui_characterInfoEquipmentsSlot.length; k++)
            this.ui_characterInfoEquipmentsSlot[k].draw(this.player.equipment_[k]);
    }
}
}
