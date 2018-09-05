//
//  CAFloatingWeatherView.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-09-05.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit

class CAFloatingWeatherView: UIView, CAWeatherDataUpdatable {
    private var currentDate: Date!
    private var weatherImageView: UIImageView!
    private var tempView: UIView!
    private var tempLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        weatherImageView = UIImageView(frame: self.frame)
        weatherImageView.backgroundColor = UIColor.clear
        self.addSubview(weatherImageView)
        
        var f = frame
        f.origin.x = f.size.width - (Constants.tempViewRadius / 2)
        f.origin.y = -(Constants.tempViewRadius / 2)
        f.size.width = Constants.tempViewRadius
        f.size.height = Constants.tempViewRadius
        tempView = UIView(frame: f)
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = Constants.tempViewRadius / 2
        tempView.backgroundColor = UIColor.clear
        
        self.addSubview(tempView)
        
        tempLabel = UILabel(frame: f)
        tempLabel.font = UIFont.systemFont(ofSize: 13)
        tempLabel.textAlignment = .center
        tempView.addSubview(tempLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(weatherManager: CAWeatherDataControllable, weatherDate: Date) {
        self.init(frame:CGRect(x: 0, y: 0, width: Constants.floatingViewRadius, height: Constants.floatingViewRadius))
        currentDate = weatherDate.yyyyMMMddDate()
        weatherManager.setUpdateDelegate(self)
        weatherManager.fetchWeather(weatherDate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let f = tempView.bounds
        tempLabel.frame = f
    }
    
    // MARK: CAWeatherDataUpdatable
    
    func weatherDataDidReturn(weatherInfoDict: [Date : Any]) {
        guard let info = weatherInfoDict[currentDate] as? CAWeatherInfo else {
            return
        }
        DispatchQueue.main.async() {
            self.weatherImageView.image = info.weatherIcon.image
            self.tempLabel.text = "\(info.weatherDegree)°"
            self.tempView.backgroundColor = UIColor.hexColor(string: "#f2ec0c")
        }
    }
}

extension CAFloatingWeatherView {
    struct Constants {
        static let floatingViewRadius: CGFloat = 50
        static let tempViewRadius: CGFloat = 28
    }
}
