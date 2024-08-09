//
//  NetworkClient+Request.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Alamofire

public extension NetworkClient {
    @discardableResult
    func request<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        completion: @escaping NetworkCompletion<T>
    ) -> Request {
        switch router.task {
        case .requestPlain,
             .requestData,
             .requestJSONEncodable,
             .requestCustomJSONEncodable,
             .requestParameters,
             .requestCompositeData,
             .requestCompositeParameters:
            
            let request = session.request(router, interceptor: session.interceptor)
            let validatedRequest = request.validate()

            validatedRequest.responseDecodable(of: T.self) { [weak self] responseData in
                guard let self else { return }

                switch responseData.result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    self.handle(
                        error: error,
                        responseData: responseData,
                        completion: completion
                    )
                }
            }
            return validatedRequest
        default:
            fatalError("\(router.task) is not a request task.")
        }
    }
}
