//
//  PickCityPopoverViewController.swift
//  CafeCity
//
//  Created by Shane on 2019/8/13.
//  Copyright © 2019 Shane. All rights reserved.
//

import UIKit

protocol PickCityViewControllerDelegate {
    func updateFilterCityName(cityNameCht:String, cityNameEng: String)
}

class PickCityPopoverViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var delegate: PickCityViewControllerDelegate?
    
    // MARK - Property
    @IBOutlet weak var myPickerView: UIPickerView!
    
    var cityListDic = [String:String]()
    var cityListKeysArray = [String]()
    var pickedCityName: String?
    
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self

        self.cityListDic = self.loadCityListFromLoaclJson()
        self.cityListKeysArray = Array(self.cityListDic.keys).sorted()

    }
    
    
    // MARK: - Common
    func loadCityListFromLoaclJson ()-> [String:String]{
        let url = Bundle.main.url(forResource: "cityListJason", withExtension: "txt")
        var jsonDict = [String:String]()
        do {
            let data = try Data(contentsOf: url!)
            jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String,String>
        } catch  {
            print(error.localizedDescription)
        }
        return jsonDict
    }
    
    
    //MARK: - UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cityListDic.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.cityListKeysArray[row]
        pickerLabel?.textColor = UIColor.myColor.mainColor
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickedKey = self.cityListKeysArray[row]
        
        let pickValue = self.cityListDic[pickedKey]
        self.pickedCityName = pickValue
        print(self.pickedCityName!)
        
        if let _pickedCityName = self.pickedCityName {
            self.delegate?.updateFilterCityName(cityNameCht: pickedKey, cityNameEng: _pickedCityName)
        }
        
    }


}
