//
//  AlertAction.swift
//
//
//  Created by Ozan Barış Günaydın on 21.12.2023.
//

import UIKit

// MARK: - AlertAction
public class AlertAction: NSObject {
    // MARK: - Init
    public convenience init(
        title: String?,
        style: ButtonStyle,
        handler: ((AlertAction) -> Void)? = nil
    ) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }

    // MARK: - Variables
    public var handler: ((AlertAction) -> Void)?

    private(set) public var title: String? {
        get { return self.attributedTitle?.string }
        set { self.attributedTitle = newValue.map(NSAttributedString.init) }
    }

    private(set) public var attributedTitle: NSAttributedString?

    internal(set) public var style: ButtonStyle = .primary
}
