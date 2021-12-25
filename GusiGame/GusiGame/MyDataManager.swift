//
//  Resource.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 18.10.2021.
//

import Foundation
import UIKit

    // MARK: - Protocols

protocol Word {
    var leftSyllable: String { get }
    var rightSyllable: String { get }
    var fullWord: String { get }
    var image: UIImage! { get }
}

protocol DataManager {
    func getList() -> [Word]
}

struct RussianWord: Word {
    let leftSyllable: String
    let rightSyllable: String
    var fullWord: String {return leftSyllable + rightSyllable}
    var image: UIImage!
    init(firstSyllable: String, secondSyllable: String, image: UIImage) {
        self.leftSyllable = firstSyllable
        self.rightSyllable = secondSyllable
        self.image = image
    }
}


class MyDataManager : DataManager {
    
    func getImage (named name : String) -> UIImage?
        {
        let bundle = Bundle.main
        guard let imgPath = bundle.path(forResource: name, ofType: "jpg") else { fatalError("122") }
        return UIImage(contentsOfFile: imgPath)
        }
    
    func getList() -> [Word] {
        
        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "words", ofType: "json") else { return [] }
        guard let content = try? String(contentsOfFile: path), let data = content.data(using: .utf8) else { return [] }
        var jsonObjects: [JsonWord]!
            jsonObjects = try? JSONDecoder().decode([JsonWord].self, from: data)
        
        let words = jsonObjects.map {
            RussianWord(firstSyllable: $0.leftSyllable, secondSyllable: $0.rightSyllable, image: getImage(named: $0.picName)!)
            
        }
        return words
    }
}

struct JsonWord: Codable {
    let leftSyllable: String
    let rightSyllable: String
    let picName: String
}
