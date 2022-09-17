
import Foundation
import UIKit

/*
Designing the API Methods
 Getting a request token
 Getting a session ID
 Getting the user's ID
 Searching movies by a search string
 Getting a user's favourite movies
 Adding/removing favourite movies
 Getting user's watchlist movies
 Adding/removing watchlist movies
 */

class TMDBClient {
    
    static let apiKey = "29805ea54c4b20db9f744e00ed54144c"

    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var guestSessionID = ""
        static var sessionId = ""
        static var username = ""
        static var profileImage = ""
        static var avatarPath = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getPopular
        case getGuestSession
        case getTopRated
        case getTrending
        case nowPlaying
        case getGuestRatedMovies
        case getWatchList
        case getFavoriteList
        case getRequestToken
        case accountDetails
        case login
        case createSessionId
        case webAuth
        case logout
        case search(String)
        case markWatchlist
        case markFavorite
        case posterImageURL(String)
        case hash(String)
        case avatar(String)
        case getMovieDetails(String)
        case getCredits(String)
        
        var stringValue: String {
            switch self {
            case .getPopular:
                return Endpoints.base + "/movie/popular" + Endpoints.apiKeyParam
            case .getGuestSession:
                return Endpoints.base + "/authentication/guest_session/new" + Endpoints.apiKeyParam
            case .getGuestRatedMovies:
                return Endpoints.base + "/guest_session/\(Auth.guestSessionID)/rated/movies" + Endpoints.apiKeyParam
            case .getTopRated:
                return Endpoints.base + "/movie/top_rated" + Endpoints.apiKeyParam
            case .getTrending:
                return Endpoints.base + "/trending/\(MediaType.all)/\(ValidTimeWindows.week)" + Endpoints.apiKeyParam
            case .nowPlaying:
                return Endpoints.base + "/movie/now_playing" + Endpoints.apiKeyParam
            case .getWatchList:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getFavoriteList:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .accountDetails:
                return Endpoints.base + "/account" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .webAuth:
                return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=themoviemanager:authentication"
            case .logout:
                return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .search(let query):
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .markWatchlist:
                return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .markFavorite:
                return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .posterImageURL(let posterPath):
                return "https://image.tmdb.org/t/p/w500" + "\(posterPath)"
            case .hash(let hashPath):
                return "https://secure.gravatar.com/avatar/" + "\(hashPath)" + ".jpg?s=200"
            case .avatar(let avatarPath):
                return "https://image.tmdb.org/t/p/w200" + "\(avatarPath)"
            case .getMovieDetails(let movie_id):
                return Endpoints.base + "/movie/\(movie_id)" + Endpoints.apiKeyParam
            case .getCredits(let movie_id):
                return Endpoints.base + "/movie/\(movie_id)/credits" + Endpoints.apiKeyParam
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }

    //MARK: - GET Request
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    completion(nil, errorResponse)
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    //MARK: - Request Token
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getRequestToken.url, response: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    class func getPopular(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getPopular.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    class func getTopRated(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getTopRated.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    class func getTrending(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getTrending.url, response: MovieResults.self) {
            (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    class func getNowPlaying(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.nowPlaying.url, response: MovieResults.self) {
            (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getWatchList.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    class func getFavoriteList(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getFavoriteList.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionTask {
        let url = Endpoints.search(query).url
        let task = taskForGETRequest(url: url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
//    //MARK: - Guest Session
//    class func getGuestSessionID(completion: @escaping (Bool, Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.getGuestSession.url, response: GuestTokenResponse.self) { (response, error) in
//            if let response = response {
//                Auth.guestSessionID = response.guestSessionID
//                completion(true, nil)
//            } else {
//                completion(false, error)
//            }
//        }
//    }
//    class func getGuestRatedMovies(completion: @escaping ([Movie], Error?) -> Void) {
//        taskForGETRequest(url: Endpoints.getGuestRatedMovies.url, response: MovieResults.self) { (response, error) in
//            if let response = response {
//                completion(response.results, nil)
//            } else {
//                completion([], error)
//            }
//        }
//    }
    class func getMovieDetails(movie_id: String, completion: @escaping (MovieDetails?, Error?) -> Void) {
        let url = Endpoints.getMovieDetails(movie_id).url
        taskForGETRequest(url: url, response: MovieDetails.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    class func getCast(movie_id: String, completion: @escaping ([Cast], Error?) -> Void) {
        let url = Endpoints.getCredits(movie_id).url
        taskForGETRequest(url: url, response: CastResult.self) { (response, error) in
            if let response = response {
                completion(response.cast, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func accountDetails(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.accountDetails.url, response: AccountDetails.self) {
            (response, error) in
            if let response = response {
                Auth.username = response.username
                Auth.profileImage = response.avatar.gravatar.hash
                Auth.avatarPath = response.avatar.tmdb.avatarPath
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
//MARK: - Download Poster/Avatar
    class func downloadPosterImage(posterPath: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = Endpoints.posterImageURL(posterPath).url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    class func downloadAvatarImage(avatarPath: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = Endpoints.avatar(avatarPath).url
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    //MARK: - POST Request
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, body: RequestType, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let respnseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(respnseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
        taskForPOSTRequest(url: Endpoints.markWatchlist.url, body: body, response: TMDBResponse.self) { (response, error) in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, error)
            }
        }
    }
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
        taskForPOSTRequest(url: Endpoints.markFavorite.url, body: body, response: TMDBResponse.self) { (response, error) in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, error)
            }
        }
    }
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.createSessionId.url, body: PostSession(requestToken: Auth.requestToken), response: SessionResponse.self) { (response, error) in
            if let response = response {
                Auth.sessionId = response.sessionId
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func login(username: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.login.url, body: LoginRequest(username: username, password: password, requestToken: Auth.requestToken), response: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }

    //MARK: Logout
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            Auth.requestToken = ""
            Auth.sessionId = ""
            Auth.avatarPath = ""
            Auth.username = ""
            Auth.guestSessionID = ""
            
            completion()
        }
        task.resume()
    }
}
