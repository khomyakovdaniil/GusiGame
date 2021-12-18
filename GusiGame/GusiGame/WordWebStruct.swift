//
//  WordWebStruct.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 08.11.2021.
//

import Foundation

struct Translation: Codable {
    var text: String
}
struct Define: Codable {
    let tr: [Translation]
}
struct WebWord: Codable {
    let def: [Define]
}



