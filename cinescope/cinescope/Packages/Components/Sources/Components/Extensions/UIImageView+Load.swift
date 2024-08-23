//
//  UIImageView+Load.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import UIKit
import Kingfisher

public typealias Completion = (Result<RetrieveImageResult, KingfisherError>) -> Void
public typealias Progress = DownloadProgressBlock

public extension UIImageView {
    /// Loads an image into the UIImageView from a given URL or URL string using Kingfisher.
    /// - Parameters:
    ///   - progressBlock: Optional block to monitor download progress.
    ///   - urlString: URL string of the image to load.
    ///   - animated: Boolean to determine if a fade animation should be applied on image load.
    ///   - placeholder: Name of the placeholder image to show while loading.
    ///   - placeholderImage: UIImage to use as a placeholder while loading.
    ///   - shouldKeepCurrentWhileLoading: Boolean to keep the current image until the new one loads.
    ///   - completion: Optional completion block to handle success or failure of the image load.
    func loadImage(
        progressBlock: Progress? = nil,
        with urlString: String?,
        animated: Bool = true,
        placeholder: String? = nil,
        placeholderImage: UIImage? = nil,
        shouldKeepCurrentWhileLoading: Bool = true,
        completion: (Completion)? = nil
    ) {
        guard 
            let urlString = urlString,
            let url = URL(string: urlString)
        else {
            image = placeholderImage ?? (placeholder != nil ? UIImage(named: placeholder!) : nil)
            completion?(.failure(.requestError(reason: .emptyRequest)))
            return
        }
        
        loadImage(
            progressBlock: progressBlock,
            with: url,
            animated: animated,
            placeholder: placeholder,
            placeholderImage: placeholderImage,
            shouldKeepCurrentWhileLoading: shouldKeepCurrentWhileLoading,
            completion: completion
        )
    }
    
    /// Loads an image into the UIImageView from a given URL or URL string using Kingfisher.
    /// - Parameters:
    ///   - progressBlock: Optional block to monitor download progress.
    ///   - url: URL of the image to load.
    ///   - animated: Boolean to determine if a fade animation should be applied on image load.
    ///   - placeholder: Name of the placeholder image to show while loading.
    ///   - placeholderImage: UIImage to use as a placeholder while loading.
    ///   - shouldKeepCurrentWhileLoading: Boolean to keep the current image until the new one loads.
    ///   - completion: Optional completion block to handle success or failure of the image load.
    func loadImage(
        progressBlock: Progress? = nil,
        with url: URL?,
        animated: Bool = true,
        placeholder: String? = nil,
        placeholderImage: UIImage? = nil,
        shouldKeepCurrentWhileLoading: Bool = false,
        completion: (Completion)? = nil
    ) {
        guard let url = url else {
            image = placeholderImage ?? (placeholder != nil ? UIImage(named: placeholder!) : nil)
            completion?(.failure(.requestError(reason: .emptyRequest)))
            return
        }
        
        let phImage = placeholderImage ?? (placeholder != nil ? UIImage(named: placeholder!) : nil)
        
        var options: KingfisherOptionsInfo = [
            .processor(DownsamplingImageProcessor(size: self.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .targetCache(.default)
        ]
        
        if shouldKeepCurrentWhileLoading {
            options.append(.keepCurrentImageWhileLoading)
        }
        
        if animated {
            options.append(.transition(.fade(0.3)))
        }
        
        kf.setImage(
            with: url,
            placeholder: phImage,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completion
        )
    }
}
