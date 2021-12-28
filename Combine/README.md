# Combine framework

This folder will contain use-cases & best practices for using the Apple Combine framework.

## Table of Contents
* [Overview](#overview)
    * [RxSwift comparison](#rxswift)
* [Gesture extensions](#gesture-extensions)
* [UIControl extensions](#uicontrol-extensions)

## Overview

The Combine framework provides a declarative Swift API for processing values over time. Please read the official [Combine documentation](https://developer.apple.com/documentation/combine). Also, you can check out several tutorials:
* [Ray Wenderlich](https://www.raywenderlich.com/7864801-combine-getting-started)
* [The Swift Dev](https://theswiftdev.com/the-ultimate-combine-framework-tutorial-in-swift/)
* [Medium](https://medium.com/flawless-app-stories/combine-framework-in-swift-b730ccde131)
* Combine: Asynchronous Programming with Swift e-book - ask for Five devs for the link

### RxSwift
Combine is similar to RxSwift but it also has a [back-pressure](https://heckj.github.io/swiftui-notes/#coreconcepts-backpressure) feature. Also, since it is written by Apple, it is faster and uses less memory. You can find some interesting comparisons [here](https://quickbirdstudios.com/blog/combine-vs-rxswift/).

<br />  

## Gesture extensions

Combine does not have out-of-the-box support for handling view gestures from the UIKit framework. However, it has a great tutorial for creating custom publishers & subscriptions. The iOS dev community has written extensions that makes handling various gestures pretty straightforward.

<br />  

**GestureSubscription**

A custom implementation of Combine's [Subscription](https://developer.apple.com/documentation/combine/subscription) class. On init, it attaches a gesture recognizer to the view and emits an event when a gesture is detected.

**GesturePublisher**

A custom implementation of Combine's [Publisher](https://developer.apple.com/documentation/combine/publisher) class. On new [subscriber](https://developer.apple.com/documentation/combine/subscriber), it creates an instance of `GestureSubscription` class and attaches a subscriber to it.

**GestureType**

An enum which defines gesture type. Supported gestures are:
* [tap](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_tap_gestures)
* [swipe](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_swipe_gestures)
* [long press](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_long-press_gestures)
* [pan](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_pan_gestures) &
* [pinch](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_pinch_gestures)

It is possible to support other gesture types, as long as that gesture recognizer extends [UIGestureRecognizer](https://developer.apple.com/documentation/uikit/uigesturerecognizer) class.

See [Gesture+Extensions.swift](Gesture+Extensions.swift) file for more details.

<br />  

### Examples

<br />  

#### **Tap gesture**

```swift
let button = UIButton()
button
    .gesture(.tap())
    .sink { gesture in
        // process tap here
    }
    .store(in: &cancellables)
```

Since tap is the most common gesture, we have created a convenience computed property on `UIView` named `tap`:
```swift
let button = UIButton()
button
    .tap
    .sink { gesture in
        // process tap here
    }
    .store(in: &cancellables)
```
<br />  

#### **Swipe gesture**

When creating a swipe `GestureType`, it takes a `UISwipeGestureRecognizer` as a constructor argument and it will create a default one if you do not provide one. However, there are multiple cases where you want to provide your own. For example, you want to handle a left swipe. A default `UISwipeGestureRecognizer` direction `property` has a value `right`. To support a left swipe, you will have to manually create a `UISwipeGestureRecognizer` class.

```swift
let recognizer = UISwipeGestureRecognizer()
recognizer.direction = .left
view
    .gesture(.swipe(recognizer))
    .sink { gesture in
        // process swipe here
    }
    .store(in: &cancellables)
```
<br />  

#### **Long press gesture**

If you want that the minimum press duration is different than 0.5 seconds, you will have to create an instance of `UILongPressGestureRecognizer`.

```swift
let recognizer = UILongPressGestureRecognizer()
recognizer.minimumPressDuration = 1
view
    .gesture(.longPress(recognizer))
    .sink { gesture in
        // process long press here
    }
    .store(in: &cancellables)
```
<br />  

#### **Pan gesture**

You can access current gesture properties on each emitted event by using `recognizer` property of a `GestureType`, which is passed on each event. For example, a pan gesture is usually used to track finger movement on the screen.

```swift
private var initialCenter: CGPoint = .zero

...

view
    .gesture(.pan())
    .compactMap { $0.recognizer as? UIPanGestureRecognizer } // recognizer is a UIGestureRecognizer type so we have to cast it
    .sink { recognizer in
        guard
            let view = recognizer.view,
            let superview = view.superview
        else {
            return
        }

        let state = recognizer.state
        let translation = recognizer.translation(in: superview)

        if state == .began {
            initialCenter = containerView.center
            return
        }
        if state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            containerView.center = newCenter
        }
    }
    .store(in: &cancellables)
```
<br />  

## UIControl extensions

<br />  

The [UIControl](https://developer.apple.com/documentation/uikit/uicontrol) is the base class for controls, which are visual elements that convey a specific action or intention in response to user interactions.

<br />  

### UITextField extensions

It is a common use case to observe a text change in the UITextField so we have added a `rxText` property which listens to a text change and emits a current text in the field. If you set a new text manually in the code via the `text` property, it **will not** emit a new text value. You have to call the function `notifyTextChanged` so that the change is propagated.

See [UIControl+Extensions.swift](UIControl+Extensions.swift) file for more details.

```swift
let usernameField = UITextField()
usernameField
    .rxText
    .sink { username in
        // process username here
    }
    .store(in: &cancellables)

usernameField
    .onEditingStart
    .sink {
        // e.g.: change UI elements while username is being typed. 
    }
    .store(in: &cancellables)
```