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
        httpClient.get(.getToken(DSMAuth_token), param: nil)
            .map{response, data -> StatusCodes in
                print(response)
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(TokenModel.self, from: data) else {
                        return .fault
                    }
                    Token.accessToken = data.access_token
                    return .success
                case 400:
                    return .badRequest
                case 401:
                    return .unauthorized
                case 404:
                    return .notFound
                default:
                    print(response.statusCode)
                    return .fault
                }
            }
    }
}
