//
//  ViewModelProtocol.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/20.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype input
    associatedtype output
    
    func transform(_ input: input) -> output
}
