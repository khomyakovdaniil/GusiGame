//
//  GameViewController.swift
//  GusiGame
//
//  Created by  Даниил Хомяков on 02.10.2021.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loadingSpinnerView: UIActivityIndicatorView!
    
    @IBOutlet weak var leftSyllablesCollectionView: UICollectionView!
    @IBOutlet weak var rightSyllablesCollectionView: UICollectionView!
    
    @IBOutlet weak var leftSlotView: UICollectionView!
    @IBOutlet weak var rightSlotView: UICollectionView!
    
    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main
        let syllableCellNib = UINib(nibName: "SyllableCell", bundle: bundle)
        let slotCellNib = UINib(nibName: "SlotCell", bundle: bundle)
        
        leftSlotView.register(slotCellNib, forCellWithReuseIdentifier: slotCellID)
        leftSlotView.dataSource = self
        leftSlotView.dragInteractionEnabled = true
        leftSlotView.dragDelegate = self
        leftSlotView.dropDelegate = self
        leftSlotView.delegate = self
        leftSlotView.clipsToBounds = false
        
        rightSlotView.register(slotCellNib, forCellWithReuseIdentifier: slotCellID)
        rightSlotView.dataSource = self
        rightSlotView.dragInteractionEnabled = true
        rightSlotView.dragDelegate = self
        rightSlotView.dropDelegate = self
        rightSlotView.delegate = self
        rightSlotView.clipsToBounds = false
        
        leftSyllablesCollectionView.dragInteractionEnabled = true
        leftSyllablesCollectionView.dragDelegate = self
        leftSyllablesCollectionView.dropDelegate = self
        leftSyllablesCollectionView.register(syllableCellNib, forCellWithReuseIdentifier: cellID)
        leftSyllablesCollectionView.dataSource = self
        leftSyllablesCollectionView.delegate = self
        leftSyllablesCollectionView.clipsToBounds = false
        
        rightSyllablesCollectionView.dragInteractionEnabled = true
        rightSyllablesCollectionView.dragDelegate = self
        rightSyllablesCollectionView.dropDelegate = self
        rightSyllablesCollectionView.register(syllableCellNib, forCellWithReuseIdentifier: cellID)
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
    private let slotCellID = "SlotCell"
    
    // MARK: - Private
    
    private var originalCentersLeft: [CGPoint] = []// The original position of each card
    private var originalCentersRight: [CGPoint] = []// The original position of each card
    
    private let lineSpacingForSyllablesCollections = CGFloat(5)
    private let insetsForSyllablesCollections = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    private let lineSpacingForSlots = CGFloat (0)
    private let insetsForSlots = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let cellSize = CGSize(width: 65, height: 65)
    
    private var leftSlot = "" //Indicates which card is in the left slot
    private var rightSlot = "" //Indicates which card is in the right slot
    
    private var initialCenter = CGPoint()  // The initial center point of the view for movement
    
    private lazy var words: [Word] = dataManager.getList()
    private lazy var leftSyllables: [String] = words.compactMap {$0.leftSyllable}
    private lazy var rightSyllables: [String] = words.shuffled().compactMap {$0.rightSyllable}
    
    private var meaning: String = ""
    private var checkCounter = 0
    
    private var moveView: UIView?
    
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
                self.leftSlotView.reloadData()
                self.rightSlot = ""
                self.rightSlotView.reloadData()
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
}

extension GameViewController: UICollectionViewDataSource {
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
            cell.left = true
            return cell
        } else if collectionView == self.rightSyllablesCollectionView {
            guard let cell = rightSyllablesCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SyllableCell else { fatalError("Couldn't get cell for cellID") }
            cell.title = rightSyllables[indexPath.item]
            cell.left = false
            return cell
        } else if collectionView == self.leftSlotView {
            guard let cell = leftSlotView.dequeueReusableCell(withReuseIdentifier: slotCellID, for: indexPath) as? SlotCell else { fatalError("Couldn't get cell for cellID") }
            cell.title = leftSlot
            return cell
        } else {
            guard let cell = rightSlotView.dequeueReusableCell(withReuseIdentifier: slotCellID, for: indexPath) as? SlotCell else { fatalError("Couldn't get cell for cellID") }
            cell.title = rightSlot
            return cell
        }
    }
}

extension GameViewController: UICollectionViewDelegate  {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        if collectionView == leftSyllablesCollectionView || collectionView == rightSyllablesCollectionView {
            return lineSpacingForSyllablesCollections
        } else {
            return lineSpacingForSlots
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == leftSyllablesCollectionView || collectionView == rightSyllablesCollectionView {
            return insetsForSyllablesCollections
        } else {
            return insetsForSlots
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return cellSize
    }
}

extension GameViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == leftSyllablesCollectionView ? leftSyllables[indexPath.item] : rightSyllables[indexPath.item]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        session.localContext = DragInfo(collection: collectionView, indexPath: indexPath)
        return [dragItem]
    }
}

extension GameViewController: UICollectionViewDropDelegate {
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        guard let sourceData = coordinator.session.localDragSession?.localContext as? DragInfo else {fatalError("11")}
        let sourceCollection = sourceData.collection
        let sourceIndex = sourceData.indexPath
        if collectionView === self.leftSlotView && sourceCollection === leftSyllablesCollectionView
        {
            if leftSlot.isEmpty {
                leftSyllables.remove(at: sourceIndex.item)
                leftSyllablesCollectionView.deleteItems(at: [sourceIndex])
            } else {
                let cell = leftSyllablesCollectionView.cellForItem(at: sourceIndex) as? SyllableCell
                cell?.setVisibility(false)
                let oldLeftSlot = leftSlot
                UIView.animate(withDuration: 2, animations: {
                    self.moveView = self.leftSlotView.copyView()
                    self.view.addSubview(self.moveView!)
                    self.moveView!.center = self.leftSyllablesCollectionView.cellForItem(at: sourceIndex)!.center
                }){ [weak self] _ in
                    guard let strongSelf = self else { return }
                    strongSelf.moveView?.removeFromSuperview()
                    strongSelf.leftSyllables[sourceIndex.item] = oldLeftSlot
                    strongSelf.leftSyllablesCollectionView.reloadItems(at: [sourceIndex])
                }
            }
            leftSlot = coordinator.items[0].dragItem.localObject as! String
        }
        else if collectionView === self.rightSlotView && sourceCollection === rightSyllablesCollectionView
        {
            if rightSlot.isEmpty {
                rightSyllables.remove(at: sourceIndex.item)
                rightSyllablesCollectionView.deleteItems(at: [sourceIndex])
            } else {
                let cell = rightSyllablesCollectionView.cellForItem(at: sourceIndex) as? SyllableCell
                cell?.setVisibility(false)
                let oldRightSlot = rightSlot
                UIView.animate(withDuration: 2, animations: {
                    self.moveView = self.rightSlotView.copyView()
                    self.view.addSubview(self.moveView!)
                    self.moveView!.center = CGPoint(x: self.rightSyllablesCollectionView.cellForItem(at: sourceIndex)!.center.x + self.rightSyllablesCollectionView.frame.origin.x , y: self.rightSyllablesCollectionView.cellForItem(at: sourceIndex)!.center.y)
                }){[weak self] _ in
                    guard let strongSelf = self else { return }
                    strongSelf.moveView?.removeFromSuperview()
                    strongSelf.rightSyllables[sourceIndex.item] = oldRightSlot
                    strongSelf.rightSyllablesCollectionView.reloadItems(at: [sourceIndex])
                }
            }
            rightSlot = coordinator.items[0].dragItem.localObject as! String
        }
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        })
    }
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
