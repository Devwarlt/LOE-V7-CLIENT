package com.company.assembleegameclient.screens {
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;

public class GameStoreWindow extends Sprite {
    public static var ALLOW_ACTION:Boolean = true;
    public static var CART_OFFERS:Array = null;
    public static var CART_PROCESSED_OFFERS:Array = null;
    public static var OFFER_BACKGROUND_COLOR:int = 0x898989;

    private var darkBox_:Shape;
    private var dialog_:Dialog;
    private var viewBoard_:GameStore;
    private var client_:AppEngineClient;

    public function GameStoreWindow() {
        this.darkBox_ = new Shape();
        var _local1:Graphics = this.darkBox_.graphics;
        _local1.clear();
        _local1.beginFill(0, 0.8);
        _local1.drawRect(0, 0, 800, 600);
        _local1.endFill();
        addChild(this.darkBox_);
        this.load();
    }

    private function load():void {
        this.darkBox_.visible = true;
        this.client_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.client_.complete.addOnce(this.onAccountInformationComplete);
        this.client_.sendRequest("/gamestore/getOffers", StaticInjectorContext.getInjector().getInstance(Account).getCredentials());
        this.dialog_ = new Dialog(null, "Loading...", null, null, null);
        addChild(this.dialog_);
    }

    private function onAccountInformationComplete(_arg1:Boolean, _arg2:*):void {
        (_arg1 && _arg2 != null && _arg2 != "") ? this.showAccountInformation(_arg2) : this.reportError();
    }

    private function showAccountInformation(_arg1:String):void {
        this.darkBox_.visible = true;
        removeChild(this.dialog_);
        this.show(_arg1);
    }

    private function reportError():void {
        this.darkBox_.visible = true;
        removeChild(this.dialog_);
        this.dialog_ = new Dialog(null, "An error occurred during your request to our server, try again later.", null, null, null);
        addChild(this.dialog_);
        var _timer:Timer = new Timer(4000, 1);
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onClose);
        _timer.start();
    }

    private function onClose(event:TimerEvent):void {
        this.darkBox_.visible = false;
        removeChild(this.dialog_);
    }

    private function show(response:String):void {
        var data:Array = response.split("|");
        var _welcome:String = data[0];
        var _offers:Array = [];
        var _offer1:Array = [];
        var _offer2:Array = [];
        var _offer3:Array = [];
        var _offer4:Array = [];
        var _offer5:Array = [];
        for each (var _local1:String in data[1].split(';'))
            _offers.push({offerId: _local1.split(',')[0], offerName: _local1.split(',')[1]});
        for each (var _local2:String in data[2].split(';'))
            _offer1.push({
                offerId: _local2.split(',')[0],
                objectType: _local2.split(',')[1],
                price: _local2.split(',')[2],
                currencyType: _local2.split(',')[3]
            });
        for each (var _local3:String in data[3].split(';'))
            _offer2.push({
                offerId: _local3.split(',')[0],
                objectType: _local3.split(',')[1],
                price: _local3.split(',')[2],
                currencyType: _local3.split(',')[3]
            });
        for each (var _local4:String in data[4].split(';'))
            _offer3.push({
                offerId: _local4.split(',')[0],
                objectType: _local4.split(',')[1],
                price: _local4.split(',')[2],
                currencyType: _local4.split(',')[3]
            });
        for each (var _local5:String in data[5].split(';'))
            _offer4.push({
                offerId: _local5.split(',')[0],
                objectType: _local5.split(',')[1],
                price: _local5.split(',')[2],
                currencyType: _local5.split(',')[3]
            });
        for each (var _local6:String in data[6].split(';'))
            _offer5.push({
                offerId: _local6.split(',')[0],
                objectType: _local6.split(',')[1],
                price: _local6.split(',')[2],
                currencyType: _local6.split(',')[3]
            });
        this.viewBoard_ = new GameStore("", _offers, _offer1.concat(_offer2, _offer3, _offer4, _offer5), _welcome);
        this.viewBoard_.addEventListener(Event.COMPLETE, this.onViewComplete);
        addChild(this.viewBoard_);
    }

    private function onViewComplete(_arg1:Event):void {
        parent.removeChild(this);
    }
}
}

