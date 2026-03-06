import Foundation

final class SavingPlannerModel: ObservableObject {
    // used for user inputs
    @Published var startingBalance:      Double = 0
    @Published var monthlyContribution:  Double = 0
    @Published var annualInterestRate:   Double = 0
    @Published var goalAmount:           Double = 0
    
    // used for calculations
    // the max(_ ,0) ensures there are no negative numbers
    var starting:      Double { max(startingBalance, 0) }
    var contribution:  Double { max(monthlyContribution, 0) }
    var apyPercent:    Double { max(annualInterestRate, 0) }
    var goal:          Double { max(goalAmount, 0) }
    
    var monthlyRate: Double { max(((apyPercent / 100.0) / 12.0), 0) }
    
    var monthsToGoal: Int {
        guard goal > 0 else {
            return 0
        }
        if starting >= goal {
            return 0
        }
        if contribution == 0 && monthlyRate == 0 {
            return Int.max
        }
        var balance = starting
        var m = 0
        
        while balance < goal && m < 1200 {
            balance += contribution
            balance *= (1 + monthlyRate)
            m += 1
        }
        return (balance >= goal ? m : Int.max)
    }
    
    struct SavingPoint: Identifiable {
            let id = UUID()
            let month: Int
            let balance: Double
            let interestEarnedToDate: Double
            let contributionsToDate: Double
        }

        var projectionToGoal: [SavingPoint] {
            guard goal > 0 else { return [] }
            if starting >= goal {
                return [
                    .init(
                        month: 0,
                        balance: starting,
                        interestEarnedToDate: 0,
                        contributionsToDate: 0
                    )
                ]
            }

            var balance = starting
            var contributionsSum = 0.0
            var points: [SavingPoint] = []

            points.append(.init(
                month: 0,
                balance: balance,
                interestEarnedToDate: 0,
                contributionsToDate: 0
            ))

            var m = 0
            while balance < goal && m < 1200 {
                m += 1
                contributionsSum += contribution
                balance += contribution
                balance *= (1 + monthlyRate)

                let interestToDate = max(balance - starting - contributionsSum, 0)

                points.append(.init(
                    month: m,
                    balance: max(balance, 0),
                    interestEarnedToDate: interestToDate,
                    contributionsToDate: contributionsSum
                ))
            }

            return points
        }
}
