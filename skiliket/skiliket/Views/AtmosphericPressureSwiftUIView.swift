//
//  AtmosphericPressureSwiftUIView.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import SwiftUI
import Charts

struct AtmosphericPressureChartSwiftUIView: View {
    
    let pressures: [AtmosphericPressureInfo]
    
    var body: some View {
        Chart {
            ForEach(pressures, id: \.timeStamp) { pressure in
                LineMark(
                    x: .value("Day", pressure.timeStamp, unit: .day),
                    y: .value("Pressure", pressure.value)
                )
                .foregroundStyle(.green)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}

// Simulación de una estructura para datos de presión atmosférica
struct AtmosphericPressureInfo: Identifiable {
    let id = UUID()
    let value: Double
    let timeStamp: Date
}

#Preview {
    AtmosphericPressureChartSwiftUIView(
        pressures: [
            AtmosphericPressureInfo(value: 1013, timeStamp: Date()),
            AtmosphericPressureInfo(value: 1010, timeStamp: Date().addingTimeInterval(86400)),  // +1 día
            AtmosphericPressureInfo(value: 1015, timeStamp: Date().addingTimeInterval(2 * 86400)),  // +2 días
            AtmosphericPressureInfo(value: 1008, timeStamp: Date().addingTimeInterval(3 * 86400)),  // +3 días
            AtmosphericPressureInfo(value: 1020, timeStamp: Date().addingTimeInterval(4 * 86400))   // +4 días
        ]
    )
}
