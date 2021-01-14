//
//  Common.swift
//  DSMSDK
//
//  Created by 김수완 on 2020/12/23.
//

import Foundation

final public class DSMSDKCommon{
    
    public static let shared = DSMSDKCommon()
    
    private var _client_id : String? = nil
    private var _client_secret : String? = nil
    private var _redirctURL : String? = nil
    
    public init(){
        _client_id = nil
        _client_secret = nil
        _redirctURL = nil
    }
    
    public static func initSDK(clientID : String, clientSecret : String, redirectURL : String){
        DSMSDKCommon.shared.initialize(client_id : clientID, client_secret : clientSecret, redirectURL : redirectURL)
    }
    
    private func initialize(client_id : String, client_secret : String, redirectURL : String){
        _client_id = client_id
        _client_secret = client_secret
        _redirctURL = redirectURL
        DSMAuth.shared.initialize(client_id: client_id,
                        client_secret: client_secret,
                        redirctURL: redirectURL)
    }
}
