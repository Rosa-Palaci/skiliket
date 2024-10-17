//
//  HumidityChartSwiftUIView.swift
//  skiliket
//
//  Created by Rosa Palacios on 12/10/24.
//

import SwiftUI
import Charts

struct HumidityChartSwiftUIView: View {
    
    let humidities: [HumidityInfo]
    
    var body: some View {
        Chart {
            ForEach(humidities, id: \.timeStamp) { humidity in
                LineMark(
                    x: .value("Day", humidity.timeStamp, unit: .day),
                    y: .value("Humidity", humidity.value)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}

// Simulación de una estructura para datos de humedad
struct HumidityInfo: Identifiable {
    let id = UUID()
    let value: Double
    let timeStamp: Date
}

#Preview {
    HumidityChartSwiftUIView(
        humidities: [
            HumidityInfo(value: 60, timeStamp: Date()),
            HumidityInfo(value: 65, timeStamp: Date().addingTimeInterval(86400)),  // +1 día
            HumidityInfo(value: 70, timeStamp: Date().addingTimeInterval(2 * 86400)),  // +2 días
            HumidityInfo(value: 68, timeStamp: Date().addingTimeInterval(3 * 86400)),  // +3 días
            HumidityInfo(value: 72, timeStamp: Date().addingTimeInterval(4 * 86400))   // +4 días
        ]
    )
}
