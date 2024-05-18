//
//  WeatherViewModel.swift
//  Collab N1 N-27
//
//  Created by Zuka Papuashvili on 17.05.24.
//

import Foundation

//MARK: - Constants
struct Constants {
    static let apiKey = "980a60647f866587fa2048fcc7e6af5f"
    static let dateFormat = "MMM dd, yyyy HH:mm"
    static let noInputMessage = "Please enter a city"
    static let cityNameLatinAlphabetMessage = "Please enter a city name using only Latin alphabet characters."
    static let cityNameErrorMessage = "Failed to fetch weather data for the entered city name."
}

//MARK: - ViewModel
final class WeatherViewModel {
    private let networkingService = NetworkingService.shared
    private var weatherInfo: WeatherInfo?
    
    var cityName: String {
        return weatherInfo?.city.name ?? ""
    }
    
    var numberOfForecasts: Int {
        return weatherInfo?.list.count ?? 0
    }
    
    func forecast(at index: Int) -> WeatherInfo.WeatherForecast? {
        guard let forecasts = weatherInfo?.list, index < forecasts.count else { return nil }
        return forecasts[index]
    }
    
    func fetchWeather(for cityName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "Invalid city name", code: 0, userInfo: nil)))
            return
        }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(encodedCityName)&appid=\(Constants.apiKey)&units=metric") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1, userInfo: nil)))
            return
        }
        
        networkingService.fetchData(from: url) { (result: Result<WeatherInfo, Error>) in
            switch result {
            case .success(let weatherInfo):
                self.weatherInfo = weatherInfo
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
