package kabam.rotmg.ui.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUICharacterStats_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIHighscores_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIInventory_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUILogout_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIMinimapBackground_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUIOptionsToolBar_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_LoENewUISettings_shapeEmbed_;
import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.minimap.view.MiniMapImp;

public class HUDView extends Sprite implements UnFocusAble {
    private var gameSprite:GameSprite;

    public var interactPanel:InteractPanel;

    /*
    * Game UI
    * Author: DV
    * */
    private static const UI_ICON_SIZE:int = 24;
    private static const UI_STAGE_WIDTH:int = 800;
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
    private static const UI_LOGOUT_ICON_POSITION:Point = new Point(UI_STAGE_WIDTH - UI_ICON_SIZE - UI_OVERLAY_ICON_SPACE_POSITION.x, UI_INVENTORY_ICON_POSITION.y);
    private static const UI_SETTINGS_ICON_POSITION:Point = new Point(UI_LOGOUT_ICON_POSITION.x - 2 * UI_ICON_SIZE, UI_LOGOUT_ICON_POSITION.y);

    private var ui_optionsToolBar:Bitmap;
    private var ui_minimapBackground:Bitmap;
    private var ui_minimap:MiniMapImp;
    private var ui_characterStatsIcon:Bitmap;
    private var ui_highscoresIcon:Bitmap;
    private var ui_inventoryIcon:Bitmap;
    private var ui_logoutIcon:Bitmap;
    private var ui_settingsIcon:Bitmap;
    private var ui_characterStatsIconSprite:Sprite;
    private var ui_highscoresIconSprite:Sprite;
    private var ui_inventoryIconSprite:Sprite;
    private var ui_logoutIconSprite:Sprite;
    private var ui_settingsIconSprite:Sprite;

    public function HUDView(_arg1:GameSprite) {
        this.gameSprite = _arg1;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();
    }

    private function drawUI():void {
        this.ui_characterStatsIconSprite = new Sprite();

        this.ui_highscoresIconSprite = new Sprite();

        this.ui_inventoryIconSprite = new Sprite();

        this.ui_logoutIconSprite = new Sprite();

        this.ui_settingsIconSprite = new Sprite();

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

        this.ui_logoutIcon = new Bitmap();
        this.ui_logoutIcon.bitmapData = new EmbeddedAssets_LoENewUILogout_shapeEmbed_().bitmapData;

        this.ui_settingsIcon = new Bitmap();
        this.ui_settingsIcon.bitmapData = new EmbeddedAssets_LoENewUISettings_shapeEmbed_().bitmapData;
    }

    private function setUI():void {
        this.ui_characterStatsIconSprite.x = UI_CHARACTER_STATS_ICON_POSITION.x;
        this.ui_characterStatsIconSprite.y = UI_CHARACTER_STATS_ICON_POSITION.y;

        this.ui_highscoresIconSprite.x = UI_HIGHSCORES_ICON_POSITION.x;
        this.ui_highscoresIconSprite.y = UI_HIGHSCORES_ICON_POSITION.y;

        this.ui_inventoryIconSprite.x = UI_INVENTORY_ICON_POSITION.x;
        this.ui_inventoryIconSprite.y = UI_INVENTORY_ICON_POSITION.y;

        this.ui_logoutIconSprite.x = UI_LOGOUT_ICON_POSITION.x;
        this.ui_logoutIconSprite.y = UI_LOGOUT_ICON_POSITION.y;

        this.ui_settingsIconSprite.x = UI_SETTINGS_ICON_POSITION.x;
        this.ui_settingsIconSprite.y = UI_SETTINGS_ICON_POSITION.y;

        this.ui_optionsToolBar.x = UI_OPTIONS_TOOL_BAR_POSITION.x;
        this.ui_optionsToolBar.y = UI_OPTIONS_TOOL_BAR_POSITION.y;

        this.ui_minimapBackground.x = UI_MINIMAP_BACKGROUND_POSITION.x;
        this.ui_minimapBackground.y = UI_MINIMAP_BACKGROUND_POSITION.y;

        this.ui_minimap.x = UI_MINIMAP_POSITION.x;
        this.ui_minimap.y = UI_MINIMAP_POSITION.y;
    }

    private function addUI():void {
        this.ui_characterStatsIconSprite.addChild(this.ui_characterStatsIcon);

        this.ui_highscoresIconSprite.addChild(this.ui_highscoresIcon);

        this.ui_inventoryIconSprite.addChild(this.ui_inventoryIcon);

        this.ui_logoutIconSprite.addChild(this.ui_logoutIcon);

        this.ui_settingsIconSprite.addChild(this.ui_settingsIcon);

        addChild(this.ui_minimapBackground);
        addChild(this.ui_minimap);
        addChild(this.ui_optionsToolBar);
        addChild(this.ui_characterStatsIconSprite);
        addChild(this.ui_highscoresIconSprite);
        addChild(this.ui_inventoryIconSprite);
        addChild(this.ui_logoutIconSprite);
        addChild(this.ui_settingsIconSprite);
    }

    private function outlineUI():void {
        this.ui_characterStatsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_highscoresIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_inventoryIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_logoutIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_settingsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];
    }

    private function eventsUI():void {
        this.ui_characterStatsIconSprite.addEventListener(MouseEvent.CLICK, this.displayCharacterStatsScreen);

        this.ui_highscoresIconSprite.addEventListener(MouseEvent.CLICK, this.displayHighscoresScreen);

        this.ui_inventoryIconSprite.addEventListener(MouseEvent.CLICK, this.displayInventoryScreen);

        this.ui_logoutIconSprite.addEventListener(MouseEvent.CLICK, this.doLogout);

        this.ui_settingsIconSprite.addEventListener(MouseEvent.CLICK, this.displaySettingsScreen);
    }

    private function displayCharacterStatsScreen(event:MouseEvent):void {
        debug("Button 'ui_characterStatsIcon' has been clicked.");

        // TODO: implement screen.
    }

    private function displayHighscoresScreen(event:MouseEvent):void {
        debug("Button 'ui_highscoresIcon' has been clicked.");

        // TODO: implement screen.
    }

    private function displayInventoryScreen(event:MouseEvent):void {
        debug("Button 'ui_inventoryIcon' has been clicked.");

        // TODO: implement screen.
    }

    private function doLogout(event:MouseEvent):void {
        debug("Button 'ui_logoutIcon' has been clicked.");

        /*stage.focus = null;
        parent.removeChild(this);
        this.gameSprite.closed.dispatch();*/
    }

    private function displaySettingsScreen(event:MouseEvent):void {
        debug("Button 'ui_settingsIcon' has been clicked.");

        // TODO: implement screen.
    }

    private static function debug(_arg1:String):void {
        var _local1:ChatMessage = new ChatMessage();
        _local1.name = Parameters.SERVER_CHAT_NAME;
        _local1.text = _arg1;

        var _local2:AddTextLineSignal = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
        _local2.dispatch(_local1);
    }
}
}
