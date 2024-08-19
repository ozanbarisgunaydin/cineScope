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
    func loadImage(
        progressBlock: Progress? = nil,
        with urlString: String?,
        animated: Bool = true,
        placeholder: String? = nil,
        placeholderImage: UIImage? = nil,
        shouldKeepCurrentWhileLoading: Bool = false,
        completion: (Completion)? = nil
    ) {
        loadImage(
            progressBlock: progressBlock,
            with: URL(string: urlString ?? ""),
            animated: animated,
            placeholder: placeholder,
            placeholderImage: placeholderImage,
            shouldKeepCurrentWhileLoading: shouldKeepCurrentWhileLoading,
            completion: completion
        )
    }

    func loadImage(
        progressBlock: Progress? = nil,
        with url: URL?,
        animated: Bool = true,
        placeholder: String? = nil,
        placeholderImage: UIImage? = nil,
        shouldKeepCurrentWhileLoading: Bool = false,
        completion: (Completion)? = nil
    ) {
        let phImage: UIImage?
        if let placeholderImage = placeholderImage {
            phImage = placeholderImage
        } else {
            if let placeholder = placeholder {
                phImage = UIImage(imageLiteralResourceName: placeholder)
            } else {
                phImage = nil
            }
        }

        guard let url = url else {
            image = phImage
            completion?(.failure(.requestError(reason: .emptyRequest)))
            return
        }

        var options: KingfisherOptionsInfo = [
            .processor(DownsamplingImageProcessor(size: self.bounds.size)),
            .scaleFactor(UIScreen.main.scale),
            .targetCache(.default)
        ]

        if shouldKeepCurrentWhileLoading {
            options.append(.keepCurrentImageWhileLoading)
        }

        if animated {
            options.append(.transition(.fade(0.3)))
        }
        
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024 /// About 100Mb
        cache.memoryStorage.config.expiration = .seconds(200) /// Expire cache after 200 seconds
        KingfisherManager.shared.cache = cache

        kf.setImage(
            with: KF.ImageResource(downloadURL: url),
            placeholder: placeholderImage,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completion
        )
    }
}