import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.GameStoreWindow;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.DynamicButton;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.util.Currency;
import com.company.ui.BaseSimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.utils.Timer;
import flash.utils.setInterval;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_buttonMediumHover_shapeEmbed_;
import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets_buttonMediumNormal_shapeEmbed_;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.fortune.components.ItemWithTooltip;
import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.util.components.LegacyBuyButton;

class GameStoreOfferBox extends Sprite {
    private var empiresCoinIcon_:Bitmap;
    private var userDetails_:BaseSimpleText;
    private var userDetailsShape_:Shape;
    private var userDetailsGraphics_:Graphics;
    private var shape_:Shape;
    private var graphics_:Graphics;
    private var offersOptions_:Array;
    private var offerId_:int;
    private var objectType_:int;
    private var price_:int;
    private var currencyType_:int;
    private var welcomeMsg_:BaseSimpleText;
    private var offerIcon_:ItemWithTooltip;
    private var offerName_:String;
    private var offerDescription_:String;
    private var offerDetails_:BaseSimpleText;

    public function GameStoreOfferBox(offerId:int, offersOptions:Array, xReference:int, welcome:String = null) {
        super();
        this.offerId_ = offerId;

        var outline1:GlowFilter = new GlowFilter();
        var outline2:GlowFilter = new GlowFilter();
        var outline3:GlowFilter = new GlowFilter();
        var filterArray1:Array = [];
        var filterArray2:Array = [];
        var filterArray3:Array = [];
        var filtersArray:Array = [];

        outline1.blurX = outline1.blurY = 1.1;
        outline1.color = 0;
        outline1.quality = BitmapFilterQuality.HIGH;
        outline1.strength = 100;

        outline2.color = 0xFFFF00;
        outline2.quality = BitmapFilterQuality.HIGH;

        outline3.blurX = outline3.blurY = 1.5;
        outline3.color = 0x898989;
        outline3.quality = BitmapFilterQuality.HIGH;
        outline3.strength = 25;

        filterArray1.push(outline1);
        filterArray2.push(outline2);
        filterArray3.push(outline3);
        filtersArray.push(filterArray1);
        filtersArray.push(filterArray2);
        filtersArray.push(filterArray3);

        this.userDetailsShape_ = new Shape();
        this.userDetailsGraphics_ = this.userDetailsShape_.graphics;
        this.userDetailsGraphics_.clear();
        this.userDetailsGraphics_.beginFill(0, 0.75);
        this.userDetailsGraphics_.drawRoundRect(0, 0, 600, 28, 12, 12);
        this.userDetailsGraphics_.endFill();
        this.userDetailsShape_.filters = filtersArray[2];
        this.userDetailsShape_.x = xReference + 6;
        this.userDetailsShape_.y = 6;
        addChild(this.userDetailsShape_);

        this.userDetails_ = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 8, 24);
        this.userDetails_.selectable = false;
        this.userDetails_.border = false;
        this.userDetails_.mouseEnabled = true;
        this.userDetails_.multiline = true;
        this.userDetails_.wordWrap = true;
        this.userDetails_.htmlText = "\tYour account has total of " + Player.empiresCoin_ + " empires coin" + (Player.empiresCoin_ > 1 ? "s" : "") + " in your balance.";
        this.userDetails_.useTextDimensions();
        this.userDetails_.x = xReference + 14;
        this.userDetails_.y = 11;
        addChild(this.userDetails_);

