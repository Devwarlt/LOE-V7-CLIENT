package kabam.rotmg.ui.view.GameHUDView {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.BaseSimpleText;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import kabam.rotmg.chat.model.ChatMessage;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.minimap.view.MiniMapImp;
import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.ui.view.*;
import kabam.rotmg.ui.view.GameHUDView.GameUI.ConfirmLogoutGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.ConnectionGameUI;
import kabam.rotmg.ui.view.GameHUDView.GameUI.GameUIInterface;

import org.osflash.signals.Signal;

public class HUDView extends Sprite implements UnFocusAble, GameUIInterface {
    public static const UI_FILTERS_BLACK_OUTLINE:GlowFilter = TextureRedrawer.OUTLINE_FILTER;

    public static function debug(_arg1:String):void {
        if (Parameters.IS_DEVELOPER_MODE) {
            var _local1:ChatMessage = new ChatMessage();
            _local1.name = Parameters.SERVER_CHAT_NAME;
            _local1.text = "[Developer Mode] " + _arg1;

            var _local2:AddTextLineSignal = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
            _local2.dispatch(_local1);
        }
    }

    public function HUDView(gameSprite:GameSprite) {
        this.gameSprite = gameSprite;

        this.drawUI();
        this.setUI();
        this.outlineUI();
        this.addUI();
        this.eventsUI();

        this.logoutSignal.add(this.setLogout);

        this.gameSprite.sendPlayerData.addOnce(this.setPlayer);
    }
    public var player:Player;

    /*
    * Game UI
    * Author: DV
    * */

    // Game UIs
    public var gameSprite:GameSprite;
    public var interactPanel:InteractPanel;
    /*public var ui_characterInfoGameUI:CharacterInfoGameUI;
    public var ui_settingsGameUI:SettingsGameUI;
    public var ui_characterStatusGameUI:CharacterStatusGameUI;
    public var ui_gameStatusGameUI:GameStatusGameUI;
    public var ui_connectionGameUI:ConnectionGameUI;*/
    public var logoutSignal:Signal = new Signal(Boolean); // done
    // LoE V3 theme
    private var ui:Sprite; // done
    private var minimap:MiniMapImp; // done
    private var ping:ConnectionGameUI; // done
    private var vocation:Bitmap; // done
    private var tools:*; // todo: display tools icon (later)
    //--
    private var logout:DialogCloseButton; // done
    private var logoutEnabled:Boolean = true; // done

    public function drawUI():void {
        this.ui = new Sprite();

        var topBar:Shape = new Shape();

        var topBarGraphics:Graphics = topBar.graphics;
        topBarGraphics.clear();
        topBarGraphics.beginFill(0x0F1B3B, 1);
        topBarGraphics.drawRect(0, 0, 800, 24);
        topBarGraphics.endFill();

        topBar.filters = [UI_FILTERS_BLACK_OUTLINE];
        topBar.x = topBar.y = 0;

        var minimapBackground:Shape = new Shape();

        var minimapBackgroundGraphics:Graphics = minimapBackground.graphics;
        minimapBackgroundGraphics.clear();
        minimapBackgroundGraphics.beginFill(0x0F1B3B, 1);
        minimapBackgroundGraphics.drawRect(0, 0, 104, 104);
        minimapBackgroundGraphics.endFill();

        minimapBackground.filters = [UI_FILTERS_BLACK_OUTLINE];
        minimapBackground.x = 16;
        minimapBackground.y = 64;

        this.ui.addChild(topBar);
        this.ui.addChild(minimapBackground);

        this.minimap = new MiniMapImp(96, 96);

        this.ping = new ConnectionGameUI(this);

        this.vocation = new Bitmap();

        this.logout = PetsViewAssetFactory.returnCloseButton(800);

        //--

        /*this.ui_characterStatsIconSprite = new Sprite();

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

        this.ui_characterStatusGameUI = new CharacterStatusGameUI(this);
        this.ui_characterStatusGameUI.visible = Parameters.data_.displayCharacterStatusMediator;

        this.ui_gameStatusGameUI = new GameStatusGameUI(this);
        this.ui_gameStatusGameUI.visible = Parameters.data_.displayGameStatusMediator;

        this.ui_connectionGameUI = new ConnectionGameUI(this);
        this.ui_connectionGameUI.visible = Parameters.data_.displayConnectionMediator;

        this.ui_settingsGameUI = new SettingsGameUI(this);
        this.ui_settingsGameUI.visible = false;

        this.ui_characterInfoGameUI = new CharacterInfoGameUI(this);
        this.ui_characterInfoGameUI.visible = false;*/
    }

    public function setUI():void {
        this.minimap.x = 20;
        this.minimap.y = 68;

        this.ping.x = 4;
        this.ping.y = 4;

        this.vocation.x = 4;
        this.vocation.y = 24;

        this.logout.y = 0;

        /*this.ui_characterStatsIconSprite.x = UI_CHARACTER_STATS_ICON_POSITION.x;
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

        this.ui_characterStatusGameUI.x = UI_OVERLAY_CHARACTER_STATUS_MEDIATOR_POSITION.x;
        this.ui_characterStatusGameUI.y = UI_OVERLAY_CHARACTER_STATUS_MEDIATOR_POSITION.y;

        this.ui_gameStatusGameUI.x = UI_OVERLAY_GAME_STATUS_MEDIATOR_POSITION.x;
        this.ui_gameStatusGameUI.y = UI_OVERLAY_GAME_STATUS_MEDIATOR_POSITION.y;

        this.ui_connectionGameUI.x = UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.x;
        this.ui_connectionGameUI.y = UI_OVERLAY_CONNECTION_MEDIATOR_POSITION.y;*/
    }

    public function outlineUI():void {
        /*this.ui_characterStatsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_highscoresIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_inventoryIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_logoutIcon.filters = [TextureRedrawer.OUTLINE_FILTER];

        this.ui_settingsIcon.filters = [TextureRedrawer.OUTLINE_FILTER];*/
    }

    public function addUI():void {
        addChild(this.ui);
        addChild(this.minimap);
        addChild(this.ping);
        addChild(this.vocation);
        addChild(this.logout);

        /*this.ui_characterStatsIconSprite.addChild(this.ui_characterStatsIcon);

        this.ui_highscoresIconSprite.addChild(this.ui_highscoresIcon);

        this.ui_inventoryIconSprite.addChild(this.ui_inventoryIcon);

        this.ui_logoutIconSprite.addChild(this.ui_logoutIcon);

        this.ui_settingsIconSprite.addChild(this.ui_settingsIcon);*/

        /*addChild(this.ui_characterStatusGameUI);
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
        addChild(this.ui_characterInfoGameUI);*/
    }

    public function eventsUI():void {
        this.logout.addEventListener(MouseEvent.CLICK, this.doLogout);

        /*this.ui_characterStatsIconSprite.addEventListener(MouseEvent.CLICK, this.displayCharacterStatsScreen);

        this.ui_highscoresIconSprite.addEventListener(MouseEvent.CLICK, this.displayHighscoresScreen);

        this.ui_inventoryIconSprite.addEventListener(MouseEvent.CLICK, this.displayInventoryScreen);

        this.ui_logoutIconSprite.addEventListener(MouseEvent.CLICK, this.doLogout);

        this.ui_settingsIconSprite.addEventListener(MouseEvent.CLICK, this.displaySettingsScreen);*/
    }

    public function InitializePing():void {
        this.ping.initializePing();
    }

    public function SetInvalidPing():void {
        this.ping.setInvalidPing();
    }

    public function updateConnectionGameUI(_arg1:Boolean):void {
        /*this.ui_connectionGameUI.visible = _arg1;

        Utils.connectionMediatorAction(_arg1);*/
    }

    public function updateGameStatusGameUI(_arg1:Boolean):void {
        /*this.ui_gameStatusGameUI.visible = _arg1;

        Utils.gameStatusMediatorAction(_arg1);*/
    }

    public function updateCharacterStatusGameUI(_arg1:Boolean):void {
        /*this.ui_characterStatusGameUI.visible = _arg1;

        Utils.characterStatusMediatorAction(_arg1);*/
    }

    public function applyFilterOverlay(_arg1:Array):void {
        this.ui.filters = _arg1;
        this.minimap.filters = _arg1;

        /*this.ui_minimapBackground.filters = _arg1;
        this.ui_minimap.filters = _arg1;
        this.ui_optionsToolBar.filters = _arg1;
        this.ui_characterStatsIconSprite.filters = _arg1;
        this.ui_highscoresIconSprite.filters = _arg1;
        this.ui_inventoryIconSprite.filters = _arg1;
        this.ui_settingsIconSprite.filters = _arg1;
        this.ui_characterStatusGameUI.filters = _arg1;*/
    }

    public function disableContents():void {
        this.minimap.mouseEnabled = false;
        this.minimap.mouseChildren = false;

        /*this.ui_minimap.mouseEnabled = false;
        this.ui_minimap.mouseChildren = false;

        this.ui_characterStatsIconSprite.mouseEnabled = false;
        this.ui_characterStatsIconSprite.mouseChildren = false;

        this.ui_highscoresIconSprite.mouseEnabled = false;
        this.ui_highscoresIconSprite.mouseChildren = false;

        this.ui_inventoryIconSprite.mouseEnabled = false;
        this.ui_inventoryIconSprite.mouseChildren = false;

        this.ui_settingsIconSprite.mouseEnabled = false;
        this.ui_settingsIconSprite.mouseChildren = false;

        this.ui_characterStatusGameUI.mouseEnabled = false;
        this.ui_characterStatusGameUI.mouseChildren = false;*/
    }

    public function enableContents():void {
        this.minimap.mouseEnabled = true;
        this.minimap.mouseChildren = true;

        /*this.ui_minimap.mouseEnabled = true;
        this.ui_minimap.mouseChildren = true;

        this.ui_characterStatsIconSprite.mouseEnabled = true;
        this.ui_characterStatsIconSprite.mouseChildren = true;

        this.ui_highscoresIconSprite.mouseEnabled = true;
        this.ui_highscoresIconSprite.mouseChildren = true;

        this.ui_inventoryIconSprite.mouseEnabled = true;
        this.ui_inventoryIconSprite.mouseChildren = true;

        this.ui_settingsIconSprite.mouseEnabled = true;
        this.ui_settingsIconSprite.mouseChildren = true;

        this.ui_characterStatusGameUI.mouseEnabled = true;
        this.ui_characterStatusGameUI.mouseChildren = true;*/
    }

    public function destroy():void {
        this.ping.destroy();

        this.logout.removeEventListener(MouseEvent.CLICK, this.doLogout);

        removeChild(this.ui);
        removeChild(this.minimap);
        removeChild(this.ping);
        removeChild(this.vocation);
        removeChild(this.logout);

        this.logoutSignal.remove(this.setLogout);

        this.gameSprite.sendPlayerData.remove(this.setPlayer);

        /*this.ui_characterStatsIconSprite.removeEventListener(MouseEvent.CLICK, this.displayCharacterStatsScreen);

        this.ui_highscoresIconSprite.removeEventListener(MouseEvent.CLICK, this.displayHighscoresScreen);

        this.ui_inventoryIconSprite.removeEventListener(MouseEvent.CLICK, this.displayInventoryScreen);

        this.ui_logoutIconSprite.removeEventListener(MouseEvent.CLICK, this.doLogout);

        this.ui_settingsIconSprite.removeEventListener(MouseEvent.CLICK, this.displaySettingsScreen);*/

        /*this.ui_characterStatusGameUI.destroy();

        this.ui_gameStatusGameUI.destroy();

        this.ui_connectionGameUI.destroy();

        this.ui_settingsGameUI.destroy();

        this.ui_characterInfoGameUI.destroy();*/

        /*removeChild(this.ui_characterStatusGameUI);
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
        removeChild(this.ui_characterInfoGameUI);*/
    }

    private function setLogout(logOut:Boolean):void {
        this.logoutEnabled = logOut;
    }

    private function setPlayer(player:Player):void {
        this.gameSprite.player = this.player = player;

        var nickname:BaseSimpleText = new BaseSimpleText(18, 0x94AEFE, false, 128, 0);
        nickname.selectable = false;
        nickname.border = false;
        nickname.mouseEnabled = true;
        nickname.htmlText = "<b>" + this.player.name_ + "</b>";
        nickname.useTextDimensions();
        nickname.filters = [UI_FILTERS_BLACK_OUTLINE];
        nickname.x = 40;
        nickname.y = 36;

        if (!this.ui.contains(nickname))
            this.ui.addChild(nickname);

        this.vocation.bitmapData = this.player.getPortrait();

        /*this.ui_characterStatusGameUI.setPlayer(player);

        this.ui_characterInfoGameUI.setPlayer(player);*/
    }

    private function displayCharacterStatsScreen(event:MouseEvent):void {
        /*debug("Button 'ui_characterStatsIcon' has been clicked.");

        this.ui_characterInfoGameUI.visible = true;*/
    }

    private function displayHighscoresScreen(event:MouseEvent):void {
        //debug("Button 'ui_highscoresIcon' has been clicked.");
    }

    private function displayInventoryScreen(event:MouseEvent):void {
        //debug("Button 'ui_inventoryIcon' has been clicked.");
    }

    private function displaySettingsScreen(event:MouseEvent):void {
        /*debug("Button 'ui_settingsIcon' has been clicked.");

        this.ui_settingsGameUI.visible = true;*/
    }

    private function doLogout(event:MouseEvent):void {
        debug("Button 'ui_logoutIcon' has been clicked.");

        if (this.logoutEnabled)
            addChild(new ConfirmLogoutGameUI(this));
    }
}
}
