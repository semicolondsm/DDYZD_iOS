//
//  AuthAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/20.
//

import Foundation

import Alamofire
import RxSwift

class AuthAPI {
    let httpClient = HTTPClient()
    
    func signIn(_ DSMAuth_token: String) -> Observable<StatusCodes> {
        httpClient.get(.getToken(DSMAuth_token), param: [:])
            .map{response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(TokenModel.self, from: data) else {
                        return .fault
                    }
                    Token.access_token = data.access_token
                    return .success
                default:
                    return .fault
                }
            }
    }
}
