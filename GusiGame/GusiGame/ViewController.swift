//
//  ViewController.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftSyllablesCollectionView: UICollectionView!
    @IBOutlet var leftSyllables: [SyllableView]!
    @IBOutlet var rightSyllables: [SyllableView]!// Cards with syllables
    
    
    @IBOutlet weak var slot: UIView!
    @IBOutlet weak var slot2: UIView! // Slots
    
    @IBOutlet weak var resultImage: UIImageView! // Result Image
    
    // @IBOutlet weak var checkButton // - FIXME сделать обращение к тексту кнопки для вывода значения полученного с сервера
    
    private let dataManager: DataManager = MyDataManager()
    
    var originalCenters = [CGPoint()]// The original position of each card
    
    var leftSlot = "" //Indicates which card is in the left slot
    var rightSlot = "" //Indicates which card is in the right slot
    
    var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    var meaning: String = " "
    
    lazy var words: [Word] = dataManager.getList()
    
    private let cellID = "SyllableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle.main
        let cellNib = UINib(nibName: "SyllableCell", bundle: bundle)
        leftSyllablesCollectionView.register(cellNib, forCellWithReuseIdentifier: cellID)
        leftSyllablesCollectionView.dataSource = self
        leftSyllablesCollectionView.delegate = self
        leftSyllablesCollectionView.clipsToBounds = false
        
        
        
        resultImage.isHidden = true
    }
    
    @objc func handleLongGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        
        let piece = gestureRecognizer.view! as! SyllableCell
        
        let label = piece.syllableLabel!
        
        var indexOfPiece: Int {
            var index = 0
            if piece.left! {
                words.enumerated().forEach {(indexOfWord, word) in
                    if word.leftSyllable == label.text {
                        index = indexOfWord + 1
                    }
                }
            } else {
                words.enumerated().forEach {(indexOfWord, word) in
                    if word.rightSyllable == label.text {
                        index = indexOfWord + words.count + 1
                    }
                }
            }
            return index
        }
        
        
        
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }// Save the view's original position
        
        
        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: piece.superview)
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            // Add the X and Y translation to the view's original position.
        }
        
        if gestureRecognizer.state != .began && gestureRecognizer.state != .changed {
            
            if slot.frame.contains(piece.center){
                leftSyllables.enumerated().forEach {(index, syllable) in
                    if syllable.center == slot.center {
                        syllable.center = originalCenters[index+1]
                    }
                }
                leftSlot = piece.syllableLabel.text!
                piece.center = slot.center
            } else if slot2.frame.contains(piece.center){
                rightSyllables.enumerated().forEach {(index, syllable) in
                    if syllable.center == slot2.center {
                        syllable.center = originalCenters[index+1+words.count]
                    }
                }
                rightSlot = piece.syllableLabel.text!
                piece.center = slot2.center
            } else {
                piece.center = originalCenters[indexOfPiece]
            }//Saves cards syllable to the slot
            
            //     if ((abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50) || (abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50)) == false {
            //         piece.center = originalCenters[indexOfPiece]
            //      } // On the end of movement return the card to its original location, if it was not moved into the slot
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        leftSyllablesCollectionView.subviews.enumerated().forEach {(indexOfSyllable, syllable) in
                originalCenters.append(syllable.center)
        }
        rightSyllables.enumerated().forEach {(indexOfSyllable, syllable) in
            if indexOfSyllable < words.count {
                syllable.setup(text: words[indexOfSyllable].rightSyllable, leftSyllable: false)
                originalCenters.append(syllable.center)
            } else {
                rightSyllables[indexOfSyllable].removeFromSuperview()
            }
        }
    }
    
    @IBAction func panPiece(_ gestureRecognizer : UIPanGestureRecognizer){
        guard gestureRecognizer.view != nil else {return}
        
        let piece = gestureRecognizer.view! as! SyllableView
        
        let label = piece.subviews[0].subviews[0] as! UILabel
        
        var indexOfPiece: Int {
            var index = 0
            if piece.left! {
                words.enumerated().forEach {(indexOfWord, word) in
                    if word.leftSyllable == label.text {
                        index = indexOfWord + 1
                    }
                }
            } else {
                words.enumerated().forEach {(indexOfWord, word) in
                    if word.rightSyllable == label.text {
                        index = indexOfWord + words.count + 1
                    }
                }
            }
            return index
        }
        
        
        
        if gestureRecognizer.state == .began {
            self.initialCenter = piece.center
        }// Save the view's original position
        
        
        if gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: piece.superview)
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
            // Add the X and Y translation to the view's original position.
        }
        
        if gestureRecognizer.state != .began && gestureRecognizer.state != .changed {
            
            if slot.frame.contains(piece.center){
                leftSyllablesCollectionView.subviews.enumerated().forEach {(index, syllable) in
                    if syllable.center == slot.center {
                        syllable.center = originalCenters[index+1]
                    }
                }
                leftSlot = piece.title.text!
                piece.center = slot.center
            } else if slot2.frame.contains(piece.center){
                rightSyllables.enumerated().forEach {(index, syllable) in
                    if syllable.center == slot2.center {
                        syllable.center = originalCenters[index+1+words.count]
                    }
                }
                rightSlot = piece.title.text!
                piece.center = slot2.center
            } else {
                piece.center = originalCenters[indexOfPiece]
            }//Saves cards syllable to the slot
            
            //     if ((abs(piece.center.x-slot.center.x)<50 && abs(piece.center.y-slot.center.y)<50) || (abs(piece.center.x-slot2.center.x)<50 && abs(piece.center.y-slot2.center.y)<50)) == false {
            //         piece.center = originalCenters[indexOfPiece]
            //      } // On the end of movement return the card to its original location, if it was not moved into the slot
        }
        
    }
    @IBAction func CheckButton(_ sender: UIButton) { // - FIXME переименовать по действию Checks the slots, displays image, destroys cards
        
        var checkCounter = 1
        var resultWordIndex = 0
        requestMeaningFromWeb(word: leftSlot+rightSlot)
        
        words.enumerated().forEach {(indexOfWord, word) in
            checkCounter += 1
            if leftSlot + rightSlot == word.fullWord {
                self.resultImage.image = word.image
                self.resultImage.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.resultImage.isHidden = true
                }
                leftSlot = ""
                rightSlot = ""
                leftSyllables[indexOfWord].removeFromSuperview()
                rightSyllables[indexOfWord].removeFromSuperview()
                checkCounter = 0
                resultWordIndex = indexOfWord
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // ~FIXME переделать эту дичь
                if checkCounter > self.words.count {
                    sender.setTitle("Неправильно", for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        sender.setTitle("Проверить", for: .normal)
                    }
                } else {  sender.setTitle(self.meaning, for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        sender.setTitle("Проверить", for: .normal)
                    }
                }
            }
        }
        
        func requestMeaningFromWeb(word: String){
            var word = word
            let searchWord = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let urlString =  "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20211105T174310Z.cb74ff4cbc3d14c3.e5957bf9a12beffb3d9cf0bfec4639c57da4c431&lang=ru-ru&text=" + searchWord
            let request = URLRequest(url: URL(string: urlString)!)
            let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
                do {
                    let wordDataFromWeb = try JSONDecoder().decode(WebWord.self, from: data!)
                    self.meaning = wordDataFromWeb.def[0].tr[0].text ?? "i"
                    print(self.meaning + "23")
                } catch let error {
                    print(error)
                }
                
            }
            task.resume()
        }
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = leftSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
        cell.syllableLabel.text = words[indexPath.item].leftSyllable
        cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gestureRecognizer:))))
        cell.left = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

