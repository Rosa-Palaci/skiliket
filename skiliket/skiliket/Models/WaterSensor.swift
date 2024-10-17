//
//  WaterSensor.swift
//  skiliket
//
//  Created by Rosa Palacios on 17/10/24.
//

import Foundation

class WaterSensor: Identifiable {
    var value: String
    var timeStamp: Date
    
    init(value: String, timeStamp: Date) {
        self.value = value
        self.timeStamp = timeStamp
    }
}
