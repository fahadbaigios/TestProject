//
//  APICallRepo.swift
//  Test-Project
//
//  Created by Muhammad Fahad Baig on 13/06/2022.
//

import Foundation
import UIKit
import PromiseKit
import Alamofire

class APICallRepo {
    
    static func getName(byIndex index: Int, completionHandler: @escaping (NameMO?, Error?) -> ()) {
        firstly {
            Alamofire
                .request("https://gc-rest.herokuapp.com/api/name", method: .get, parameters: ["index":index])
                .responseDecodable(NameMO.self)
        }.done { model in
            completionHandler(model, nil)
        }.catch { error in
            completionHandler(nil, error)
        }
    }
}

struct NameMO: Decodable {
    let name: String
}
