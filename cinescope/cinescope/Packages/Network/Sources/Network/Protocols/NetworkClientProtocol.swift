//
//  NetworkClientProtocol.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public typealias NetworkResult<T: Decodable> = (Result<T, BaseResponseError<T>>)
public typealias NetworkCompletion<T: Decodable> = (Result<T, BaseResponseError<T>>) -> Void
public typealias NetworkDownloadCompletion = (URL?, URLResponse?, NetworkError?) -> Void

public protocol NetworkClientProtocol {
    var session: Session { get }

    @discardableResult
    func request<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        completion: @escaping NetworkCompletion<T>
    ) -> Request

    @discardableResult
    func upload<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        progress: Alamofire.Request.ProgressHandler?,
        completion: @escaping NetworkCompletion<T>
    ) -> Request

    @discardableResult
    func download<R: RouterProtocol>(
        router: R,
        destination: Alamofire.DownloadRequest.Destination,
        progress: Request.ProgressHandler?,
        completion: @escaping NetworkDownloadCompletion
    ) -> Request

    func cancel(
        request: Request,
        completion: (() -> Void)?
    )
}
