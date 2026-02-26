import Foundation

// mortgage loan calculation model
final class MortgageLoanModel: ObservableObject {
    // used for user inputs
    @Published var homePriceInput:      Double = 0      // home purchase price
    @Published var downPaymentInput:    Double = 0      // down payment
    @Published var closingCostsInput:   Double = 0      // closing costs/fees
    @Published var aprInput:            Double = 0.00   // annual percentage rate
    @Published var propertyTaxInput:    Double = 0.00   // annual property tax
    @Published var termYearsInput:      Int = 0         // loan term in years
    
    // used for calculations
    // the max(_ ,0) ensures there are no negative numbers
    var homePrice:       Double { max(homePriceInput, 0) }
    var downPayment:     Double { max(downPaymentInput, 0) }
    var closingCosts:    Double { max(closingCostsInput, 0) }
    var aprPercent:      Double { max(aprInput, 0) }
    var propertyTax:     Double { max(propertyTaxInput, 0) }
    var termYears:       Int    { max(termYearsInput, 1) }

    var loanAmount:           Double { max(homePrice - downPayment, 0) }
    var monthlyRate:          Double { max(((aprPercent / 100.0) / 12.0), 0) }
    var monthlyPropertyTax:   Double { max(propertyTax / 12.0, 0) }
    
    // monthly principal & interest payment
    var monthlyPrincipalAndInterest: Double {
        let P = loanAmount
        let r = monthlyRate
        let n = Double(termYears * 12)

        guard P > 0, n > 0 else { return 0 }
        if r == 0 { return P / n }
        
        // payment = P * r * (1+r)^n / ((1+r)^n - 1)
        let powVal = pow(1 + r, n)
        return P * r * powVal / (powVal - 1)
    }
    
    var monthlyPayment: Double {
        monthlyPrincipalAndInterest + monthlyPropertyTax
    }

    var totalPaid:      Double { monthlyPrincipalAndInterest * Double(termYears * 12) }
    var totalInterest:  Double { max(totalPaid - loanAmount, 0) }

    struct PaymentPoint: Identifiable {
        let id = UUID()
        let month: Int
        let balance: Double
        let interestPaidToDate: Double
        let principalPaidToDate: Double
    }
    
    // month by months amorization
    // starts at month 0, full loan amount
    var amortization: [PaymentPoint] {
        let P = loanAmount
        let r = monthlyRate
        let n = termYears * 12
        let pay = monthlyPrincipalAndInterest
        
        guard P > 0, n > 0 else { return [] } // prevent invalid inputs. loanAmount/termMonths > 0

        var balance = P
        var interestSum = 0.0
        var principalSum = 0.0

        var points: [PaymentPoint] = []
        points.append(.init(
            month: 0,
            balance: balance,
            interestPaidToDate: 0,
            principalPaidToDate: 0
        ))

        for m in 1...n {
            let interest = (r == 0) ? 0 : balance * r // interest owed based on remaining balance
            var principal = pay - interest            // principal pay, remove interest from payment
            
            // prevent principal being below 0
            // prevent principal being greater than remaining balance
            if principal < 0 { principal = 0 }
            if principal > balance { principal = balance }

            balance -= principal
            interestSum += interest
            principalSum += principal

            points.append(.init(
                month: m,
                balance: max(balance, 0),
                interestPaidToDate: interestSum,
                principalPaidToDate: principalSum
            ))

            if balance <= 0 { break }
        }

        return points
    }
}
