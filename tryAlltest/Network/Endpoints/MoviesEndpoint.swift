//
//  MoviesEndpoint.swift
//  RequestApp
//
//  Created by Victor Catão on 18/02/22.
//

enum MoviesEndpoint {
    case topRated
    case movieDetail(id: Int)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .topRated, .movieDetail:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        //let accessToken = "insert your access token here -> https://www.themoviedb.org/settings/api"
        //APIkey - ca853fb3d24308eb7033d68b2efc9f14
        //https://api.themoviedb.org/3/movie/550?api_key=ca853fb3d24308eb7033d68b2efc9f14
        let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYTg1M2ZiM2QyNDMwOGViNzAzM2Q2OGIyZWZjOWYxNCIsInN1YiI6IjYzZmY2MjEzY2Y2MmNkMDBiMjBlMTdmNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Y12e4OxvFgJt7Un-dbNEPsHHUwsWEnxTizh0s1VU-js"
        switch self {
        case .topRated, .movieDetail:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .topRated, .movieDetail:
            return nil
        }
    }
}
