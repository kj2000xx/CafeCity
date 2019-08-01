//
//  MapViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/7/30.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Property
    
    //View
    var myMapView: MKMapView! {
        didSet{
            myMapView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var searchButton: UIButton! {
        didSet{
            searchButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var arViewbutton: UIButton! {
        didSet{
            arViewbutton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    var myLocationButton: UIButton! {
        didSet{
            myLocationButton.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    
    
    // MARK: - Life Circle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.buildingView()
        self.customBuilding()
        self.setupView()
        self.setupConstaints()
        
    }
    
    
    // MARK: - Common
    
    func buttonDidSelected(sender: UIButton?)
    {
        print(sender! )
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
