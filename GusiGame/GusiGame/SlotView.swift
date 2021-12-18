//
//  SlotView.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 18.12.2021.
//

import UIKit

class SlotView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var slotLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit(){
        let nibName = "SlotView"
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        slotLabel.text = ""
    }
}
