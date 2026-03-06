import Foundation

@MainActor
class MarketDataViewModel: ObservableObject {
    @Published var autoLoanRate: String = "7.2%"
    @Published var mortgageRate: String = "6.8%"
    @Published var savingsAPY: String = "4.5%"
    @Published var sp500Change: String = "+1.2%"
    @Published var isLoading: Bool = false
    
    private let fredService = FREDService()
    
    func fetchRates() async {
        isLoading = true
        
        // fetching auto loan rate
        do {
            let rate = try await fredService.fetchAutoLoanRate()
            autoLoanRate = String(format: "%.1f%%", rate)
        } catch {
            print("Failed to fetch auto loan rate: \(error)")
        }
        
        // fetching mortgage rate
        do {
            let rate = try await fredService.fetchMortgageRate()
            mortgageRate = String(format: "%.1f%%", rate)
        } catch {
            print("Failed to fetch mortgage rate: \(error)")
        }
        
        isLoading = false
    }
}
