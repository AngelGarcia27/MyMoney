import SwiftUI
import PDFKit

struct PDFExportService {
    
    static func generateBudgetPDF(
        monthlyIncome: Double,
        expenses: [BudgetExpense],
        totalExpenses: Double,
        remaining: Double
    ) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            var yPosition: CGFloat = margin
            
            // Title
            yPosition = drawTitle("Budget Summary", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawSubtitle("Generated on \(formattedDate())", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 20
            
            // Income Section
            yPosition = drawSectionHeader("Monthly Income", at: yPosition, margin: margin)
            yPosition = drawRow("Income", formatCurrency(monthlyIncome), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 20
            
            // Expenses Section
            yPosition = drawSectionHeader("Expenses", at: yPosition, margin: margin)
            
            let expensesByCategory = Dictionary(grouping: expenses, by: { $0.category })
            for (category, categoryExpenses) in expensesByCategory.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
                let categoryTotal = categoryExpenses.reduce(0) { $0 + $1.amount }
                yPosition = drawRow(category.rawValue, formatCurrency(categoryTotal), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true)
                
                for expense in categoryExpenses {
                    yPosition = drawRow("  • \(expense.name)", formatCurrency(expense.amount), at: yPosition, pageWidth: pageWidth, margin: margin)
                }
            }
            yPosition += 10
            
            // Summary
            yPosition = drawDivider(at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Total Expenses", formatCurrency(totalExpenses), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true)
            yPosition = drawRow("Remaining", formatCurrency(remaining), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true, valueColor: remaining >= 0 ? .systemGreen : .systemRed)
            
            if monthlyIncome > 0 {
                let percentage = Int((totalExpenses / monthlyIncome) * 100)
                yPosition = drawRow("Budget Used", "\(percentage)%", at: yPosition, pageWidth: pageWidth, margin: margin)
            }
            
            // Footer
            drawFooter(at: pageHeight - margin, pageWidth: pageWidth, margin: margin)
        }
        
        return data
    }
    
    static func generateAutoLoanPDF(model: AutoLoanModel) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            var yPosition: CGFloat = margin
            
            // Title
            yPosition = drawTitle("Auto Loan Summary", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawSubtitle("Generated on \(formattedDate())", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 20
            
            // Loan Details
            yPosition = drawSectionHeader("Loan Details", at: yPosition, margin: margin)
            yPosition = drawRow("Vehicle Price", formatCurrency(model.autoPrice), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Down Payment", formatCurrency(model.downPayment), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Trade-In Value", formatCurrency(model.tradeIn), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Sales Tax (\(formatPercent(model.salesTaxPercent)))", formatCurrency(model.salesTax), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Fees", formatCurrency(model.fees), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 10
            
            // Loan Terms
            yPosition = drawSectionHeader("Loan Terms", at: yPosition, margin: margin)
            yPosition = drawRow("Loan Amount", formatCurrency(model.loanAmount), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("APR", formatPercent(model.aprPercent), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Term", "\(model.termMonths) months", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 10
            
            // Payment Summary
            yPosition = drawSectionHeader("Payment Summary", at: yPosition, margin: margin)
            yPosition = drawDivider(at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Monthly Payment", formatCurrency(model.monthlyPayment), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true, valueColor: .systemBlue)
            yPosition = drawRow("Total Interest", formatCurrency(model.totalInterest), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Total Amount Paid", formatCurrency(model.totalPaid), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true)
            
            // Footer
            drawFooter(at: pageHeight - margin, pageWidth: pageWidth, margin: margin)
        }
        
        return data
    }
    
    static func generateMortgagePDF(model: MortgageLoanModel) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            var yPosition: CGFloat = margin
            
            // Title
            yPosition = drawTitle("Mortgage Summary", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawSubtitle("Generated on \(formattedDate())", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 20
            
            // Property Details
            yPosition = drawSectionHeader("Property Details", at: yPosition, margin: margin)
            yPosition = drawRow("Home Price", formatCurrency(model.homePrice), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Down Payment", formatCurrency(model.downPayment), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Closing Costs", formatCurrency(model.closingCosts), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 10
            
            // Loan Terms
            yPosition = drawSectionHeader("Loan Terms", at: yPosition, margin: margin)
            yPosition = drawRow("Loan Amount", formatCurrency(model.loanAmount), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("APR", formatPercent(model.aprPercent), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Term", "\(model.termYears) years", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Annual Property Tax", formatCurrency(model.propertyTax), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 10
            
            // Payment Summary
            yPosition = drawSectionHeader("Monthly Payment Breakdown", at: yPosition, margin: margin)
            yPosition = drawDivider(at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Principal & Interest", formatCurrency(model.monthlyPrincipalAndInterest), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Property Tax", formatCurrency(model.monthlyPropertyTax), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Total Monthly Payment", formatCurrency(model.monthlyPayment), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true, valueColor: .systemBlue)
            yPosition += 10
            
            // Totals
            yPosition = drawSectionHeader("Loan Totals", at: yPosition, margin: margin)
            yPosition = drawRow("Total Interest", formatCurrency(model.totalInterest), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Total Amount Paid", formatCurrency(model.totalPaid), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true)
            
            // Footer
            drawFooter(at: pageHeight - margin, pageWidth: pageWidth, margin: margin)
        }
        
        return data
    }
    
    static func generateSavingsPDF(model: SavingPlannerModel) -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            var yPosition: CGFloat = margin
            
            // Title
            yPosition = drawTitle("Savings Plan Summary", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawSubtitle("Generated on \(formattedDate())", at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition += 20
            
            // Savings Details
            yPosition = drawSectionHeader("Savings Details", at: yPosition, margin: margin)
            yPosition = drawRow("Starting Balance", formatCurrency(model.starting), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Monthly Contribution", formatCurrency(model.contribution), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Annual Interest Rate (APY)", formatPercent(model.apyPercent), at: yPosition, pageWidth: pageWidth, margin: margin)
            yPosition = drawRow("Savings Goal", formatCurrency(model.goal), at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true, valueColor: .systemGreen)
            yPosition += 10
            
            // Goal Progress
            yPosition = drawSectionHeader("Goal Progress", at: yPosition, margin: margin)
            yPosition = drawDivider(at: yPosition, pageWidth: pageWidth, margin: margin)
            
            let months = model.monthsToGoal
            if months == Int.max {
                yPosition = drawRow("Time to Goal", "Unable to reach goal", at: yPosition, pageWidth: pageWidth, margin: margin, valueColor: .systemRed)
            } else if months == 0 {
                yPosition = drawRow("Time to Goal", "Goal already reached!", at: yPosition, pageWidth: pageWidth, margin: margin, valueColor: .systemGreen)
            } else {
                let years = months / 12
                let remainingMonths = months % 12
                var timeString = ""
                if years > 0 { timeString += "\(years) year\(years == 1 ? "" : "s")" }
                if remainingMonths > 0 {
                    if !timeString.isEmpty { timeString += " " }
                    timeString += "\(remainingMonths) month\(remainingMonths == 1 ? "" : "s")"
                }
                yPosition = drawRow("Time to Goal", timeString, at: yPosition, pageWidth: pageWidth, margin: margin, isBold: true)
                yPosition = drawRow("Total Months", "\(months)", at: yPosition, pageWidth: pageWidth, margin: margin)
            }
            
            // Projection Summary
            if let lastPoint = model.projectionToGoal.last, months != Int.max && months > 0 {
                yPosition += 10
                yPosition = drawSectionHeader("At Goal", at: yPosition, margin: margin)
                yPosition = drawRow("Final Balance", formatCurrency(lastPoint.balance), at: yPosition, pageWidth: pageWidth, margin: margin)
                yPosition = drawRow("Total Contributions", formatCurrency(lastPoint.contributionsToDate), at: yPosition, pageWidth: pageWidth, margin: margin)
                yPosition = drawRow("Interest Earned", formatCurrency(lastPoint.interestEarnedToDate), at: yPosition, pageWidth: pageWidth, margin: margin, valueColor: .systemGreen)
            }
            
            // Footer
            drawFooter(at: pageHeight - margin, pageWidth: pageWidth, margin: margin)
        }
        
        return data
    }
    
    // MARK: - Drawing Helpers
    
    @discardableResult
    private static func drawTitle(_ text: String, at y: CGFloat, pageWidth: CGFloat, margin: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 28, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let size = attributedString.size()
        let x = (pageWidth - size.width) / 2
        attributedString.draw(at: CGPoint(x: x, y: y))
        return y + size.height + 10
    }
    
    @discardableResult
    private static func drawSubtitle(_ text: String, at y: CGFloat, pageWidth: CGFloat, margin: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor.darkGray
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let size = attributedString.size()
        let x = (pageWidth - size.width) / 2
        attributedString.draw(at: CGPoint(x: x, y: y))
        return y + size.height + 8
    }
    
    @discardableResult
    private static func drawSectionHeader(_ text: String, at y: CGFloat, margin: CGFloat) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(at: CGPoint(x: margin, y: y))
        return y + attributedString.size().height + 10
    }
    
    @discardableResult
    private static func drawRow(
        _ label: String,
        _ value: String,
        at y: CGFloat,
        pageWidth: CGFloat,
        margin: CGFloat,
        isBold: Bool = false,
        valueColor: UIColor = .black
    ) -> CGFloat {
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: isBold ? .semibold : .regular),
            .foregroundColor: UIColor.black
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.monospacedDigitSystemFont(ofSize: 14, weight: isBold ? .bold : .medium),
            .foregroundColor: valueColor
        ]
        
        let labelString = NSAttributedString(string: label, attributes: labelAttributes)
        let valueString = NSAttributedString(string: value, attributes: valueAttributes)
        
        labelString.draw(at: CGPoint(x: margin, y: y))
        let valueX = pageWidth - margin - valueString.size().width
        valueString.draw(at: CGPoint(x: valueX, y: y))
        
        return y + max(labelString.size().height, valueString.size().height) + 8
    }
    
    @discardableResult
    private static func drawDivider(at y: CGFloat, pageWidth: CGFloat, margin: CGFloat) -> CGFloat {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: margin, y: y))
        path.addLine(to: CGPoint(x: pageWidth - margin, y: y))
        UIColor.lightGray.setStroke()
        path.lineWidth = 1.0
        path.stroke()
        return y + 15
    }
    
    private static func drawFooter(at y: CGFloat, pageWidth: CGFloat, margin: CGFloat) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor: UIColor.gray
        ]
        let text = "Generated by MyMoney App"
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let size = attributedString.size()
        let x = (pageWidth - size.width) / 2
        attributedString.draw(at: CGPoint(x: x, y: y))
    }
    
    // MARK: - Formatting Helpers
    
    private static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    private static func formatPercent(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return "\(formatter.string(from: NSNumber(value: value)) ?? "0")%"
    }
    
    private static func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }
}

// MARK: - Share Sheet Helper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Export Button View
struct ExportButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text(title)
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.blue)
            )
        }
    }
}
