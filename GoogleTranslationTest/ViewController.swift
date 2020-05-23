//
//  ViewController.swift
//  GoogleTranslationTest
//
//  Created by Donkemezuo Raymond Tariladou on 2/17/20.
//  Copyright © 2020 EnProTech Group. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var allSupportedLanguages = [TranslationLanguage]()
    var languageCode = ""
    var speechSynthensizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
      // testLanguageDetection()
     // testTextToSpeech()
        translateText()
      // fetchAllSupportedLanguages()
        
        
        // Do any additional setup after loading the view.
    }

    // AIzaSyAuVvypNuYrwq5iV0KApkuFo4e6XJnmbI0

    
    private func testLanguageDetection(){
        
        TranslationAPIclient.shared.detectTextLanguage(fromText: "mo nifẹ rẹ") { (error, language) in
            if let error = error {
                print(error.localizedDescription)
            } else if let detectedLanguage = language {
                self.languageCode = detectedLanguage
                self.fetchAllSupportedLanguages()
               // print(self.getLanguageName(withLanguageCode: detectedLanguage))
            }
        }
        
    }
    
    private func fetchAllSupportedLanguages(){
        TranslationAPIclient.shared.fetchSupportedLanguages { (error, translatedLanguages) in
            if let error = error {
                print(error.localizedDescription)
            } else if let languages = translatedLanguages {
                self.allSupportedLanguages = languages
               // dump(self.allSupportedLanguages)
            }
        }
    }
    
    private func getLanguageName(withLanguageCode code: String) -> String? {
        var codeName: String?
        for language in allSupportedLanguages {
            if language.code == languageCode {
                codeName = language.name
            }
        }
        return codeName
    }
    
    private func testTextToSpeech(){
        let speechUtterance = AVSpeechUtterance(string: "This is the last test for english")
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-NG")
        speechSynthensizer.speak(speechUtterance)
    }
    
    private func translateText() {
        TranslationAPIclient.shared.textToTranslate = "mo nifẹ rẹ"
        TranslationAPIclient.shared.sourceLanguageCode = "en"
        TranslationAPIclient.shared.translateText { (text) in
            print(text)
        }
    }
    
    
    
}