        this.empiresCoinIcon_ = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 31));
        this.empiresCoinIcon_.filters = filtersArray[0];
        this.empiresCoinIcon_.x = xReference + 6 + this.empiresCoinIcon_.width / 2;
        this.empiresCoinIcon_.y = this.empiresCoinIcon_.height / 2 + 4;
        addChild(this.empiresCoinIcon_);

        if (this.offerId_ == -1 && welcome != null) {
            this.welcomeMsg_ = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 16, 0);
            this.welcomeMsg_.selectable = false;
            this.welcomeMsg_.border = false;
            this.welcomeMsg_.mouseEnabled = true;
            this.welcomeMsg_.multiline = true;
            this.welcomeMsg_.wordWrap = true;
            this.welcomeMsg_.htmlText = welcome;
            this.welcomeMsg_.useTextDimensions();
            this.welcomeMsg_.x = xReference + 6;
            this.welcomeMsg_.y = 48;
            addChild(this.welcomeMsg_);
            return;
        }

        if (this.offerId_ == -1)
            return;

        this.offersOptions_ = offersOptions;
        var i:int = 0;
        var _local1:Object = {};

        for each (_local1 in this.offersOptions_) {
            if (_local1.offerId == this.offerId_) {
                this.objectType_ = _local1.objectType;
                this.price_ = _local1.price;
                this.currencyType_ = _local1.currencyType;
                this.shape_ = new Shape();
                this.graphics_ = shape_.graphics;
                this.graphics_.clear();
                this.graphics_.beginFill(GameStoreWindow.OFFER_BACKGROUND_COLOR, 0.5);
                this.graphics_.drawRoundRect(0, 0, 600, 96, 12, 12);
                this.graphics_.endFill();
                this.shape_.x = xReference + 6;
                this.shape_.y = 48 + i * 96 + (i == 0 ? 0 : i * 8);
                addChild(this.shape_);

                this.offerName_ = ObjectLibrary.typeToDisplayId_[this.objectType_];

                var _local2:XML = ObjectLibrary.xmlLibrary_[this.objectType_];

                if (_local2.hasOwnProperty("@successChance"))
                    this.offerName_ = this.offerName_ + " (" + _local2.attribute("successChance") + " chance)";
                if (_local2.hasOwnProperty("Doses"))
                    this.offerName_ = _local2.Doses + "x " + this.offerName_;

                this.offerDescription_ = _local2.Description;

                if (this.offerDescription_ == null || this.offerDescription_ == "")
                    this.offerDescription_ = "No item description.";

                do
                    this.offerDescription_ = this.offerDescription_.replace("\\n\\n", "\n\n\t\t");
                while (this.offerDescription_.indexOf("\\n\\n") >= 0);

                do
                    this.offerDescription_ = this.offerDescription_.replace("\\n", "\n\t\t");
                while (this.offerDescription_.indexOf("\\n") >= 0);

                this.offerDetails_ = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 16, 0);
                this.offerDetails_.selectable = false;
                this.offerDetails_.border = false;
                this.offerDetails_.mouseEnabled = true;
                this.offerDetails_.multiline = true;
                this.offerDetails_.wordWrap = true;
                this.offerDetails_.htmlText = "\n\t\t<b>" + this.offerName_ + "</b>\n\n\t\t<i>" + this.offerDescription_ + "</i>";
                this.offerDetails_.useTextDimensions();
                this.offerDetails_.x = this.shape_.x;
                this.offerDetails_.y = this.shape_.y;
                addChild(this.offerDetails_);

                this.offerIcon_ = new ItemWithTooltip(this.objectType_, 64, false, true);
                this.offerIcon_.filters = filtersArray[1];
                this.offerIcon_.x = this.offerDetails_.x;
                this.offerIcon_.y = this.offerDetails_.y + this.offerIcon_.height / 2;
                addChild(this.offerIcon_);

                var _local5:GameStoreButton = new GameStoreButton(this.price_, this.currencyType_, this.width, this.offerDetails_.y, this.objectType_, this.offerName_);
                addChild(_local5);

                i++;
            }
        }
    }
}

class GameStoreButton extends Sprite {
    private var buyButton_:LegacyBuyButton;
    private var price_:int;
    private var currencyType_:int;
    private var objectType_:int;
    private var offerName_:String;
    private var success_:Boolean;
    private var popup_:Dialog;

    public function GameStoreButton(_price:int, _currencyType:int, xReference:int, yReference:int, _objectType:int, _offerName:String) {
        this.success_ = GameStoreWindow.CART_PROCESSED_OFFERS == null ? Player.empiresCoin_ >= _price : Player.empiresCoin_ >= remainingCoins();
        this.price_ = _price;
        this.currencyType_ = _currencyType;
        this.objectType_ = _objectType;
        this.offerName_ = _offerName;
        this.buyButton_ = new LegacyBuyButton(TextKey.SELLABLEOBJECTPANEL_BUY, 16, 0, Currency.INVALID, true, false, true);
        this.buyButton_.setPrice(this.price_, this.currencyType_);
        this.buyButton_.x = xReference - 32 - this.buyButton_._width;
        this.buyButton_.y = yReference + 4;
        this.buyButton_.addEventListener(MouseEvent.CLICK, this.onClick);
        addChild(this.buyButton_);
    }

