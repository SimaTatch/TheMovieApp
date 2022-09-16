
import Foundation
import UIKit

class MovieModel {
    //GET
    static var popular = [Movie]()
    static var topRated = [Movie]()
    static var nowPlaying = [Movie]()
    static var trending = [Movie]()
    
    //POST
    static var favorites = [Movie]()
    static var watchlist = [Movie]()
}

class MovieCategories {
    static let popularCategories = ["What's Popular","Top Rated","Now Playing","Trending"]
}

class MovieCast {
    static var castList = [Cast]()
}

