//
//  WebRequest.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 24.11.2021.
//

import Foundation
import UIKit

protocol WebRequest {
    func getMeaning(word: String) -> String
}

class MyWebRequest: WebRequest {
    func getMeaning(word: String) -> String {
        let mySerialQueue = DispatchQueue.global(qos: .utility)
        var word = word
        var meaning = "x"
        print("раз")
        let searchWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlString =  "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20211105T174310Z.cb74ff4cbc3d14c3.e5957bf9a12beffb3d9cf0bfec4639c57da4c431&lang=ru-ru&text=" + searchWord
        let request = URLRequest(url: URL(string: urlString)!)
        mySerialQueue.sync{
            URLSession.shared.dataTask(with: request) { (data, responce, error) in
            do {
                let wordDataFromWeb = try JSONDecoder().decode(WebWord.self, from: data!)
                meaning = wordDataFromWeb.def[0].tr[0].text
                print(meaning + "get")
                print("два")
            } catch let error {
                print(error)
            }
        }.resume()
        }
        print(meaning + "set")
        print("три")
        return meaning
    }
}

