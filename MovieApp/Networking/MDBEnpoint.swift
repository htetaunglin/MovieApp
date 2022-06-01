//
//  MDBEnpoint.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 26/03/2022.
//

import Foundation
import Alamofire

enum MDBEndpoint: URLConvertible, URLRequestConvertible {
    
    
    
    case movieGenre
    case upcomingMovieList
    case popularMovieList
    case popularSeriesList
    case topRelatedMovieList(_ page: Int)
    case popularPeople(_ page: Int)
    case movieDetail(_ id: Int)
    case tvDetail(_ id: Int)
    case movieCredit(_ id: Int)
    case movieSimilar(_ id: Int)
    case movieTrailer(_ id: Int)
    case tvTrailer(_ id: Int)
    case searchMovie(_ page: Int, _ query: String)
    case actorDetail(_ id: Int)
    case actorMovieCredit(_ id: Int)
    case actorTVCredit(_ id: Int)

    func asURL() throws -> URL {
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        return try! URLRequest(url: self.url, method: .get)
    }
    
    var url: URL {
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? apiPath))
        if urlComponents?.queryItems == nil {
            urlComponents!.queryItems = []
        }
        urlComponents?.queryItems!.append(contentsOf: [URLQueryItem(name: "api_key", value: apiKey)])
        return urlComponents!.url!
    }
    
    private var apiPath: String {
        switch self {
        case .movieGenre:
            return "/genre/movie/list"
        case .upcomingMovieList:
            return "/movie/upcoming"
        case .popularMovieList:
            return "/movie/popular"
        case .popularSeriesList:
            return "/tv/popular"
        case .topRelatedMovieList(let page):
            return "/movie/top_rated?page=\(page)"
        case .popularPeople(let page):
            return "/person/popular?page=\(page)"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .tvDetail(let id):
            return "/tv/\(id)"
        case .movieCredit(let id):
            return "/movie/\(id)/credits"
        case .movieSimilar(let id):
            return "/movie/\(id)/similar"
        case .movieTrailer(let id):
            return "/movie/\(id)/videos"
        case .tvTrailer(let id):
            return "tv/\(id)/videos"
        case .searchMovie(let page, let query):
            return "/search/movie?query=\(query)&page=\(page)"
        case .actorDetail(let id):
            return "/person/\(id)"
        case .actorMovieCredit(let id):
            return "/person/\(id)/movie_credits"
        case .actorTVCredit(let id):
            return "/person/\(id)/tv_credits"
        }
    }
    
}

