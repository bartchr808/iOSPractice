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
    private let scrollView = UIScrollView()
    private let currentWeatherView = CurrentWeatherView(frame: CGRect.zero)

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
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(currentWeatherView)
        view.addSubview(scrollView)
    }
}

// MARK: - Layout
extension PrettyWeatherViewController {
    func layoutView() {
        constrain(backgroundView) {
            $0.edges == $0.superview!.edges
        }
        
        constrain(scrollView) {
            $0.edges == $0.superview!.edges
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
