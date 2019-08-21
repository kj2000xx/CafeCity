//
//  Testtest.swift
//  CafeCity
//
//  Created by Shane on 2019/8/20.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import UIKit
import MapKit


public let CalloutBorderSpace:CGFloat = 5

class SHCalloutAnnotation: NSObject,MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
    //左侧icon
    var icon: UIImage?
    //icon描述
    var descriptionDetail: String?
    //底部评分视图
    var rate: UIImage?
}




class SHCalloutAnnotationView: MKAnnotationView{
    
    //#MARK:使用懒加载声明需要的控件属性
    lazy var leftIcon:UIImageView = {
        let leftIcon = UIImageView()
        self.addSubview(leftIcon)
        return leftIcon
    }()
    
    lazy var detailLabel:UILabel = {
        let detailLabel = UILabel(frame:  CGRect.zero)
        detailLabel.lineBreakMode = .byCharWrapping
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.numberOfLines = 0
        self.addSubview(detailLabel)
        return detailLabel
    }()
    
    lazy var rateIcon:UIImageView = {
        let rateIcon = UIImageView()
        self.addSubview(rateIcon)
        return rateIcon
    }()
    
    var button:UIButton!
    
    //#MARK: 创建弹出视图
    class func calloutAnnotationViewWith(mapView: MKMapView)-> SHCalloutAnnotationView{
        let indentifier = "SHCallOutAnnotationView"
        var calloutView = mapView.dequeueReusableAnnotationView(withIdentifier: indentifier) as? SHCalloutAnnotationView
        if calloutView == nil{
            calloutView = SHCalloutAnnotationView()
            calloutView!.backgroundColor = UIColor.gray
        }
        return calloutView!
    }
    
    //#MARK:赋值数据模型显示相应的数据
    override var annotation: MKAnnotation?{
        
        didSet(callOutAnnotation){
            if let callOutAnnotation = callOutAnnotation as? SHCalloutAnnotation{
                self.leftIcon.image = callOutAnnotation.icon
                self.leftIcon.frame = CGRect(x: CalloutBorderSpace, y: CalloutBorderSpace, width: callOutAnnotation.icon!.size.width, height: callOutAnnotation.icon!.size.height)
                
                self.detailLabel.text = callOutAnnotation.descriptionDetail
                let string:NSString = self.detailLabel.text! as NSString
                let detailLabelSize = string.boundingRect(with: CGSize(width: 200,height: 200), options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.detailLabel.font!], context: nil)
                self.detailLabel.frame = CGRect(x: self.leftIcon.frame.maxX + CalloutBorderSpace, y:self.leftIcon.frame.minY, width: detailLabelSize.width, height: detailLabelSize.height)
                
                self.rateIcon.image = callOutAnnotation.rate
                self.rateIcon.frame = CGRect(x: self.detailLabel.frame.minX, y: self.detailLabel.frame.maxY + CalloutBorderSpace, width: callOutAnnotation.rate!.size.width, height: callOutAnnotation.rate!.size.height)
                
                self.bounds = CGRect(x: 0, y: 0, width: self.detailLabel.frame.maxX + CalloutBorderSpace, height: self.rateIcon.frame.maxY + CalloutBorderSpace)
                
                //注意：确定最终的显示位置
                self.centerOffset = CGPoint(x: 0,y: -(self.bounds.size.height + 28))
            }
        }
    }
    
    //#MARK:当弹出视图显示的时候添加缩放动画
    override func didMoveToSuperview() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0,1.5,1,1.5,1]
        animation.duration = 0.5
        self.layer.add(animation, forKey: nil)
    }
}






