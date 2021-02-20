//
//  PersonalAPI.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/02/17.
//

import Foundation

import Alamofire
import RxSwift


class PersonalAPI {
    let httpClient = HTTPClient()
    
    func getGCN() -> Observable<(GCN?, StatusCodes)> {
        httpClient.get(.getGCN, param: nil)
            .map{ response, data -> (GCN?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(GCN.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func getUserInfo(gcn: String) -> Observable<(UserInfo?, StatusCodes)> {
        httpClient.get(.userInfo(gcn), param: nil)
            .map{ response, data -> (UserInfo?, StatusCodes) in
                switch response.statusCode {
                case 200:
                    guard let data = try? JSONDecoder().decode(UserInfo.self, from: data) else { return (nil, .fault) }
                    return (data, .success)
                default:
                    return (nil, .fault)
                }
            }
    }
    
    func modifyGithubID(githubID: String) -> Observable<StatusCodes> {
        httpClient.put(.modifyGithubID, param: ["git":githubID])
            .map{ response, data -> StatusCodes in
                switch response.statusCode {
                case 200:
                    return .success
                default:
                    return .fault
                }
            }
    }
    
    func modifyBio(bio: String) -> Observable<StatusCodes> {
        httpClient.put(.modifyBio, param: ["bio":bio])
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
