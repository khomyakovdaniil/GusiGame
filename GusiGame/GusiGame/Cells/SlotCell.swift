//
//  SlotCell.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 26.12.2021.
//

import UIKit

class SlotCell: UICollectionViewCell {

    // MARK - Outlets
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - Public
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
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 5
        contentView.backgroundColor = .green
        backgroundColor = .clear
    }
}
