//
//  CafeMapModel.swift
//  CafeCity
//
//  Created by Shane on 2019/8/12.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import MapKit

class CafeMapModel {
    static let shared = CafeMapModel()
    
    var allAnnotationArry: [MKPointAnnotation]?
    var filiterResultArray: [MKPointAnnotation]?
    var cafeNomadAPIModelArray: [CafeNomadAPIModel]?
    
    }
