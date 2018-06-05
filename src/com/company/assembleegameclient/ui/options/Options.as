package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.util.AssetLibrary;
import com.company.util.KeyCodes;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.navigateToURL;
import flash.system.Capabilities;
import flash.text.TextFieldAutoSize;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

import kabam.rotmg.game.view.components.StatView;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;
import kabam.rotmg.ui.UIUtils;

public class Options extends Sprite {

    private static const TABS:Vector.<String> = new <String>[TextKey.OPTIONS_CONTROLS, TextKey.OPTIONS_HOTKEYS, TextKey.OPTIONS_CHAT, TextKey.OPTIONS_GRAPHICS, TextKey.OPTIONS_SOUND, TextKey.OPTIONS_MISC];
    public static const Y_POSITION:int = 550;
    public static const CHAT_COMMAND:String = "chatCommand";
    public static const CHAT:String = "chat";
    public static const TELL:String = "tell";
    public static const GUILD_CHAT:String = "guildChat";
    public static const SCROLL_CHAT_UP:String = "scrollChatUp";
    public static const SCROLL_CHAT_DOWN:String = "scrollChatDown";

    private var gs_:GameSprite;
    private var continueButton_:TitleMenuOption;
    private var resetToDefaultsButton_:TitleMenuOption;
    private var homeButton_:TitleMenuOption;
    private var tabs_:Vector.<OptionsTabTitle>;
    private var selected_:OptionsTabTitle = null;
    private var options_:Vector.<Sprite>;

