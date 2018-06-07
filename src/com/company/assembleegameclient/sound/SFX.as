package com.company.assembleegameclient.sound {
import com.company.assembleegameclient.parameters.Parameters;

import flash.media.SoundTransform;

public class SFX {

    private static var sfxTrans_:SoundTransform;


    public static function load():void {
        sfxTrans_ = new SoundTransform(Parameters.data_.sound ? 1 : 0);
    }

    public static function setPlaySFX():void {
        SoundEffectLibrary.updateTransform();
    }

    public static function setSFXVolume():void {
        SoundEffectLibrary.updateVolume(Parameters.data_.sound ? 1 : 0);
    }


}
}
