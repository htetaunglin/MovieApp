//
//  NetworkingAgent.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 18/03/2022.
//

import Foundation
import Alamofire

struct MovieDBNetworkAgent : NetworkingAgentProtocol {
    static let shared = MovieDBNetworkAgent()
    private init(){}
    
    /// "\(baseURL)/genre/movie/list?api_key=\(apiKey)"
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void){
        AF.request(MDBEndpoint.movieGenre)
            .responseDecodable(of: MovieGenreList.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/upcoming?api_key=\(apiKey)"
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.upcomingMovieList)
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/popular?api_key=\(apiKey)"
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.popularMovieList)
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/tv/popular?api_key=\(apiKey)"
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.popularSeriesList)
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/top_rated?page=\(page)&api_key=\(apiKey)"
    func getTopRelatedMoveiList(page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.topRelatedMovieList(page))
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/person/popular?page=\(page)&api_key=\(apiKey)"
    func getPopularPeople(page: Int = 1, completion: @escaping (MDBResult<ActorListResponse>) -> Void){
        AF.request(MDBEndpoint.popularPeople(page))
            .responseDecodable(of: ActorListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
    func getMovieDetailById(_ id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void){
        AF.request(MDBEndpoint.movieDetail(id))
            .responseDecodable(of: MovieDetailResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/tv/\(id)?api_key=\(apiKey)"
    func getTVSeriesDetailById(_ id: Int, completion: @escaping (MDBResult<TVSeriesDetailResponse>) -> Void){
        AF.request(MDBEndpoint.tvDetail(id))
            .responseDecodable(of: TVSeriesDetailResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/\(id)/credits?api_key=\(apiKey)"
    func getMovieCreditByMovieId(_ id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void){
        AF.request(MDBEndpoint.movieCredit(id))
            .responseDecodable(of: MovieCreditResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/\(id)/similar?api_key=\(apiKey)"
    func getMovieSimilar(_ id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.movieSimilar(id))
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/movie/\(id)/videos?api_key=\(apiKey)"
    func getMovieTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void){
        AF.request(MDBEndpoint.movieTrailer(id))
            .responseDecodable(of: TrailerResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/tv/\(id)/videos?api_key=\(apiKey)"
    func getTVTrailerVideo(_ id: Int, completion: @escaping (MDBResult<TrailerResponse>) -> Void){
        AF.request(MDBEndpoint.tvTrailer(id))
            .responseDecodable(of: TrailerResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "\(baseURL)/search/movie?page=\(page)&query=\(text)&api_key=\(apiKey)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    func searchMovie(_ text: String, page: Int = 1, completion: @escaping (MDBResult<MovieListResponse>) -> Void){
        AF.request(MDBEndpoint.searchMovie(page, text))
            .responseDecodable(of: MovieListResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "/person/287?api_key=<API Key>"
    func getActorDetail(_ id: Int, completion: @escaping (MDBResult<ActorDetailResponse>) -> Void) {
        AF.request(MDBEndpoint.actorDetail(id))
            .responseDecodable(of: ActorDetailResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "/person/:person_id/movie_credits"
    func getActorMovieCredit(_ id: Int, completion: @escaping (MDBResult<ActorMovieCreditResponse>) -> Void) {
        AF.request(MDBEndpoint.actorMovieCredit(id))
            .responseDecodable(of: ActorMovieCreditResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    /// "/person/:person_id/tv_credits"
    func getActorTVCredit(_ id: Int, completion: @escaping (MDBResult<CastTVCreditResponse>) -> Void) {
        AF.request(MDBEndpoint.actorTVCredit(id))
            .responseDecodable(of: CastTVCreditResponse.self) {response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }

    
    fileprivate func handleError<T, E: MDBErrorModel>(
        _ response : DataResponse<T, AFError>,
        _ error: AFError,
        _ errorBodyType : E.Type) -> String {
            
            var resBody: String = ""
            var serverErrorMessage: String?
            var errorBody: E?
            
            if let responseData = response.data {
                resBody = String(data: responseData, encoding: .utf8) ?? "empty response body"
                errorBody = try? JSONDecoder().decode(errorBodyType, from: responseData)
                serverErrorMessage = errorBody?.message
            }
            
            let respCode: Int = response.response?.statusCode ?? 0
            let sourcePath: String = response.request?.url?.absoluteString ?? ""
            
            print("""
            ===================
            URL
            -> \(sourcePath)
            Status
            -> \(respCode)
            Body
            -> \(resBody)
            Underlying Error
            -> \(error.underlyingError)
            Error Description
            -> \(error.errorDescription!)
            ===================
            """)
            
            return serverErrorMessage ?? error.errorDescription ?? "undefined"
    }
}

protocol MDBErrorModel: Decodable {
    var message : String { get }
}

class MDBCommonResponseError: MDBErrorModel {
    var message: String {
        return statusMessage
    }
 
    let statusMessage: String
    let statusCode : Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MDBResult<T>{
    case success(T)
    case failure(String)
}
