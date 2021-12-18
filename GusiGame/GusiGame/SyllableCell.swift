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
<<<<<<< Updated upstream
        syllableLabel.adjustsFontSizeToFitWidth = true
=======
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 5
        contentView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
>>>>>>> Stashed changes
        // Initialization code
    }
}
