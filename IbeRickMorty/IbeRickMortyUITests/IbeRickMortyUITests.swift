//
//  IbeRickMortyUITests.swift
//  IbeRickMortyUITests
//
//  Created by Ángel Luis Bayón Romero on 8/1/26.
//

import XCTest

final class IbeRickMortyUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
