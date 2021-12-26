//
//  AnimationView.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 26.12.2021.
//

import UIKit

class AnimationView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Public
    var title: String {
        get {
            return titleLabel.text!
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        let view = Bundle.main.loadNibNamed("AnimationView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.backgroundColor = .green
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 5
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.masksToBounds = true
        addSubview(view)
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