    private static function remainingCoins():int {
        var _local1:int;
        for each (var _local2:Object in GameStoreWindow.CART_PROCESSED_OFFERS)
            _local1 += _local2.price * _local2.quantity;
        return _local1;
    }

    private function onClick(event:MouseEvent):void {
        GameStoreWindow.ALLOW_ACTION = false;
        if (this.success_) {
            var _local1:Object = {
                objectType: this.objectType_,
                price: this.price_,
                currencyType: this.currencyType_
            };
            if (GameStoreWindow.CART_OFFERS == null)
                GameStoreWindow.CART_OFFERS = [];
            GameStoreWindow.CART_OFFERS.push(_local1);
        }
        this.buyButton_.setEnabled(false);
        this.buyButton_.removeEventListener(MouseEvent.CLICK, this.onClick);
        this.popup_ = new Dialog(null, this.success_ ? "You added \"" + this.offerName_ + "\" in your cart for " + this.price_ + " empire coin" + (this.price_ > 1 ? "s" : "") + ".\n\nYou can remove this pending item at \"Cart\", before payment." : "You do not have enough amount of empire coins in your account to add this item in your cart.", null, null, null);
        this.popup_.y = -224;
        var _timer:Timer = new Timer(4000, 1);
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onClose);
        _timer.start();
        setInterval(this.animatedPopUp, 250);
        addChild(this.popup_);
    }

    private function animatedPopUp():void {
        this.popup_.y -= 2;
    }

    private function onClose(event:TimerEvent):void {
        GameStoreWindow.ALLOW_ACTION = true;
        this.buyButton_.setEnabled(true);
        this.buyButton_.addEventListener(MouseEvent.CLICK, this.onClick);
        removeChild(this.popup_);
    }
}

class GameStoreCart extends Sprite {
    private var dialog_:Dialog;
    private var darkBox_:Shape;
    private var darkBoxGraphics_:Graphics;
    private var confirmPurchaseButton_:DeprecatedTextButton;
    private var client_:AppEngineClient;

