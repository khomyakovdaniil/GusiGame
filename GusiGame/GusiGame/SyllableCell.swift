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
        self.syllableLabel.font = UIFont(name: "System", size: syllableLabel.frame.height/2)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // Initialization code
    }
}
