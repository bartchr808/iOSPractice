//
//  ViewController.swift
//  GuessTheNumber
//
//  Created by Bart Chrzaszcz on 2017-12-24.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var lowerBound = 0
    private var upperBound = 100
    private var numGuesses = 0
    private var secretNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberTxtField.becomeFirstResponder()
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var rangeLbl: UILabel!
    @IBOutlet weak var numberTxtField: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var numGuessesLbl: UILabel!
    
    @IBAction func onOkPressed(sender: AnyObject) {
        guard let number = Int(numberTxtField.text!) else { // check if number exists in textbox
            let alert = UIAlertController(title: nil, message: "Enter a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        selectedNumber(number: number)
    }
}


// Game Logic
private extension ViewController {
    
    enum Comparison {
        case Smaller
        case Greater
        case Equals
    }
    
    func selectedNumber(number: Int) {
        switch compareNumber(number: number, otherNumber: secretNumber) {
        case .Equals:
            let alert = UIAlertController(
                title: nil,
                message: "You won in \(numGuesses) guesses!",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { cmd in
                        self.reset()
                        self.numberTxtField.text = ""
                    }
                )
            )
            self.present(alert, animated: true, completion: nil)

        case .Smaller:
            lowerBound = max(lowerBound, number)
            messageLbl.text = "Your last guess was too low"
            numberTxtField.text = ""
            numGuesses += 1
            renderRange()
            renderNumGuesses()
        case .Greater:
            upperBound = min(upperBound, number)
            messageLbl.text = "Your last guess was too high"
            numberTxtField.text = ""
            numGuesses += 1
            renderRange()
            renderNumGuesses()
        }
    }
    
    func compareNumber(number: Int, otherNumber: Int) -> Comparison {
        if number < otherNumber {
            return .Smaller
        } else if number > otherNumber {
            return .Greater
        }
        return .Equals
    }
}


// Rendering Labels
private extension ViewController {
    func extractSecretNumber() {
        let diff = upperBound - lowerBound
        let randomNumber = Int(arc4random_uniform(UInt32(diff)))
        secretNumber = randomNumber + lowerBound
    }
    
    func renderRange() {
        rangeLbl.text = "\(lowerBound) and \(upperBound)"
    }
    
    func renderNumGuesses() {
        numGuessesLbl.text = "Number of Guesses: \(numGuesses)"
    }
    
    func resetData() {
        lowerBound = 0
        upperBound = 100
        numGuesses = 0
    }
    
    func resetMsg() {
        messageLbl.text = ""
    }
    
    func reset() {
        resetData()
        renderRange()
        renderNumGuesses()
        extractSecretNumber()
        resetMsg()
    }
}
