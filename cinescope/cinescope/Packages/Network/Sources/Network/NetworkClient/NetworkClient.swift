//
//  NetworkClient.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public class NetworkClient: NetworkClientProtocol {
    public var session: Session

    public init(
        session: Session = Session()
    ) {
        self.session = session
    }
}
