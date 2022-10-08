//
//  AstroDeliveryAttributes.swift
//  LiveActivities
//
//  Created by Ignatio Julian on 08/10/22.
//

import SwiftUI
import ActivityKit

struct AstroDeliveryAttributes: ActivityAttributes {
    public typealias DeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var driverName: String
        var estimatedDeliveryTime: ClosedRange<Date>
    }

    var numberOfQuantity: Int
    var totalAmount: String
}

struct AdAttributes: ActivityAttributes {
    public typealias AdStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var adName: String
        var showTime: Date
    }
    
    var discount: String
}

