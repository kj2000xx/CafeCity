//
//  SNNode+Ext.swift
//  CafeCity
//
//  Created by Shane on 2019/8/16.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    
    // This solved flickering issue.
    func renderOnTop() {
        self.renderingOrder = 2
        if let geom = self.geometry {
            for material in geom.materials {
                material.readsFromDepthBuffer = false
            }
        }
        for child in self.childNodes {
            child.renderOnTop()
        }
    }
}
