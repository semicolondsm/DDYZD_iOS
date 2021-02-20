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
    
    func getClubDetailInfo(clubID: Int) -> Observable<(ClubInfoModel?, StatusCodes)> {
        httpClient.get(.clubDetailInfo(clubID), param: nil)
            .map{ response, data -> (ClubInfoModel?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ClubInfoModel.self, from: data) else { return (nil, .fault)}
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getClubMembers(clubID: Int)  -> Observable<(ClubMember?, StatusCodes)> {
        httpClient.get(.getClubMember(clubID), param: nil)
            .map{ response, data -> (ClubMember?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ClubMember.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
}
