//
//  ActorDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol ActorDetailModel {
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<ActorMovieCreditResponse>) -> Void)
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<CastTVCreditResponse>) -> Void)
}

class ActorDetailModelImpl: BaseModel, ActorDetailModel {
    static let shared = ActorDetailModelImpl()
    private override init(){}
    
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        networkAgent.getActorDetail(id, completion: completion)
    }
    
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<ActorMovieCreditResponse>) -> Void) {
        networkAgent.getActorMovieCredit(id, completion: completion)
    }
    
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<CastTVCreditResponse>) -> Void) {
        networkAgent.getActorTVCredit(id, completion: completion)
    }
    
}
