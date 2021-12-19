//
//  SyllableCell.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 19.12.2021.
//

import UIKit

class SyllableCell: UICollectionViewCell {
    // MARK - Outlets
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Public
    var left: Bool = false //FIXME: - убрать
    var title: String {
        get {
            return titleLabel.text!
        }
        set {
            titleLabel.text = newValue
        }
    }


    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 5
        backgroundColor = .green
    }

    // MARK: - Private

    
}
