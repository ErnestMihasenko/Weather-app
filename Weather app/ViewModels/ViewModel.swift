//
//  ViewModel.swift
//  Weather app
//
//  Created by Ernest Mihasenko on 27.07.22.
//

import Foundation
import CoreLocation
import Combine

class CurrentWeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weatherData: NetworkWeatherData?
    @Published var isLoading = false
    @Published var presentsSearch = false
    @Published var city: String = "City"
    @Published var searchCity: String = ""
    @Published var temperature: String = "0"
    @Published var status: String = "Status"
    @Published var daily = [Daily]()
    @Published var humidity: String = "Humidity"
    @Published var windSpeed: String = "Wind speed:"
    let locationManager = CLLocationManager()
    
    private var cancellableSet = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        $weatherData.receive(on: RunLoop.main).sink { [weak self] weather in
            self?.city = weather?.timezone ?? "City"
            self?.temperature = weather?.current.temp.description ?? "0"
            self?.status = weather?.current.weather.first?.weatherDescription.localizedStatus ?? "Description"
            self?.humidity = weather?.current.humidity.description ?? "0%"
            self?.windSpeed = weather?.current.windSpeed.description ?? "Wind speed"
            self?.daily = weather?.daily ?? []
        }.store(in: &cancellableSet)
        refreshWeather()
    }
    
    func onAppear() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate,
        searchCity.isEmpty
        else {
            return
        }
        self.getData(latitude: locValue.latitude, longitude: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    private func loadWeather(city: String) {
        isLoading = true
        getCityCoordinates(city) { latitude, longitude in
            self.getData(latitude: latitude, longitude: longitude)
        }
    }
    
    func refreshWeather() {
        loadWeather(city: searchCity)
    }
    
    private func getData(latitude: Double, longitude: Double) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric&appid=96948292c452b55e34cc13f064de9c2a")
        else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data = data,
                  let weather = try? JSONDecoder().decode(NetworkWeatherData.self, from: data)
            else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.weatherData = weather
                self?.isLoading = false
            }
        }
        task.resume()
    }
    
    private func getCityCoordinates(_ city: String, callback: @escaping (Double, Double) -> Void) {
        CLGeocoder().geocodeAddressString(city) { cities, error in
            guard let cityLocation = cities?.first?.location else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }
            callback(cityLocation.coordinate.latitude, cityLocation.coordinate.longitude)
        }
    }
    
    func dateString(for daily: Daily) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let date = Date(timeIntervalSince1970: Double(daily.date))
        return dateFormatter.string(from: date)
    }
    
    func tempString(for daily: Daily) -> String {
        "\(daily.temp.min)°-\(daily.temp.max)°"
    }
    
    func weatherString(for daily: Daily) -> String {
        daily.weather.map { $0.weatherDescription.emojiStatus }.joined(separator: ", ")
    }
}
