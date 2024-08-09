//
//  NetworkClient+Download.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public extension NetworkClient {
    @discardableResult
    func download<R: RouterProtocol>(
        router: R,
        destination: Alamofire.DownloadRequest.Destination,
        progress: Request.ProgressHandler?,
        completion: @escaping NetworkDownloadCompletion
    ) -> Request {
        switch router.task {
        case .downloadDestination(let destination),
                .downloadParameters(_, _, let destination):
            let request = session.download(router, to: destination)
            let validatedRequest = request.validate()

            if let progress = progress {
                validatedRequest.downloadProgress(closure: progress)
            }

            validatedRequest.response { response in
                if let error = response.error {
                    completion(response.fileURL, response.response, .error(error))
                } else {
                    completion(response.fileURL, response.response, nil)
                }
            }

            return validatedRequest

        default:
            fatalError("\(router.task) is not a download task.")
        }
    }
}
