package kabam.rotmg.pets.view.components {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.gskinner.motion.GTween;
import com.gskinner.motion.plugins.ColorAdjustPlugin;

import flash.display.Bitmap;
import flash.display.Sprite;

import kabam.rotmg.fortune.components.ItemWithTooltip;
import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

public class NewPetsTabContentView extends Sprite {
    private static const WIDTH:int = 174;
    private static const HEIGHT:int = 114;
    private static const HP_COLOR:String = "#FF6347";
    private static const MP_COLOR:String = "#1E90FF";

    protected var petObjectId:int;
    protected var petHpHealingAverageMin:int;
    protected var petHpHealingAverageMax:int;
    protected var petHpHealingAverageBonus:int;
    protected var petMpHealingAverageMin:int;
    protected var petMpHealingAverageMax:int;
    protected var petMpHealingAverageBonus:int;
    protected var petAttackCooldown:int;
    protected var petAttackChance:int;
    protected var petAttackDamageMin:int;
    protected var petAttackDamageMax:int;
    protected var petHealingCooldown:int;

    private var petTabSprite:Sprite;
    private var petIconPortrait:Sprite;
    private var petIcon:ItemWithTooltip;
    private var samplePetIcons:Array = [0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4705, 0x4706, 0x4707];
    private var petNameTextField:TextFieldDisplayConcrete;
    private var petHpIcon:Bitmap;
    private var petMpIcon:Bitmap;
    private var petAttIcon:Bitmap;
    private var petHpIconSprite:Sprite;
    private var petMpIconSprite:Sprite;
    private var petAttIconSprite:Sprite;
    private var petHpTextField:TextFieldDisplayConcrete;
    private var petMpTextField:TextFieldDisplayConcrete;
    private var petAttTextField:TextFieldDisplayConcrete;
    private var petHpBonusTextField:TextFieldDisplayConcrete;
    private var petMpBonusTextField:TextFieldDisplayConcrete;
    private var petHpBonusSprite:Sprite;
    private var petMpBonusSprite:Sprite;
    private var petHealingTextField:TextFieldDisplayConcrete;
    private var petAttackTextField:TextFieldDisplayConcrete;

    public function NewPetsTabContentView(player:Player) {
        super();
        this.petTabSprite = new Sprite();
        this.petTabSprite.graphics.clear();
        this.petTabSprite.graphics.beginFill(0, 0);
        this.petTabSprite.graphics.drawRect(6, 6, WIDTH, HEIGHT);
        this.petTabSprite.graphics.endFill();
        addChild(this.petTabSprite);
        this.petObjectId = player.petObjectId;
        this.petHpHealingAverageMin = player.petHpHealingAverageMin;
        this.petHpHealingAverageMax = player.petHpHealingAverageMax;
        this.petHpHealingAverageBonus = player.petHpHealingAverageBonus;
        this.petMpHealingAverageMin = player.petMpHealingAverageMin;
        this.petMpHealingAverageMax = player.petMpHealingAverageMax;
        this.petMpHealingAverageBonus = player.petMpHealingAverageBonus;
        this.petAttackCooldown = player.petAttackCooldown;
        this.petAttackChance = player.petAttackChance;
        this.petAttackDamageMin = player.petAttackDamageMin;
        this.petAttackDamageMax = player.petAttackDamageMax;
        this.petHealingCooldown = this.petAttackCooldown + 250;
        this.drawPetIcon();
        this.drawPetName();
        this.drawPetStatIconsSprite();
        this.drawPetStatIcons();
        this.drawPetStatParameters();
        this.drawPetStatBonusParameters();
        this.drawPetStatDetails();
    }

    private function drawPetIcon():void {
        this.petIconPortrait = new Sprite();
        this.petIconPortrait.graphics.clear();
        this.petIconPortrait.graphics.beginFill(0x454545, 1);
        this.petIconPortrait.graphics.drawRoundRect(8, 28, 56, 56, 12, 12);
        this.petIconPortrait.graphics.endFill();
        this.petIconPortrait.filters = [TextureRedrawer.OUTLINE_FILTER];
        this.petTabSprite.addChild(this.petIconPortrait);
        if (this.petObjectId == 0) {
            this.petIcon = new ItemWithTooltip(this.samplePetIcons[int(this.samplePetIcons.length * Math.random())], 64, false, true);
            this.petIcon.filters = [TextureRedrawer.matrixFilter(0x121212)];
        } else
            this.petIcon = new ItemWithTooltip(this.petObjectId, 64, false, true);
        this.petIcon.x = this.petIcon.width / 6 + 3;
        this.petIcon.y = this.petIconPortrait.height - this.petIcon.height / 2;
        this.petIconPortrait.addChild(this.petIcon);
    }

    private function drawPetName():void {
        this.petNameTextField = PetsViewAssetFactory.returnTextfield(0xB3B3B3, 15, true, true);
        if (this.petObjectId == 0)
            this.petNameTextField.setStringBuilder(new LineBuilder().setParams("Empty"));
        else
            this.petNameTextField.setStringBuilder(new LineBuilder().setParams(ObjectLibrary.typeToDisplayId_[this.petObjectId]));
        this.petNameTextField.x = 8;
        this.petNameTextField.y = 20;
        this.petTabSprite.addChild(this.petNameTextField);
    }

    private function drawPetStatIconsSprite():void {
        this.petHpIconSprite = new Sprite();
        this.petHpIconSprite.graphics.clear();
        this.petHpIconSprite.graphics.beginFill(0, 0);
        this.petHpIconSprite.graphics.drawRect(0, 0, 32, 32);
        this.petHpIconSprite.graphics.endFill();
        this.petTabSprite.addChild(this.petHpIconSprite);
        this.petMpIconSprite = new Sprite();
        this.petMpIconSprite.graphics.clear();
        this.petMpIconSprite.graphics.beginFill(0, 0);
        this.petMpIconSprite.graphics.drawRect(0, 0, 32, 32);
        this.petMpIconSprite.graphics.endFill();
        this.petTabSprite.addChild(this.petMpIconSprite);
        this.petAttIconSprite = new Sprite();
        this.petAttIconSprite.graphics.clear();
        this.petAttIconSprite.graphics.beginFill(0, 0);
        this.petAttIconSprite.graphics.drawRect(0, 0, 32, 32);
        this.petAttIconSprite.graphics.endFill();
        this.petTabSprite.addChild(this.petAttIconSprite);
    }

    private function drawPetStatIcons():void {
        this.petHpIcon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 32));
        this.petHpIcon.filters = [TextureRedrawer.matrixFilter(0xFFFFFF)];
        this.petHpIcon.x = WIDTH / 2 - 12;
        this.petHpIcon.y = 30;
        this.petHpIconSprite.addChild(this.petHpIcon);
        this.petMpIcon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 33));
        this.petMpIcon.filters = [TextureRedrawer.matrixFilter(0xFFFFFF)];
        this.petMpIcon.x = this.petHpIcon.x;
        this.petMpIcon.y = this.petHpIcon.y + 18;
        this.petMpIconSprite.addChild(this.petMpIcon);
        this.petAttIcon = new Bitmap(AssetLibrary.getImageFromSet("lofiInterfaceBig", 34));
        this.petAttIcon.filters = [TextureRedrawer.matrixFilter(0xFFFFFF)];
        this.petAttIcon.x = this.petMpIcon.x;
        this.petAttIcon.y = this.petMpIcon.y + 18;
        this.petAttIconSprite.addChild(this.petAttIcon);
        this.petHpIconSprite.filters = [TextureRedrawer.OUTLINE_FILTER];
        this.petMpIconSprite.filters = [TextureRedrawer.OUTLINE_FILTER];
        this.petAttIconSprite.filters = [TextureRedrawer.OUTLINE_FILTER];
    }

    private function drawPetStatParameters():void {
        this.petHpTextField = PetsViewAssetFactory.returnTextfield(0xB3B3B3, 13, false, true).setHTML(true);
        if (this.petObjectId == 0)
            this.petHpTextField.setStringBuilder(new LineBuilder().setParams("Null"));
        else
            this.petHpTextField.setStringBuilder(new LineBuilder().setParams(this.petHpHealingAverageMin == this.petHpHealingAverageMax ? "<b><font color='" + HP_COLOR + "'>" + this.petHpHealingAverageMin + "</font></b>" : "<b><font color='" + HP_COLOR + "'>" + this.petHpHealingAverageMin + "</font></b> to <b><font color='" + HP_COLOR + "'>" + this.petHpHealingAverageMax + "</b></font>"));
        this.petHpTextField.x = this.petHpIcon.x + 16;
        this.petHpTextField.y = this.petHpIcon.y + 13;
        this.petTabSprite.addChild(this.petHpTextField);
        this.petMpTextField = PetsViewAssetFactory.returnTextfield(0xB3B3B3, 13, false, true).setHTML(true);
        if (this.petObjectId == 0)
            this.petMpTextField.setStringBuilder(new LineBuilder().setParams("Null"));
        else
            this.petMpTextField.setStringBuilder(new LineBuilder().setParams(this.petMpHealingAverageMin == this.petMpHealingAverageMax ? "<b><font color='" + MP_COLOR + "'>" + this.petMpHealingAverageMin + "</font></b>" : "<b><font color='" + MP_COLOR + "'>" + this.petMpHealingAverageMin + "</font></b> to <b><font color='" + MP_COLOR + "'>" + this.petMpHealingAverageMax + "</font></b>"));
        this.petMpTextField.x = this.petMpIcon.x + 16;
        this.petMpTextField.y = this.petMpIcon.y + 13;
        this.petTabSprite.addChild(this.petMpTextField);
        this.petAttTextField = PetsViewAssetFactory.returnTextfield(0xB3B3B3, 13, false, true).setHTML(true);
        if (this.petObjectId == 0)
            this.petAttTextField.setStringBuilder(new LineBuilder().setParams("Null"));
        else
            this.petAttTextField.setStringBuilder(new LineBuilder().setParams(this.petAttackDamageMin == this.petAttackDamageMax ? "<b>" + this.petAttackDamageMin + "</b>" : ("<b>" + this.petAttackDamageMin + "</b> to <b>" + this.petAttackDamageMax + "</b>")));
        this.petAttTextField.x = this.petAttIcon.x + 16;
        this.petAttTextField.y = this.petAttIcon.y + 13;
        this.petTabSprite.addChild(this.petAttTextField);
    }

    private function drawPetStatBonusParameters():void {
        this.petHpBonusSprite = new Sprite();
        this.petHpBonusSprite.graphics.clear();
        this.petHpBonusSprite.graphics.beginFill(0, 0);
        this.petHpBonusSprite.graphics.drawRect(0, 0, 24, 9);
        this.petHpBonusSprite.graphics.endFill();
        this.petTabSprite.addChild(this.petHpBonusSprite);
        this.petMpBonusSprite = new Sprite();
        this.petMpBonusSprite.graphics.clear();
        this.petMpBonusSprite.graphics.beginFill(0, 0);
        this.petMpBonusSprite.graphics.drawRect(0, 0, 24, 9);
        this.petMpBonusSprite.graphics.endFill();
        this.petTabSprite.addChild(this.petMpBonusSprite);
        this.petHpBonusTextField = PetsViewAssetFactory.returnTextfield(10092390, 10, true, true);
        if (this.petHpHealingAverageBonus > 0) {
            this.petHpBonusTextField.setStringBuilder(new LineBuilder().setParams("+" + this.petHpHealingAverageBonus + "%"));
            this.petHpBonusTextField.x = WIDTH - 30;
            this.petHpBonusTextField.y = this.petHpTextField.y - 2;
            this.petHpBonusSprite.addChild(this.petHpBonusTextField);
            ColorAdjustPlugin.install();
            new GTween(this.petHpBonusSprite, 3, {contrast: 100}, {repeatCount: 0, reflect: true});
        }
        this.petMpBonusTextField = PetsViewAssetFactory.returnTextfield(10092390, 10, true, true);
        if (this.petMpHealingAverageBonus > 0) {
            this.petMpBonusTextField.setStringBuilder(new LineBuilder().setParams("+" + this.petMpHealingAverageBonus + "%"));
            this.petMpBonusTextField.x = WIDTH - 30;
            this.petMpBonusTextField.y = this.petMpTextField.y - 2;
            this.petMpBonusSprite.addChild(this.petMpBonusTextField);
            ColorAdjustPlugin.install();
            new GTween(this.petMpBonusSprite, 3, {contrast: 100}, {repeatCount: 0, reflect: true});
        }
    }

    private function drawPetStatDetails():void {
        if (this.petObjectId != 0) {
            this.petHealingTextField = PetsViewAssetFactory.returnTextfield(0xFFFFFF, 12, false, true).setHTML(true);
            this.petHealingTextField.setStringBuilder(new LineBuilder().setParams("Your pet heals every <b>" + Parameters.formatValue(this.petHealingCooldown / 1000, 1) + "s</b>."));
            this.petHealingTextField.x = 8;
            this.petHealingTextField.y = HEIGHT - 18;
            this.petTabSprite.addChild(this.petHealingTextField);
            this.petAttackTextField = PetsViewAssetFactory.returnTextfield(0xFFFFFF, 12, false, true).setHTML(true);
            this.petAttackTextField.setStringBuilder(new LineBuilder().setParams("Your pet attacks every <b>" + Parameters.formatValue(this.petAttackCooldown / 1000, 1) + "s</b>, with\n<b>" + this.petAttackChance + "%</b> chance to deal damage."));
            this.petAttackTextField.x = 8;
            this.petAttackTextField.y = this.petHealingTextField.y + 12;
            this.petTabSprite.addChild(this.petAttackTextField);
        }
    }
}
}
