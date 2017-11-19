    //
    //  Speech.swift
    //  FarsiEnglishDictionary
    //
    //  Created by Maryam Rajaei on 2017-11-06.
    //  Copyright © 2017 veddes. All rights reserved.
    //

    import Foundation
    import Speech

    class Speech {

        var rate: Float!
        var pitch: Float!
        var volume: Float!
       init (rate: Float, pitch:Float, volume:Float) {
            self.rate = rate
            self.pitch = pitch
            self.volume = volume
        }
        
        //constant of speechSynthesizer
        let speechSynthesizer = AVSpeechSynthesizer()
        
        
        //when view is loaded in myMainTableView this method is run
        func initialSpeechSettings() {
            if !loadSettings() {
                registerDefaultSettings()
            }
        }
        
   // Mark: - Speak the text
        func speak(a:String){
            let speechUtterance = AVSpeechUtterance(string: a)
        
            //speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            speechUtterance.rate = rate
            speechUtterance.pitchMultiplier = pitch
            speechUtterance.volume = volume
        
            speechSynthesizer.speak(speechUtterance)
        }
        
    // Mark: - Registering Defaults
        func registerDefaultSettings() {
            rate = AVSpeechUtteranceDefaultSpeechRate
            pitch = 1
            volume = 1.0
            
            let defaultSpeechSettings: [NSObject : AnyObject] = ["rate" as NSObject: rate as AnyObject, "pitch" as NSObject: pitch as AnyObject, "volume" as NSObject: volume as AnyObject]
            
            UserDefaults.standard.register(defaults: defaultSpeechSettings as! [String : Any])
        }
        
   // Mark: - Load Setting
        func loadSettings() -> Bool {
            let myUserDefaults = UserDefaults.standard
            
            if let theRate:   Float = myUserDefaults.value(forKey: "rate"  ) as? Float,
               let thePitch:  Float = myUserDefaults.value(forKey: "pitch" ) as? Float,
               let theVolume: Float = myUserDefaults.value(forKey: "volume") as? Float
            {
                rate = theRate
                pitch = thePitch
                volume = theVolume
                return true
            }
            return false
        }//end of method
        
    }
