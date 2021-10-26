//
//  SyllableView.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 22.10.2021.
//

import UIKit

class SyllableView: UIView {

    @IBOutlet weak var title: UILabel!
    
    

    var view: UIView!
    var nibName: String = "SyllableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func setup(text: String, leftSyllable: Bool) {
        view = loadFromNib()
        view.frame = bounds
        view.backgroundColor = leftSyllable ? UIColor.systemGreen : UIColor.systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.title.text = text
        self.title.font = UIFont.systemFont(ofSize: 80)
        self.title.adjustsFontSizeToFitWidth = true
        
        addSubview(view)
        view.widthAnchor.constraint(equalToConstant: 120).isActive = true
        view.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
