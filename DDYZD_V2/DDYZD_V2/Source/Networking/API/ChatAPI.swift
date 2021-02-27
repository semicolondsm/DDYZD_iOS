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
    
    func getChatList() -> Observable<(ChatList?, StatusCodes)> {
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
    
    func getRecruitmentInfo(clubID: Int) -> Observable<(RecruitmentInfo?, StatusCodes)> {
        httpClient.get(.getRecruitment(clubID), param: nil)
            .map{ response, data -> (RecruitmentInfo?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(RecruitmentInfo.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getRoomToken(roomID: Int) -> Observable<(SocketToken?, StatusCodes)> {
        httpClient.get(.getRoomToken(roomID), param: nil)
            .map{ response, data -> (SocketToken?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(SocketToken.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getRoomInfo(roomID: Int) -> Observable<(RoomInfo?, StatusCodes)> {
        httpClient.get(.chatRoomInfo(roomID), param: nil)
            .map{ response, data -> (RoomInfo? ,StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(RoomInfo.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getBreakdown(roomID: Int) -> Observable<([Chat]?, StatusCodes)> {
        httpClient.get(.chatBreakdown(roomID), param: nil)
            .map{ response, data -> ([Chat]?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode([Chat].self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
}
