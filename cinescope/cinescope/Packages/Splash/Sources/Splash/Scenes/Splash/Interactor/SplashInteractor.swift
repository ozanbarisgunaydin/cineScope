//
//  SplashInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Foundation

protocol SplashInteractorProtocol: AnyObject {
    
}

protocol SplashInteractorOutputProtocol: AnyObject {
    
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
}
