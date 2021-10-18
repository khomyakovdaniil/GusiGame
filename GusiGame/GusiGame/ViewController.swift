//
//  ViewController.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gu1: UIView!
    @IBOutlet weak var si2: UIView!
    @IBOutlet weak var li3: UIView!
    @IBOutlet weak var sa4: UIView! // Cards with syllables
    
    @IBOutlet weak var slot: UIView!
    @IBOutlet weak var slot2: UIView! // Slots
    
    @IBOutlet weak var lisaImage: UIImageView!
    @IBOutlet weak var gusiImage: UIImageView! // Images
    
    var originalCenterGu = CGPoint()
    var originalCenterSi = CGPoint()
    var originalCenterLi = CGPoint()
    var originalCenterSa = CGPoint() // The original position of each card
    
    var leftSlot = "" //Indicates which card is in the left slot
    var rightSlot = "" //Indicates which card is in the right slot
    
    var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalCenterGu = gu1.center
        originalCenterSi = si2.center
        originalCenterLi = li3.center
        originalCenterSa = sa4.center // Saves the original position of cards
        lisaImage.isHidden = true
        gusiImage.isHidden = true
    }
    
    @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer){
        guard gestureRecognizer.view != nil else {return}
        
        let piece = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: piece.superview)
        
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }// Save the view's original position
        
        
        if gestureRecognizer.state != .cancelled {
            
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            // Add the X and Y translation to the view's original position.
            
            func cardText() -> String{
                switch piece.tag{
                case 1:
                    return "Gu"
                case 2:
                    return "Si"
                case 3:
                    return "Li"
                case 4:
                    return "Sa"
                default:
                    return "none"
                }
            } // Indicates which syllable is in the current moving card
            if abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50{
                leftSlot = cardText()
            }
            if abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50{
                rightSlot = cardText()
            } //Saves cards syllable to the slot
        }
        else {
            piece.center = initialCenter
        } // On cancellation, return card to its initial location.
        
        if gestureRecognizer.state == .ended {
            func originalCenter() -> CGPoint {
                switch piece.tag{
                case 1:
                    return originalCenterGu
                case 2:
                    return originalCenterSi
                case 3:
                    return originalCenterLi
                case 4:
                    return originalCenterSa
                default:
                    return originalCenterGu
                }
            }
            if ((abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50) || (abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50)) == false {
                piece.center = originalCenter()
            } // On the end of movement return the card to its original location, if it was not moved into the slot
        }
        
    }
    @IBAction func CheckButton(_ sender: UIButton) { //Checks the slots, displays image, destroys cards
        switch leftSlot + rightSlot {
        case "GuSi":
            gusiImage.isHidden = false
            leftSlot = ""
            rightSlot = ""
            gu1.removeFromSuperview()
            si2.removeFromSuperview()
            
            
        case "LiSa":
            lisaImage.isHidden = false
            leftSlot = ""
            rightSlot = ""
            li3.removeFromSuperview()
            sa4.removeFromSuperview()
            
        default:
            sender.setTitle("Неправильно", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                sender.setTitle("Проверить", for: .normal)
            }
        }
    }
}


