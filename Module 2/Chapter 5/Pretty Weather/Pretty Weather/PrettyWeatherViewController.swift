//
//  PrettyWeatherViewController.swift
//  Pretty Weather
//
//  Created by Bart Chrzaszcz on 2017-12-29.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit
import Cartography

class PrettyWeatherViewController: UIViewController {
    
    private let backgroundView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        style()
        render(image: UIImage(named: "DefaultImage"))
    }
}

// MARK: - Setup
private extension PrettyWeatherViewController {
    func setup() {
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
    }
}

// MARK: - Layout
extension PrettyWeatherViewController {
    func layoutView() {
        constrain(backgroundView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
    }
}

// MARK: - Render
private extension PrettyWeatherViewController {
    func render(image: UIImage?) {
        if let image = image {
            backgroundView.image = image
        }
    }
}

// Mark: - Style
private extension PrettyWeatherViewController {
    func style() {
        
    }
}
