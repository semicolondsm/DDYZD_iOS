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
    
    func getClubList() -> Observable<([ClubList]? ,StatusCodes)> {
        httpClient.get(.clubList, param: nil)
            .map{ response, data -> ([ClubList]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([ClubList].self, from: data) else { return (nil, .fault)}
                    return(data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getClubDetailInfo(clubID: Int) -> Observable<(ClubInfo?, StatusCodes)> {
        httpClient.get(.clubDetailInfo(clubID), param: nil)
            .map{ response, data -> (ClubInfo?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ClubInfo.self, from: data) else { return (nil, .fault)}
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getClubMembers(clubID: Int)  -> Observable<([ClubMember]?, StatusCodes)> {
        httpClient.get(.getClubMember(clubID), param: nil)
            .map{ response, data -> ([ClubMember]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([ClubMember].self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func followClub(clubID: Int) -> Observable<StatusCodes>{
        httpClient.post(.followClub(clubID), param: nil)
            .map{ response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    return .success
                default:
                    return .fault
                }
            }
    }
    
    func unfollowClub(clubID: Int) -> Observable<StatusCodes>{
        httpClient.delete(.followClub(clubID), param: nil)
            .map{ response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    return .success
                default:
                    return .fault
                }
            }
    }
    
    func createRoom(clubID: Int) -> Observable<(ChatRoom?, StatusCodes)>{
        httpClient.post(.createChatRoom(clubID), param: nil)
            .map{ res, data -> (ChatRoom?, StatusCodes) in
                switch res.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(ChatRoom.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
}
