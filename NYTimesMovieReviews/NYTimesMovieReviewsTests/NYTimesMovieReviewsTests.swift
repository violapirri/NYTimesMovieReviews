//
//  NYTimesMovieReviewsTests.swift
//  NYTimesMovieReviewsTests
//
//  Created by Viola Pirri on 9/26/17.
//  Copyright © 2017 Viola Pirri. All rights reserved.
//

import XCTest
@testable import NYTimesMovieReviews

class NYTimesMovieReviewsTests: XCTestCase {
    
    var sessionUnderTest = URLSession()
    
    override func setUp() {
        super.setUp()
        
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCallToNYTimesAPI() {
        // given
        let url = URL(string: "https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=68b0070d4910436cb1b211e4305f310d&critics-pick=Y")
        
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
