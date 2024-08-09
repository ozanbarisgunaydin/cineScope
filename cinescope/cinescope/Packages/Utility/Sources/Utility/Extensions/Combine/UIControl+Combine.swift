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
    final public class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void {
        private let subscriber: S?
        private var barButton: UIBarButtonItem
        private let event: UIControl.Event
        
        init(
            title: String,
            subscriber: S,
            event: UIControl.Event
        ) {
            self.subscriber = subscriber
            self.event = event
            barButton = UIBarButtonItem()
            defer {
                barButton = UIBarButtonItem(
                    title: title,
                    style: .done,
                    target: self,
                    action: #selector(handleEvent)
                )
            }
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
        
        private let event: UIControl.Event
        private let title: String
        
        public init(event: UIControl.Event, title: String) {
            self.event = event
            self.title = title
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscription(
                title: title,
                subscriber: subscriber,
                event: event
            )
            subscriber.receive(subscription: subscription)
        }
    }
    
    public func publisher(for event: UIControl.Event) -> UIBarButtonItem.InteractionPublisher {
        InteractionPublisher(event: event, title: self.title ?? String())
    }
}
