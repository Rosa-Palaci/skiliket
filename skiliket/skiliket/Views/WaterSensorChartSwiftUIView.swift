//
//  WaterSensorChartSwiftUIView.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import SwiftUI
import Charts

struct WaterSensorChartSwiftUIView: View {
    
    let waterReadings: [WaterSensorInfo]
    
    var body: some View {
        Chart {
            ForEach(waterReadings, id: \.timeStamp) { reading in
                LineMark(
                    x: .value("Day", reading.timeStamp, unit: .day),
                    y: .value("Water Level", reading.value)
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

// Simulación de una estructura para datos del sensor de agua
struct WaterSensorInfo: Identifiable {
    let id = UUID()
    let value: Double
    let timeStamp: Date
}

#Preview {
    WaterSensorChartSwiftUIView(
        waterReadings: [
            WaterSensorInfo(value: 10.0, timeStamp: Date()),
            WaterSensorInfo(value: 15.0, timeStamp: Date().addingTimeInterval(86400)),  // +1 día
            WaterSensorInfo(value: 12.0, timeStamp: Date().addingTimeInterval(2 * 86400)),  // +2 días
            WaterSensorInfo(value: 18.0, timeStamp: Date().addingTimeInterval(3 * 86400)),  // +3 días
            WaterSensorInfo(value: 14.0, timeStamp: Date().addingTimeInterval(4 * 86400))   // +4 días
        ]
    )
}
