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
    
    func getChatList() -> Observable<(ChatList? ,StatusCodes)> {
        httpClient.get(.chatList, param: nil)
            .map{ response, data -> (ChatList?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ChatList.self, from: data) else { return (nil, .fault)}
                    return(data, .success)
                case 401, 422:
                    return(nil, .unauthorized)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getBreakdown() {
        
    }
}
