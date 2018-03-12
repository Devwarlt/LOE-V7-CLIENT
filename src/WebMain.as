package {
import com.adobe.crypto.SHA256;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.AssetLoader;
import com.company.assembleegameclient.util.StageProxy;

import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import kabam.lib.net.NetConfig;
import kabam.rotmg.account.AccountConfig;
import kabam.rotmg.appengine.AppEngineConfig;
import kabam.rotmg.application.ApplicationConfig;
import kabam.rotmg.application.ApplicationSpecificConfig;
import kabam.rotmg.application.EnvironmentConfig;
import kabam.rotmg.arena.ArenaConfig;
import kabam.rotmg.assets.AssetsConfig;
import kabam.rotmg.build.BuildConfig;
import kabam.rotmg.build.impl.BuildEnvironments;
import kabam.rotmg.characters.CharactersConfig;
import kabam.rotmg.classes.ClassesConfig;
import kabam.rotmg.core.CoreConfig;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dailyLogin.config.DailyLoginConfig;
import kabam.rotmg.death.DeathConfig;
import kabam.rotmg.dialogs.DialogsConfig;
import kabam.rotmg.editor.EditorConfig;
import kabam.rotmg.errors.ErrorConfig;
import kabam.rotmg.external.ExternalConfig;
import kabam.rotmg.fame.FameConfig;
import kabam.rotmg.fortune.FortuneConfig;
import kabam.rotmg.friends.FriendConfig;
import kabam.rotmg.game.GameConfig;
import kabam.rotmg.language.LanguageConfig;
import kabam.rotmg.legends.LegendsConfig;
import kabam.rotmg.maploading.MapLoadingConfig;
import kabam.rotmg.minimap.MiniMapConfig;
import kabam.rotmg.mysterybox.MysteryBoxConfig;
import kabam.rotmg.news.NewsConfig;
import kabam.rotmg.packages.PackageConfig;
import kabam.rotmg.pets.PetsConfig;
import kabam.rotmg.promotions.PromotionsConfig;
import kabam.rotmg.protip.ProTipConfig;
import kabam.rotmg.questrewards.QuestRewardsConfig;
import kabam.rotmg.queue.QueueConfig;
import kabam.rotmg.servers.ServersConfig;
import kabam.rotmg.stage3D.Stage3DConfig;
import kabam.rotmg.startup.StartupConfig;
import kabam.rotmg.startup.control.StartupSignal;
import kabam.rotmg.text.TextConfig;
import kabam.rotmg.text.model.FontModel;
import kabam.rotmg.tooltips.TooltipsConfig;
import kabam.rotmg.ui.UIConfig;
import kabam.rotmg.ui.UIUtils;

import robotlegs.bender.bundles.mvcs.MVCSBundle;
import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.LogLevel;

import starling.utils.Color;

[SWF(frameRate="60", backgroundColor="#000000", width="800", height="600")]
public class WebMain extends Sprite {

    public static const USER_PREFERENCES:SharedObject = SharedObject.getLocal("LOE_V6_CLIENT_PREFERENCES", "/");

    public static var ENVIRONMENT:String;
    public static var STAGE:Stage;

    protected var context:IContext;

    public function WebMain() {
        //MonsterDebugger.initialize(this);
        if (stage) {
            this.dispatchSetup();
        }
        else {
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        }
    }

    private function dispatchSetup():void {
        if (Parameters.IS_PRODUCTION)
            if (!validateEnvironment(Capabilities.playerType)) {
                NotDesktop();
                return;
            }

        this.setup();
    }

    private function onAddedToStage(_arg1:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.dispatchSetup();
    }

    private function setup():void {
        this.setEnvironment();
        this.hackParameters();
        this.createContext();
        new AssetLoader().load();
        stage.scaleMode = StageScaleMode.EXACT_FIT;
        this.context.injector.getInstance(StartupSignal).dispatch();
        this.configureForAirIfDesktopPlayer();
        STAGE = stage;
        UIUtils.toggleQuality(Parameters.data_.uiQuality);
    }

    private function setEnvironment():void {
        //ENVIRONMENT = stage.loaderInfo.parameters["env"];
        //if (!Parameters.IS_PRODUCTION)
        ENVIRONMENT = Parameters.ENVIRONMENT_VARIABLE;
        //else {
        //    if (ENVIRONMENT != null && (ENVIRONMENT == BuildEnvironments.LOESOFTPRODUCTION || ENVIRONMENT == BuildEnvironments.LOESOFTTESTING))
        //        ENVIRONMENT = stage.loaderInfo.parameters["env"];
        //    else
        //        ENVIRONMENT = null;
        //}
    }

    private function hackParameters():void {
        Parameters.root = stage.root;
    }

    private function createContext():void {
        this.context = new StaticInjectorContext();
        this.context.injector.map(LoaderInfo).toValue(root.stage.root.loaderInfo);
        var _local1:StageProxy = new StageProxy(this);
        this.context.injector.map(StageProxy).toValue(_local1);
        this.context
                .extend(MVCSBundle)
                .extend(SignalCommandMapExtension)
                .configure(BuildConfig)
                .configure(StartupConfig)
                .configure(NetConfig)
                .configure(DialogsConfig)
                .configure(EnvironmentConfig)
                .configure(ApplicationConfig)
                .configure(LanguageConfig)
                .configure(TextConfig)
                .configure(AppEngineConfig)
                .configure(AccountConfig)
                .configure(ErrorConfig)
                .configure(CoreConfig)
                .configure(ApplicationSpecificConfig)
                .configure(AssetsConfig)
                .configure(DeathConfig)
                .configure(CharactersConfig)
                .configure(ServersConfig)
                .configure(GameConfig)
                .configure(EditorConfig)
                .configure(UIConfig)
                .configure(MiniMapConfig)
                .configure(LegendsConfig)
                .configure(NewsConfig)
                .configure(FameConfig)
                .configure(TooltipsConfig)
                .configure(PromotionsConfig)
                .configure(ProTipConfig)
                .configure(MapLoadingConfig)
                .configure(ClassesConfig)
                .configure(PackageConfig)
                .configure(PetsConfig)
                .configure(QuestRewardsConfig)
                .configure(DailyLoginConfig)
                .configure(Stage3DConfig)
                .configure(ArenaConfig)
                .configure(ExternalConfig)
                .configure(MysteryBoxConfig)
                .configure(FortuneConfig)
                .configure(FriendConfig)
                .configure(QueueConfig)
                .configure(this);
        this.context.logLevel = LogLevel.DEBUG;
    }

    private function configureForAirIfDesktopPlayer():void {
        if (Capabilities.playerType == "Desktop") {
            Parameters.data_.fullscreenMode = false;
            Parameters.save();
        }
    }

    private function NotDesktop():void {
        var _local0:FontModel = new FontModel();
        var _local1:TextFormat = new TextFormat();
        var _local2:TextField = new TextField();
        var _local3:TextFormat = new TextFormat();
        var _local4:TextField = new TextField();
        _local1.size = 24;
        _local1.color = Color.RED;
        _local1.font = _local0.getFont().getName();
        _local3.size = 18;
        _local3.color = Color.WHITE;
        _local3.align = TextAlign.JUSTIFY;
        _local3.font = _local0.getFont().getName();
        _local2.selectable = false;
        _local2.defaultTextFormat = _local1;
        _local2.htmlText = "<b>Game is not responding!</b>";
        _local2.width = 792;
        _local2.x = 4;
        _local2.y = 4;
        _local4.selectable = false;
        _local4.defaultTextFormat = _local3;
        _local4.htmlText = "<b>Official Notification</b>" +
                "\nOn 3rd Mar 2018, the LoESoft Games updated game client to version 1.6.5 (v6-1.6.5 edition1: pre-beta), " +
                "and unfortunately Flash Projector and Web Game Client have been disabled and not supported anymore. Since " +
                "announcement from Adobe about Flash will be discontinued, we migrated our whole game engine to <b>Adobe AIR</b>, " +
                "which allow us to bring way better game contents and visual for your game-play experience." +
                "\n\nSorry for inconvenience." +
                "\n\nKind regards, The Staff." +
                "\nYour <b>LoESoft Games</b>" +
                "\n<img width='48px' height='48px' src='http://loesoft-games.github.io/loesoft.png' />\n\n" +
                "\n\n<font color='#FFFF00'><b><i>How to avoid this screen?</i></b></font>" +
                "\n\t<font color='#FFFF00'><b>Option 1.</b></font>\tDownload <b>Adobe AIR</b>, click <b><a href='https://get.adobe.com/air/'><font color='#FF6347'>here</font></a></b>." +
                "\n\t<font color='#FFFF00'><b>Option 2.</b></font>\tDo not run game using your browser, as instead run installer of LoE Realm client or run shortcut of program (commonly located at your desktop environment)." +
                "\n\t<font color='#FFFF00'><b>Option 3.</b></font>\tDo not run game using your <b>Adobe Flash Projector</b>, our game engine only support <b>Adobe AIR</b> and it already contains all framework settings able to run game client properly with good performance.";
        _local4.wordWrap = true;
        _local4.width = 792;
        _local4.height = 520;
        _local4.x = 4;
        _local4.y = 80;
        addChild(_local2);
        addChild(_local4);
    }

    private static const KEY_A:String = "9bd88f2485acbb";
    private static const KEY_B:String = "9426ad3dd9e068";
    private static const KEY_C:String = "42ede8c7516d0b";
    private static const KEY_D:String = "a8559298675f09";
    private static const KEY_E:String = "419681fa";

    private static function validateEnvironment(param1:String):Boolean { return getHash(param1) == TOKEN; }

    private static const TOKEN:String = KEY_A + KEY_B + KEY_C + KEY_D + KEY_E;

    private static function getHash(param1:String):String { return SHA256.hash(param1); }
}
}
