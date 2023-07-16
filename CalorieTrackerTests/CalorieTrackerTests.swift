//
//  CalorieTrackerTests.swift
//  CalorieTrackerTests
//
//  Created by Hongru on 7/7/23.
//

import XCTest
@testable import CalorieTracker

final class CalorieTrackerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNutrition() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        var nutrition = Nutrition()
        var nutrition2 = Nutrition()
        var diaryRecord = DiaryRecord.sampleData[0]
        var nutrition3 = nutrition + diaryRecord.nutrition
        // XCTAssertEqual(nutrition3, Nutrition(), "should be equal")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
