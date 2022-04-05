//
//  GenreModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol GenreModel {
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void)
}

class GenreModelImpl: BaseModel, GenreModel {
    static let shared = GenreModelImpl()
    let genreRespository: GenreRepository = GenreRepositoryImpl.shared
    private override init(){}
    
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void){
        /// [1] - Fetch from Network
        networkAgent.getGenreList { result in
            switch result {
            case .success(let genreList):
                /// [2] - Save to Database
                self.genreRespository.save(data: genreList)
            case .failure(let error):
                debugPrint("\(#function) \(error)")
            }
            /// [3] - Fetch inserted data from Database
            self.genreRespository.get{ completion(.success($0)) }
        }
    }
}
