//
//  SyllableCell.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 27.11.2021.
//

import UIKit

class SyllableCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var syllableLabel: UILabel!
    
    // MARK: - Internal
    
    var left = true
    
    // MARK: - Initializer
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
