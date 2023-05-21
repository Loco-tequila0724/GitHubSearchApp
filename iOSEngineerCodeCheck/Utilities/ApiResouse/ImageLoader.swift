//
//  ImageLoader.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/21.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class ImageLoader {
    private var task: Task<(), Error>?
}

extension ImageLoader {
    func load(url: URL?) async throws -> UIImage {
        guard let url else { throw ApiError.invalidData }

        let configuration = URLSessionConfiguration.default
        // キャッシュがある場合は、キャッシュデータを使用し、それ以外の場合はネットワークからデータをロードする
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        let request = URLRequest(url: url)

        return await withCheckedContinuation { configuration in
            task = Task {
                let (data, response) = try await session.data(for: request)
                guard let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200 else { throw ApiError.serverError }
                let image = UIImage(data: data)
                configuration.resume(returning: image!)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
