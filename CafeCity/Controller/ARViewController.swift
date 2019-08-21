//
//  ARViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/8/15.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit
import ARCL
import CoreLocation
import ARKit
import SceneKit
import Cosmos

class ARViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Property
    var sceneLocationView = SceneLocationView()
    var sourceAnnotation = [MKPointAnnotation]()
    let locationManager = CLLocationManager()
    var userCurrentLocation: CLLocation?
    
    var adjustedHeight: Double = 0
    var settingDistance:Double = 500.0
    
    
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Life Circle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.startReceivingLocationChanges()
        
        self.sceneLocationView.run()
//        self.view.addSubview(self.sceneLocationView)
        self.view.insertSubview(self.sceneLocationView, belowSubview: self.backButton)
    }
    
    override func viewDidLayoutSubviews()
    {
        self.sceneLocationView.frame = self.view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sceneLocationView.pause()
    }

    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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

extension ARViewController {
    
    // MARK: - Common
    func addLocationNodeInSceneLocationView(didFetch annotations: [MKPointAnnotation]) {
        
        for aAnnotation in annotations {
            
            if self.checkDistane(annotation: aAnnotation) {
            
            let view = generateView(with: aAnnotation)
            
            let image = view.asImage()
            image.accessibilityIdentifier = aAnnotation.title
            
            let  coordinate = aAnnotation.coordinate
            
            let location = CLLocation(coordinate: coordinate, altitude: adjustedHeight)
            self.adjustedHeight += 5
            
            let annotaionNode = LocationAnnotationNode(location: location, image: image)
            
            annotaionNode.continuallyAdjustNodePositionWhenWithinRange = false
            annotaionNode.continuallyUpdatePositionAndScale = false
            
            annotaionNode.renderOnTop()
            
            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotaionNode)
            }
        }
    }
    
    
    private func generateView(with annotation: MKPointAnnotation) -> UIView {
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 230, height: 30))
        nameLabel.text = annotation.title
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        var rating: Double = 0
        let myCafeMapModel = CafeMapModel.shared.cafeNomadAPIModelArray
        
        for aCafeMapModel in myCafeMapModel! {
            if aCafeMapModel.name == annotation.title {
                rating = aCafeMapModel.averageRate
            }
            
        }
        
        let ratingView = CosmosView(frame: CGRect(x: 5, y: 35, width: 150, height: 30))
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 18
        ratingView.settings.starMargin = 1
        ratingView.settings.fillMode = .full

        ratingView.settings.filledColor = .yellow
        ratingView.settings.filledBorderColor = .white
        ratingView.settings.emptyBorderColor = .white
        ratingView.rating = rating
        ratingView.settings.textColor = .lightText
        ratingView.text = "(平均)"
        
        
        let annotationLocation = CLLocation.init(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distance = self.userCurrentLocation?.distance(from: annotationLocation)
        
        let distanceLabel = UILabel(frame: CGRect(x: 170, y: 30, width: 90, height: 30))
        distanceLabel.text = "\(String(format: "%.1f", distance!))m"
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1)
        
        let view = UIView()
        view.isOpaque = false
        view.frame = CGRect.init(x: 0, y: 0, width: 240, height: 70)
        view.backgroundColor = UIColor.myColor.mainColor
        view.alpha = 0.8
        view.layer.applySketchShadow()
        view.addSubview(nameLabel)
        view.addSubview(ratingView)
        view.addSubview(distanceLabel)
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 240, height: 60), cornerRadius: 5)
        path.move(to: CGPoint(x: 115, y: 60))
        path.addLine(to: CGPoint(x: 125, y: 70))
        path.addLine(to: CGPoint(x: 135, y: 60))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        view.layer.mask = shapeLayer
        
        return view
    }
    
    func startReceivingLocationChanges()
    {
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            if location.horizontalAccuracy > 0 {
                
                self.userCurrentLocation = location
                
                self.locationManager.delegate = nil
                
                self.locationManager.stopUpdatingLocation()
                
                self.addLocationNodeInSceneLocationView(didFetch: self.sourceAnnotation)
                
            }
        }
    }

    
    // MARK: - Helper
    func checkDistane(annotation: MKPointAnnotation) -> Bool {
        
        let annotationLocation = CLLocation.init(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        let distance = self.userCurrentLocation?.distance(from: annotationLocation)
        
        let checkResult = Double(distance!) < self.settingDistance
        
        return checkResult
    }
    
}