    public function Options(_arg1:GameSprite) {
        var _local2:TextFieldDisplayConcrete;
        var _local5:int;
        var _local6:OptionsTabTitle;
        this.tabs_ = new Vector.<OptionsTabTitle>();
        this.options_ = new Vector.<Sprite>();
        super();
        this.gs_ = _arg1;
        graphics.clear();
        graphics.beginFill(0x2B2B2B, 0.8);
        graphics.drawRect(0, 0, 800, 600);
        graphics.endFill();
        graphics.lineStyle(1, 0x5E5E5E);
        graphics.moveTo(0, 100);
        graphics.lineTo(800, 100);
        graphics.lineStyle();
        _local2 = new TextFieldDisplayConcrete().setSize(36).setColor(0xFFFFFF);
        _local2.setBold(true);
        _local2.setStringBuilder(new LineBuilder().setParams(TextKey.OPTIONS_TITLE));
        _local2.setAutoSize(TextFieldAutoSize.CENTER);
        _local2.filters = [new DropShadowFilter(0, 0, 0)];
        _local2.x = ((800 / 2) - (_local2.width / 2));
        _local2.y = 8;
        addChild(_local2);
        addChild(new ScreenGraphic());
        this.continueButton_ = new TitleMenuOption(TextKey.OPTIONS_CONTINUE_BUTTON, 36, false);
        this.continueButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.continueButton_.setAutoSize(TextFieldAutoSize.CENTER);
        this.continueButton_.addEventListener(MouseEvent.CLICK, this.onContinueClick);
        addChild(this.continueButton_);
        this.resetToDefaultsButton_ = new TitleMenuOption(TextKey.OPTIONS_RESET_TO_DEFAULTS_BUTTON, 22, false);
        this.resetToDefaultsButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.resetToDefaultsButton_.setAutoSize(TextFieldAutoSize.LEFT);
        this.resetToDefaultsButton_.addEventListener(MouseEvent.CLICK, this.onResetToDefaultsClick);
        addChild(this.resetToDefaultsButton_);
        this.homeButton_ = new TitleMenuOption(TextKey.OPTIONS_HOME_BUTTON, 22, false);
        this.homeButton_.setVerticalAlign(TextFieldDisplayConcrete.MIDDLE);
        this.homeButton_.setAutoSize(TextFieldAutoSize.RIGHT);
        this.homeButton_.addEventListener(MouseEvent.CLICK, this.onHomeClick);
        addChild(this.homeButton_);
        var _local3:int = 14;
        var _local4:int;
        while (_local4 < TABS.length) {
            _local6 = new OptionsTabTitle(TABS[_local4]);
            _local6.x = _local3;
            _local6.y = 70;
            addChild(_local6);
            _local6.addEventListener(MouseEvent.CLICK, this.onTabClick);
            this.tabs_.push(_local6);
            _local3 = (_local3 + ((UIUtils.SHOW_EXPERIMENTAL_MENU) ? 90 : 108));
            _local4++;
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private static function makePotionBuy():ChoiceOption {
        return (new ChoiceOption("contextualPotionBuy", makeOnOffLabels(), [true, false], TextKey.OPTIONS_CONTEXTUAL_POTION_BUY, TextKey.OPTIONS_CONTEXTUAL_POTION_BUY_DESC, null));
    }

    private static function makeOnOffLabels():Vector.<StringBuilder> {
        return (new <StringBuilder>[makeLineBuilder(TextKey.OPTIONS_ON), makeLineBuilder(TextKey.OPTIONS_OFF)]);
    }

    private static function makeHighLowLabels():Vector.<StringBuilder> {
        return (new <StringBuilder>[new StaticStringBuilder("High"), new StaticStringBuilder("Low")]);
    }

    private static function makeStarSelectLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[
            new StaticStringBuilder("Off"),
            new StaticStringBuilder("1"),
            new StaticStringBuilder("2"),
            new StaticStringBuilder("3"),
            new StaticStringBuilder("5"),
            new StaticStringBuilder("10")
        ];
    }

    private static function makeCursorSelectLabels():Vector.<StringBuilder> {
        return new <StringBuilder>[
            new StaticStringBuilder("Off"),         // "auto": default
            new StaticStringBuilder("ProX"),        // 0
            new StaticStringBuilder("X2"),          // 1
            new StaticStringBuilder("X3"),          // 2
            new StaticStringBuilder("X4"),          // 3
            new StaticStringBuilder("Corner1"),     // 4
            new StaticStringBuilder("Corner2"),     // 5
            new StaticStringBuilder("Symb"),        // 6
            new StaticStringBuilder("Alien"),       // 7
            new StaticStringBuilder("Xhair"),       // 8
            new StaticStringBuilder("Chvzto1"),     // 9
            new StaticStringBuilder("Chvzto2")      // 10
        ];
    }

    private static function makeLineBuilder(_arg1:String):LineBuilder {
        return (new LineBuilder().setParams(_arg1));
    }

    private static function makeClickForGold():ChoiceOption {
        return (new ChoiceOption("clickForGold", makeOnOffLabels(), [true, false], TextKey.OPTIONS_CLICK_FOR_GOLD, TextKey.OPTIONS_CLICK_FOR_GOLD_DESC, null));
    }

    private static function onUIQualityToggle():void {
        UIUtils.toggleQuality(Parameters.data_.uiQuality);
    }

    private static function onBarTextToggle():void {
        StatusBar.barTextSignal.dispatch(Parameters.data_.toggleBarText);
    }

    private static function onToMaxTextToggle():void {
        StatusBar.barTextSignal.dispatch(Parameters.data_.toggleBarText);
        StatView.toMaxTextSignal.dispatch(Parameters.data_.toggleToMaxText);
    }

    public static var currentCursor:int = Parameters.data_.cursorSelect == MouseCursor.AUTO ? -1 : int(Parameters.data_.cursorSelect);
    private static var cursors:Array = [MouseCursor.AUTO, "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];

    private static function saveCursor(cursor:String):void {
        Parameters.data_.cursorSelect = cursor;
        Parameters.save();
    }

    public static function refreshCursor(loading:Boolean = false):void {
        var cursorSelect:String = Parameters.data_.cursorSelect;

        if (!loading) {
            if (currentCursor >= cursors.length - 2)
                currentCursor = -1;
            else
                currentCursor++;
        }

        if (currentCursor != -1) {
            var cursorData:MouseCursorData = new MouseCursorData();
            cursorData.hotSpot = new Point(15, 15);

            var data:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
            data[0] = AssetLibrary.getImageFromSet("cursorsEmbed", currentCursor);

            cursorData.data = data;

            Mouse.registerCursor(cursorSelect, cursorData);

            saveCursor(currentCursor.toString());
        } else {
            cursorSelect = MouseCursor.AUTO;

            Mouse.unregisterCursor(cursorSelect);

            saveCursor(cursorSelect);
        }

        Mouse.cursor = cursorSelect;
    }

    private static function makeDegreeOptions():Vector.<StringBuilder> {
        return (new <StringBuilder>[new StaticStringBuilder("45°"), new StaticStringBuilder("0°")]);
    }

    private static function onDefaultCameraAngleChange():void {
        Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
        Parameters.save();
    }


    private function onContinueClick(_arg1:MouseEvent):void {
        this.close();
    }

    private function onResetToDefaultsClick(_arg1:MouseEvent):void {
        var _local3:BaseOption;
        var _local2:int;
        while (_local2 < this.options_.length) {
            _local3 = (this.options_[_local2] as BaseOption);
            if (_local3 != null) {
                delete Parameters.data_[_local3.paramName_];
            }
            _local2++;
        }
        Parameters.setDefaults();
        Parameters.save();
        this.refresh();
    }

    private function onHomeClick(_arg1:MouseEvent):void {
        this.close();
        this.gs_.closed.dispatch();
    }

    private function onTabClick(_arg1:MouseEvent):void {
        var _local2:OptionsTabTitle = (_arg1.currentTarget as OptionsTabTitle);
        this.setSelected(_local2);
    }

    private function setSelected(_arg1:OptionsTabTitle):void {
        if (_arg1 == this.selected_) {
            return;
        }
        if (this.selected_ != null) {
            this.selected_.setSelected(false);
        }
        this.selected_ = _arg1;
        this.selected_.setSelected(true);
        this.removeOptions();
        switch (this.selected_.text_) {
            case TextKey.OPTIONS_CONTROLS:
                this.addControlsOptions();
                return;
            case TextKey.OPTIONS_HOTKEYS:
                this.addHotKeysOptions();
                return;
            case TextKey.OPTIONS_CHAT:
                this.addChatOptions();
                return;
            case TextKey.OPTIONS_GRAPHICS:
                this.addGraphicsOptions();
                return;
            case TextKey.OPTIONS_SOUND:
                this.addSoundOptions();
                return;
            case TextKey.OPTIONS_MISC:
                this.addMiscOptions();
                return;
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        this.continueButton_.x = (stage.stageWidth / 2);
        this.continueButton_.y = Y_POSITION;
        this.resetToDefaultsButton_.x = 20;
        this.resetToDefaultsButton_.y = Y_POSITION;
        this.homeButton_.x = (stage.stageWidth - 20);
        this.homeButton_.y = Y_POSITION;
        if (Capabilities.playerType == "Desktop") {
            Parameters.data_.fullscreenMode = (stage.displayState == "fullScreenInteractive");
            Parameters.save();
        }
        this.setSelected(this.tabs_[0]);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, 1);
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 1);
    }

    private function onRemovedFromStage(_arg1:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false);
    }

