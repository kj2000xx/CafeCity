//
//  MapViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/7/30.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit
import Moya

class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    enum MyButtonTagName: Int {
        case search = 0
        case arView = 1
        case myLocation = 2
    }
    
    //Property
    let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    var cafeNomadArrayModel: [CafeNomadModel]?
    var cafeAnnotationArrayModel: [MKPointAnnotation]?
    
    
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
        
        myMapView.delegate = self
        myMapView.userTrackingMode = .follow
        myAppdelegate.myLocationManger.delegate = self
        self.tryGoToMyLocation()
        
        self.callCafeNoMadAPI()
        
        
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
    
    @objc func scaleButton(sender: UIButton?)
    {
        let scaleTransform = CGAffineTransform.init(scaleX: 0.6, y: 0.6 )
        sender?.transform = scaleTransform
        
        UIView.animate(withDuration: 0.35, delay: 0.12, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.7, options: [], animations: {
            sender?.transform = .identity
        }, completion: nil)
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
        aSpan.latitudeDelta = 0.02
        aSpan.longitudeDelta = 0.02
        
        var aRegion = MKCoordinateRegion()
        aRegion.center = myLocationManger.location!.coordinate
        aRegion.span = aSpan
        
        self.myMapView.setRegion(aRegion, animated: false)
        
        self.myMapView.removeAnnotations(myMapView.annotations)
        if let _cafeAnnotationArrayModel = self.cafeAnnotationArrayModel {
            self.showMapViewAnnotationa(annotations: _cafeAnnotationArrayModel)
        }
        
    }
    
    func showMapViewAnnotationa(annotations: [MKPointAnnotation])
    {
        
        for aAnnotation in annotations {
            
            if let _aAnnotation = self.isCoodsInRegions(annotation: aAnnotation) {
                myMapView.addAnnotation(_aAnnotation)
            }
        }
        
    }
    
    func removeOutRegionAnnotationOfMapView(annotations: [MKPointAnnotation])
    {
        var outRangeAnnotations = [MKPointAnnotation]()
        
        outRangeAnnotations = annotations
        
        for aAnnotation in annotations {
            if let _aAnnotation = self.isCoodsInRegions(annotation: aAnnotation) {
                outRangeAnnotations.removeAll(where: {$0 == _aAnnotation})
            }
        }
        
        myMapView.removeAnnotations(outRangeAnnotations)
    }
    
    func appearSearchView()
    {
        
    }
    
    
    // MARK: - Handler
    func handleCafeNomadAPIModel(data: [CafeNomadModel])
    {
        self.cafeNomadArrayModel = data
        self.syncCafeNomadModelToMyAnnotation(cafeNomadModelArray: data)
        
        if let _cafeAnnotationArrayModel = self.cafeAnnotationArrayModel {
            self.showMapViewAnnotationa(annotations: _cafeAnnotationArrayModel)
        }
        
    }
    
    func syncCafeNomadModelToMyAnnotation(cafeNomadModelArray: [CafeNomadModel])
    {
        var aAnnotationArray = [MKPointAnnotation]()
        
        for cafeModel in cafeNomadModelArray {
            let aAnnotation = MKPointAnnotation()
            aAnnotation.coordinate = CLLocationCoordinate2D(latitude: (cafeModel.latitude as NSString).doubleValue, longitude: (cafeModel.longitude as NSString).doubleValue)
            aAnnotation.title = cafeModel.name
            
            aAnnotationArray.append(aAnnotation)
        }
        
        self.cafeAnnotationArrayModel = aAnnotationArray
        
    }
    
    
    // MARK: - Call API
    func callCafeNoMadAPI()
    {
        
        let provier = MoyaProvider<API>()
        
        provier.request(.api) { (result) in
            switch result {
            case let .success(response):
                print(response)
                
                if let cafeListModel = try? JSONDecoder().decode([CafeNomadModel].self, from: response.data) {
                    self.handleCafeNomadAPIModel(data: cafeListModel)
                    
                } else {
                    print("CafeNomadModel map failed")
                }
                
            case let .failure(error):
                print("网络连接失败 + \(error)")
                
                break
            }
        }
        
        
    }
    
    // MARK: - Helper
    func openURL(scheme: String)
    {
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
    
    
    func isCoodsInRegions(annotation: MKPointAnnotation) -> MKPointAnnotation?
    {
        let aAnnotation = annotation
        var coords = aAnnotation.coordinate
        
        
        var leftDegrees: CLLocationDegrees = myMapView.region.center.longitude - (myMapView.region.span.longitudeDelta / 2.0);
        let rightDegrees: CLLocationDegrees = myMapView.region.center.longitude + (myMapView.region.span.longitudeDelta / 2.0);
        let bottomDegrees: CLLocationDegrees = myMapView.region.center.latitude - (myMapView.region.span.latitudeDelta / 2.0);
        let topDegrees: CLLocationDegrees = myMapView.region.center.latitude + (myMapView.region.span.latitudeDelta / 2.0);
        
        if (leftDegrees > rightDegrees)
        {   // Int'l Date Line in View
            leftDegrees = -180.0 - leftDegrees;
            
            // coords to West of Date Line
            if (coords.longitude > 0) {
                coords.longitude = -180.0 - coords.longitude;
            }
        }
        
        if (leftDegrees <= coords.longitude
            && coords.longitude <= rightDegrees
            && bottomDegrees <= coords.latitude
            && coords.latitude <= topDegrees)
        {
            return annotation
        }
        
        return nil
    }
    
    
    // MARK: - MapView Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CafeMarker"
        
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.markerTintColor = .init(red: 242/255, green: 110/255, blue: 80/255, alpha: 1)
        //            annotationView?.glyphText = "☕️"
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        
        mapView.removeAnnotations(mapView.annotations)
        if let _cafeAnnotationArrayModel = self.cafeAnnotationArrayModel {
            self.showMapViewAnnotationa(annotations: _cafeAnnotationArrayModel)
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
