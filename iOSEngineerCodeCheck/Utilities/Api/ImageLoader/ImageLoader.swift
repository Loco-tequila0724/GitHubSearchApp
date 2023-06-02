//
//  ImageLoader.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/21.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage

/// 画像の取得処理に関する。
final class ImageLoader {
    private var task: Task<(), Error>? {
        didSet {
            // 古いタスクがまだ残っていたらタスクをキャンセル
            oldValue?.cancel()
        }
    }
}

extension ImageLoader {
    /// GitHub APIから画像データの取得
    func load(url: URL?) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { configuration in
            task = Task {
                do {
                    let request = try makeRequest(url: url)
                    let image = try await convert(request: request)
                    configuration.resume(returning: image)
                } catch let error {
                    if Task.isCancelled {
                        configuration.resume(throwing: ApiError.cancel)
                    } else {
                        configuration.resume(throwing: error)
                    }
                }
            }
        }
    }
}

/// 画像の取得に関する。
private extension ImageLoader {
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        return session
    }

    func makeRequest(url: URL?) throws -> URLRequest {
        guard let url else { throw ApiError.invalidData }
        let request = URLRequest(url: url)
        return request
    }

    func httpData(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let httpURLResponse = response as? HTTPURLResponse,
            httpURLResponse.statusCode == 200 else {
            throw ApiError.serverError
        }
        return data
    }

    func convert(request: URLRequest) async throws -> UIImage {
        let data = try await httpData(request: request)
        let image = UIImage(data: data)!
        return image
    }
}
