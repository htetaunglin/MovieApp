//
//  Models.swift
//  DataLayerNetworkLayer
//
//  Created by Htet Aung Lin on 15/03/2022.
//

import Foundation

struct RequestTokenSuccess : Decodable {
    let success: Bool?
    let expriesAt: String?
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expriesAt = "expires_at"
        case requestToken = "request_token"
    }
    
}

struct LoginRequest: Encodable {
    let username: String
    let password: String
    let requestToken: String
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

struct LoginSuccess : Decodable {
    let success: Bool?
    let expriesAt: String?
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expriesAt = "expires_at"
        case requestToken = "request_token"
    }
    
}

struct LoginFailed: Decodable {
    let success: Bool?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
}
