package kabam.rotmg.ui.view {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.NewCharacterScreen;

import kabam.rotmg.account.securityQuestions.data.SecurityQuestionsModel;
import kabam.rotmg.account.securityQuestions.view.SecurityQuestionsInfoDialog;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.BuyCharacterPendingSignal;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import kabam.rotmg.core.signals.PurchaseCharacterSignal;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.core.signals.UpdateNewCharacterScreenSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.game.signals.PlayGameSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class NewCharacterMediator extends Mediator {

    [Inject]
    public var view:NewCharacterScreen;
    [Inject]
    public var playerModel:PlayerModel;
    [Inject]
    public var setScreen:SetScreenSignal;
    [Inject]
    public var playGame:PlayGameSignal;
    [Inject]
    public var showTooltip:ShowTooltipSignal;
    [Inject]
    public var hideTooltips:HideTooltipsSignal;
    [Inject]
    public var updateNewCharacterScreen:UpdateNewCharacterScreenSignal;
    [Inject]
    public var buyCharacterPending:BuyCharacterPendingSignal;
    [Inject]
    public var purchaseCharacter:PurchaseCharacterSignal;
    [Inject]
    public var classesModel:ClassesModel;
    [Inject]
    public var openDialog:OpenDialogSignal;
    [Inject]
    public var securityQuestionsModel:SecurityQuestionsModel;
    [Inject]
    public var play:PlayGameSignal;


    override public function initialize():void {
        this.view.selected.add(this.onSelected);
        this.view.initialize(Parameters.APPRENTICE);
        if (this.securityQuestionsModel.showSecurityQuestionsOnStartup) {
            this.openDialog.dispatch(new SecurityQuestionsInfoDialog());
        }
    }

    override public function destroy():void {
        this.view.selected.remove(this.onSelected);
    }

    private function onSelected(_arg1:int):void {
        var _local1:GameInitData = new GameInitData();
        _local1.createCharacter = true;
        _local1.charId = this.playerModel.getNextCharId();
        _local1.keyTime = -1;
        _local1.isNewGame = true;
        this.play.dispatch(_local1);
        this.classesModel.getCharacterClass(_arg1).setIsSelected(true);
    }

}
}
