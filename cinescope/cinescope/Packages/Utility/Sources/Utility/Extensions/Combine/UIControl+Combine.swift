//
//  UIControl+Combine.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Combine
import UIKit.UIControl

extension UIControl {
    public class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {
        private let subscriber: S?
        private let control: UIControl
        private let event: UIControl.Event
        
        public init(
            subscriber: S,
            control: UIControl,
            event: UIControl.Event
        ) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            
            self.control.addTarget(self, action: #selector(handleEvent), for: event)
        }
        
        @objc func handleEvent(_ sender: UIControl) {
            _ = self.subscriber?.receive(())
        }
        
        public func request(_ demand: Subscribers.Demand) {}
        
        public func cancel() {}
    }
    
    public struct InteractionPublisher: Publisher {
        public typealias Output = Void
        public typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        public init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
    
    public func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher {
        return InteractionPublisher(control: self, event: event)
    }
}


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
