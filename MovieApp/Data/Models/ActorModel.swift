//
//  ActorModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol ActorModel {
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
}

class ActorModelImpl: BaseModel, ActorModel {
    static let shared = ActorModelImpl()
    private override init(){}
    
    func getPopularPeople(page: Int = 1, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        networkAgent.getPopularPeople(page: page, completion: completion)
    }
}
