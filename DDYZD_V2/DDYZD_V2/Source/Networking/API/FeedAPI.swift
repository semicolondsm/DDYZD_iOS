//
//  FeedAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/07.
//

import Foundation

import Alamofire
import RxSwift

class FeedAPI {
    let httpClient = HTTPClient()
    
    func getFeedList(page: Int) -> Observable<([FeedListModel]?, StatusCodes)> {
        httpClient.get(.feedList(page), param: nil)
            .map{ response, data -> ([FeedListModel]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([FeedListModel].self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
}