    public function GameStoreCart(display:Boolean, xReference:int) {
        if (!display)
            return;

        var outline1:GlowFilter = new GlowFilter();
        outline1.blurX = outline1.blurY = 1.1;
        outline1.color = 0x000000;
        outline1.quality = BitmapFilterQuality.HIGH;
        outline1.strength = 100;

        var outline2:GlowFilter = new GlowFilter();
        outline2.color = 0xFFFF00;
        outline2.quality = BitmapFilterQuality.HIGH;

        var filterArray1:Array = [];
        filterArray1.push(outline1);

        var filterArray2:Array = [];
        filterArray2.push(outline2);

        var filtersArray:Array = [];
        filtersArray.push(filterArray1);
        filtersArray.push(filterArray2);

        var _local1:Array = GameStoreWindow.CART_OFFERS;
        var _local2:int = GameStoreWindow.CART_OFFERS == null ? 0 : GameStoreWindow.CART_OFFERS.length;
        var _local3:BaseSimpleText = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 16, 0);
        var _local4:BaseSimpleText = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 16, 0);

        this.confirmPurchaseButton_ = new DeprecatedTextButton(14, "Confirm Purchase", 124);

        if (_local1 == null) {
            _local3.selectable = false;
            _local3.border = false;
            _local3.mouseEnabled = true;
            _local3.multiline = true;
            _local3.wordWrap = true;
            _local3.htmlText = "<b>Cart</b>\n\nThere is no pending item in your cart.";
            _local3.useTextDimensions();
            _local3.x = xReference + 6;
            _local3.y = 48;
            addChild(_local3);
            return;
        }

        _local4.selectable = false;
        _local4.border = false;
        _local4.mouseEnabled = true;
        _local4.multiline = true;
        _local4.wordWrap = true;
        _local4.htmlText = "<b>Cart</b>\n\nThere " + (_local2 > 1 ? "are" : "is") + " <b>" + _local2 + "</b> pending items in your cart awaiting to confirm purchase before payment.";
        _local4.useTextDimensions();
        _local4.x = xReference + 6;
        _local4.y = 48;
        addChild(_local4);

        this.confirmPurchaseButton_.setEnabled(true);
        this.confirmPurchaseButton_.x = this.width + 24;
        this.confirmPurchaseButton_.y = 48;
        this.confirmPurchaseButton_.addEventListener(MouseEvent.CLICK, this.requestPurchase);
        addChild(this.confirmPurchaseButton_);

        var _local5:int = 0;
        var _local6:Object = {};
        var _local7:Object = {};
        var _local8:Object = {};
        var _local9:Array = [];

        GameStoreWindow.CART_PROCESSED_OFFERS = [];

        for each (_local7 in _local1) {
            if (_local9.indexOf(_local7.objectType) == -1) {
                _local8 = processCart(_local7.objectType, _local7.price, _local7.currencyType, _local1);
                GameStoreWindow.CART_PROCESSED_OFFERS.push(_local8);
            }
            _local9.push(_local7.objectType);
        }

        for each (_local6 in GameStoreWindow.CART_PROCESSED_OFFERS) {
            var _local11:GameStoreCartButton;
            var _local12:int = _local6.quantity;
            var _local13:int = _local6.objectType;
            var _local14:int = _local6.price;
            var _local15:int = _local6.currencyType;

            _local11 = new GameStoreCartButton(_local5, xReference, 48, _local13, filtersArray[1], _local12, _local14, _local15);
            addChild(_local11);

            _local5++;
        }
    }

    private function requestPurchase(event:MouseEvent):void {
        this.confirmPurchaseButton_.removeEventListener(MouseEvent.CLICK, this.requestPurchase);
        GameStoreWindow.ALLOW_ACTION = false;
        this.confirmPurchaseButton_.setEnabled(false);
        this.darkBox_ = new Shape();
        this.darkBoxGraphics_ = this.darkBox_.graphics;
        this.darkBoxGraphics_.clear();
        this.darkBoxGraphics_.beginFill(0, 0.5);
        this.darkBoxGraphics_.drawRect(0, 0, 800, 600);
        this.darkBoxGraphics_.endFill();
        addChild(this.darkBox_);
        this.client_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.client_.complete.addOnce(this.onGameStorePurchaseComplete);
        this.client_.sendRequest("/gamestore/purchaseOffers", {
            guid: StaticInjectorContext.getInjector().getInstance(Account).getUserId(),
            password: StaticInjectorContext.getInjector().getInstance(Account).getPassword(),
            purchasedItems: processPurchases()
        });
        this.dialog_ = new Dialog(null, "Contacting server, please wait...", null, null, null);
        addChild(this.dialog_);
    }

    private function onGameStorePurchaseComplete(_arg1:Boolean, _arg2:*):void {
        (_arg1 && _arg2 != null && _arg2 != "") ? this.success(_arg2) : this.error(_arg2);
    }

    private function success(_arg1:String):void {
        GameStoreWindow.CART_OFFERS = null;
        GameStoreWindow.CART_PROCESSED_OFFERS = null;
        removeChild(this.dialog_);
        if (_arg1 != null && _arg1 != "") {
            var _local1:String = _arg1.split('#')[1];
            var _local2:Array = null;
            var _local3:int = 0;
            for each (var _local4:String in _local1.split('|')) {
                if (_local2 == null) {
                    _local2 = [];
                    _local2.push("\n\nPurchased Info:\n* " + _local4);
                }
                _local2.push(_local2[_local3] + "\n* ");
                _local3++;
            }
            this.dialog_ = new Dialog("Success!", "You completed your purchase requisition to our server and your pending order has been successfully confirmed!\n\nCheckout your gift chest.\n\n" + _local2[_local3 - 1] + "\n\n\n\nKind regards, The Staff\nYour LoESoft Games", "Ok", null, null, 0x00FF00);
        } else
            this.dialog_ = new Dialog("Success!", "You completed your purchase requisition to our server and your pending order has been successfully confirmed!\n\nCheckout your gift chest.\n\n\n\nKind regards, The Staff\nYour LoESoft Games", "Ok", null, null, 0x00FF00);
        this.dialog_.addEventListener(Dialog.LEFT_BUTTON, this.onClose);
        addChild(this.dialog_);
        this.confirmPurchaseButton_.setText("Purchased!");
    }

    private function error(_arg1:String):void {
        removeChild(this.dialog_);
        if (_arg1 != null && _arg1 != "") {
            var _local1:String = _arg1.split('#')[1];
            var _local2:Array = null;
            var _local3:int = 0;
            for each (var _local4:String in _local1.split('|')) {
                if (_local2 == null) {
                    _local2 = [];
                    _local2.push("\n\nPurchased Info:\n* " + _local4);
                }
                _local2.push(_local2[_local3] + "\n* ");
                _local3++;
            }
            this.dialog_ = new Dialog("Error!", "You cannot complete your purchase requisition to our server, try again later.\n\n" + _local2[_local3 - 1] + "\n\n\n\nKind regards, The Staff\nYour LoESoft Games", "Ok", null, null, 0xFF0000);
        } else
            this.dialog_ = new Dialog("Error", "You cannot complete your purchase requisition to our server, try again later.\n\n\n\nKind regards, The Staff\nYour LoESoft Games", "Ok", null, null, 0xFF0000);
        this.dialog_.addEventListener(Dialog.LEFT_BUTTON, this.onClose);
        addChild(this.dialog_);
        this.confirmPurchaseButton_.setEnabled(true);
        this.confirmPurchaseButton_.addEventListener(MouseEvent.CLICK, this.requestPurchase);
    }

    private function onClose(event:Event):void {
        GameStoreWindow.ALLOW_ACTION = true;
        removeChild(this.dialog_);
        removeChild(this.darkBox_);
    }

    private static function processPurchases():String {
        var _local1:Array = null;
        var _local2:int = 0;
        for each (var _local3:Object in GameStoreWindow.CART_PROCESSED_OFFERS) {
            if (_local1 == null) {
                _local1 = [];
                _local1.push((_local3.objectType + "," + _local3.price + "," + _local3.currencyType + "," + _local3.quantity).toString());
            } else
                _local1.push(_local1[_local2 - 1] + "|" + (_local3.objectType + "," + _local3.price + "," + _local3.currencyType + "," + _local3.quantity).toString());
            _local2++;
        }
        return _local1[_local2 - 1];
    }

    private static function processCart(_objectType:int, _price:int, _currencyType:int, _cartOffers:Array):Object {
        var _local1:Array = [];
        var _local2:int;
        for (_local2 = 0; _local2 < _cartOffers.length; _local2++)
            if (_cartOffers[_local2].objectType == _objectType)
                _local1.push(_local2);
        return {objectType: _objectType, price: _price, currencyType: _currencyType, quantity: _local1.length};
    }
}

