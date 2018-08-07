package com.company.assembleegameclient.game {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;
import com.company.util.KeyCodes;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.constants.UseType;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.view.Layers;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.game.signals.GiftStatusUpdateSignal;
import kabam.rotmg.game.signals.SetTextBoxVisibilitySignal;
import kabam.rotmg.game.signals.UseBuyPotionSignal;
import kabam.rotmg.game.view.components.StatsTabHotKeyInputSignal;
import kabam.rotmg.minimap.control.MiniMapZoomSignal;
import kabam.rotmg.pets.controller.reskin.ReskinPetFlowStartSignal;
import kabam.rotmg.ui.UIUtils;
import kabam.rotmg.ui.model.TabStripModel;

import net.hires.debug.Stats;

import org.swiftsuspenders.Injector;

public class MapUserInput {

    private static const MOUSE_DOWN_WAIT_PERIOD:uint = 175;

    private static var stats_:Stats = new Stats();
    private static var arrowWarning_:Boolean = false;

    public var gs_:GameSprite;
    public var moveAction_:Boolean = false;

    private var moveLeft_:Boolean = false;
    private var moveRight_:Boolean = false;
    private var moveUp_:Boolean = false;
    private var moveDown_:Boolean = false;
    private var mouseDown_:Boolean = false;
    private var autofire_:Boolean = false;
    private var currentString:String = "";
    private var enablePlayerInput_:Boolean = true;
    private var giftStatusUpdateSignal:GiftStatusUpdateSignal;
    private var addTextLine:AddTextLineSignal;
    private var setTextBoxVisibility:SetTextBoxVisibilitySignal;
    private var statsTabHotKeyInputSignal:StatsTabHotKeyInputSignal;
    private var miniMapZoom:MiniMapZoomSignal;
    private var useBuyPotionSignal:UseBuyPotionSignal;
    private var potionInventoryModel:PotionInventoryModel;
    private var openDialogSignal:OpenDialogSignal;
    private var closeDialogSignal:CloseDialogsSignal;
    private var tabStripModel:TabStripModel;
    private var layers:Layers;
    private var exitGame:ExitGameSignal;
    private var areFKeysAvailable:Boolean;
    private var reskinPetFlowStart:ReskinPetFlowStartSignal;

    public function MapUserInput(_arg1:GameSprite) {
        this.gs_ = _arg1;
        this.gs_.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.gs_.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        var _local2:Injector = StaticInjectorContext.getInjector();
        this.giftStatusUpdateSignal = _local2.getInstance(GiftStatusUpdateSignal);
        this.reskinPetFlowStart = _local2.getInstance(ReskinPetFlowStartSignal);
        this.addTextLine = _local2.getInstance(AddTextLineSignal);
        this.setTextBoxVisibility = _local2.getInstance(SetTextBoxVisibilitySignal);
        this.miniMapZoom = _local2.getInstance(MiniMapZoomSignal);
        this.useBuyPotionSignal = _local2.getInstance(UseBuyPotionSignal);
        this.potionInventoryModel = _local2.getInstance(PotionInventoryModel);
        this.tabStripModel = _local2.getInstance(TabStripModel);
        this.layers = _local2.getInstance(Layers);
        this.statsTabHotKeyInputSignal = _local2.getInstance(StatsTabHotKeyInputSignal);
        this.exitGame = _local2.getInstance(ExitGameSignal);
        this.openDialogSignal = _local2.getInstance(OpenDialogSignal);
        this.closeDialogSignal = _local2.getInstance(CloseDialogsSignal);
        var _local3:ApplicationSetup = _local2.getInstance(ApplicationSetup);
        this.areFKeysAvailable = _local3.areDeveloperHotkeysEnabled();
        this.gs_.map.signalRenderSwitch.add(this.onRenderSwitch);
    }

    public function onRenderSwitch(_arg1:Boolean):void {
        if (_arg1) {
            this.gs_.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        else {
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            this.gs_.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
    }

    public function clearInput():void {
        this.moveAction_ = false;
        this.moveLeft_ = false;
        this.moveRight_ = false;
        this.moveUp_ = false;
        this.moveDown_ = false;
        this.mouseDown_ = false;
        this.autofire_ = false;
        this.setPlayerMovement();
    }

    public function setEnablePlayerInput(_arg1:Boolean):void {
        if (this.enablePlayerInput_ != _arg1) {
            this.enablePlayerInput_ = _arg1;
            this.clearInput();
        }
    }

    private function onAddedToStage(_arg1:Event):void {
        var _local2:Stage = this.gs_.stage;
        _local2.addEventListener(Event.ACTIVATE, this.onActivate);
        _local2.addEventListener(Event.DEACTIVATE, this.onDeactivate);
        _local2.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        _local2.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        _local2.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        if (Parameters.isGpuRender()) {
            _local2.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            _local2.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        else {
            this.gs_.map.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.map.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        _local2.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        _local2.addEventListener(MouseEvent.RIGHT_CLICK, this.disableRightClick);
    }

    public function disableRightClick(_arg1:MouseEvent):void {
    }

    private function onRemovedFromStage(_arg1:Event):void {
        var _local2:Stage = this.gs_.stage;
        _local2.removeEventListener(Event.ACTIVATE, this.onActivate);
        _local2.removeEventListener(Event.DEACTIVATE, this.onDeactivate);
        _local2.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        _local2.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        _local2.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        if (Parameters.isGpuRender()) {
            _local2.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            _local2.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        else {
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            this.gs_.map.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        _local2.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        _local2.removeEventListener(MouseEvent.RIGHT_CLICK, this.disableRightClick);
    }

    private function onActivate(_arg1:Event):void {
    }

    private function onDeactivate(_arg1:Event):void {
        this.clearInput();
    }

    public function onMouseDown(_arg1:MouseEvent):void {
        var _local3:Number;
        var _local4:int;
        var _local5:XML;
        var _local6:Number;
        var _local7:Number;
        var _local2:Player = this.gs_.map.player_;
        if (_local2 == null) {
            return;
        }
        if (!this.enablePlayerInput_) {
            return;
        }
        if (_arg1.shiftKey) {
            _local4 = _local2.equipment_[2];
            if (_local4 == -1) {
                return;
            }
            _local5 = ObjectLibrary.xmlLibrary_[_local4];
            if ((((_local5 == null)) || (_local5.hasOwnProperty("EndMpCost")))) {
                return;
            }
            if (_local2.isUnstable()) {
                _local6 = ((Math.random() * 600) - 300);
                _local7 = ((Math.random() * 600) - 325);
            }
            else {
                _local6 = this.gs_.map.mouseX;
                _local7 = this.gs_.map.mouseY;
            }
            if (Parameters.isGpuRender()) {
                if ((((((_arg1.currentTarget == _arg1.target)) || ((_arg1.target == this.gs_.map)))) || ((_arg1.target == this.gs_)))) {
                    _local2.useAltWeapon(_local6, _local7, UseType.START_USE);
                }
            }
            else {
                _local2.useAltWeapon(_local6, _local7, UseType.START_USE);
            }
            return;
        }
        if (Parameters.isGpuRender()) {
            if ((((((((_arg1.currentTarget == _arg1.target)) || ((_arg1.target == this.gs_.map)))) || ((_arg1.target == this.gs_)))) || ((_arg1.currentTarget == this.gs_.chatBox_.list)))) {
                _local3 = Math.atan2(this.gs_.map.mouseY, this.gs_.map.mouseX);
            }
            else {
                return;
            }
        }
        else {
            _local3 = Math.atan2(this.gs_.map.mouseY, this.gs_.map.mouseX);
        }
        doneAction(this.gs_, Tutorial.ATTACK_ACTION);
        if (_local2.isUnstable()) {
            _local2.attemptAttackAngle((Math.random() * 360));
        }
        else {
            _local2.attemptAttackAngle(_local3);
        }
        this.mouseDown_ = true;
    }

    public function onMouseUp(_arg1:MouseEvent):void {
        this.mouseDown_ = false;
        var _local2:Player = this.gs_.map.player_;
        if (_local2 == null) {
            return;
        }
        _local2.isShooting = false;
    }

    private function onMouseWheel(_arg1:MouseEvent):void {
        if (_arg1.delta > 0) {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.IN);
        }
        else {
            this.miniMapZoom.dispatch(MiniMapZoomSignal.OUT);
        }
    }

    private function onEnterFrame(_arg1:Event):void {
        var _local2:Player;
        var _local3:Number;
        doneAction(this.gs_, Tutorial.UPDATE_ACTION);
        if (((this.enablePlayerInput_) && (((this.mouseDown_) || (this.autofire_))))) {
            _local2 = this.gs_.map.player_;
            if (_local2 != null) {
                if (_local2.isUnstable()) {
                    _local2.attemptAttackAngle((Math.random() * 360));
                }
                else {
                    _local3 = Math.atan2(this.gs_.map.mouseY, this.gs_.map.mouseX);
                    _local2.attemptAttackAngle(_local3);
                }
            }
        }
    }

    private function onKeyDown(_arg1:KeyboardEvent):void {
        var _local1:Stage = this.gs_.stage;
        this.currentString = (this.currentString + String.fromCharCode(_arg1.keyCode).toLowerCase());
        if (!UIUtils.SHOW_EXPERIMENTAL_MENU_NOTIFICATION) {
            this.currentString = "";
            UIUtils.SHOW_EXPERIMENTAL_MENU = true;
            UIUtils.SHOW_EXPERIMENTAL_MENU_NOTIFICATION = true;
        }
        switch (_arg1.keyCode) {
            case KeyCodes.F1:
            case KeyCodes.F2:
            case KeyCodes.F3:
            case KeyCodes.F4:
            case KeyCodes.F5:
            case KeyCodes.F6:
            case KeyCodes.F7:
            case KeyCodes.F8:
            case KeyCodes.F9:
            case KeyCodes.F10:
            case KeyCodes.F11:
            case KeyCodes.F12:
                break;
            default:
                if (_local1.focus != null) {
                    return;
                }
        }
        switch (_arg1.keyCode) {
            case Parameters.data_.moveUp:
                doneAction(this.gs_, Tutorial.MOVE_FORWARD_ACTION);
                this.moveUp_ = true;
                break;
            case Parameters.data_.moveDown:
                doneAction(this.gs_, Tutorial.MOVE_BACKWARD_ACTION);
                this.moveDown_ = true;
                break;
            case Parameters.data_.moveLeft:
                doneAction(this.gs_, Tutorial.MOVE_LEFT_ACTION);
                this.moveLeft_ = true;
                break;
            case Parameters.data_.moveRight:
                doneAction(this.gs_, Tutorial.MOVE_RIGHT_ACTION);
                this.moveRight_ = true;
                break;
        }

        this.moveAction_ = this.moveUp_ || this.moveDown_ || this.moveLeft_ || this.moveRight_;

        this.setPlayerMovement();
    }

    private function onKeyUp(_arg1:KeyboardEvent):void {
        var _local2:Number;
        var _local3:Number;
        switch (_arg1.keyCode) {
            case Parameters.data_.moveUp:
                this.moveUp_ = false;
                break;
            case Parameters.data_.moveDown:
                this.moveDown_ = false;
                break;
            case Parameters.data_.moveLeft:
                this.moveLeft_ = false;
                break;
            case Parameters.data_.moveRight:
                this.moveRight_ = false;
                break;
        }

        this.moveAction_ = this.moveUp_ || this.moveDown_ || this.moveLeft_ || this.moveRight_;

        this.setPlayerMovement();
    }

    private function setPlayerMovement():void {

        if (this.gs_.map.player_ != null) {
            this.gs_.map.player_.moveAction_ = this.moveAction_;

            if (this.enablePlayerInput_)
                this.gs_.map.player_.setRelativeMovement(0, (((this.moveRight_) ? 1 : 0) - ((this.moveLeft_) ? 1 : 0)), (((this.moveDown_) ? 1 : 0) - ((this.moveUp_) ? 1 : 0)));
            else
                this.gs_.map.player_.setRelativeMovement(0, 0, 0);
        }
    }
}
}
