//
//  SyllableCell.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 19.12.2021.
//

import UIKit

class SyllableCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    
    var left: Bool = false
    var title: String = String() {
        didSet {
            titleLabel.text = title
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 5
        backgroundColor = .green
    }

    
}
