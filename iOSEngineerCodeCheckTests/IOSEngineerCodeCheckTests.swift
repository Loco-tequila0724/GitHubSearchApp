import XCTest
@testable import iOSEngineerCodeCheck

// MARK: - すいません。勉強不足でまだUnitテストは上手く行えませんでした。 -
final class IOSEngineerCodeCheckTests: XCTestCase {
    var gitHubApi: GitHubApiManager!

    override func setUpWithError() throws {
        gitHubApi = GitHubApiManager()
    }

    ///  API通信。実行されているかテスト。データの取得が出来ているかテスト。
    func testFetchApi() throws {
        let expectation = XCTestExpectation(description: "fetch data")

        gitHubApi.fetch(text: "Swift") { result in

            switch result {
            case .success(let gitHubItem):
                // 中身がnilだった場合はエラー
                let nilItems = gitHubItem.items == nil ? true : false
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
