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
import Cosmos
import WebKit
import WKWebViewController

class MapViewController: UIViewController, CLLocationManagerDelegate,  SearchFilterViewDelegate {
    
    enum MapViewButtonTagName: Int {
        case search = 0
        case arView = 1
        case myLocation = 2
    }
    
    //Property
    let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
    var myCafeMapModel: CafeMapModel?
    var finalShowAnnotationArray: [MKPointAnnotation]?
    var finalInRegionShowAnnotationArray: [MKPointAnnotation]?
    
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
        
        self.setStatusBarBackgroundColor(color: UIColor.myColor.mainColor)
        
        myMapView.delegate = self
        myMapView.userTrackingMode = .follow
        myAppdelegate.myLocationManger.delegate = self
        self.tryGoToMyLocation()
        
        self.callCafeNoMadAPI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - Common
    @objc func buttonPressed(sender: UIButton?)
    {
        switch sender?.tag {
        case MapViewButtonTagName.search.rawValue:
            print(String(sender!.tag))
            
            self.showSearchFilterView()
            
        case MapViewButtonTagName.arView.rawValue:
            print(String(sender!.tag))
            
            self.showArView()
            
        case MapViewButtonTagName.myLocation.rawValue:
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
    
    func setStatusBarBackgroundColor(color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
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
                fatalError("Failed to go to self's location")
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
        aSpan.latitudeDelta = 0.012
        aSpan.longitudeDelta = 0.012
        
        var aRegion = MKCoordinateRegion()
        if let _mylocation = myLocationManger.location {
            
            aRegion.center = _mylocation.coordinate
            aRegion.span = aSpan
            self.myMapView.setRegion(aRegion, animated: true)
        }
        
        if let _finalShowAnnotationArray = self.finalShowAnnotationArray {
            self.showMapViewAnnotationa(annotations: _finalShowAnnotationArray)
        }
        
    }
    
    func showMapViewAnnotationa(annotations: [MKPointAnnotation])
    {
        self.finalInRegionShowAnnotationArray = [MKPointAnnotation]()
        for aAnnotation in annotations {
            
            if self.isAnnotationInViewRange(annotation: aAnnotation) {
                myMapView.addAnnotation(aAnnotation)
                self.finalInRegionShowAnnotationArray?.append(aAnnotation)
            } else {
                myMapView.removeAnnotation(aAnnotation)
            }
        }
        
    }
    
    func showArView()
    {
        //        let lodingLayer = CycleLoadingView(frame: CGRect(x: self.view.frame.midX - 60, y: self.view.frame.midY - 90, width: 120, height: 120))
        //        self.myMapView.addSubview(lodingLayer)
        //        lodingLayer.startLoading()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let arViewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController  {
            
            if let finalInRegionShowAnnotationArray = self.finalInRegionShowAnnotationArray{
                arViewController.sourceAnnotation = finalInRegionShowAnnotationArray
            }
            present(arViewController, animated: true)
        }
        
    }
    
    func showSearchFilterView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for subViewController in self.children {
            if subViewController.isKind(of: SearchFilterViewController.self) {
                return
            }
        }
        
        if let searchFilterViewController = storyboard.instantiateViewController(withIdentifier: "searchFilterViewController") as? SearchFilterViewController {
            
            searchFilterViewController.delegate = self
            
            self.addChild(searchFilterViewController)
            searchFilterViewController.view.frame = CGRect(x: (self.myMapView.bounds.width - 300)/2 , y: 100, width: 300, height: 400)
            self.view.addSubview(searchFilterViewController.view)
            searchFilterViewController.didMove(toParent: self)
            
        }
        
    }
    
    @objc func showWebView(sender: UIButton?)
    {
        let domain = "https://cafenomad.tw/shop/"
        let id: String = sender?.layer.value(forKey: "id") as! String
        
        let url = URL.init(string: domain + id )!
        
        let webViewController = WKWebViewController.init()
        webViewController.source = .remote(url)
        webViewController.bypassedSSLHosts = [url.host!]
//        webViewController.userAgent = "WKWebViewController/1.0.0"
        webViewController.websiteTitleInNavigationBar = false
        webViewController.navigationItem.title = ""
        webViewController.leftNavigaionBarItemTypes = [.reload]
        webViewController.toolbarItemTypes = [.back, .forward, .activity]
        
        let navigation = UINavigationController.init(rootViewController: webViewController)
        
        self.present(navigation, animated: true, completion: nil)

    }
    
    // MARK: - Handler
    func handleCafeNomadAPIModel(data: [CafeNomadAPIModel])
    {
        self.myCafeMapModel = CafeMapModel.shared
        self.myCafeMapModel?.cafeNomadAPIModelArray = data
        
        if let _cafeNomadAPIModelArray = self.myCafeMapModel?.cafeNomadAPIModelArray {
            self.syncCafeNomadModelToMyAnnotation(cafeNomadModelArray: _cafeNomadAPIModelArray)
        }
        
        self.finalShowAnnotationArray = self.myCafeMapModel?.allAnnotationArry
        if let finalShowAnnotationArray = self.finalShowAnnotationArray {
            self.showMapViewAnnotationa(annotations: finalShowAnnotationArray)
        }
        
    }
    