    private function onKeyDown(_arg1:KeyboardEvent):void {
        _arg1.stopImmediatePropagation();
    }

    private function close():void {
        stage.focus = null;
        parent.removeChild(this);
    }

    private function onKeyUp(_arg1:KeyboardEvent):void {
        _arg1.stopImmediatePropagation();
    }

    private function removeOptions():void {
        var _local1:Sprite;
        for each (_local1 in this.options_) {
            removeChild(_local1);
        }
        this.options_.length = 0;
    }

    private function addControlsOptions():void {
        this.addOptionAndPosition(new KeyMapper("moveUp", TextKey.OPTIONS_MOVE_UP, TextKey.OPTIONS_MOVE_UP_DESC));
        this.addOptionAndPosition(new KeyMapper("moveLeft", TextKey.OPTIONS_MOVE_LEFT, TextKey.OPTIONS_MOVE_LEFT_DESC));
        this.addOptionAndPosition(new KeyMapper("moveDown", TextKey.OPTIONS_MOVE_DOWN, TextKey.OPTIONS_MOVE_DOWN_DESC));
        this.addOptionAndPosition(new KeyMapper("moveRight", TextKey.OPTIONS_MOVE_RIGHT, TextKey.OPTIONS_MOVE_RIGHT_DESC));
        this.addOptionAndPosition(new KeyMapper("togglePerformanceStats", TextKey.OPTIONS_TOGGLE_PERFORMANCE_STATS, TextKey.OPTIONS_TOGGLE_PERFORMANCE_STATS_DESC));
    }

