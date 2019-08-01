//
//  CafeNomadModel.swift
//  CafeCity
//
//  Created by Shane on 2019/8/1.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation

struct CafeNomad: Codable {
    
    var id: String
    var name: String
    var city: String
    var wifi: Int
    var seat: Int
    var quiet: Int
    var tasty: Int
    var cheap: Int
    var music: Int
    var address: String
    var latitude: Float
    var longitude: Float
    var url: String
    var limited_time: String
    var socket: String
    var standing_desk: String
    var mrt: String
    var open_time: String
}
