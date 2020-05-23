//
//  GoogleTranslationAPI.swift
//  GoogleTranslationTest
//
//  Created by Donkemezuo Raymond Tariladou on 2/17/20.
//  Copyright © 2020 EnProTech Group. All rights reserved.
//

import Foundation


//var tranlationKey = "AIzaSyAuVvypNuYrwq5iV0KApkuFo4e6XJnmbI0"


enum TranslationAPI {
    case detectLanguage
    case translate
    case supportedLanguages
    
    
    
    func getURL() -> String { // This method returns the right url endpoint base of what we are trying to do
        var urlString = ""
        
        switch self {
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"
        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"
        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
            }
            return urlString
        }
    
    // Creating the method that determines the right HTTP network call to me
    // To get the supported langauges, we use the "GET" while we use the "POST" to translate and detect Language

    func getHTTPMethod() -> String {
        if self == .supportedLanguages {
            return "GET"
        } else {
            return "POST"
        }
    }
    
    }



    