    private function addHotKeysOptions():void {
        this.addOptionAndPosition(new KeyMapper("options", TextKey.OPTIONS_SHOW_OPTIONS, TextKey.OPTIONS_SHOW_OPTIONS_DESC));
        this.addOptionAndPosition(new KeyMapper("GPURenderToggle", TextKey.OPTIONS_HARDWARE_ACC_HOTKEY_TITLE, TextKey.OPTIONS_HARDWARE_ACC_HOTKEY_DESC));
    }

    private function addChatOptions():void {
        this.addOptionAndPosition(new KeyMapper(CHAT, TextKey.OPTIONS_ACTIVATE_CHAT, TextKey.OPTIONS_ACTIVATE_CHAT_DESC));
        this.addOptionAndPosition(new KeyMapper(CHAT_COMMAND, TextKey.OPTIONS_START_CHAT, TextKey.OPTIONS_START_CHAT_DESC));
        this.addOptionAndPosition(new KeyMapper(TELL, TextKey.OPTIONS_BEGIN_TELL, TextKey.OPTIONS_BEGIN_TELL_DESC));
        this.addOptionAndPosition(new KeyMapper(GUILD_CHAT, TextKey.OPTIONS_BEGIN_GUILD_CHAT, TextKey.OPTIONS_BEGIN_GUILD_CHAT_DESC));
        this.addOptionAndPosition(new ChoiceOption("filterLanguage", makeOnOffLabels(), [true, false], TextKey.OPTIONS_FILTER_OFFENSIVE_LANGUAGE, TextKey.OPTIONS_FILTER_OFFENSIVE_LANGUAGE_DESC, null));
        this.addOptionAndPosition(new KeyMapper(SCROLL_CHAT_UP, TextKey.OPTIONS_SCROLL_CHAT_UP, TextKey.OPTIONS_SCROLL_CHAT_UP_DESC));
        this.addOptionAndPosition(new KeyMapper(SCROLL_CHAT_DOWN, TextKey.OPTIONS_SCROLL_CHAT_DOWN, TextKey.OPTIONS_SCROLL_CHAT_DOWN_DESC));
        this.addOptionAndPosition(new ChoiceOption("forceChatQuality", makeOnOffLabels(), [true, false], TextKey.OPTIONS_FORCE_CHAT_QUALITY, TextKey.OPTIONS_FORCE_CHAT_QUALITY_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("hidePlayerChat", makeOnOffLabels(), [true, false], TextKey.OPTIONS_HIDE_PLAYER_CHAT, TextKey.OPTIONS_HIDE_PLAYER_CHAT_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("chatAll", makeOnOffLabels(), [true, false], TextKey.OPTIONS_CHAT_ALL, TextKey.OPTIONS_CHAT_ALL_DESC, this.onAllChatEnabled));
        this.addOptionAndPosition(new ChoiceOption("chatWhisper", makeOnOffLabels(), [true, false], TextKey.OPTIONS_CHAT_WHISPER, TextKey.OPTIONS_CHAT_WHISPER_DESC, this.onAllChatDisabled));
        this.addOptionAndPosition(new ChoiceOption("chatGuild", makeOnOffLabels(), [true, false], TextKey.OPTIONS_CHAT_GUILD, TextKey.OPTIONS_CHAT_GUILD_DESC, this.onAllChatDisabled));
    }

    private function onAllChatDisabled():void {
        var _local2:ChoiceOption;
        Parameters.data_.chatAll = false;
        var _local1:int;
        while (_local1 < this.options_.length) {
            _local2 = (this.options_[_local1] as ChoiceOption);
            if (_local2 != null) {
                switch (_local2.paramName_) {
                    case "chatAll":
                        _local2.refreshNoCallback();
                        break;
                }
            }
            _local1++;
        }
    }

    private function onAllChatEnabled():void {
        var _local2:ChoiceOption;
        Parameters.data_.hidePlayerChat = false;
        Parameters.data_.chatWhisper = true;
        Parameters.data_.chatGuild = true;
        Parameters.data_.chatFriend = false;
        var _local1:int;
        while (_local1 < this.options_.length) {
            _local2 = (this.options_[_local1] as ChoiceOption);
            if (_local2 != null) {
                switch (_local2.paramName_) {
                    case "hidePlayerChat":
                    case "chatWhisper":
                    case "chatGuild":
                    case "chatFriend":
                        _local2.refreshNoCallback();
                        break;
                }
            }
            _local1++;
        }
    }

    private function addGraphicsOptions():void {
        var _local1:String;
        var _local2:Number;
        this.addOptionAndPosition(new ChoiceOption("drawShadows", makeOnOffLabels(), [true, false], TextKey.OPTIONS_DRAW_SHADOWS, TextKey.OPTIONS_DRAW_SHADOWS_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("textBubbles", makeOnOffLabels(), [true, false], TextKey.OPTIONS_DRAW_TEXT_BUBBLES, TextKey.OPTIONS_DRAW_TEXT_BUBBLES_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("showGuildInvitePopup", makeOnOffLabels(), [true, false], TextKey.OPTIONS_SHOW_GUILD_INVITE_PANEL, TextKey.OPTIONS_SHOW_GUILD_INVITE_PANEL_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("cursorSelect", makeCursorSelectLabels(), cursors, "Custom Cursor", "Click here to change the mouse cursor. May help with aiming.", refreshCursor));
        if (!Parameters.GPURenderError) {
            _local1 = TextKey.OPTIONS_HARDWARE_ACC_DESC;
            _local2 = 0xFFFFFF;
        }
        else {
            _local1 = TextKey.OPTIONS_HARDWARE_ACC_DESC_ERROR;
            _local2 = 16724787;
        }
        this.addOptionAndPosition(new ChoiceOption("GPURender", makeOnOffLabels(), [true, false], TextKey.OPTIONS_HARDWARE_ACC_TITLE, _local1, null, _local2));
        this.addOptionAndPosition(new ChoiceOption("particleEffect", makeHighLowLabels(), [true, false], TextKey.OPTIONS_TOGGLE_PARTICLE_EFFECT, TextKey.OPTIONS_TOGGLE_PARTICLE_EFFECT_DESC, null));
        this.addOptionAndPosition(new ChoiceOption("uiQuality", makeHighLowLabels(), [true, false], TextKey.OPTIONS_TOGGLE_UI_QUALITY, TextKey.OPTIONS_TOGGLE_UI_QUALITY_DESC, onUIQualityToggle));
        this.addOptionAndPosition(new ChoiceOption("HPBar", makeOnOffLabels(), [true, false], TextKey.OPTIONS_HPBAR, TextKey.OPTIONS_HPBAR_DESC, null));
    }

    private function addSoundOptions():void {
        this.addOptionAndPosition(new ChoiceOption("playMusic", makeOnOffLabels(), [true, false], TextKey.OPTIONS_PLAY_MUSIC, TextKey.OPTIONS_PLAY_MUSIC_DESC, this.onPlayMusicChange));
        this.addOptionAndPosition(new SliderOption("musicVolume", this.onMusicVolumeChange), -120, 15);
        this.addOptionAndPosition(new ChoiceOption("playSFX", makeOnOffLabels(), [true, false], TextKey.OPTIONS_PLAY_SOUND_EFFECTS, TextKey.OPTIONS_PLAY_SOUND_EFFECTS_DESC, this.onPlaySoundEffectsChange));
        this.addOptionAndPosition(new SliderOption("SFXVolume", this.onSoundEffectsVolumeChange), -120, 34);
        this.addOptionAndPosition(new ChoiceOption("playPewPew", makeOnOffLabels(), [true, false], TextKey.OPTIONS_PLAY_WEAPON_SOUNDS, TextKey.OPTIONS_PLAY_WEAPON_SOUNDS_DESC, null));
    }

    private function addMiscOptions():void {
        this.addOptionAndPosition(new ChoiceOption("showProtips", new <StringBuilder>[makeLineBuilder(TextKey.DISCORD_INVITE_LINK_LABEL), makeLineBuilder(TextKey.DISCORD_INVITE_LINK_LABEL)], [Parameters.data_.showProtips, Parameters.data_.showProtips], TextKey.DISCORD_INVITE_LINK_TITLE, TextKey.DISCORD_INVITE_LINK_TITLE_DESC, this.onJoinDiscordClick));
    }

    private function onJoinDiscordClick():void {
        var _local1:URLRequest = new URLRequest();
        _local1.url = Parameters.DISCORD_PERMANENTLY_INVITE;
        _local1.method = URLRequestMethod.GET;
        navigateToURL(_local1, "_blank");
    }

    private function onPlayMusicChange():void {
        Music.setPlayMusic(Parameters.data_.playMusic);
        this.refresh();
    }

    private function onPlaySoundEffectsChange():void {
        SFX.setPlaySFX(Parameters.data_.playSFX);
        if (((Parameters.data_.playSFX) || (Parameters.data_.playPewPew))) {
            SFX.setSFXVolume(1);
        }
        else {
            SFX.setSFXVolume(0);
        }
        this.refresh();
    }

    private function onMusicVolumeChange(_arg1:Number):void {
        Music.setMusicVolume(_arg1);
    }

    private function onSoundEffectsVolumeChange(_arg1:Number):void {
        SFX.setSFXVolume(_arg1);
    }

    private function onLegalPrivacyClick():void {
        var _local1:URLRequest = new URLRequest();
        _local1.url = Parameters.PRIVACY_POLICY_URL;
        _local1.method = URLRequestMethod.GET;
        navigateToURL(_local1, "_blank");
    }

    private function onLegalTOSClick():void {
        var _local1:URLRequest = new URLRequest();
        _local1.url = Parameters.TERMS_OF_USE_URL;
        _local1.method = URLRequestMethod.GET;
        navigateToURL(_local1, "_blank");
    }

    private function addOptionAndPosition(option:Option, offsetX:Number = 0, offsetY:Number = 0):void {
        var positionOption:Function;
        positionOption = function ():void {
            option.x = (((((options_.length % 2) == 0)) ? 20 : 415) + offsetX);
            option.y = (((int((options_.length / 2)) * 44) + 122) + offsetY);
        };
        option.textChanged.addOnce(positionOption);
        this.addOption(option);
    }

    private function addOption(_arg1:Option):void {
        addChild(_arg1);
        _arg1.addEventListener(Event.CHANGE, this.onChange);
        this.options_.push(_arg1);
    }

    private function onChange(_arg1:Event):void {
        this.refresh();
    }

    private function refresh():void {
        var _local2:BaseOption;
        var _local1:int;
        while (_local1 < this.options_.length) {
            _local2 = (this.options_[_local1] as BaseOption);
            if (_local2 != null) {
                _local2.refresh();
            }
            _local1++;
        }
    }


}
}
