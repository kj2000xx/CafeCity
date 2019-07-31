//
//  MapViewController+Ext.swift
//  CafeCity
//
//  Created by Shane on 2019/7/31.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit
import MapKit

extension MapViewController {
    
    
    // MARK: - Building & Setup
    func buildingView()
    {
        self.myMapView = MKMapView()
        self.searchButton = UIButton(type: .roundedRect)
        self.arViewbutton = UIButton()
    }
    
    func customBuilding()
    {
        self.myMapViewCustomBuliding()
        self.searchButtonCustomBuliding()
        self.arViewButtonCustomBuliding()
    }
    
    func setupView()
    {
        
        self.view.addSubview(self.myMapView!)
        self.myMapView?.addSubview(self.searchButton!)
        self.myMapView?.addSubview(self.arViewbutton!)
        
    }
    
    func setupConstaints()
    {
        self.setupMyMapViewConstraint()
        self.setupSearchButtonConstraint()
        self.setupArViewButtonConstraint()
    }
    
    
    // MARK: - CustomBuilding
    func myMapViewCustomBuliding()
    {
        
        
    }
    
    func searchButtonCustomBuliding()
    {
        searchButton?.layer.cornerRadius = 40 / 2
        searchButton?.clipsToBounds = true
        searchButton?.backgroundColor = .black
        
    }
    
    func arViewButtonCustomBuliding()
    {
        arViewbutton?.layer.cornerRadius = 44 / 2
        arViewbutton?.clipsToBounds = true
        arViewbutton?.backgroundColor = .black
    }
    
    
    // MARK: - Constraints setting
    func setupMyMapViewConstraint()
    {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0) )
        constraints.append( NSLayoutConstraint(item: self.myMapView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0) )
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
