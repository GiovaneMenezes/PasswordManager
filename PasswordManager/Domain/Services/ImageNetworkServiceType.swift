//
//  ImageNetworkServiceType.swift
//  PasswordManager
//
//  Created by Caio Sanchez Santos Costa on 17/05/18.
//  Copyright © 2018 Cedro. All rights reserved.
//

import Foundation
import RxSwift

protocol ImageNetworkServiceType {
    
    func loadImage(from url: String) -> Single<UIImage?>
}
