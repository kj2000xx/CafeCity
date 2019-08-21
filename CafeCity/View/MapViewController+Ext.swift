//
//  MapViewController+Ext.swift
//  CafeCity
//
//  Created by Shane on 2019/7/31.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit
import ARCL


extension MapViewController {
    
    
    // MARK: - Building & Setup
    func buildingView()
    {
        self.myMapView = MKMapView()
        self.searchButton = UIButton(type: .system)
        self.arViewbutton = UIButton(type: .system)
        self.myLocationButton = UIButton(type: .system)
    }
    
    func customBuilding()
    {
        self.myMapViewCustomBuliding()
        self.searchButtonCustomBuliding()
        self.arViewButtonCustomBuliding()
        self.myMapViewCustomBuliding()
        self.myLoactionButtonCustomBuliding()
    }
    
    func setupView()
    {
        
        self.view.addSubview(self.myMapView)
        self.myMapView.addSubview(self.searchButton)
        self.myMapView.addSubview(self.arViewbutton)
        self.myMapView.addSubview(self.myLocationButton)
        
    }
    
    func setupConstaints()
    {
        self.setupMyMapViewConstraint()
        self.setupSearchButtonConstraint()
        self.setupArViewButtonConstraint()
        self.setupmyLocationButtonConstraint()
    }
    
    
    // MARK: - CustomBuilding
    func myMapViewCustomBuliding()
    {
        self.myMapView.showsUserLocation = true
        self.myMapView.userLocation.title = "目前位置"

    }
    
    func searchButtonCustomBuliding()
    {
        searchButton.layer.cornerRadius = 40 / 2
        searchButton.clipsToBounds = true
        searchButton.backgroundColor = .white
        
        searchButton.layer.borderWidth = 2.5
        searchButton.layer.borderColor = UIColor.myColor.mainColor.cgColor
        
        searchButton.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal) ,for: .normal)
        searchButton.frame.size = CGSize(width: 64.0, height: 64.0)
        
        searchButton.tag = MapViewButtonTagName.search.rawValue
        searchButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(scaleButton), for: .touchDown)
        
    }
    
    func arViewButtonCustomBuliding()
    {
        arViewbutton.layer.cornerRadius = 44 / 2
        arViewbutton.clipsToBounds = true
        
        arViewbutton.backgroundColor = UIColor.myColor.mainColor
        arViewbutton.layer.borderWidth = 2
        arViewbutton.layer.borderColor = UIColor.white.cgColor
        
        arViewbutton.setTitleColor(.white, for: .normal)
        arViewbutton.setTitle("AR模式", for: .normal)
        
        arViewbutton.tag = MapViewButtonTagName.arView.rawValue
        arViewbutton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        arViewbutton.addTarget(self, action: #selector(scaleButton), for: .touchDown)
    }
    
    func myLoactionButtonCustomBuliding()
    {
        myLocationButton.backgroundColor = .white
        myLocationButton.layer.cornerRadius = 35 / 2
        myLocationButton.clipsToBounds = true

        myLocationButton.frame.size = CGSize(width: 64.0, height: 64.0)
        myLocationButton.setImage(UIImage(named: "GPS")?.withRenderingMode(.alwaysOriginal), for: .normal)
        myLocationButton.setImage(UIImage(named: "GPS-lighted")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
        
        myLocationButton.tag = MapViewButtonTagName.myLocation.rawValue
        myLocationButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        myLocationButton.addTarget(self, action: #selector(scaleButton), for: .touchDown)
    }
    
    
    // MARK: - Constraints setting
    func setupMyMapViewConstraint()
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0) )
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupSearchButtonConstraint()
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( NSLayoutConstraint(item: self.searchButton!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30) )
        constraints.append( NSLayoutConstraint(item: self.searchButton!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30) )
        constraints.append( NSLayoutConstraint(item: self.searchButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        constraints.append( NSLayoutConstraint(item: self.searchButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func setupArViewButtonConstraint()
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( NSLayoutConstraint(item: self.arViewbutton!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.arViewbutton!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -30) )
        constraints.append( NSLayoutConstraint(item: self.arViewbutton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150))
        constraints.append( NSLayoutConstraint(item: self.arViewbutton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupmyLocationButtonConstraint()
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( NSLayoutConstraint(item: self.myLocationButton!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -30) )
        constraints.append( NSLayoutConstraint(item: self.myLocationButton!, attribute: .bottom, relatedBy: .equal, toItem: self.arViewbutton, attribute: .top, multiplier: 1, constant: -30) )
       
        constraints.append( NSLayoutConstraint(item: self.myLocationButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35))
        constraints.append( NSLayoutConstraint(item: self.myLocationButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35))

        NSLayoutConstraint.activate(constraints)
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
