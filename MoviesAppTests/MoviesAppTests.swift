//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Серафима  Татченкова  on 20.07.2022.
//

import XCTest
@testable import MoviesApp

class MoviesAppTests: XCTestCase {
    
    var movies = [Movie]()
    var credits = [Cast]()
    let thorMovieID = "616037"
    let login = "Serafima728"
    let password = "s11ima"


    override func setUp() {
        super.setUp()
    }
    
    func test_get_trending_movie(){
        TMDBClient.getTrending { movie, error in
            XCTAssertEqual(movie, self.movies)
        }
    }
    
    func test_get_request_token(){
        TMDBClient.getRequestToken { success, error in
            XCTAssertEqual(true, success)
        }
    }
    
    func test_get_cast(){
        TMDBClient.getCast(movie_id: thorMovieID) { cast, error in
            XCTAssertEqual(cast, self.credits)
        }
    }
    
    func test_login(){
        TMDBClient.login(username: login, password: password) { success, error in
            XCTAssertEqual(true, success)
        }
    }
    func test_logout(){
        TMDBClient.logout {
            XCTAssertEqual(TMDBClient.Auth.sessionId, "")
            XCTAssertEqual(TMDBClient.Auth.requestToken, "")
            XCTAssertEqual(TMDBClient.Auth.username, "")
        }
    }
}
