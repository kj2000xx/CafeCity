//
//  API.swift
//  CafeCity
//
//  Created by Shane on 2019/8/2.
//  Copyright © 2019 Shane. All rights reserved.
//

import Foundation
import Moya

enum API {
    case api
    case apiPara(para1:String)
}

extension API: TargetType {
    
    
    
    var baseURL: URL {
        return URL.init(string: "https://cafenomad.tw/api/v1.2/cafes")!
    }
    
    var path: String {
        switch self {
        case .api:
            return ""
        case .apiPara(let para1):
            return "\(para1)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .api:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .api:
            return .requestPlain
        case let .apiPara(para1):
            //後台的content-Type 為application/x-www-form-urlencoded時選擇URLEncoding
            return .requestParameters(parameters: ["key":para1], encoding: URLEncoding.default)
//        case let .apiDict(dict):
//            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
       return nil
    }
    
    
}