class GameStoreCartButton extends Sprite {
    private var offerShape_:Shape;
    private var offerGraphics_:Graphics;
    private var offerXML_:XML;
    private var objectName_:String;
    private var objectDescription_:String;
    private var objectText_:BaseSimpleText;
    private var objectItem_:ItemWithTooltip;
    private var buyButton_:LegacyBuyButton;
    private var objectType_:int;
    private var quantity_:int;
    private var price_:int;
    private var currency_:int;

    public function GameStoreCartButton(position:int, X:int, Y:int, objectType:int, filters:Array, quantity:int, price:int, currency:int) {
        if (objectType == -1 || objectType == 0)
            return;
        this.objectType_ = objectType;
        this.quantity_ = quantity;
        this.price_ = price;
        this.currency_ = currency;
        this.offerShape_ = new Shape();
        this.offerGraphics_ = this.offerShape_.graphics;
        this.offerGraphics_.clear();
        this.offerGraphics_.beginFill(GameStoreWindow.OFFER_BACKGROUND_COLOR, 0.5);
        this.offerGraphics_.drawRoundRect(0, 0, 600, 96, 12, 12);
        this.offerGraphics_.endFill();
        this.offerShape_.x = X + 6;
        this.offerShape_.y = Y + 48 + position * 96 + (position == 0 ? 0 : position * 8);
        addChild(this.offerShape_);
        this.offerXML_ = ObjectLibrary.xmlLibrary_[objectType];
        this.objectName_ = ObjectLibrary.typeToDisplayId_[objectType];
        if (this.offerXML_.hasOwnProperty("@successChance"))
            this.objectName_ = this.objectName_ + " (" + this.offerXML_.attribute("successChance") + " chance)";
        if (this.offerXML_.hasOwnProperty("Doses"))
            this.objectName_ = this.offerXML_.Doses + "x " + this.objectName_;
        this.objectDescription_ = this.offerXML_.Description;
        if (this.objectDescription_ == null || this.objectDescription_ == "")
            this.objectDescription_ = "No item description.";
        do
            this.objectDescription_ = this.objectDescription_.replace("\\n\\n", "\n\n\t\t");
        while (this.objectDescription_.indexOf("\\n\\n") >= 0);
        do
            this.objectDescription_ = this.objectDescription_.replace("\\n", "\n\t\t");
        while (this.objectDescription_.indexOf("\\n") >= 0);
        this.objectText_ = new BaseSimpleText(12, 0xFFFFFF, false, 600 - 16, 0);
        this.objectText_.selectable = false;
        this.objectText_.border = false;
        this.objectText_.mouseEnabled = true;
        this.objectText_.multiline = true;
        this.objectText_.wordWrap = true;
        this.objectText_.htmlText = "\n\t\t<b>" + this.objectName_ + "</b>\n\n\t\t<i>" + this.objectDescription_ + "</i>";
        this.objectText_.useTextDimensions();
        this.objectText_.x = this.offerShape_.x;
        this.objectText_.y = this.offerShape_.y;
        addChild(this.objectText_);
        this.objectItem_ = new ItemWithTooltip(objectType, 64, false, true);
        this.objectItem_.filters = filters;
        this.objectItem_.x = this.objectText_.x;
        this.objectItem_.y = this.objectText_.y + this.objectItem_.height / 2;
        addChild(this.objectItem_);
        this.buyButton_ = new LegacyBuyButton(this.quantity_ + "x for " + this.price_ * this.quantity_, 16, 0, this.currency_, true, true, true, this.price_ + " each");
        this.buyButton_.setEnabled(false);
        this.buyButton_.x = this.width - 32 - this.buyButton_._width;
        this.buyButton_.y = this.objectText_.y + 4;
        addChild(this.buyButton_);
    }
}

