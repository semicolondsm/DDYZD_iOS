//
//  HTTPClient.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/17.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class HTTPClient {
    
    let baseURL = ""
    
    typealias httpResult = Observable<(HTTPURLResponse, Data)>
    
    func get(_ api: DDYZDAPI, param: Parameters?) -> httpResult {
        return requestData(.get, baseURL + api.path(),
                           parameters: param,
                           encoding: JSONEncoding.prettyPrinted,
                           headers: api.header())
    }
    
    func post(_ api: DDYZDAPI, param: Parameters?, encoding: ParameterEncoding = JSONEncoding.default) -> httpResult {
        return requestData(.post, baseURL + api.path(),
                           parameters: param,
                           encoding: encoding,
                           headers: api.header())
    }
    
    func put(_ api: DDYZDAPI, param: Parameters?) -> httpResult {
        return requestData(.put, baseURL + api.path(),
                           parameters: param,
                           encoding: JSONEncoding.prettyPrinted,
                           headers: api.header())
    }
    
    func delete(_ api: DDYZDAPI, param: Parameters?) -> httpResult {
        return requestData(.delete, baseURL + api.path(),
                           parameters: param,
                           encoding: JSONEncoding.prettyPrinted,
                           headers: api.header())
    }
}

