//
//  WeatherDaysForecastView.swift
//  Pretty Weather
//
//  Created by Bart Chrzaszcz on 2017-12-31.
//  Copyright © 2017 Bart Chrzaszcz. All rights reserved.
//

import UIKit
import Cartography

class WeatherDaysForecastView: UIView {

    static var HEIGHT: CGFloat {
        get {
            return 300
        }
    }
    private var didSetupConstraints = false
    
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
private extension WeatherDaysForecastView {
    func setup() {
        
    }
}

// MARK: - Layout
private extension WeatherDaysForecastView {
    func layoutView() {
        constrain(self) { view in
            view.height == WeatherDaysForecastView.HEIGHT
            return
        }
    }
}

// MARK: - Style
private extension WeatherDaysForecastView {
    func style() {
        backgroundColor = UIColor.blue
    }
}