class GameStore extends Sprite {
    public static const TEXT_WIDTH:int = 800;
    public static const TEXT_HEIGHT:int = 600;

    public static const BUTTON_X:int = 1;

    public static const SCROLLBAR_X:int = TEXT_WIDTH - 56;
    public static const SCROLLBAR_Y:int = 3;

    public static const INDICATOR_SIZE:int = 5 * 96 + 48;
    public static const INDICATOR_SIZE_ADJUST:int = 2 * 96;

    public static const X_REFERENCE:int = 128;

    private var button1_:DynamicButton;
    private var button2_:DynamicButton;
    private var button3_:DynamicButton;
    private var button4_:DynamicButton;
    private var button5_:DynamicButton;

    private var cart_:DynamicButton;

    private var containsScrollBar_:Boolean;
    private var containsCart_:Boolean = false;

    private var offers_:Array = [];
    private var offersOptions_:Array = [];
    private var gameStoreOfferBoxes_:GameStoreOfferBox;
    private var gameStoreCart_:GameStoreCart;
    private var text_:String;
    public var w_:int;
    public var h_:int;
    private var mainSprite_:Sprite;
    private var scrollBar_:Scrollbar;
    private var closeButton_:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(TEXT_WIDTH);

    public function GameStore(textData:String, offers:Array, offersOptions:Array, welcome:String) {
        super();
        GameStoreWindow.CART_OFFERS = null;
        this.text_ = textData;
        this.offers_ = offers;
        this.offersOptions_ = offersOptions;
        this.mainSprite_ = new Sprite();
        var _local1:Object = {};
        var _local2:DynamicButton;
        var _local3:Shape = new Shape();
        var _local4:Graphics = _local3.graphics;
        var _local5:Shape = new Shape();
        _local4.beginFill(0);
        _local4.drawRect(0, 0, TEXT_WIDTH, TEXT_HEIGHT);
        _local4.endFill();
        this.mainSprite_.addChild(_local3);
        this.mainSprite_.mask = _local3;
        addChild(this.mainSprite_);
        this.button1_ = new DynamicButton(16, this.offers_[0].offerName, new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.button1_.x = BUTTON_X;
        this.button1_.y = 2;
        this.button2_ = new DynamicButton(16, this.offers_[1].offerName, new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.button2_.x = BUTTON_X;
        this.button2_.y = this.button2_.height + 8;
        this.button3_ = new DynamicButton(16, this.offers_[2].offerName, new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.button3_.x = BUTTON_X;
        this.button3_.y = 2 * this.button3_.height + 8 * 2;
        this.button4_ = new DynamicButton(16, this.offers_[3].offerName, new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.button4_.x = BUTTON_X;
        this.button4_.y = 3 * this.button4_.height + 8 * 3;
        this.button5_ = new DynamicButton(16, this.offers_[4].offerName, new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.button5_.x = BUTTON_X;
        this.button5_.y = 4 * this.button5_.height + 8 * 4;
        this.cart_ = new DynamicButton(16, "Cart", new EmbeddedAssets_buttonMediumNormal_shapeEmbed_().bitmapData, new EmbeddedAssets_buttonMediumHover_shapeEmbed_().bitmapData);
        this.cart_.x = BUTTON_X;
        this.cart_.y = 6 * this.cart_.height + 8 * 6;
        this.button1_.addEventListener(MouseEvent.CLICK, this.updateGameStoreOffers1);
        this.button2_.addEventListener(MouseEvent.CLICK, this.updateGameStoreOffers2);
        this.button3_.addEventListener(MouseEvent.CLICK, this.updateGameStoreOffers3);
        this.button4_.addEventListener(MouseEvent.CLICK, this.updateGameStoreOffers4);
        this.button5_.addEventListener(MouseEvent.CLICK, this.updateGameStoreOffers5);
        this.cart_.addEventListener(MouseEvent.CLICK, this.checkCart);
        addChild(this.button1_);
        addChild(this.button2_);
        addChild(this.button3_);
        addChild(this.button4_);
        addChild(this.button5_);
        addChild(this.cart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(-1, this.offersOptions_, X_REFERENCE, welcome);
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.closeButton_.x = this.w_ - this.closeButton_.width - 4;
        this.closeButton_.y = 4;
        this.closeButton_.addEventListener(MouseEvent.CLICK, this.onClose);
        addChild(this.closeButton_);
    }

    private function updateGameStoreOffers1(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = false;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(0, this.offersOptions_, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function updateGameStoreOffers2(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = false;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(1, this.offersOptions_, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function updateGameStoreOffers3(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = false;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(2, this.offersOptions_, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function updateGameStoreOffers4(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = false;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(3, this.offersOptions_, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function updateGameStoreOffers5(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = false;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(false, 0);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(4, this.offersOptions_, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreOfferBoxes_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreOfferBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function checkCart(event:MouseEvent):void {
        if (!GameStoreWindow.ALLOW_ACTION)
            return;
        this.containsCart_ = true;
        if (this.containsScrollBar_)
            removeChild(this.scrollBar_);
        this.mainSprite_.removeChild(this.gameStoreCart_);
        this.gameStoreCart_ = new GameStoreCart(true, X_REFERENCE);
        this.mainSprite_.removeChild(this.gameStoreOfferBoxes_);
        this.gameStoreOfferBoxes_ = new GameStoreOfferBox(-1, null, X_REFERENCE);
        this.containsScrollBar_ = this.gameStoreCart_.height > INDICATOR_SIZE;
        if (this.containsScrollBar_) {
            this.scrollBar_ = new Scrollbar(16, (TEXT_HEIGHT - 4));
            this.scrollBar_.x = SCROLLBAR_X;
            this.scrollBar_.y = SCROLLBAR_Y;
            this.scrollBar_.setIndicatorSize(INDICATOR_SIZE_ADJUST, this.gameStoreCart_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
        }
        this.w_ = (TEXT_WIDTH - ((this.containsScrollBar_) ? 26 : 0));
        this.mainSprite_.addChild(this.gameStoreCart_);
        this.mainSprite_.addChild(this.gameStoreOfferBoxes_);
    }

    private function onScrollBarChange(_arg1:Event):void {
        if (!this.containsCart_)
            this.gameStoreOfferBoxes_.y = (-this.scrollBar_.pos()) * (this.gameStoreOfferBoxes_.height - TEXT_HEIGHT + INDICATOR_SIZE_ADJUST / 2);
        else
            this.gameStoreCart_.y = (-this.scrollBar_.pos()) * (this.gameStoreCart_.height - TEXT_HEIGHT + INDICATOR_SIZE_ADJUST / 2);
    }

    private function onClose(_arg1:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }
}