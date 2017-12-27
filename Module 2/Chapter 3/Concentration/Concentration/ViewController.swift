//
//  ViewController.swift
//  Concentration
//
//  Created by Bart Chrzaszcz on 2017-12-25.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit


enum Difficulty {
    case Easy, Medium, Hard
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension ViewController {
    func setup() {
        view.backgroundColor = .greenSea()
        
        buildButtonWithCenter(center: CGPoint(x: view.center.x, y: view.center.y/2.0), title: "EASY", color: .emerald(), action: #selector(ViewController.onEasyTapped))
        buildButtonWithCenter(center: CGPoint(x: view.center.x, y: view.center.y), title: "MEDIUM", color: .sunflower(), action: #selector(ViewController.onMediumTapped))
        buildButtonWithCenter(center: CGPoint(x: view.center.x, y: view.center.y*3.0/2.0), title: "HARD", color: .alizarin(), action: #selector(ViewController.onHardTapped))
    }
    
    func buildButtonWithCenter(center: CGPoint, title: String, color: UIColor, action: Selector) {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        button.center = center
        button.backgroundColor = color
        
        button.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        
        view.addSubview(button)
    }
}

// MARK: Level Buttons
extension ViewController {
    @objc func onEasyTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Easy)
    }
    
    @objc func onMediumTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Medium)
    }
    
    @objc func onHardTapped(sender: UIButton) {
        newGameDifficulty(difficulty: .Hard)
    }
    
    func newGameDifficulty(difficulty: Difficulty) {
        let gameViewController = MemoryViewController(difficulty: difficulty)
        present(gameViewController, animated: true, completion: nil)
    }
}

extension UIColor {
    class func greenSea() -> UIColor {
        return colorComponents(components: (22, 160, 133))
    }
    class func emerald() -> UIColor {
        return colorComponents(components: (46, 204, 133))
    }
    class func sunflower() -> UIColor {
        return colorComponents(components: (241, 196, 15))
    }
    class func alizarin() -> UIColor {
        return colorComponents(components: (231, 76, 60))
    }
}

private extension UIColor {
    class func colorComponents(components: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: components.0/255, green: components.1/255, blue: components.2/255, alpha: 1)
    }
}
