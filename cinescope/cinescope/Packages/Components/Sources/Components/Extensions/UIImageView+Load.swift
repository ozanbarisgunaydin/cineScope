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
            .targetCache(.default)
        ]

        if shouldKeepCurrentWhileLoading {
            options.append(.keepCurrentImageWhileLoading)
        }

        if animated {
            options.append(.transition(.fade(0.3)))
        }

        kf.setImage(
            with: KF.ImageResource(downloadURL: url),
            placeholder: placeholderImage,
            options: options,
            progressBlock: progressBlock,
            completionHandler: completion
        )
    }
}
