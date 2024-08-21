//
//  MockDataManager.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//

import Foundation

final public class MockDataManager {
    public func getData<T>(
        from resource: String,
        type: T.Type,
        on bundle: Bundle
    ) -> T? where T: Decodable & Encodable {
        var model: T?
        
        guard
            let fileUrl = bundle.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: fileUrl)
        else {
            print("⭕️ \(resource) file not found")
            return nil
        }
        
        do {
            model = try JSONDecoder().decode(type, from: data)
        } catch {
            print("⭕️ Decoding error: \(error.localizedDescription)")
        }
        
        return model
    }
    
    public init() { }
}
