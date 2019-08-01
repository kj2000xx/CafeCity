//
//  MapViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/7/30.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    enum MyButtonTagName: Int {
        case search = 0
        case arView = 1
        case myLocation = 2
    }
    
    //Property
    let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
        
        myAppdelegate.myLocationManger.delegate = self
        self.tryGoToMyLocation()
    }
    
    
    // MARK: - Common
    
    @objc func buttonDidpressed(sender: UIButton?)
    {
        switch sender?.tag {
        case MyButtonTagName.search.rawValue:
            print(String(sender!.tag))
            
            
        case MyButtonTagName.arView.rawValue:
            print(String(sender!.tag))
            
            
        case MyButtonTagName.myLocation.rawValue:
            print(String(sender!.tag))
            
            self.tryGoToMyLocation()
            
        default:
            print("button pressed failed")
            
        }
        
    }
    
    func tryGoToMyLocation()
    {
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                print("No access")
                
                let alertMessage = UIAlertController(title: "Location Services Disabled", message: "You need to enable location services in settings.", preferredStyle: .alert)
                
                alertMessage.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { (action: UIAlertAction!) in
                    
                    let schemeString = UIApplication.openSettingsURLString
                    
                    self.openURL(scheme: schemeString )
                }))
                
                present(alertMessage, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.goToMyLocation()
                
            case .notDetermined:
                print("asking for access...")
                myAppdelegate.myLocationManger.requestAlwaysAuthorization()
                
            @unknown default:
                fatalError()
            }
            
        } else {
            
            let alertMessage = UIAlertController(title: "Location Services Disabled", message: "You need to enable location services in settings.", preferredStyle: .alert)
            
            alertMessage.addAction(UIAlertAction(title: "Okay!", style: .default, handler: { (action: UIAlertAction!) in
                
                let schemeString = "App-Prefs:root=Privacy&path=LOCATION"
                
                self.openURL(scheme: schemeString )
            }))
            
            present(alertMessage, animated: true, completion: nil)
        }
    }
    
    func goToMyLocation()
    {
        let myLocationManger = myAppdelegate.myLocationManger
        
        myLocationManger.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManger.distanceFilter = 1
        
        var aSpan = MKCoordinateSpan()
        aSpan.latitudeDelta = 0.01
        aSpan.longitudeDelta = 0.01
        
        var aRegion = MKCoordinateRegion()
        aRegion.center = myLocationManger.location!.coordinate
        aRegion.span = aSpan
        
        self.myMapView.setRegion(aRegion, animated: false)
        
    }
    
    
    // MARK: - Helper
    func openURL(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
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
