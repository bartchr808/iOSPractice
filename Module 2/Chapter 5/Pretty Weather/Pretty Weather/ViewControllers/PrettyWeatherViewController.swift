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
    
    static var INSET: CGFloat {
        get {
            return 20
        }
    }
    
    private let gradientView = UIView()
    private let backgroundView = UIImageView()
    private let scrollView = UIScrollView()
    private let currentWeatherView = CurrentWeatherView(frame: CGRect.zero)
    private let hourlyForecastView = WeatherHourlyForecastView(frame: CGRect.zero)
    private let daysForecastView = WeatherDaysForecastView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutView()
        style()
        render(image: UIImage(named: "DefaultImage"))
        renderSubviews()
    }
}

// MARK: - Setup
private extension PrettyWeatherViewController {
    func setup() {
        
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        view.addSubview(backgroundView)
        view.addSubview(gradientView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(currentWeatherView)
        scrollView.addSubview(hourlyForecastView)
        scrollView.addSubview(daysForecastView)
        view.addSubview(scrollView)
    }
}

// MARK: - Layout
extension PrettyWeatherViewController {
    func layoutView() {
        constrain(backgroundView) {
            $0.edges ==  $0.superview!.edges
        }
        
        constrain(scrollView) {
            $0.edges ==  $0.superview!.edges
        }
        
        constrain(currentWeatherView) {
            $0.width == $0.superview!.width
            $0.centerX == $0.superview!.centerX
        }
        
        constrain(hourlyForecastView, currentWeatherView) {
            $0.top == $1.bottom + PrettyWeatherViewController.INSET
            $0.width == $0.superview!.width
            $0.centerX == $0.superview!.centerX
        }
        
        constrain(daysForecastView, hourlyForecastView) {
            $0.top == $1.bottom
            $0.width == $1.width
            $0.bottom == $0.superview!.bottom - PrettyWeatherViewController.INSET
            $0.centerX == $0.superview!.centerX
        }
        
        let currentWeatherInsect: CGFloat = view.frame.height - CurrentWeatherView.HEIGHT - PrettyWeatherViewController.INSET
        
        constrain(currentWeatherView) {
            $0.top == $0.superview!.top + currentWeatherInsect
        }
        
        constrain(gradientView) {
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
    func renderSubviews() {
        currentWeatherView.render()
    }
}

// MARK: - Style
private extension PrettyWeatherViewController {
    func style() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let clearColor = UIColor(white: 0, alpha: 0).cgColor
        let blackColor = UIColor(white: 0, alpha: 0.7).cgColor
        gradient.colors = [clearColor, blackColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
}

