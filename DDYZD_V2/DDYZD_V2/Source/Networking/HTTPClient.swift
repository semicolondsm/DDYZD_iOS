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
    
    let baseURL = "https://api.semicolon.live"
    
    typealias httpResult = Observable<(HTTPURLResponse, Data)>
    
    func get(_ api: DDYZDAPI, param: Parameters?) -> httpResult {
        return requestData(.get, baseURL + api.path() + "?" + now(),
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
    
    
    private func now() -> String {
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "ss"
        let current_time_string = formatter_time.string(from: Date())
        return current_time_string
    }
}

enum StatusCodes: Int {
    case success = 200          // 성공
    case badRequest = 400       // 올바르지 않은 요청
    case unauthorized = 401     // 토큰 인증 실패
    case forbidden = 403        // 권한 없음
    case notFound = 404         // 찾을 수 없는 경로
    case fault = 0              // 내부 로직 오류
}
