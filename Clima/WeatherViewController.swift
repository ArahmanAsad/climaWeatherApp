//clima
//  Created by A.Rahman on 7/7/18.
//  Copyright © 2018 . All rights reserved.
//
import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
//براكتس علي التعامل مع alamofire , swiftyJSON , parsing JSON 
// الديزاين وال assests داونلوود من ميل  angela yu GITHUB
class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    // instance variables
    let locationManger=CLLocationManager()
    let weatherDataModel=WeatherDataModel()

    //IBOutlets
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //locationMAnager
        
        locationManger.delegate=self
        locationManger.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()

    }
    //networking
    
    //getWeatherData methods
    
    func getWeatherData (url:String,parameters:[String:String]){
        Alamofire.request(url,method:.get,parameters:parameters).responseJSON{
            response in
        if response.result.isSuccess{
            
        //print ("succ , got the weather data")
            let weatherJSON:JSON=JSON(response.result.value!)
            
       //print (weatherJSON)
          self.updateWeatherData(json: weatherJSON)
            
            
            
        }else {
            print ("error\(response.result.error)")
            self.cityLabel.text="connection issues"
        }
            
        }
        
    }
    
    
    //JSON Parsing
   
    
//   updateWeatherData method
    func updateWeatherData(json:JSON){
        if let tempResult=json["main"]["temp"].double{
        weatherDataModel.temperature = Int(tempResult-273.15 )
        weatherDataModel.city=json["name"].stringValue
        weatherDataModel.condition=json["weather"][0]["id"].int!
        weatherDataModel.weatherIconName=weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWeatherData()
        }else {
            cityLabel.text="weather unavailable"
        }
    }

    
    
    
    //UI Updates
    
    
    // updateUIWithWeatherData
    func updateUIWeatherData(){
        cityLabel.text=weatherDataModel.city
        temperatureLabel.text=String(weatherDataModel.temperature)
        weatherIcon.image=UIImage(named:weatherDataModel.weatherIconName)
        
    }
 
    
    
    
    
  //Location Manager Delegate Methods

    
  //didUpdateLocations method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManger.stopUpdatingLocation()
            print ("longtidue = \(location.coordinate.longitude),latitude = \(location.coordinate.latitude)")
            let latitude = String(location.coordinate.latitude)
            let longtitude = String(location.coordinate.longitude)
            
            let params:[String:String]=["lat":latitude,"lon":longtitude,"appid":APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        
    }
    
    //didFailWithError method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
        cityLabel.text="location unavailable"
    }

    
}


