//
//  Deck.swift
//  Concentration
//
//  Created by Bart Chrzaszcz on 2017-12-26.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import Foundation

enum Suit: CustomStringConvertible {
    case Spades, Hearts, Diamonds, Clubs
    var description: String {
        switch self {
            case .Spades:
                return "spades"
            case .Hearts:
                return "hearts"
            case .Diamonds:
                return "diamonds"
            case .Clubs:
                return "clubs"
        }
    }
}

enum Rank: Int, CustomStringConvertible {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    var description: String {
        switch self {
            case .Ace:
                return "ace"
            case .Jack:
                return "jack"
            case .Queen:
                return "queen"
            case .King:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}

struct Card: CustomStringConvertible, Equatable {
    private let rank: Rank
    private let suit: Suit
    
    // !!!: Why do I need to write this? Why is `init` private?
    init(rank: Rank, suit: Suit) {
        self.rank = rank
        self.suit = suit
    }
    
    var description: String {
        return "\(rank.description)_of_\(suit.description)"
    }
    
    static func ==(card1: Card, card2: Card) -> Bool {
        return card1.rank == card2.rank && card1.suit == card2.suit
    }
}

struct Deck {
    private var cards = [Card]()
    
    static func full() -> Deck {
        var deck = Deck()
        for i in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, .Hearts, .Clubs, .Diamonds] {
                let card = Card(rank: Rank(rawValue: i)!, suit: suit)
                deck.cards.append(card)
            }
        }
        return deck
    }
    
    // Fisher-Yates (fast and uniform) shuffle
    func shuffled() -> Deck {
        var list = cards
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            
            if i != j {
                list.swapAt(i, j)
            }
        }
        return Deck(cards: list)
    }
    
    func deckOfNumberOfCards(num: Int) -> Deck {
        return Deck(cards: Array(cards[0..<num]))
    }
    
    static func +(deck1: Deck, deck2: Deck) -> Deck { // NOTE: "this function must be defined outside the Deck struct"
        return Deck(cards: deck1.cards + deck2.cards)
    }
    
    var count: Int {
        get {
            return cards.count
        }
    }
    
    subscript(index: Int) -> Card? {
        get {
            return cards[index]
        }
    }
}
