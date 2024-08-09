//
//  NetworkClient+Upload.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public extension NetworkClient {
    @discardableResult
    func upload<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        progress: Alamofire.Request.ProgressHandler?,
        completion: @escaping NetworkCompletion<T>
    ) -> Request {
        switch router.task {
        case .uploadFile(let file):
            return self.uploadFile(
                router: router,
                file: file,
                model: model,
                progress: progress,
                completion: completion
            )
        case .uploadMultipart(let multipartBody),
                .uploadCompositeMultipart(let multipartBody, _):
            guard !multipartBody.isEmpty && router.method.supportsMultipart else {
                fatalError("\(router.task) is not a multipart upload task.")
            }
            return self.uploadMultipart(
                router: router,
                multipartBody: multipartBody,
                model: model,
                progress: progress,
                completion: completion
            )
        default:
            fatalError("\(router.task) is not a upload task.")
        }
    }

    @discardableResult
    func uploadFile<R: RouterProtocol, T: Decodable>(
        router: R,
        file: URL,
        model: T.Type,
        progress: Alamofire.Request.ProgressHandler?,
        completion: @escaping NetworkCompletion<T>
    ) -> Request {
        let request = session.upload(file, with: router)
        let validatedRequest = request.validate()

        if let progress = progress {
            validatedRequest.uploadProgress(closure: progress)
        }

        validatedRequest.responseDecodable(of: T.self) { responseData in
            switch responseData.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                self.handle(error: error, responseData: responseData, completion: completion)
            }
        }

        return validatedRequest
    }

    @discardableResult
    func uploadMultipart<R: RouterProtocol, T: Decodable>(
        router: R,
        multipartBody: [BaseMultipartFormData],
        model: T.Type,
        progress: Alamofire.Request.ProgressHandler?,
        completion: @escaping NetworkCompletion<T>
    ) -> Request {
        let multipartFormData: (MultipartFormData) -> Void = { form in
            form.applyMultipartFormData(multipartBody)
        }

        let request = session.upload(multipartFormData: multipartFormData, with: router)
        let validatedRequest = request.validate()

        if let progress = progress {
            validatedRequest.uploadProgress(closure: progress)
        }

        validatedRequest.responseDecodable(of: T.self) { responseData in
            switch responseData.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                self.handle(error: error, responseData: responseData, completion: completion)
            }
        }

        return validatedRequest
    }
}

fileprivate extension HTTPMethod {
    /// A Boolean value determining whether the request supports multipart.
    var supportsMultipart: Bool {
        switch self {
        case .post, .put, .patch, .connect:
            return true
        default:
            return false
        }
    }
}
