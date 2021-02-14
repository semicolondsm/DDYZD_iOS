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
    
    func getFeedList(page: Int) -> Observable<([FeedModel]?, StatusCodes)> {
        httpClient.get(.feedList(page), param: nil)
            .map{ response, data -> ([FeedModel]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([FeedModel].self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getClubFeedList(clubID: Int, page: Int) -> Observable<([FeedModel]?, StatusCodes)> {
        httpClient.get(.clubFeedList(clubID, page), param: nil)
            .map{ response, data -> ([FeedModel]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([FeedModel].self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
                
            }
    }
    
    func flagIt(feedID: Int) -> Observable<StatusCodes> {
        httpClient.put(.flagIt(feedID), param: nil)
            .map{ response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    return .success
                case 401, 422:
                    return .unauthorized
                default:
                    return .fault
                }
            }
    }
    
    func deleteFeed(feedID: Int) -> Observable<StatusCodes> {
        httpClient.delete(.deleteFeed(feedID), param: nil)
            .map{ response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    return .success
                default:
                    return .fault
                }
            }
    }
}
