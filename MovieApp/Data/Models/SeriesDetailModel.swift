//
//  SeriesDetailModel.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 27/03/2022.
//

import Foundation

protocol SeriesDetailModel {
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<TVSeriesDetailResponse>) -> Void)
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void)
}

class SeriesDetailModelImpl: BaseModel, SeriesDetailModel {
    static let shared = SeriesDetailModelImpl()
    private override init(){}
    
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<TVSeriesDetailResponse>) -> Void){
        networkAgent.getTVSeriesDetailById(id, completion: completion)
    }
    
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void) {
        networkAgent.getTVTrailerVideo(id, completion: completion)
    }
}
