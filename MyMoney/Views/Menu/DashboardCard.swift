import SwiftUI
import Charts

struct DashboardCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let trendData: [TrendPoint]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(color)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .monospacedDigit()
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if !trendData.isEmpty {
                Chart(trendData) { point in
                    LineMark(
                        x: .value("Index", point.index),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(color.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Index", point.index),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 40)
            }
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct TrendPoint: Identifiable {
    let id = UUID()
    let index: Int
    let value: Double
}

#Preview {
    VStack(spacing: 16) {
        DashboardCard(
            title: "Avg Auto Loan",
            value: "7.2%",
            subtitle: "60-month new car",
            icon: "car.fill",
            color: .blue,
            trendData: [
                TrendPoint(index: 0, value: 6.8),
                TrendPoint(index: 1, value: 7.0),
                TrendPoint(index: 2, value: 7.1),
                TrendPoint(index: 3, value: 7.3),
                TrendPoint(index: 4, value: 7.2)
            ]
        )
        
        DashboardCard(
            title: "Avg Mortgage",
            value: "6.8%",
            subtitle: "30-year fixed",
            icon: "house.fill",
            color: .green,
            trendData: [
                TrendPoint(index: 0, value: 6.5),
                TrendPoint(index: 1, value: 6.7),
                TrendPoint(index: 2, value: 6.9),
                TrendPoint(index: 3, value: 6.8),
                TrendPoint(index: 4, value: 6.8)
            ]
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
