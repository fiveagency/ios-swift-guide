import Combine
import UIKit

// MARK: Gestures
extension UIView {

    var tap: GesturePublisher {
        gesture(.tap())
    }

    func gesture(_ gestureType: GestureType) -> GesturePublisher {
        GesturePublisher(view: self, gestureType: gestureType)
    }

}

extension UIBarButtonItem {

    var tap: BarItemGesturePublisher {
        BarItemGesturePublisher(barItem: self)
    }

}

enum GestureType {

    var recognizer: UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        }
    }

    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())

}

class GestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {

    private var subscriber: S?
    private var view: UIView
    private var gestureType: GestureType

    init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType

        configureGesture(gestureType)
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    private func configureGesture(_ gestureType: GestureType) {
        let recognizer = gestureType.recognizer
        recognizer.addTarget(self, action: #selector(handler))
        view.addGestureRecognizer(recognizer)
    }

    @objc private func handler() {
        _ = subscriber?.receive(gestureType)
    }
}

struct GesturePublisher: Publisher {

    typealias Output = GestureType
    typealias Failure = Never

    private let view: UIView
    private let gestureType: GestureType

    init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }

    func receive<S>(subscriber: S) where S: Subscriber,
                                         GesturePublisher.Failure == S.Failure,
                                         GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(subscriber: subscriber, view: view, gestureType: gestureType)
        subscriber.receive(subscription: subscription)
    }

}

class BarItemGestureSubscription<S: Subscriber>: Subscription where S.Input == GestureType, S.Failure == Never {

    private let gestureType: GestureType = .tap()
    private var subscriber: S?
    private var barItem: UIBarButtonItem
    

    init(subscriber: S, barItem: UIBarButtonItem) {
        self.subscriber = subscriber
        self.barItem = barItem

        configureGesture()
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    private func configureGesture() {
        barItem.target = self
        barItem.action = #selector(handler)
    }

    @objc private func handler() {
        _ = subscriber?.receive(gestureType)
    }

}

struct BarItemGesturePublisher: Publisher {

    typealias Output = GestureType
    typealias Failure = Never

    private let barItem: UIBarButtonItem

    init(barItem: UIBarButtonItem) {
        self.barItem = barItem
    }

    func receive<S>(subscriber: S) where S: Subscriber,
                                         GesturePublisher.Failure == S.Failure,
                                         GesturePublisher.Output == S.Input {
        let subscription = BarItemGestureSubscription(subscriber: subscriber, barItem: barItem)
        subscriber.receive(subscription: subscription)
    }

}
