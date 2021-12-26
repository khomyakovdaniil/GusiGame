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
    var title: String {
        get {
            return titleLabel.text!
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    func setVisibility(_ visibility: Bool ) {
        contentView.isHidden = !visibility
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

    // MARK: - Private

    
}
