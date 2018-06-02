package kabam.rotmg.ui.view {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.panels.InteractPanel;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUICharacterStats_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIHighscores_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIInventory_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIMinimapBackground_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIOptionsToolBar_shapeEmbed_;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.minimap.view.MiniMapImp;

public class HUDView extends Sprite implements UnFocusAble {

    public var tabStrip:TabStripView;
    public var interactPanel:InteractPanel;

    /*
    * Game UI
    * Author: DV
    * */
    private static const UI_OVERLAY_POSITION:Point = new Point(0, 0);
    private static const UI_OVERLAY_ICON_SPACE:int = 36;
    private static const UI_OVERLAY_ICON_SPACE_POSITION:Point = new Point(12, 6);
    private static const UI_OVERLAY_MINIMAP_POSITION:Point = new Point(-4, 40);
    private static const UI_OVERLAY_MINIMAP_SIZE:Point = new Point(128, 128);
    private static const UI_OPTIONS_TOOL_BAR_POSITION:Point = new Point(UI_OVERLAY_POSITION.x, UI_OVERLAY_POSITION.y);
    private static const UI_MINIMAP_BACKGROUND_POSITION:Point = new Point(UI_OPTIONS_TOOL_BAR_POSITION.x + UI_OVERLAY_MINIMAP_POSITION.x, UI_OPTIONS_TOOL_BAR_POSITION.y + UI_OVERLAY_MINIMAP_POSITION.y);
    private static const UI_MINIMAP_POSITION:Point = new Point(UI_MINIMAP_BACKGROUND_POSITION.x + 12, UI_MINIMAP_BACKGROUND_POSITION.y + 12);
    private static const UI_CHARACTER_STATS_ICON_POSITION:Point = new Point(UI_OPTIONS_TOOL_BAR_POSITION.x + UI_OVERLAY_ICON_SPACE_POSITION.x, UI_OPTIONS_TOOL_BAR_POSITION.y + UI_OVERLAY_ICON_SPACE_POSITION.y);
    private static const UI_HIGHSCORES_ICON_POSITION:Point = new Point(UI_CHARACTER_STATS_ICON_POSITION.x + UI_OVERLAY_ICON_SPACE, UI_CHARACTER_STATS_ICON_POSITION.y);
    private static const UI_INVENTORY_ICON_POSITION:Point = new Point(UI_HIGHSCORES_ICON_POSITION.x + UI_OVERLAY_ICON_SPACE, UI_HIGHSCORES_ICON_POSITION.y);

    public var ui_optionsToolBar:Bitmap;
    public var ui_minimapBackground:Bitmap;
    public var ui_minimap:MiniMapImp;
    public var ui_characterStatsIcon:Bitmap;
    public var ui_highscoresIcon:Bitmap;
    public var ui_inventoryIcon:Bitmap;

    public function HUDView() {
        this.drawUI();
        this.setUI();
        this.addUI();
    }

    private function drawUI():void {
        this.ui_optionsToolBar = new Bitmap();
        this.ui_optionsToolBar.bitmapData = new EmbeddedAssets_LoENewUIOptionsToolBar_shapeEmbed_().bitmapData;

        this.ui_minimapBackground = new Bitmap();
        this.ui_minimapBackground.bitmapData = new EmbeddedAssets_LoENewUIMinimapBackground_shapeEmbed_().bitmapData;

        this.ui_minimap = new MiniMapImp(UI_OVERLAY_MINIMAP_SIZE.x, UI_OVERLAY_MINIMAP_SIZE.y);

        this.ui_characterStatsIcon = new Bitmap();
        this.ui_characterStatsIcon.bitmapData = new EmbeddedAssets_LoENewUICharacterStats_shapeEmbed_().bitmapData;

        this.ui_highscoresIcon = new Bitmap();
        this.ui_highscoresIcon.bitmapData = new EmbeddedAssets_LoENewUIHighscores_shapeEmbed_().bitmapData;

        this.ui_inventoryIcon = new Bitmap();
        this.ui_inventoryIcon.bitmapData = new EmbeddedAssets_LoENewUIInventory_shapeEmbed_().bitmapData;
    }

    private function setUI():void {
        this.ui_optionsToolBar.x = UI_OPTIONS_TOOL_BAR_POSITION.x;
        this.ui_optionsToolBar.y = UI_OPTIONS_TOOL_BAR_POSITION.y;

        this.ui_minimapBackground.x = UI_MINIMAP_BACKGROUND_POSITION.x;
        this.ui_minimapBackground.y = UI_MINIMAP_BACKGROUND_POSITION.y;

        this.ui_minimap.x = UI_MINIMAP_POSITION.x;
        this.ui_minimap.y = UI_MINIMAP_POSITION.y;

        this.ui_characterStatsIcon.x = UI_CHARACTER_STATS_ICON_POSITION.x;
        this.ui_characterStatsIcon.y = UI_CHARACTER_STATS_ICON_POSITION.y;

        this.ui_highscoresIcon.x = UI_HIGHSCORES_ICON_POSITION.x;
        this.ui_highscoresIcon.y = UI_HIGHSCORES_ICON_POSITION.y;

        this.ui_inventoryIcon.x = UI_INVENTORY_ICON_POSITION.x;
        this.ui_inventoryIcon.y = UI_INVENTORY_ICON_POSITION.y;
    }

    private function addUI():void {
        addChild(this.ui_optionsToolBar);
        addChild(this.ui_minimapBackground);
        addChild(this.ui_minimap);
        addChild(this.ui_characterStatsIcon);
        addChild(this.ui_highscoresIcon);
        addChild(this.ui_inventoryIcon);
        addChild(this.ui_characterStatsIcon);
        addChild(this.ui_highscoresIcon);
        addChild(this.ui_inventoryIcon);
    }

    public function setPlayerDependentAssets(_arg1:GameSprite):void { }

    public function setMiniMapFocus(object:GameObject):void {
        this.ui_minimap.setFocus(object);
    }

    public function draw():void { }

    public function startTrade(_arg1:AGameSprite, _arg2:TradeStart):void { }

    public function tradeDone():void { }

    public function tradeChanged(_arg1:TradeChanged):void { }

    public function tradeAccepted(_arg1:TradeAccepted):void { }
}
}
