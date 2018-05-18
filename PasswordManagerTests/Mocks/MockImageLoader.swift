//
//  MockImageLoader.swift
//  PasswordManagerTests
//
//  Created by Caio Sanchez Santos Costa on 18/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift
@testable import PasswordManager

struct MockImageLoader: ImageLoaderType {

    let imageNetworkService: ImageNetworkServiceType

    init(imageNetworkService: ImageNetworkServiceType = MockImageNetworkService()) {
        self.imageNetworkService = imageNetworkService
    }

    func loadImage(from url: String) -> Single<UIImage?> {
        return imageNetworkService.loadImage(from: url)
    }

}