    func syncCafeNomadModelToMyAnnotation(cafeNomadModelArray: [CafeNomadAPIModel])
    {
        var aAnnotationArray = [MKPointAnnotation]()
        
        for aCafeModel in cafeNomadModelArray {
            let aAnnotation = MKPointAnnotation()
            aAnnotation.coordinate = CLLocationCoordinate2D(latitude: (aCafeModel.latitude as NSString).doubleValue, longitude: (aCafeModel.longitude as NSString).doubleValue)
            aAnnotation.title = aCafeModel.name
            
            aAnnotationArray.append(aAnnotation)
        }
        
        self.myCafeMapModel?.allAnnotationArry = aAnnotationArray
        
    }
    
    
    // MARK: - Call API
    func callCafeNoMadAPI()
    {
        let provier = MoyaProvider<API>()
        
        provier.request(.api) { (result) in
            switch result {
            case let .success(response):
                print("callCafeNoMadAPI sussceed \(response)")
                
                if let cafeListModel = try? JSONDecoder().decode([CafeNomadAPIModel].self, from: response.data) {
                    
                    self.handleCafeNomadAPIModel(data: cafeListModel)
                    
                } else {
                    print("CafeNomadModel mapping failed")
                }
                
            case let .failure(error):
                print("網路連接失敗 + \(error)")
                
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
    
    
    func isAnnotationInViewRange(annotation: MKPointAnnotation) -> Bool
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
            return true
        }
        
        return false
    }
    
    // MARK: - SearchFilter Delegate
    
    func refreshShowFilterResultAnnotaion(buttonName: String) {
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        switch buttonName {
        case "searchButton":
            self.finalShowAnnotationArray = self.myCafeMapModel?.filiterResultArray
        case "defaultButton":
            self.finalShowAnnotationArray = self.myCafeMapModel?.allAnnotationArry
        default:
            fatalError("refreshShowFilterResultAnnotaion get buttonName failed")
        }
        if let _finalShowAnnotationArray = self.finalShowAnnotationArray {
            self.showMapViewAnnotationa(annotations: _finalShowAnnotationArray)
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


extension MapViewController: MKMapViewDelegate{
    
    // MARK: - MapView Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CafeMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = UIColor.myColor.mainColor
        }
        
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView])
    {
        for aAnnotationView in views {
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            aAnnotationView.transform = scaleTransform
            
            UIView.animate(withDuration: 0.8, delay: 0.12, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.7, options: [], animations: {
                aAnnotationView.transform = .identity
            }, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        if let _finalShowAnnotationArray = self.finalShowAnnotationArray {
            self.showMapViewAnnotationa(annotations: _finalShowAnnotationArray)
        }
    }

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard !view.annotation!.isKind(of: MKUserLocation.self) else {return}
             self.configureDetailView(annotationView: view)
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        view.detailCalloutAccessoryView = nil
    }
    
    
    // MARk: - Helper
    
    //creat View
    func configureDetailView(annotationView: MKAnnotationView)
    {
        let width = 160
        let height = 140
        
        let detailView = UIView()
        let views = ["detailView": detailView]
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[detailView(\(width))]", options: [], metrics: nil, views: views))
        detailView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[detailView(\(height))]", options: [], metrics: nil, views: views))
        
        var cafeNomadAPIModel: CafeNomadAPIModel?
        
        if let _cafeNomadAPIModelArray = self.myCafeMapModel?.cafeNomadAPIModelArray {
            for aCafeNomadAPIModel in _cafeNomadAPIModelArray {
                
                if aCafeNomadAPIModel.name == annotationView.annotation?.title{
                    cafeNomadAPIModel = aCafeNomadAPIModel
                }
            }
        }
        
        
        if let _cafeNomadAPIModel = cafeNomadAPIModel {
            
            let keyArrays = [ "Wi-Fi", "有座位", "音樂", "好喝", "價位"];
            let rateArrays = [ _cafeNomadAPIModel.wifi, _cafeNomadAPIModel.seat,  _cafeNomadAPIModel.music, _cafeNomadAPIModel.tasty, _cafeNomadAPIModel.cheap,]
            
            let labelWidth = 44
            let labelHeight = 25
            
            var lableStartY = 0
            var ratingViewStartY = 1
            
            for i in 0...keyArrays.count-1  {
                let alabel = self.creatRateTitleLabel(x: 0, y: lableStartY, width: labelWidth, height: labelHeight)
                
                alabel.text = keyArrays[i]
                lableStartY = lableStartY + labelHeight
                detailView.addSubview(alabel)
                
                let wifiRatingView = self.creatStarRateView(x: 48, y: ratingViewStartY, rating: Double(rateArrays[i]))
                
                ratingViewStartY = ratingViewStartY + 25
                detailView.addSubview(wifiRatingView)
            }
            
        }
        
        annotationView.detailCalloutAccessoryView = detailView
        
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(showWebView), for: .touchUpInside)
        
        if let _id = cafeNomadAPIModel?.id {
            rightButton.layer.setValue(_id, forKey: "id")
            annotationView.rightCalloutAccessoryView = rightButton
        }
        
        annotationView.leftCalloutAccessoryView = UIButton(type: .contactAdd)
    
    }
    
    
    func creatRateTitleLabel(x: Int, y: Int, width: Int, height: Int) -> UILabel
    {
        
        let alabel = UILabel(frame: CGRect(x: 0, y: y, width: width, height: height))
        alabel.font = .boldSystemFont(ofSize: 14)
        alabel.textAlignment = .center
        alabel.textColor = .red
        
        return alabel
    }
    
    func creatStarRateView(x: Int, y: Int,rating: Double) -> UIView
    {
        
        let ratingView = CosmosView(frame: CGRect(x: x, y: y, width: 100, height: 25))
        ratingView.settings.updateOnTouch = false
        ratingView.settings.starSize = 22
        ratingView.settings.starMargin = 2
        ratingView.settings.fillMode = .full
        
        ratingView.settings.filledColor = .orange
        ratingView.settings.filledBorderColor = .white
        ratingView.settings.emptyBorderColor = .gray
        ratingView.settings.textColor = .red
        
        ratingView.rating = rating
        
        
        return ratingView
    }
    
    
}


