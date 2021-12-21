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
    
    @IBOutlet weak var leftSlotView: UICollectionView!
    @IBOutlet weak var slot2: SlotView!
    
    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main
        let cellNib = UINib(nibName: "SyllableCell", bundle: bundle)
        
        leftSlotView.register(cellNib, forCellWithReuseIdentifier: cellID)
        leftSlotView.dataSource = self
        leftSlotView.dragInteractionEnabled = true
        leftSlotView.dragDelegate = self
        leftSlotView.dropDelegate = self
        leftSlotView.delegate = self
        leftSlotView.clipsToBounds = false
        
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
    
    private var leftSlot = "xx" //Indicates which card is in the left slot
    private var rightSlot = "" //Indicates which card is in the right slot
    
    private var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    private lazy var words: [Word] = dataManager.getList()
    private lazy var leftSyllables: [String] = words.compactMap {$0.leftSyllable}
    private lazy var rightSyllables: [String] = words.shuffled().compactMap {$0.rightSyllable}
    
    private var meaning: String = ""
    private var checkCounter = 0
    
    // MARK: - Private functions
    
    private func checkWord(leftSlot: String, rightSlot: String) {
        self.words.enumerated().forEach {(indexOfWord, word) in
            self.checkCounter += 1
            if self.leftSlot + self.rightSlot == word.fullWord {
                self.checkCounter += 1
                self.resultImage.image = word.image
                self.resultImage.isHidden = false
                words.remove(at: indexOfWord)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.resultImage.isHidden = true
                }
                self.leftSlot = ""
                self.rightSlot = ""
                self.slot2.title = ""
            }
        }
    }
    
    private func changeTitle(checkCounter: Int, meaning: String) {
        if checkCounter == words.count {
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
        if slot2.frame.contains(convertRightCollectionCoordinates(coordinates: piece.center)) && !piece.left {
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
        let syllable = piece.title
        if !leftSlot.isEmpty {
            guard let index = leftSyllables.firstIndex(of: syllable) else { fatalError("Couldn't find index of piece") }
            leftSyllables.insert(leftSlot, at: index)
            leftSyllablesCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
        }
        leftSlot = syllable
    }
    
    private func setCardInLeftSlot() {
        guard let index = leftSyllables.firstIndex(of: leftSlot)  else { fatalError("Couldn't find index of leftSlot") }
        leftSyllables.remove(at: index)
        leftSyllablesCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
    private func clearRightSlot(piece: SyllableCell) {
        let syllable = piece.title
        if !rightSlot.isEmpty{
            guard let index = rightSyllables.firstIndex(of: syllable) else { fatalError("Couldn't find index of piece") }
            rightSyllables.insert(rightSlot, at: index)
            rightSyllablesCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
        }
        rightSlot = syllable
    }
    
    private func setCardInRightSlot() {
        guard let index = rightSyllables.firstIndex(of: rightSlot)  else { fatalError("Couldn't find index of leftSlot") }
        rightSyllables.remove(at: index)
        rightSyllablesCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        slot2.title = rightSlot
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
        } else if collectionView == self.rightSyllablesCollectionView {
            return rightSyllables.count
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.leftSyllablesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID,
                                                                for: indexPath) as? SyllableCell else {
                fatalError("Couldn't get cell for cellID")
            }
            cell.title = leftSyllables[indexPath.item]
            cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gestureRecognizer:))))
            cell.left = true
            return cell
        } else if collectionView == self.rightSyllablesCollectionView {
            guard let cell = rightSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
            cell.title = rightSyllables[indexPath.item]
            cell.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gestureRecognizer:))))
            cell.left = false
            return cell
        } else {
            guard let cell = rightSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
            cell.title = leftSlot
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

extension ViewController: UICollectionViewDragDelegate {
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.item + index, section: destinationIndexPath.section)
                if collectionView === self.leftSlotView
                {
                    self.leftSlot = item.dragItem.localObject as! String
                }
                else
                {
                    self.leftSyllables.insert(item.dragItem.localObject as! String, at: indexPath.item)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                collectionView.reloadData()
//                self.leftSlotView.reloadData()
//                self.leftSyllablesCollectionView.reloadData()
//            })
        })
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == leftSyllablesCollectionView ? leftSyllables[indexPath.item] : rightSyllables[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        switch coordinator.proposal.operation
        {
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        default:
            return
        }
    }
}
