package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.minimap.view.MiniMapImp;
import kabam.rotmg.ui.view.*;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUICharacterStats_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIHighscores_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIInventory_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUILogout_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIMinimapBackground_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUIOptionsToolBar_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.Assets.NewUISettings_shapeEmbed_;
import kabam.rotmg.ui.view.GameHUDView.GameUI.CharacterStatusGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.ConfirmLogoutGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.ConnectionGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.GameStatusGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.GameUIInterface;
import kabam.rotmg.ui.view.GameHUDView.GameUI.SettingsGameUI;

public class HUDView extends Sprite implements UnFocusAble, GameUIInterface {
    public static const WIDTH:int = 800;
    public static const HEIGHT:int = 600;
    public static const UI_FILTERS_BLACK_OUTLINE:GlowFilter = TextureRedrawer.OUTLINE_FILTER;
    public static const UI_FILTERS_GRAY_SHADES:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);

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
    private static const UI_OVERLAY_CONNECTION_MEDIATOR_POSITION:Point = new Point(UI_MINIMAP_POSITION.x, UI_MINIMAP_POSITION.y + UI_OVERLAY_MINIMAP_SIZE.y + UI_OVERLAY_ICON_SPACE_POSITION.y);
    private static const UI_OVERLAY_GAME_STATUS_MEDIATOR_POSITION:Point = new Point(UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.x, UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.y + UI_OVERLAY_ICON_SPACE_POSITION.x + UI_OVERLAY_ICON_SPACE_POSITION.y);
    private static const UI_OVERLAY_CHARACTER_STATUS_MEDIATOR_POSITION:Point = new Point(0, WebMain.STAGE.stageHeight / 2);

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

    // Game UIs
    //public var ui_characterStatusGameUI:CharacterStatusGameUI;
    public var ui_gameStatusGameUI:GameStatusGameUI;
    public var ui_connectionGameUI:ConnectionGameUI;
    public var ui_settingsGameUI:SettingsGameUI;

    public function HUDView(_gameSprite:GameSprite) {
        this.gameSprite = _gameSprite;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();
    }

    public function drawUI():void {
        this.ui_characterStatsIconSprite = new Sprite();

        this.ui_highscoresIconSprite = new Sprite();

        this.ui_inventoryIconSprite = new Sprite();

        this.ui_logoutIconSprite = new Sprite();

        this.ui_settingsIconSprite = new Sprite();

        this.ui_optionsToolBar = new Bitmap();
        this.ui_optionsToolBar.bitmapData = new NewUIOptionsToolBar_shapeEmbed_().bitmapData;

        this.ui_minimapBackground = new Bitmap();
        this.ui_minimapBackground.bitmapData = new NewUIMinimapBackground_shapeEmbed_().bitmapData;

        this.ui_minimap = new MiniMapImp(UI_OVERLAY_MINIMAP_SIZE.x, UI_OVERLAY_MINIMAP_SIZE.y);

        this.ui_characterStatsIcon = new Bitmap();
        this.ui_characterStatsIcon.bitmapData = new NewUICharacterStats_shapeEmbed_().bitmapData;

        this.ui_highscoresIcon = new Bitmap();
        this.ui_highscoresIcon.bitmapData = new NewUIHighscores_shapeEmbed_().bitmapData;

        this.ui_inventoryIcon = new Bitmap();
        this.ui_inventoryIcon.bitmapData = new NewUIInventory_shapeEmbed_().bitmapData;

        this.ui_logoutIcon = new Bitmap();
        this.ui_logoutIcon.bitmapData = new NewUILogout_shapeEmbed_().bitmapData;

        this.ui_settingsIcon = new Bitmap();
        this.ui_settingsIcon.bitmapData = new NewUISettings_shapeEmbed_().bitmapData;

        //this.ui_characterStatusGameUI = new CharacterStatusGameUI(this, this.gameSprite.player);
        //this.ui_characterStatusGameUI.visible = Parameters.data_.displayCharacterStatusMediator;

        this.ui_gameStatusGameUI = new GameStatusGameUI(this);
        this.ui_gameStatusGameUI.visible = Parameters.data_.displayGameStatusMediator;

        this.ui_connectionGameUI = new ConnectionGameUI(this);
        this.ui_connectionGameUI.visible = Parameters.data_.displayConnectionMediator;

        this.ui_settingsGameUI = new SettingsGameUI(this);
        this.ui_settingsGameUI.visible = false;
    }

    public function setUI():void {
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

        //this.ui_characterStatusGameUI.x = UI_OVERLAY_CHARACTER_STATUS_MEDIATOR_POSITION.x;
        //this.ui_characterStatusGameUI.y = UI_OVERLAY_CHARACTER_STATUS_MEDIATOR_POSITION.y;

        this.ui_gameStatusGameUI.x = UI_OVERLAY_GAME_STATUS_MEDIATOR_POSITION.x;
        this.ui_gameStatusGameUI.y = UI_OVERLAY_GAME_STATUS_MEDIATOR_POSITION.y;

        this.ui_connectionGameUI.x = UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.x;
        this.ui_connectionGameUI.y = UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.y;
    }

    public function addUI():void {
        this.ui_characterStatsIconSprite.addChild(this.ui_characterStatsIcon);

        this.ui_highscoresIconSprite.addChild(this.ui_highscoresIcon);

        this.ui_inventoryIconSprite.addChild(this.ui_inventoryIcon);

        this.ui_logoutIconSprite.addChild(this.ui_logoutIcon);

        this.ui_settingsIconSprite.addChild(this.ui_settingsIcon);

        //addChild(this.ui_characterStatusGameUI);
        addChild(this.ui_gameStatusGameUI);
        addChild(this.ui_connectionGameUI);
        addChild(this.ui_minimapBackground);
        addChild(this.ui_minimap);
        addChild(this.ui_optionsToolBar);
        addChild(this.ui_characterStatsIconSprite);
        addChild(this.ui_highscoresIconSprite);
        addChild(this.ui_inventoryIconSprite);
        addChild(this.ui_logoutIconSprite);
        addChild(this.ui_settingsIconSprite);
        addChild(this.ui_settingsGameUI);
    }

    public function outlineUI():void {
        this.ui_characterStatsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_highscoresIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_inventoryIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_logoutIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_settingsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];
    }

    public function eventsUI():void {
        this.ui_characterStatsIconSprite.addEventListener(MouseEvent.CLICK, this.displayCharacterStatsScreen);

        this.ui_highscoresIconSprite.addEventListener(MouseEvent.CLICK, this.displayHighscoresScreen);

        this.ui_inventoryIconSprite.addEventListener(MouseEvent.CLICK, this.displayInventoryScreen);

        this.ui_logoutIconSprite.addEventListener(MouseEvent.CLICK, this.doLogout);

        this.ui_settingsIconSprite.addEventListener(MouseEvent.CLICK, this.displaySettingsScreen);
    }

    private function displayCharacterStatsScreen(event:MouseEvent):void {
        debug("Button 'ui_characterStatsIcon' has been clicked.");
    }

    private function displayHighscoresScreen(event:MouseEvent):void {
        debug("Button 'ui_highscoresIcon' has been clicked.");
    }

    private function displayInventoryScreen(event:MouseEvent):void {
        debug("Button 'ui_inventoryIcon' has been clicked.");
    }

    private function doLogout(event:MouseEvent):void {
        debug("Button 'ui_logoutIcon' has been clicked.");

        addChild(new ConfirmLogoutGameUI(this.gameSprite));
    }

    public function updateConnectionGameUI(_arg1:Boolean):void {
        this.ui_connectionGameUI.visible = _arg1;

        Utils.connectionMediatorAction(_arg1);
    }

    public function updateGameStatusGameUI(_arg1:Boolean):void {
        this.ui_gameStatusGameUI.visible = _arg1;

        Utils.gameStatusMediatorAction(_arg1);
    }

    public function updateCharacterStatusGameUI(_arg1:Boolean):void {
        //this.ui_characterStatusGameUI.visible = _arg1;

        Utils.characterStatusMediatorAction(_arg1);
    }

    public function applyFilterOverlay(_arg1:Array):void {
        this.ui_minimapBackground.filters = _arg1;
        this.ui_minimap.filters = _arg1;
        this.ui_optionsToolBar.filters = _arg1;
        this.ui_characterStatsIconSprite.filters = _arg1;
        this.ui_highscoresIconSprite.filters = _arg1;
        this.ui_inventoryIconSprite.filters = _arg1;
        this.ui_settingsIconSprite.filters = _arg1;
        //this.ui_characterStatusGameUI.filters = _arg1;
    }

    public function disableContents():void {
        this.ui_minimap.mouseEnabled = false;
        this.ui_minimap.mouseChildren = false;

        this.ui_characterStatsIconSprite.mouseEnabled = false;
        this.ui_characterStatsIconSprite.mouseChildren = false;

        this.ui_highscoresIconSprite.mouseEnabled = false;
        this.ui_highscoresIconSprite.mouseChildren = false;

        this.ui_inventoryIconSprite.mouseEnabled = false;
        this.ui_inventoryIconSprite.mouseChildren = false;

        this.ui_settingsIconSprite.mouseEnabled = false;
        this.ui_settingsIconSprite.mouseChildren = false;

        //this.ui_characterStatusGameUI.mouseEnabled = false;
        //this.ui_characterStatusGameUI.mouseChildren = false;
    }

    public function enableContents():void {
        this.ui_minimap.mouseEnabled = true;
        this.ui_minimap.mouseChildren = true;

        this.ui_characterStatsIconSprite.mouseEnabled = true;
        this.ui_characterStatsIconSprite.mouseChildren = true;

        this.ui_highscoresIconSprite.mouseEnabled = true;
        this.ui_highscoresIconSprite.mouseChildren = true;

        this.ui_inventoryIconSprite.mouseEnabled = true;
        this.ui_inventoryIconSprite.mouseChildren = true;

        this.ui_settingsIconSprite.mouseEnabled = true;
        this.ui_settingsIconSprite.mouseChildren = true;

        //this.ui_characterStatusGameUI.mouseEnabled = true;
        //this.ui_characterStatusGameUI.mouseChildren = true;
    }

    private function displaySettingsScreen(event:MouseEvent):void {
        debug("Button 'ui_settingsIcon' has been clicked.");

        this.ui_settingsGameUI.visible = true;
    }

    public static function debug(_arg1:String):void {
        if (Parameters.IS_DEVELOPER_MODE) {
            var _local1:ChatMessage = new ChatMessage();
            _local1.name = Parameters.SERVER_CHAT_NAME;
            _local1.text = "[Developer Mode] " + _arg1;

            var _local2:AddTextLineSignal = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
            _local2.dispatch(_local1);
        }
    }

    public function destroy():void {
        this.ui_characterStatsIconSprite.removeEventListener(MouseEvent.CLICK, this.displayCharacterStatsScreen);

        this.ui_highscoresIconSprite.removeEventListener(MouseEvent.CLICK, this.displayHighscoresScreen);

        this.ui_inventoryIconSprite.removeEventListener(MouseEvent.CLICK, this.displayInventoryScreen);

        this.ui_logoutIconSprite.removeEventListener(MouseEvent.CLICK, this.doLogout);

        this.ui_settingsIconSprite.removeEventListener(MouseEvent.CLICK, this.displaySettingsScreen);

        //this.ui_characterStatusGameUI.destroy();

        this.ui_gameStatusGameUI.destroy();

        this.ui_connectionGameUI.destroy();

        this.ui_settingsGameUI.destroy();

        //removeChild(this.ui_characterStatusGameUI);
        removeChild(this.ui_gameStatusGameUI);
        removeChild(this.ui_connectionGameUI);
        removeChild(this.ui_minimapBackground);
        removeChild(this.ui_minimap);
        removeChild(this.ui_optionsToolBar);
        removeChild(this.ui_characterStatsIconSprite);
        removeChild(this.ui_highscoresIconSprite);
        removeChild(this.ui_inventoryIconSprite);
        removeChild(this.ui_logoutIconSprite);
        removeChild(this.ui_settingsIconSprite);
        removeChild(this.ui_settingsGameUI);
    }
}
}
