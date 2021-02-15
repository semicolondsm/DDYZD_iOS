//
//  ClubAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import Foundation

import Alamofire
import RxSwift


class ClubAPI {
    let httpClient = HTTPClient()
    
    func getClubList() -> Observable<([ClubListModel]? ,StatusCodes)> {
        httpClient.get(.clubList, param: nil)
            .map{ response, data -> ([ClubListModel]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([ClubListModel].self, from: data) else { return (nil, .fault)}
                    return(data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    
}
