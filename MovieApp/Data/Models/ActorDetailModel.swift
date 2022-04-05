//
//  ActorDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol ActorDetailModel {
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void)
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class ActorDetailModelImpl: BaseModel, ActorDetailModel {
    static let shared = ActorDetailModelImpl()
    private override init(){}
    
    private let actorRepo: ActorRepository = ActorRepositoryImpl.shared
    private let movieRepo: MovieRepository = MovieRepositoryImpl.shared
    
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        networkAgent.getActorDetail(id){ result in
            switch(result){
            case .success(let response):
                self.actorRepo.saveDetails(data: response)
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.actorRepo.getDetails(id: id){ item in
                if let item = item {
                    completion(.success(item))
                } else {
                    completion(.failure("Failed to get detail with id \(id)"))
                }
            }
        }
    }
    
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getActorMovieCredit(id){ result in
                switch(result){
                case .success(let response):
                    self.actorRepo.saveMoviesByActor(id, list: response.cast?.map{ $0.toMovieResult() } ?? [])
                case .failure(let error):
                    debugPrint("\(#function) \(error)")
                }
            self.actorRepo.getMoviesByActor(id, isSeries: false){ completion(.success($0)) }
        }
    }
    
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getActorTVCredit(id){ result in
            switch (result) {
            case .success(let response):
                self.actorRepo.saveMoviesByActor(id, list: response.cast?.map{ $0.toMovieResult() } ?? [])
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            self.actorRepo.getMoviesByActor(id, isSeries: true){ completion(.success($0)) }
        }
    }
}
