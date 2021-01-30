//
//  ChatAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/24.
//

import Foundation

import Alamofire
import RxSwift

class ChatAPI {
    let httpClient = HTTPClient()
    
    func getCHatList() -> Observable<([room]? ,StatusCodes)> {
        httpClient.get(.clubList, param: nil)
            .map{ response, data -> ([room]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([room].self, from: data) else { return (nil, .fault)}
                    return(data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
}
