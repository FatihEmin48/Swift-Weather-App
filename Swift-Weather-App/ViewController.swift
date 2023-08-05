//
//  ViewController.swift
//  Swift-Weather-App
//
//  Created by Fatih Karahan on 5.08.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    var manager: CLLocationManager?
    
    var latitude = 36.644715
    var longitude = 29.141268

    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var fellsLikeLAbel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var API = "b04e6028fe9b31431052bdf0c2b8537c"
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather API"
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else{ return }
        latitude = first.coordinate.latitude
        longitude = first.coordinate.longitude
    }

    @IBAction func getButtonClicked(_ sender: Any) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(API)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!){ data, response, error in
            if error != nil{
                print("error")
            } else {
                if data != nil{
                    do{
                        
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        
                        DispatchQueue.main.async {
                            if let main = jsonResponse!["main"] as? [String:Any]{
                                if let temp = main["temp"] as? Double{
                                    self.currentTempLabel.text = String(Int(temp-272.15))
                                }
                                
                                if let feels = main["feels_like"] as? Double{
                                    self.fellsLikeLAbel.text = String(Int(feels-272.15))
                                }
                            }
                            if let wind = jsonResponse!["wind"] as? [String:Any]{
                                if let speed = wind["speed"] as? Double{
                                    self.windSpeedLabel.text = String(Int(speed))
                                }
                            }
                        }
                        
                    } catch {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
}

