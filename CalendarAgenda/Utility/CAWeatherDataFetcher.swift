//
//  CAWeatherDataFetcher.swift
//  CalendarAgenda
//
//  Created by Kevin on 2018-09-04.
//  Copyright © 2018 Kevin's Project. All rights reserved.
//

import UIKit
import CoreLocation

protocol CAWeatherDataControllable {
    func setUpdateDelegate(_ delegate: CAWeatherDataUpdatable)
    func fetchTodayWeather()
    func fetchWeather(_ date: Date)
}

protocol CAWeatherDataUpdatable {
    func weatherDataDidReturn(weatherInfoDict: [Date: Any])
}

class CAWeatherDataFetcher: NSObject, CAWeatherDataControllable, CLLocationManagerDelegate {
    static let sharedInstance = CAWeatherDataFetcher()
    var updateDelegate: CAWeatherDataUpdatable?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var curLatitude: Double = 0
    var curLongitude: Double = 0 {
        didSet {
            if (curLatitude != 0 && curLongitude != 0 && curLongitude != oldValue) {
                for date in weatherInfoDict.keys {
                    fetchWeather(date)
                }
            }
        }
    }
    var weatherInfoDict = [Date : Any]() {
        didSet {
             updateDelegate?.weatherDataDidReturn(weatherInfoDict: weatherInfoDict)
        }
    }

    override init() {
        super.init()
        initializeCurrentLocation()
    }

    func setUpdateDelegate(_ delegate: CAWeatherDataUpdatable) {
        updateDelegate = delegate
    }
    
    func fetchTodayWeather() {
        fetchWeather(Date())
    }
    
    func fetchWeather(_ date: Date) {
        let dayDate = date.yyyyMMMddDate()
        if (curLatitude != 0 && curLongitude != 0) {
            let dateTimeString = darkSkyAPIDateString(dayDate)
            let urlString = "https://api.darksky.net/forecast/\(Constants.darkSkyAPIKey)/\(curLatitude),\(curLongitude),\(dateTimeString)"
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request,
                                            completionHandler: { [weak self] (data, response, error) -> Void in
                                                if error != nil{
                                                    print(error.debugDescription)
                                                } else {
                                                    if let strongSelf = self {
                                                        strongSelf.weatherInfoDict[dayDate] = strongSelf.parseWeatherData(data!)
                                                    }
                                                }
            }) as URLSessionTask
            
            dataTask.resume()
        } else {
            weatherInfoDict[dayDate] = NSNull()
        }
    }
    
    func parseWeatherData(_ data: Data) -> CAWeatherInfo {
        let jsonData = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String, Any>
        let currentlyDateBlock = jsonData["currently"] as! Dictionary<String, Any>
        let icon = currentlyDateBlock["icon"] as! String
        var weatherIcon: caWeatherIcon = .cloudy
        let temp = currentlyDateBlock["temperature"] as! NSNumber
        let tempCelsius = (temp.intValue - 32) * 5/9
        
        if icon.hasPrefix("clear") {
            weatherIcon = .clear
        } else if icon == "rain" {
            weatherIcon = .rain
        } else if icon == "snow" {
            weatherIcon = .snow
        } else if icon == "wind" {
            weatherIcon = .wind
        } else if icon == "cloudy" {
            weatherIcon = .cloudy
        }
        
        return CAWeatherInfo(date: Date(), weatherIcon: weatherIcon, weatherDegree: String(tempCelsius))
    }
    
    func initializeCurrentLocation() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
        print("定位经纬度为：\(currentLocation.coordinate.latitude)")
        print(currentLocation.coordinate.longitude)
        
        curLatitude = currentLocation.coordinate.latitude
        curLongitude = currentLocation.coordinate.longitude
        
        manager.stopUpdatingLocation()
    }

    func darkSkyAPIDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.darkSkyAPIKeyDateFormatterString
        return dateFormatter.string(from: date)
    }
}

extension CAWeatherDataFetcher {
    struct Constants {
        static let darkSkyAPIKey = "b998283645b9a801b8985083b4e0835c"
        static let darkSkyAPIKeyDateFormatterString = "yyyy-MM-dd'T'HH:mm:ss"
    }
}

struct CAWeatherInfo {
    var date: Date
    var weatherIcon: caWeatherIcon
    var weatherDegree: String
}

enum caWeatherIcon: String {
    case clear = "clear"
    case rain = "rain"
    case snow = "snow"
    case wind = "wind"
    case cloudy = "cloudy"
    
    var image: UIImage? {
        switch self {
        case .clear:
            return #imageLiteral(resourceName: "weatherClear")
        case .wind:
            return #imageLiteral(resourceName: "weatherWind")
        case .rain:
            return #imageLiteral(resourceName: "weatherRain")
        case .snow:
            return #imageLiteral(resourceName: "weatherSnow")
        case .cloudy:
            return #imageLiteral(resourceName: "weatherCloudy")
        default:
            return #imageLiteral(resourceName: "weatherCloudy")
        }
    }
}
