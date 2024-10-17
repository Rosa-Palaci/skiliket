//
//  SoundSensorChartSwiftUIView.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import SwiftUI
import Charts

struct SoundSensorChartSwiftUIView: View {
    
    let soundReadings: [SoundSensorInfo]
    
    var body: some View {
        Chart {
            ForEach(soundReadings, id: \.timeStamp) { reading in
                LineMark(
                    x: .value("Day", reading.timeStamp, unit: .day),
                    y: .value("Sound Level", reading.value)
                )
                .foregroundStyle(.red)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .padding()
    }
}

// Simulación de una estructura para datos del sensor de sonido
struct SoundSensorInfo: Identifiable {
    let id = UUID()
    let value: Double
    let timeStamp: Date
}

#Preview {
    SoundSensorChartSwiftUIView(
        soundReadings: [
            SoundSensorInfo(value: 30.0, timeStamp: Date()),
            SoundSensorInfo(value: 45.0, timeStamp: Date().addingTimeInterval(86400)),  // +1 día
            SoundSensorInfo(value: 50.0, timeStamp: Date().addingTimeInterval(2 * 86400)),  // +2 días
            SoundSensorInfo(value: 55.0, timeStamp: Date().addingTimeInterval(3 * 86400)),  // +3 días
            SoundSensorInfo(value: 40.0, timeStamp: Date().addingTimeInterval(4 * 86400))   // +4 días
        ]
    )
}
