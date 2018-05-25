package com.company.assembleegameclient.util {
import com.company.assembleegameclient.engine3d.Model3D;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.particles.ParticleLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.options.Options;
import com.company.util.AssetLibrary;

import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

import kabam.rotmg.assets.EmbeddedAssets.EmbeddedAssets;
import kabam.rotmg.assets.EmbeddedData.EmbeddedData;

public class AssetLoader {

    public static var currentXmlIsTesting:Boolean = false;


    public function load():void {
        this.addImages();
        this.addAnimatedCharacters();
        this.addSoundEffects();
        this.parseGroundFiles();
        this.parseObjectFiles();
        this.parseRegionFiles();
        Parameters.load();
        Options.refreshCursor(true);
        SFX.load();
    }

    private function addImages():void {
    }

    private function addAnimatedCharacters():void {
    }

    private function addSoundEffects():void {
        SoundEffectLibrary.load("button_click");
        SoundEffectLibrary.load("death_screen");
        SoundEffectLibrary.load("enter_realm");
        SoundEffectLibrary.load("error");
        SoundEffectLibrary.load("inventory_move_item");
        SoundEffectLibrary.load("level_up");
        SoundEffectLibrary.load("loot_appears");
        SoundEffectLibrary.load("no_mana");
        SoundEffectLibrary.load("use_key");
        SoundEffectLibrary.load("use_potion");
    }

    private function parseGroundFiles():void {
        var _local1:*;
        for each (_local1 in EmbeddedData.groundFiles) {
            GroundLibrary.parseFromXML(XML(_local1));
        }
    }

    private function parseObjectFiles():void {
        var _local1:int;
        while (_local1 < 25) {
            currentXmlIsTesting = this.checkIsTestingXML(EmbeddedData.objectFiles[_local1]);
            ObjectLibrary.parseFromXML(XML(EmbeddedData.objectFiles[_local1]));
            _local1++;
        }
        while (_local1 < EmbeddedData.objectFiles.length) {
            ObjectLibrary.parseDungeonXML(getQualifiedClassName(EmbeddedData.objectFiles[_local1]), XML(EmbeddedData.objectFiles[_local1]));
            _local1++;
        }
        currentXmlIsTesting = false;
    }

    private function parseRegionFiles():void {
        var _local1:*;
        for each (_local1 in EmbeddedData.regionFiles) {
            RegionLibrary.parseFromXML(XML(_local1));
        }
    }

    private function checkIsTestingXML(_arg1:*):Boolean {
        return (!((getQualifiedClassName(_arg1).indexOf("TestingCXML", 33) == -1)));
    }


}
}
