//
//  ViewController.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var leftSyllables: [SyllableView]!
    @IBOutlet var rightSyllables: [SyllableView]!// Cards with syllables
    
    @IBOutlet weak var slot: UIView!
    @IBOutlet weak var slot2: UIView! // Slots
    
    @IBOutlet weak var resultImage: UIImageView! // Result Image
    
    var originalCenters = [CGPoint()]// The original position of each card
    
    var leftSlot = "" //Indicates which card is in the left slot
    var rightSlot = "" //Indicates which card is in the right slot
    
    var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    let words = DataManager().getList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var lSsetupCounter = 0
        for syllable in leftSyllables {
            syllable.setup(text: words[lSsetupCounter].leftSyllable, leftSyllable: true)
            originalCenters.append(syllable.center)
            lSsetupCounter += 1
        }
        
        var rSsetupCounter = 0
        for syllable in rightSyllables {
            syllable.setup(text: words[rSsetupCounter].rightSyllable, leftSyllable: false)
            originalCenters.append(syllable.center)
            rSsetupCounter += 1
        }
        
        resultImage.isHidden = true
    }
    
    @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer){
        guard gestureRecognizer.view != nil else {return}
        
        let piece = gestureRecognizer.view! as! SyllableView
        
        let translation = gestureRecognizer.translation(in: piece.superview)
        
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }// Save the view's original position
        
        
        if gestureRecognizer.state != .cancelled {
            
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            // Add the X and Y translation to the view's original position.
            
            if abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50{
                leftSlot = piece.title.text!
            }
            if abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50{
                rightSlot = piece.title.text!
            } //Saves cards syllable to the slot
        }
        else {
            piece.center = initialCenter
        } // On cancellation, return card to its initial location.
        
        if gestureRecognizer.state == .ended {
            if ((abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50) || (abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50)) == false {
                piece.center = originalCenters[piece.tag]
            } // On the end of movement return the card to its original location, if it was not moved into the slot
        }
        
    }
    @IBAction func CheckButton(_ sender: UIButton) { //Checks the slots, displays image, destroys cards
        
        var checkCounter = 1
        for word in words {
            checkCounter += 1
            if leftSlot + rightSlot == word.fullWord {
                self.resultImage.image = word.image
                self.resultImage.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.resultImage.isHidden = true
                }
                leftSlot = ""
                rightSlot = ""
                let indexOfWord = words.firstIndex(of: word)!
                leftSyllables[indexOfWord].removeFromSuperview()
                rightSyllables[indexOfWord].removeFromSuperview()
                checkCounter = 0
            }
            if checkCounter > 9 {
                sender.setTitle("Неправильно", for: .normal)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    sender.setTitle("Проверить", for: .normal)
                }
            }

        }
    }
}


