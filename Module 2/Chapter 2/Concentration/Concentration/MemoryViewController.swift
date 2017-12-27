//
//  MemoryViewController.swift
//  Concentration
//
//  Created by Bart Chrzaszcz on 2017-12-25.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController {
    private let difficulty: Difficulty
    private var collectionView: UICollectionView!
    private var deck: Deck!
    private var selectedIndexes = Array<NSIndexPath>()
    private var numberOfPairs = 0
    private var score = 0
    
    // not used
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.deck = Deck()
        super.init(nibName: nil, bundle: nil)
        self.deck = createDeck(numCards: numCardsNeededDifficulty(difficulty: difficulty))
        for i in 0..<deck.count {
            print("The card at index \(i) is [\(deck[i]!.description)]")
        }
    }
    
    // required by UIViewController
    required init?(coder aDecoder: NSCoder) { // for hn
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    private func start() {
        deck = createDeck(numCards: numCardsNeededDifficulty(difficulty: difficulty))
        collectionView.reloadData()
    }
    
    private func createDeck(numCards: Int) -> Deck {
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(num: numCards / 2)
        return (halfDeck + halfDeck).shuffled()
    }
}

// MARK: Setup
private extension MemoryViewController {
    func setup() {
        view.backgroundColor = .greenSea()
        
        let space: CGFloat = 5
        let (covWidth, covHeight) = collectionViewSizeDifficulty(difficulty: difficulty, space: space)
        let layout = layoutCardSize(cardSize: cardSizeDifficulty(difficulty: difficulty, space: space), space: space)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width:  covWidth, height: covHeight), collectionViewLayout: layout)
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
    }
    
    func collectionViewSizeDifficulty(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
        let (columns, rows) = sizeDifficulty(difficulty: difficulty)
        let (cardWidth, cardHeight) = cardSizeDifficulty(difficulty: difficulty, space: space)
        let covWidth = columns * (cardWidth + (2 * space))
        let covHeight = rows * (cardHeight + space)
        return (covWidth, covHeight)
    }
    
    func cardSizeDifficulty(difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat) {
            let ratio: CGFloat = 1.452
        let (_, rows) = sizeDifficulty(difficulty: difficulty)
            let cardHeight: CGFloat = view.frame.height/rows - (2 * space)
            let cardWidth: CGFloat = cardHeight/ratio
            return (cardWidth, cardHeight)
    }
    
    func layoutCardSize(cardSize: (cardWidth: CGFloat, cardHeight: CGFloat), space: CGFloat) -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.itemSize = CGSize(width: cardSize.cardWidth, height: cardSize.cardHeight)
        layout.minimumLineSpacing = space
        return layout
    }
}

// MARK: Difficulty
private extension MemoryViewController {
    func sizeDifficulty(difficulty: Difficulty) -> (CGFloat, CGFloat) {
        switch difficulty {
            case .Easy:
                return (4,3)
            case .Medium:
                return (6,4)
            case .Hard:
                return (8,4)
        }
    }
    
    func numCardsNeededDifficulty(difficulty: Difficulty) -> Int {
        let (columns, rows) = sizeDifficulty(difficulty: difficulty)
        return Int(columns * rows)
    }
}

// MARK: UICollectionViewDataSource
extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
        let card = deck[indexPath.row]!
        cell.renderCardName(cardImageName: card.description, backImageName: "back")
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MemoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (selectedIndexes.count == 2 || selectedIndexes.contains(indexPath as NSIndexPath)) {
            return
        }
        selectedIndexes.append(indexPath as NSIndexPath)
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        cell.upturn()
        
        if (selectedIndexes.count < 2) {
            return
        }
        
        let card1 = deck[selectedIndexes[0].row]
        let card2 = deck[selectedIndexes[1].row]
        
        if card1 == card2 {
            numberOfPairs += 1
            checkIfFinished()
            removeCards()
        } else {
            score += 1
            turnCardsFaceDown()
        }
    }
}

// MARK: Actions
private extension MemoryViewController {
    func checkIfFinished() {
        if numberOfPairs == (deck.count / 2) {
            showFinalPopUp()
        }
    }
    func showFinalPopUp() {
        let alert = UIAlertController(title: "Great!", message: "You won with score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeCards() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeCardsAtPlaces(places: self.selectedIndexes)
            self.selectedIndexes = []
        }
    }
    func removeCardsAtPlaces(places: Array<NSIndexPath>) {
        for index in selectedIndexes {
            let cardCell = collectionView.cellForItem(at: index as IndexPath) as! CardCell
            cardCell.remove()
        }
    }
    
    func turnCardsFaceDown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.downturnCardsAtPlaces(places: self.selectedIndexes)
            self.selectedIndexes = []
        }
    }
    func downturnCardsAtPlaces(places: Array<NSIndexPath>) {
        for index in selectedIndexes {
            let cardCell = collectionView.cellForItem(at: index as IndexPath) as! CardCell
            cardCell.downturn()
        }
    }
}
