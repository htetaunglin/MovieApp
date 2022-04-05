//
//  ActorModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol ActorModel {
    var totalPageActorList : Int { get set }
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
}

class ActorModelImpl: BaseModel, ActorModel {
    var totalPageActorList: Int = 1
    
    static let shared = ActorModelImpl()
    private override init(){}
    
    let actorRepo: ActorRepository = ActorRepositoryImpl.shared
    
    func getPopularPeople(page: Int = 1, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        var netWorkResult = [ActorInfoResponse]()
        networkAgent.getPopularPeople(page: page){ result in
            switch result {
            case .success(let response):
                netWorkResult = response.results ?? []
                self.actorRepo.save(list: response.results ?? [])
                self.totalPageActorList = response.totalPages
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            if netWorkResult.isEmpty {
                self.actorRepo.getTotalPageActorList{
                    self.totalPageActorList = $0
                }
            }
            self.actorRepo.getList(page: page, type: .popularActor){ list in
                let response = ActorListResponse(dates: nil, page: page, results: list, totalPages: self.totalPageActorList, totalResults: 0)
                completion(.success(response))
            } 
        }
    }
}
