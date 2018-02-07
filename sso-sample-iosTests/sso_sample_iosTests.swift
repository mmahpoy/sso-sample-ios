//
//  sso_sample_iosTests.swift
//  sso-sample-iosTests
//
//  Created by Mathew Spolin on 5/4/16.
//  Copyright © 2016 AppDirect. All rights reserved.
//

import XCTest
@testable import sso_sample_ios

class sso_sample_iosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func DISABLED_testThatObjectCanBeCreatedFromUrl() {
        let didParseUrl = expectation(description: "testThatObjectCanBeCreatedFromUrl")
        
        let testToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZW1vLnVzZXIyMDE4QHlvcG1haWwuY29tIiwiYXVkIjpbIm9wZW5pZCIsImFjY291bnQiLCJiaWxsaW5nIiwiYXR0IiwibzM2NSIsIm1hcmtldHBsYWNlIiwiY2hhbm5lbCIsImhvc3RlZGNoZWNrb3V0Iiwic2Vzc2lvbiIsInN1cGVydXNlciIsImludGVncmF0aW9uIiwicmVwb3J0aW5nIiwibm90aWZpY2F0aW9uIiwiUFJNIiwibWFya2V0cGxhY2V2MyJdLCJleHAiOjE1MTgwNjU4NzMsImp0aSI6ImQ3YjI4YmU4LWY2M2YtNGNmNi1hNTQ4LWU4ZTZlNmUyNWQzNyIsImNsaWVudF9pZCI6Im4xQkpPUkNnN3IiLCJzY29wZSI6WyJST0xFX1VTRVIiLCJvcGVuaWQiLCJwcm9maWxlIl19.Gb-q1DiEPn5y_088xmIKWiWuUepSAixdBftZeUY7QqIYFFKGQY5kitkG3dALRqoYBfBauUJ-45MAF2OOVrwvyMoZYWU9fsr-9N4JusS3FDhBWSK8deR8ETEYp7jaFdWQ6lEYZ2eHlKzbW0BBvMYTepZWw_HGpRdlJhk8C5gxm1HLGLinwJDHAqx8fcPDvlmn2lEIQlD5MM5u98-2ACP7J_UnAO4MP8cGBcPnPyjrInQniBqHPhbfPexbgZ1JWrQU71-8IzU1Wj-d80FNbZRscqzzwJts7zDWH9ckbg8nThPYNK6e-XGw1HCjhEq2d3byClm9JbTxp-0JwFsZ9IvQjA"
        
        if let userObject = UserObject.objectFromAccessToken(testToken) {
            
            XCTAssertEqual(userObject.info["sub"] as? String, "demo.user2018@yopmail.com")
            XCTAssertEqual(userObject.info["client_id"] as? String, "n1BJORCg7r")
            
            if let scope = userObject.info["scope"] as? [String] {
                if scope.count > 0 {
                    for role in scope {
                        print(role)
                        XCTAssertEqual(role, "ROLE_USER")
                        didParseUrl.fulfill()
                        break
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
