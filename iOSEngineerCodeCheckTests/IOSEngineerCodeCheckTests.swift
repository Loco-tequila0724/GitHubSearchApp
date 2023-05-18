//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

// MARK: - SchemeをiOSEngineerCodeCheckに変更するとテスト可能です。 -
// 新しく作ったスキームからテストコードを動かす事が出来ませんでした。
final class IOSEngineerCodeCheckTests: XCTestCase {
    var apiManager: ApiManager!

    override func setUpWithError() throws {
        apiManager = ApiManager()
    }

    ///  API通信。実行されているかテスト。データの取得が出来ているかテスト。
    func testFetchApi() throws {
        let expectation = XCTestExpectation(description: "fetch data")

        apiManager.fetch(text: "Swift") { result in
            switch result {
            case .success(let gitHubData):
                // 中身がnilだった場合はエラー
                let nilItems = gitHubData.items == nil ? true : false
                XCTAssertNotNil(nilItems)
            case .failure(let error):
                // エラーが返ってきたことを通知する。
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        // ６秒たってもFulFillされない場合はデータの取得が行われていない。
        wait(for: [expectation], timeout: 6)
    }
}
