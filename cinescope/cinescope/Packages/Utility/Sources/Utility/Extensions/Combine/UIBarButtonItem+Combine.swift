//
//  UIBarButtonItem+Combine.swift
//
//
//  Created by Ozan Barış Günaydın on 27.08.2024.
//

import Combine
import UIKit.UIBarButtonItem

extension UIBarButtonItem {
    public class BarButtonItemSubscription<S: Subscriber>: Subscription where S.Input == Void {
        private var subscriber: S?
        private let barButtonItem: UIBarButtonItem
        
        init(subscriber: S, barButtonItem: UIBarButtonItem) {
            self.subscriber = subscriber
            self.barButtonItem = barButtonItem
            barButtonItem.target = self
            barButtonItem.action = #selector(eventHandler)
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {
            subscriber = nil
        }
        
        @objc private func eventHandler() {
            _ = subscriber?.receive(())
        }
    }
    
    public struct BarButtonItemPublisher: Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        let barButtonItem: UIBarButtonItem
        
        public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Void, S.Failure == Never {
            let subscription = BarButtonItemSubscription(subscriber: subscriber, barButtonItem: barButtonItem)
            subscriber.receive(subscription: subscription)
        }
    }
    
    public func publisher() -> BarButtonItemPublisher {
        BarButtonItemPublisher(barButtonItem: self)
    }
}

