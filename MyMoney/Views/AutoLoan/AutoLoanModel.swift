import Foundation

// auto loan calculation model
final class AutoLoanModel: ObservableObject {
    // used for user inputs
    @Published var autoPriceInput:   Double = 0      // vehicle purchase price
    @Published var downPaymentInput: Double = 0      // down payment
    @Published var tradeInInput:     Double = 0      // trade in value
    @Published var feesInput:        Double = 0      // doc/title/registration/etc
    @Published var aprInput:         Double = 0.00   // annual percentage rate
    @Published var salesTaxInput:    Double = 0.00   // state sales tax
    @Published var termMonthsInput:  Int = 0         // loan term in months
    
    // used for calculations
    // the max(_ ,0) ensures there are no negative numbers
    var autoPrice:       Double { max(autoPriceInput, 0) }
    var downPayment:     Double { max(downPaymentInput, 0) }
    var tradeIn:         Double { max(tradeInInput, 0) }
    var fees:            Double { max(feesInput, 0) }
    var aprPercent:      Double { max(aprInput, 0) }
    var salesTaxPercent: Double { max(salesTaxInput, 0) }
    var termMonths:      Int    { max(termMonthsInput, 1) }

    var taxableAmount:   Double { max(autoPrice - tradeIn, 0) }                         // amount subject to sales tax
    var salesTax:        Double { max(taxableAmount * (salesTaxPercent / 100.0), 0) }   // amount of sales tax
    var outTheDoorTotal: Double { max(autoPrice + salesTax + fees, 0) }                 // total purchase price
    var loanAmount:      Double { max(outTheDoorTotal - downPayment - tradeIn, 0) }     // amount financed
    var monthlyRate:     Double { max(((aprPercent / 100.0) / 12.0), 0) }               // monthly interest
    
    // monthly payment
    var monthlyPayment:  Double {
        let P = loanAmount
        let r = monthlyRate
        let n = Double(termMonths)

        guard P > 0, n > 0 else { return 0 } // prevent invalid inputs. loanAmount/termMonths > 0
        if r == 0 { return P / n }           // 0% apr case
        
        // payment = P * r * (1+r)^n / ((1+r)^n - 1)
        let powVal = pow(1 + r, n)
        return P * r * powVal / (powVal - 1)
    }

    var totalPaid:      Double { monthlyPayment * Double(termMonths) }
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
        let n = termMonths
        let pay = monthlyPayment
        
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
