//
//  ViewController.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 02.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loadingSpinnerView: UIActivityIndicatorView!
    
    @IBOutlet weak var leftSyllablesCollectionView: UICollectionView!
    @IBOutlet weak var rightSyllablesCollectionView: UICollectionView!
    
    @IBOutlet weak var slot: SlotView!
    @IBOutlet weak var slot2: SlotView!
    
    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main
        let cellNib = UINib(nibName: "SyllableCell", bundle: bundle)
        
        leftSyllablesCollectionView.register(cellNib, forCellWithReuseIdentifier: cellID)
        leftSyllablesCollectionView.dataSource = self
        leftSyllablesCollectionView.delegate = self
        leftSyllablesCollectionView.clipsToBounds = false
        
        rightSyllablesCollectionView.register(cellNib, forCellWithReuseIdentifier: cellID)
        rightSyllablesCollectionView.dataSource = self
        rightSyllablesCollectionView.delegate = self
        rightSyllablesCollectionView.clipsToBounds = false
        
        resultImage.isHidden = true
        
        loadingSpinnerView.hidesWhenStopped = true
        loadingSpinnerView.stopAnimating()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        originalCentersLeft = leftSyllablesCollectionView.subviews.map{$0.center}
        originalCentersRight = rightSyllablesCollectionView.subviews.map{$0.center}
        
    }
    
    // MARK: - Actions
    
    @IBAction private func SlotsChecked(_ sender: UIButton) {
        
        self.webRequest.getMeaning(word: self.leftSlot+self.rightSlot) {[weak self] meaning in
            guard let strongSelf = self else { return }
            strongSelf.loadingSpinnerView.startAnimating()
            strongSelf.checkWord(leftSlot: strongSelf.leftSlot, rightSlot: strongSelf.rightSlot)
            strongSelf.loadingSpinnerView.stopAnimating()
            strongSelf.changeTitle(checkCounter: strongSelf.checkCounter, meaning: meaning)
        }
    }
    
    // MARK: - Private constants
    
    private let dataManager: DataManager = MyDataManager()
    private let webRequest: WebRequest = MyWebRequest()
    private let cellID = "SyllableCell"
    
    // MARK: - Private
    
    private var originalCentersLeft: [CGPoint] = []// The original position of each card
    private var originalCentersRight: [CGPoint] = []// The original position of each card
    
    private var leftSlot = "" //Indicates which card is in the left slot
    private var rightSlot = "" //Indicates which card is in the right slot
    
    private var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    private lazy var words: [Word] = dataManager.getList()
    private lazy var leftSyllables: [String] = words.compactMap {$0.leftSyllable}
    private lazy var rightSyllables: [String] = words.shuffled().compactMap {$0.rightSyllable}
    
    private var meaning: String = " "
    private var checkCounter = 0
    
    // MARK: - Private functions
    
    private func checkWord(leftSlot: String, rightSlot: String) {
        self.words.enumerated().forEach {(indexOfWord, word) in
            checkCounter += 1
            if self.leftSlot + self.rightSlot == word.fullWord {
                checkCounter = 0
                self.resultImage.image = word.image
                self.resultImage.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.resultImage.isHidden = true
                }
                self.leftSlot = ""
                self.rightSlot = ""
            }
        }
    }
    
    private func changeTitle(checkCounter: Int, meaning: String) {
        if checkCounter > words.count {
            checkButton.setTitle("Неправильно", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.checkButton.setTitle("Проверить", for: .normal)
            }
        } else {checkButton.setTitle(meaning, for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.checkButton.setTitle("Проверить", for: .normal)
            }
        }
        self.checkCounter = 0
    }
    
    @objc private func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let piece = gestureRecognizer.view! as! SyllableCell
        switch gestureRecognizer.state {
        case .began:
            self.initialCenter = piece.center
        case .changed:
            let translation = gestureRecognizer.translation(in: piece.superview)
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            piece.center = newCenter
        default:
            handleEndOfGesture(piece: piece)
        }
    }
    
    private func handleEndOfGesture(piece: SyllableCell) {
        if slot.frame.contains(piece.center) && piece.left {
            if leftSlot.count > 1 {
                    leftSyllables.append(leftSlot)
                }
            leftSlot = piece.syllableLabel.text!
            leftSyllables.remove(at: leftSyllables.firstIndex(of: leftSlot)!)
            leftSyllablesCollectionView.reloadSections(IndexSet(integer: 0))
            slot.slotLabel.text = leftSlot
        } else if slot2.frame.contains(convertRightCollectionCoordinates(coordinates: piece.center)) && !piece.left {
            if rightSlot.count > 1 {
                    rightSyllables.append(rightSlot)
                }
            rightSlot = piece.syllableLabel.text!
            rightSyllables.remove(at: rightSyllables.firstIndex(of: rightSlot)!)
            rightSyllablesCollectionView.reloadSections(IndexSet(integer: 0))
            slot2.slotLabel.text = rightSlot
        } else if piece.left {
            piece.center = originalCentersLeft[leftSyllablesCollectionView.indexPath(for: piece)!.item]
        } else if !piece.left {
            piece.center = originalCentersRight[rightSyllablesCollectionView.indexPath(for: piece)!.item]
        }
    }
    
    private func convertRightCollectionCoordinates(coordinates: CGPoint) -> CGPoint {
        let convertedCoordinates = CGPoint(x: coordinates.x + rightSyllablesCollectionView.frame.origin.x, y: coordinates.y)
        return convertedCoordinates
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.leftSyllablesCollectionView {
        return leftSyllables.count
        } else {
            return rightSyllables.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.leftSyllablesCollectionView {
            guard let cell = leftSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
            cell.syllableLabel.text = leftSyllables[indexPath.item]
            cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gestureRecognizer:))))
            cell.left = true
            return cell
        } else {
            guard let cell = rightSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
            cell.syllableLabel.text = rightSyllables[indexPath.item]
            cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gestureRecognizer:))))
            cell.left = false
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return CGFloat(5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        return insets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 65, height: 65)
    }
}

