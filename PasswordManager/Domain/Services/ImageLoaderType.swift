//
//  ImageLoaderType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 13/05/18.
//  Copyright © 2018 Caio Sanchez Santos Costa. All rights reserved.
//

import Foundation
import RxSwift

protocol ImageLoaderType {
    func loadImage(from url: String) -> Single<UIImage?>
}
