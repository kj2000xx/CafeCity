//
//  SearchFilterViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/8/6.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit

protocol SearchFilterViewDelegate {
    
    func refreshShowFilterResultAnnotaion(buttonName: String)
    
}

class SearchFilterViewController: UIViewController, UIPopoverPresentationControllerDelegate,PickCityViewControllerDelegate {
    
    //MARK - Property
    
    enum SearchViewButtonTagName: Int {
        case close = 0
        case location = 1
        case search = 2
        case defaultButton = 3
    }
    
    enum StarRateViewName: String {
        case wifi
        case seat
        case music
        case tasty
        case cheap
    }
    
    // Button
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.tag = SearchViewButtonTagName.close.rawValue
        }
    }
    @IBOutlet weak var locationButton: UIButton!{
        didSet{
            locationButton.tag = SearchViewButtonTagName.location.rawValue
        }
    }
    @IBOutlet weak var searchButton: UIButton!{
        didSet{
            searchButton.tag = SearchViewButtonTagName.search.rawValue
        }
    }
    @IBOutlet weak var defaultButton: UIButton!{
        didSet{
            defaultButton.tag = SearchViewButtonTagName.defaultButton.rawValue
        }
    }
    
    // UIView
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var wifiView: UIView!
    @IBOutlet weak var seatView: UIView!
    @IBOutlet weak var musicVIew: UIView!
    @IBOutlet weak var tastyView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    // StarRateView
    @IBOutlet weak var wifiStarRateView: UIView!
    @IBOutlet weak var seatStarRateView: UIView!
    @IBOutlet weak var musicStarRateView: UIView!
    @IBOutlet weak var tastyStarRateView: UIView!
    @IBOutlet weak var priceStarRateVIew: UIView!
    
    // Delegate
    var delegate:SearchFilterViewDelegate?
    
    var animationViews: [UIView]!
    var searchConditionCityName: String?
    var searchCondictionDictionary = [String : Float]()
    
    // MARK: - Life Circle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.addStarRateView()
        
        self.animationViews = [locationView, wifiView, seatView, musicVIew, tastyView, priceView]
        
        self.searchCondictionDictionary = ["wifi": 0.0, "seat": 0.0, "music": 0.0, "tasty": 0.0, "cheap": 0.0]
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        for aView in animationViews {
            self.addMoveUpTransform(view: aView)
        }
        
        for index in 0...self.animationViews.count-1 {
            UIView.animate(withDuration: 0.4, delay: 0.06 * Double(index), options: [], animations: {
                self.animationViews[index].alpha = 1
                self.animationViews[index].transform = .identity
                
            }, completion: nil)
        }
    }
    
    
    // MARK: - Common
    func addMoveUpTransform(view: UIView)
    {
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: 20)
        view.transform = moveUpTransform
        view.alpha = 0
    }
    
    func addStarRateView()
    {
        self.addStarRateViewInView(view: self.wifiStarRateView, viewName: StarRateViewName.wifi.rawValue)
        self.addStarRateViewInView(view: self.seatStarRateView, viewName: StarRateViewName.seat.rawValue)
        self.addStarRateViewInView(view: self.musicStarRateView, viewName: StarRateViewName.music.rawValue)
        self.addStarRateViewInView(view: self.tastyStarRateView, viewName: StarRateViewName.tasty.rawValue)
        self.addStarRateViewInView(view: self.priceStarRateVIew, viewName: StarRateViewName.cheap.rawValue)
    }
    
    func addStarRateViewInView(view: UIView, viewName: String)
    {
        let starRateView = StarRateView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height),totalStarCount: 5 ,currentStarCount: 0 ,starSpace: 2)
        
        view.addSubview(starRateView)
        starRateView.show(type: .default, isPanEnable: true, leastStar: 0) { (score) in
            
            self.searchCondictionDictionary[viewName] = Float(score)
            print(self.searchCondictionDictionary)
        }
        
    }
    
    func handleFilterResultAnnotationArray()
    {
        let  myCafeMapModel = CafeMapModel.shared
        
        let myCafeNomadAPIModelArray = myCafeMapModel.cafeNomadAPIModelArray
        
        var newArray = [MKPointAnnotation]()
        
        if let _myCafeNomadAPIModelArray = myCafeNomadAPIModelArray {
            
            for aCafeNomadAPIModel in _myCafeNomadAPIModelArray{
                
                if self.checkFilterCondition(cityModel: self.searchConditionCityName, rateModel: aCafeNomadAPIModel) {
                    
                    let aPointAnnotation = makeAnnotation(model: aCafeNomadAPIModel)
                    newArray.append(aPointAnnotation)
                }
                
            }
            
            myCafeMapModel.filiterResultArray = newArray
            
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton!)
    {
        switch sender.tag {
        case SearchViewButtonTagName.close.rawValue:
            print(sender.tag)
            self.dismissSelf()
            
        case SearchViewButtonTagName.location.rawValue:
            print(sender.tag)
            
            
        case SearchViewButtonTagName.search.rawValue:
            print(sender.tag)
            
            self.handleFilterResultAnnotationArray()
            self.delegate?.refreshShowFilterResultAnnotaion(buttonName: "searchButton")
            self.dismissSelf()
            
        case SearchViewButtonTagName.defaultButton.rawValue:
            print(sender.tag)
            
            self.delegate?.refreshShowFilterResultAnnotaion(buttonName: "defaultButton")
            self.dismissSelf()
            
        default:
            fatalError()
        }
    }
    
    func dismissSelf()
    {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    
    // MARK: - Helper
    func checkFilterCondition(cityModel: String?, rateModel: CafeNomadAPIModel) -> Bool {
        
        let isCityPass: Bool = (cityModel == rateModel.city)
        let isRatePass: Bool = (Int(rateModel.wifi) >= Int(self.searchCondictionDictionary["wifi"]!) && Int(rateModel.seat) >= Int(self.searchCondictionDictionary["seat"]!) && Int(rateModel.music) >= Int(self.searchCondictionDictionary["music"]!) && Int(rateModel.tasty) >= Int(self.searchCondictionDictionary["tasty"]!) && Int(rateModel.cheap) >= Int(self.searchCondictionDictionary["cheap"]!))
        
        let checkResult = (cityModel ?? "").isEmpty ? isRatePass : (isCityPass && isRatePass)
        
        return checkResult
    }
    
    func makeAnnotation(model: CafeNomadAPIModel) -> MKPointAnnotation
    {
        let aPointAnnotation = MKPointAnnotation()
        aPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: (model.latitude as NSString).doubleValue, longitude: (model.longitude as NSString).doubleValue)
        aPointAnnotation.title = model.name
        
        return aPointAnnotation
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let popoverController = segue.destination.popoverPresentationController
        
        let pickCityPopoverController = segue.destination as! PickCityPopoverViewController
        pickCityPopoverController.delegate = self
        
        if sender is UIButton {
            popoverController?.sourceRect = (sender as! UIButton).bounds
        }
        popoverController?.delegate = self
        print(popoverController!.description)
    }
    
    // MARK: -PickCityPopoverViewController Delegate
    func updateFilterCityName(cityNameCht: String, cityNameEng: String) {
        self.searchConditionCityName = cityNameEng
        self.locationButton.setTitle(cityNameCht, for: .normal)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    
}
