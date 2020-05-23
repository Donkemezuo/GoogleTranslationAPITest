//
//  GoogleTranslationTestAPIClient.swift
//  GoogleTranslationTest
//
//  Created by Donkemezuo Raymond Tariladou on 2/17/20.
//  Copyright © 2020 EnProTech Group. All rights reserved.
//

import Foundation

class TranslationAPIclient {
    static let shared = TranslationAPIclient() // This will allow us use this class as a singleton class
    
    private let googleTranslationAPIKey = "AIzaSyAuVvypNuYrwq5iV0KApkuFo4e6XJnmbI0"
    var sourceLanguageCode: String?
    var textToTranslate: String?
    var targetLanguageCode: String?
    
    
    var supportedLanguages = [TranslationLanguage]()
    
    private func makeRequest(usingTranslationAPI api: TranslationAPI, withURLParagram urlParagrams: [String: String], completionHandler: @escaping(Error?,_ results: [String: Any]?) -> Void) {
        // The api will help us determine which type of HTTP request we are making and which endpoint we are using
        
        if var components = URLComponents(string: api.getURL()) {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in urlParagrams {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            if let url = components.url {
                var request = URLRequest(url: url)
                request.httpMethod = api.getHTTPMethod()
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completionHandler(error, nil)
                    } else if let response = response as? HTTPURLResponse, let result = data {
                        if response.statusCode == 200 || response.statusCode == 201 {
                            do {
                                
                                if let resultDict = try JSONSerialization.jsonObject(with: result, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                                    completionHandler(nil, resultDict)
                                }
                                
                            } catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            completionHandler(error, nil)
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func detectTextLanguage(fromText text: String, completionHandler: @escaping(Error?, String?) -> Void) {
        
        let urlParams = ["key": googleTranslationAPIKey, "q": text]
        
        makeRequest(usingTranslationAPI: .detectLanguage, withURLParagram: urlParams) { (error, results) in
            if let error = error {
                completionHandler(error, nil)
            } else if let results = results {
                
                if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                    var detectedLanguages = [String]()
                    
                    for detection in detections {
                        for currentDetection in detection {
                            if let language = currentDetection["language"] as? String {
                                detectedLanguages.append(language)
                            }
                        }
                    }
                    
                    
                    if detectedLanguages.count > 0 {
                        self.sourceLanguageCode = detectedLanguages.first
                        completionHandler(nil, detectedLanguages[0])
                    } else {
                         completionHandler(error, nil)
                    }
                    
                    
                } else {
                    completionHandler(error, nil)
                }
            }
        }
    }
    
    func fetchSupportedLanguages(completionHandler: @escaping(Error?, [TranslationLanguage]?) -> Void) {
        var urlParams = [String:String]()
        urlParams["key"] = googleTranslationAPIKey
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        makeRequest(usingTranslationAPI: .supportedLanguages, withURLParagram: urlParams) { (error, results) in
            if let error = error {
                completionHandler(error, nil)
            } else if let results = results {
                if let data = results["data"] as? [String: Any], let languages = data["languages"] as? [[String: Any]] {
                    
                    for language in languages {
                        var languageCode: String?
                        var languageName: String?
                        
                        if let code = language["language"] as? String {
                            languageCode = code
                        }
                        
                        if let name = language["name"] as? String {
                            languageName = name
                        }
                        
                        self.supportedLanguages.append(TranslationLanguage(code: languageCode, name: languageName))
                    }
                
                    completionHandler(nil, self.supportedLanguages)
                    
                } else {
                    completionHandler(error, nil)
                }
            }
        }
        
    }
    
    func translateText(completionHandler: @escaping( _ translations: String?) -> Void) {
        guard let textTotranslate = textToTranslate, let targetLanguageCode = targetLanguageCode else {return}
        var urlParams = [String: String]()
        urlParams["key"] = googleTranslationAPIKey
        urlParams["q"] = textTotranslate
        urlParams["target"] = targetLanguageCode
        urlParams["format"] = "text"
        
        if let sourceLanguage = sourceLanguageCode {
            urlParams["source"] = sourceLanguage
        }
        
        makeRequest(usingTranslationAPI: .translate, withURLParagram: urlParams) { (error, result) in
            if error != nil {
                completionHandler(nil)
            } else if let result = result {
                
                if let data = result["data"] as? [String: Any], let translations = data["translations"] as? [[String: Any]] {
                    
                    var allTranslations = [String]()
                    
                    for translation in translations {
                        if let translatedText = translation["translatedText"] as? String {
                            allTranslations.append(translatedText)
                        }
                    }
                    
                    if allTranslations.count > 0 {
                        completionHandler(allTranslations.first)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
                
            }
        }
    }
    
    
    
}

struct TranslationLanguage {
    var code: String?
    var name: String?
}
