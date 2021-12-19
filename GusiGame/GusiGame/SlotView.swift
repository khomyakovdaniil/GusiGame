//
//  SlotView.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 18.12.2021.
//

import UIKit

class SlotView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet private var slotLabel: UILabel!
    
    // MARK: - Public
    var title: String = "" {
        didSet {
            slotLabel.text = title
            updateView()
        }
    }
    
    // MARK: - Private
    private func updateView() {
        if title.isEmpty {
            slotLabel.backgroundColor = #colorLiteral(red: 0.2129294574, green: 0.3743387461, blue: 0.8922179937, alpha: 1)
        } else {
            slotLabel.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        }
    }
    
    // MARK: - Initializer
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
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.masksToBounds = true
    }
}
