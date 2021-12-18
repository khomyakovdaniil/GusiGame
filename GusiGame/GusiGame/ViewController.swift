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
    
    private let lineSpacingForCollection = CGFloat(5)
    private let insetsForCollection = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    private let cellSize = CGSize(width: 65, height: 65)
    
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
                self.slot.slotLabel.text = ""
                self.slot.contentView.backgroundColor = #colorLiteral(red: 0.2129294574, green: 0.3743387461, blue: 0.8922179937, alpha: 1)
                self.slot2.slotLabel.text = ""
                self.slot2.contentView.backgroundColor = #colorLiteral(red: 0.2129294574, green: 0.3743387461, blue: 0.8922179937, alpha: 1)
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
        guard let piece = gestureRecognizer.view as? SyllableCell else { fatalError("Couldn't downcast piece")}
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
            clearLeftSlot(piece: piece)
            setCardInLeftSlot()
        } else if slot2.frame.contains(convertRightCollectionCoordinates(coordinates: piece.center)) && !piece.left {
            clearRightSlot(piece: piece)
            setCardInRightSlot()
        } else if piece.left {
            guard let indexPath = leftSyllablesCollectionView.indexPath(for: piece) else { fatalError("Couldn't find indexPath for piece")}
            piece.center = originalCentersLeft[indexPath.item]
        } else if !piece.left {
            guard let indexPath = rightSyllablesCollectionView.indexPath(for: piece) else { fatalError("Couldn't find indexPath for piece")}
            piece.center = originalCentersRight[indexPath.item]
        }
    }
    
    private func clearLeftSlot(piece: SyllableCell) {
        guard let syllable = piece.syllableLabel.text else { fatalError("Couldn't unwrapp piece.syllableLabel.text") }
        if !leftSlot.isEmpty {
            guard let index = leftSyllables.firstIndex(of: syllable) else { fatalError("Couldn't find index of piece") }
            leftSyllables.insert(leftSlot, at: index)
        }
        leftSlot = syllable
    }
    
    private func setCardInLeftSlot() {
        guard let index = leftSyllables.firstIndex(of: leftSlot)  else { fatalError("Couldn't find index of leftSlot") }
        leftSyllables.remove(at: index)
        leftSyllablesCollectionView.reloadSections(IndexSet(integer: 0))
        slot.slotLabel.text = leftSlot
        slot.contentView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
    private func clearRightSlot(piece: SyllableCell) {
        guard let syllable = piece.syllableLabel.text  else { fatalError("Couldn't unwrapp piece.syllableLabel.text") }
        if !rightSlot.isEmpty{
            guard let index = rightSyllables.firstIndex(of: syllable) else { fatalError("Couldn't find index of piece") }
            rightSyllables.insert(rightSlot, at: index)
        }
        rightSlot = syllable
    }
    
    private func setCardInRightSlot() {
        guard let index = rightSyllables.firstIndex(of: rightSlot)  else { fatalError("Couldn't find index of leftSlot") }
        rightSyllables.remove(at: index)
        rightSyllablesCollectionView.reloadSections(IndexSet(integer: 0))
        slot2.slotLabel.text = rightSlot
        slot2.contentView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
        return lineSpacingForCollection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetsForCollection
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return cellSize
    }
}

