//
//  BaseMultipartFormData.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public struct BaseMultipartFormData {
    /// Method to provide the form data.
    public enum FormDataProvider {
        case data(Foundation.Data)
        case file(URL)
        case stream(stream: InputStream, length: UInt64)
    }

    public init(
        provider: FormDataProvider,
        name: String,
        fileName: String? = nil,
        mimeType: String? = nil
    ) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    /// The method being used for providing form data.
    public let provider: FormDataProvider

    /// The name.
    public let name: String

    /// The file name.
    public let fileName: String?

    /// The MIME type
    public let mimeType: String?
}

// MARK: RequestMultipartFormData appending
 extension MultipartFormData {
    func append(
        data: Data,
        bodyPart: BaseMultipartFormData
    ) {
        if let mimeType = bodyPart.mimeType {
            if let fileName = bodyPart.fileName {
                append(data, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
            } else {
                append(data, withName: bodyPart.name, mimeType: mimeType)
            }
        } else {
            append(data, withName: bodyPart.name)
        }
    }

    func append(
        fileURL url: URL,
        bodyPart: BaseMultipartFormData
    ) {
        if let fileName = bodyPart.fileName, let mimeType = bodyPart.mimeType {
            append(url, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
        } else {
            append(url, withName: bodyPart.name)
        }
    }

    func append(
        stream: InputStream,
        length: UInt64,
        bodyPart: BaseMultipartFormData
    ) {
        append(
            stream,
            withLength: length,
            name: bodyPart.name,
            fileName: bodyPart.fileName ?? "",
            mimeType: bodyPart.mimeType ?? ""
        )
    }

    func applyMultipartFormData(_ multipartBody: [BaseMultipartFormData]) {
        for bodyPart in multipartBody {
            switch bodyPart.provider {
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            case .file(let url):
                append(fileURL: url, bodyPart: bodyPart)
            case let .stream(stream, length):
                append(stream: stream, length: length, bodyPart: bodyPart)
            }
        }
    }
}
