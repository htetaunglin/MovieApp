//
//  BaseModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

class BaseModel: NSObject {
    let networkAgent : NetworkingAgentProtocol = MovieDBNetworkAgent.shared
}
