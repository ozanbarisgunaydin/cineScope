//
//  NetworkClient+Cancel.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public extension NetworkClient {
    func cancel(
        request: Request,
        completion: (() -> Void)?
    ) {
        session.withAllRequests { requests in
            requests.forEach { sessionRequest in
                if sessionRequest.request == request.request {
                    sessionRequest.cancel()
                }
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
