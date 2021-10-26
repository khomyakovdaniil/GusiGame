//
//  Resource.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 18.10.2021.
//

import Foundation
import UIKit


protocol ForWord {
    var leftSyllable: String { get }
    var rightSyllable: String { get }
    var fullWord: String { get }
    var image: UIImage! { get }
}

protocol ForDataManager {
    func getList() -> [Word]
}

struct Word: ForWord, Equatable {
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

class DataManager {
    
    private let gusi = Word(firstSyllable: "Гу", secondSyllable: "Си", image: UIImage(named: "Gusi")!)
    
    private let lisa = Word(firstSyllable: "Ли", secondSyllable: "Са", image: UIImage(named: "Lisa")!)
    
    private let nosok = Word(firstSyllable: "Но", secondSyllable: "Сок", image: UIImage(named: "Nosok")!)
    
    private let sanki = Word(firstSyllable: "Сан", secondSyllable: "Ки", image: UIImage(named: "Sanki")!)
    
    private let sapog = Word(firstSyllable: "Са", secondSyllable: "Пог", image: UIImage(named: "Sapog")!)
    
    private let seno = Word(firstSyllable: "Се", secondSyllable: "Но", image: UIImage(named: "Seno")!)
    
    private let sinok = Word(firstSyllable: "Сы", secondSyllable: "Нок", image: UIImage(named: "Sinok")!)
    
    private let sito = Word(firstSyllable: "Си", secondSyllable: "То", image: UIImage(named: "Sito")!)
    
    private let sovi = Word(firstSyllable: "Со", secondSyllable: "Вы", image: UIImage(named: "Sovi")!)
    
    func getList() -> [Word] {
        let Words = [gusi, lisa, nosok, sanki, sapog, seno, sinok, sito, sovi]
        return Words
    }
}
