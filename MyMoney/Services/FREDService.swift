import Foundation

class FREDService {
    private let apiKey = "7623bd31597eb8a33ef39f401d1c13f6"
    private let baseURL = "https://api.stlouisfed.org/fred/series/observations"
    
 
    private let autoLoanSeriesID = "TERMCBAUTO48NS"
    private let mortgageSeriesID = "MORTGAGE30US"
    
    func fetchAutoLoanRate() async throws -> Double {
        return try await fetchLatestRate(seriesID: autoLoanSeriesID)
    }
    
    func fetchMortgageRate() async throws -> Double {
        return try await fetchLatestRate(seriesID: mortgageSeriesID)
    }
    
    private func fetchLatestRate(seriesID: String) async throws -> Double {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "series_id", value: seriesID),
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "file_type", value: "json"),
            URLQueryItem(name: "sort_order", value: "desc"),
            URLQueryItem(name: "limit", value: "1")
        ]
        
        guard let url = components?.url else {
            throw FREDError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(FREDResponse.self, from: data)
        
        guard let observation = response.observations.first,
              let value = Double(observation.value) else {
            throw FREDError.noData
        }
        
        return value
    }
}

struct FREDResponse: Codable {
    let observations: [FREDObservation]
}

struct FREDObservation: Codable {
    let date: String
    let value: String
}

enum FREDError: Error {
    case invalidURL
    case noData
}
