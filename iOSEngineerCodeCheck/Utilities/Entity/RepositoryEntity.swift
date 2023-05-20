//
//  RepositoryEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryEntity {
    let `default`: GitHubSearchEntity
    let desc: GitHubSearchEntity
    let asc: GitHubSearchEntity

    init(`default`: GitHubSearchEntity, desc: GitHubSearchEntity, asc: GitHubSearchEntity) {
        self.default = `default`
        self.desc = desc
        self.asc = asc
    }
}

