//
//  CurrentWeatherView.swift
//  Pretty Weather
//
//  Created by Bart Chrzaszcz on 2017-12-31.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit

class CurrentWeatherView: UIView {

    static var HEIGHT: CGFloat {
        get {
            return 160
        }
    }
    private var didSetupConstraints = false
    private let cityLbl = UILabel()
    private let maxTempLbl = UILabel()
    private let minTempLbl = UILabel()
    private let iconLbl = UILabel()
    private let weatherLbl = UILabel()
    private let currentTempLbl = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This method is called by the framework when all other constraints are set and the view needs to be laid out
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
}


// MARK: - Setup
private extension CurrentWeatherView {
    func setup() {
        
    }
}

// MARK: - Layout
private extension CurrentWeatherView {
    func layoutView() {
        constrain(self) {
            $0.height == CurrentWeatherView.HEIGHT
        }
        constrain(iconLbl) {
            $0.top == $0.superview!.top
            $0.left == $0.superview!.left + 20
            $0.width == 30
            $0.width == $0.height
        }
        constrain(weatherLbl, iconLbl) {
            $0.top == $1.top
            $0.left == $1.right + 10
            $0.height == $1.height
            $0.width == 200
        }
        constrain(currentTempLbl, iconLbl) {
            $0.top == $1.bottom
            $0.left == $1.left
        }
        constrain(currentTempLbl, minTempLbl) {
            $0.bottom == $1.top
            $0.left == $1.left
        }
        constrain(minTempLbl) {
            $0.bottom == $0.superview!.bottom
            $0.height == 30
        }
        constrain(maxTempLbl, minTempLbl) {
            $0.top == $1.top
            $0.height == $1.height
            $0.left == $1.right + 10
        }
        constrain(cityLbl) {
            $0.bottom == $0.superview!.bottom
            $0.right == $0.superview!.right - 10
            $0.height == 30
            $0.width == 200
        }
    }
}

// MARK: - Style
private extension CurrentWeatherView {
    func style() {
        backgroundColor = UIColor.red
    }
}
