package {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
import com.company.assembleegameclient.util.AssetLoader;
import com.company.assembleegameclient.util.StageProxy;

import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.net.SharedObject;
import flash.system.Capabilities;
import flash.system.Security;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import kabam.lib.net.NetConfig;
import kabam.rotmg.account.web.WebAccountConfig;
import kabam.rotmg.appengine.AppEngineConfig;
import kabam.rotmg.application.ApplicationConfig;
import kabam.rotmg.application.ApplicationSpecificConfig;
import kabam.rotmg.application.EnvironmentConfig;
import kabam.rotmg.arena.ArenaConfig;
import kabam.rotmg.assets.AssetsConfig;
import kabam.rotmg.build.BuildConfig;
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

    [Inject]
    public var playerType:String;
    [Inject]
    private var gameStage:Stage;

    public static const USER_PREFERENCES:SharedObject = SharedObject.getLocal("LOE_V7_CLIENT_PREFERENCES", "/");

    public static var ENVIRONMENT:String;
    public static var STAGE:Stage;

    protected var context:IContext;

    public function WebMain() {
        if (stage)
            this.dispatchSetup();
        else
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    private function dispatchSetup():void {
        this.setup();
    }

    private function onAddedToStage(_arg1:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.dispatchSetup();
    }

    private function setup():void {
        STAGE = stage;
        ENVIRONMENT = Parameters.ENVIRONMENT_VARIABLE;
        Parameters.root = STAGE.root;
        this.configureCapabilities();
    }

    private function continueConfiguration():void {
        this.createContext();
        new AssetLoader().load();
        stage.scaleMode = StageScaleMode.EXACT_FIT;
        this.context.injector.getInstance(StartupSignal).dispatch();
        UIUtils.toggleQuality(Parameters.data_.uiQuality);
    }

    private function createContext():void {
        this.context = new StaticInjectorContext(this);
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
            .configure(WebAccountConfig)
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

    // "ActiveX" for the Flash Player ActiveX control used by Microsoft Internet Explorer.
    public const ActiveX_:String = "ActiveX";

    // "Desktop" for the Adobe AIR runtime (except for SWF content loaded by an HTML page, which has Capabilities.playerType set to "PlugIn").
    public const Desktop_:String = "Desktop";

    // "External" for the external Flash Player or in test mode.
    public const External_:String = "External";

    // "PlugIn" for the Flash Player browser plug-in (and for SWF content loaded by an HTML page in an AIR application).
    public const PlugIn_:String = "PlugIn";

    // "StandAlone" for the stand-alone Flash Player.
    public const StandAlone_:String = "StandAlone";

    private function configureCapabilities():void {
        this.playerType = Capabilities.playerType;

        this.gameStage = STAGE;

        switch (this.playerType) {
            case PlugIn_:
            case ActiveX_:
                this.configureBrowser();
                break;
            case Desktop_:
                this.continueConfiguration();
                break;
            case External_:
            case StandAlone_:
            default:
                this.notSupportedPlayerType(this.playerType);
                return;
        }
    }

    private function configureBrowser():void {
        var _local1:String = this.gameStage.loaderInfo.url;

        try
        {
            Security.allowDomain(_local1);
            this.continueConfiguration();
        }
        catch (error:Error) {
            this.onConnectionFailed("Access denied to the following domain: '" + _local1 + "', due sandbox violation issue.");
            trace(error.getStackTrace());
        }
    }

    private function notSupportedPlayerType(playerType:String):void {
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
        _local2.htmlText = "<b>Game is not responding!</b>\nYou are trying to run an invalid player type.";
        _local2.width = 792;
        _local2.x = 4;
        _local2.y = 4;
        _local4.selectable = false;
        _local4.defaultTextFormat = _local3;
        _local4.htmlText =
            "<b>Official Notification</b>" +
            "\nOn 3rd Mar 2018, the LoESoft Games updated game client, " +
            "and unfortunately player type <b>" + playerType + "</b> has been disabled and not supported anymore. Since " +
            "announcement from Adobe about Flash will be discontinued, we migrated our whole game engine to <b>Adobe AIR</b>, " +
            "which allow us to bring way better game contents and visual for your game-play experience." +
            "\n\nSorry for inconvenience." +
            "\n\nKind regards, The Staff." +
            "\nYour <b>LoESoft Games</b>" +
            "\n<img width='48px' height='48px' src='http://loesoft-games.github.io/loesoft.png' />\n\n" +
            "\n\n<font color='#FFFF00'><b><i>How to avoid this screen?</i></b></font>" +
            "\n\t<font color='#FFFF00'><b>Option 1.</b></font>\tDownload <b>Adobe AIR</b>, click <b><a href='https://get.adobe.com/air/' target='_blank'><font color='#FF6347'>here</font></a></b> (direct link <b>https://get.adobe.com/air/</b>)." +
            "\n\t<font color='#FFFF00'><b>Option 2.</b></font>\tGame could be run via browser, click <b><a href='https://loesoft-games.github.io/play' target='_blank'><font color='#FF6347'>here</font></a></b> to play (direct link <b>https://loesoft-games.github.io/play</b>)." +
            "\n\t<font color='#FFFF00'><b>Option 3.</b></font>\tDo not run game using your <b>Adobe Flash Projector</b>, our game engine support only <b>Adobe AIR</b> and browser invocation, it already contains all framework settings able to run properly with good performance.";
        _local4.wordWrap = true;
        _local4.width = 792;
        _local4.height = 520;
        _local4.x = 4;
        _local4.y = 80;
        addChild(_local2);
        addChild(_local4);
    }

    private function onConnectionFailed(_arg1:String):void {
        var _local1:ErrorDialog = new ErrorDialog(_arg1);
        addChild(_local1);
    }
}
}
