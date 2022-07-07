# FIVE iOS Swift Code Style

This is an official code style guide for FIVE iOS Swift projects. [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) was used as the base, additional rules were added where necessary and existing ones were modified where needed.

## Table of Contents
* [Naming](#naming)
    * [Delegates](#delegates)
    * [Class prefixes](#class-prefixes)
    * [Type Inferred Context](#type-inferred-context)
    * [Generics](#generics)
* [Code Organization](#code-organization)
    * [Extensions](#extensions)
    * [Protocol Conformance](#protocol-conformance)
    * [Unused Code](#unused-code)
    * [Imports](#imports)
* [Spacing](#spacing)
* [Comments](#comments)
* [Classes and structs](#classes-and-structs)
    * [Use of self](#use-of-self)
* [Functions](#functions)
    * [Function Declarations](#function-declarations)
    * [Function Calls](#function-calls)
* [Closure Expressions](#closure-expressions)
* [Types](#types)
    * [Optionals](#optionals)
    * [Type inference](#type-inference)
    * [Syntactic Sugar](#syntactic-sugar)
* [Functions vs Methods](#functions-vs-methods)
* [Memory Management](#memory-management)
    * [Extending object lifetime](#extending-object-lifetime)
* [Access Control](#access-control)
* [Property Declaration Order](#property-declaration-order)
* [Control Flow](#control-flow)
    * [If Else Statement](#if-else-statement)
    * [Ternary Operator](#ternary-operator)
    * [Multiline Ternary Operator](#multiline-ternary-operator)
    * [Guard Statement](#guard-statement)
* [Semicolons](#semicolons)
* [Parentheses](#parentheses)
* [Multi-line String Literals](#multi-line-string-literals)

## Naming

Please read official Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) as it is the basis for naming conventions. Some more important rules are:
* use `camelCase` - `UpperCamelCase` for types and protocols and `lowerCamelCase` for variables, constants, function names and everything else
* clarity is more important than brevity - you should use the smallest possible number of words that **clearly** describe the type/variable/function so take your time before naming them
* name variables, parameters, and associated types according to their roles, not type
* name functions and methods according to their side-effects
* beginning factory methods with `make`
* choose parameter names to serve documentation
* avoid obscure terms and abbreviations
* take advantage of defaulted parameters and prefer to locate parameters with defaults toward the end
* label tuple members and name closure parameters
* protocols should be suffixed with `Protocol` except:
    * delegate protocols, they should have the suffix `Delegate`
    * protocols that describe the object, they should have suffix `able` - `Equatable`, `Codable`, `Runnable`...

### Delegates
The first parameter of a custom delegate method should be unnamed and contain the delegate source.

**Use:**
```swift
func imageDownloader(_ imageDownloader: ImageDownloader, didFinishDownloading: Bool)
func imageDownloaderDidStart(_ imageDownloader: ImageDownloader) -> Bool
```

**Avoid:**
```swift
func didFinishDownloading(imageDownloader: ImageDownloader)
func imageDownloaderDidStart() -> Bool
```

### Class prefixes
Do not add a prefix to a class. The only exception is if you are extending an existing class from an Apple library, most commonly from UIKit. Nevertheless, you should think and find a good name without using the prefix.

**Use:**
```swift
// Onboarding module
import CoreUI

...
let button = CoreUI.RoundedButton()
...
```

**Avoid:**
```swift
// Onboarding module
import CoreUI

...
let button = CoreUIRoundedButton()
...
```

### Type Inferred Context
The Swift compiler can conclude what is the desired (inferred) type so use that feature when assigning a value.

**Use:**
```swift
let view = UIView(frame: .zero)
view.backgroundColor = .red
```

**Avoid:**
```swift
let view = UIView(frame: CGRect.zero)
view.backgroundColor = UIColor.red
```

### Generics
Generic type parameters should have a descriptive name and it should always have in upper camel case. `T`, `U`, `V`, and other one-letter `generic types` can be used only when types don't have a meaning.

**Use:**
```swift
struct Stack<Element> { ... }
func associateBy<Key>(_ keySelector: (Element) -> Key) -> [Key: Element]
func pow<T>(_ a: T, _ b: T)
```

**Avoid:**
```swift
struct Stack<E> { ... }
func associateBy<K>(_ keySelector: (Element) -> K) -> [K: Element]
func pow<Number>(_ a: Number, _ b: Number)
```

## Code Organization
### Extensions
You should write a separate extension for each protocol you are conforming to. The extension should be:
* In a new file if that allows you not to modify class property visibility (this does not apply to properties that are an extension of `UIView`)
* Otherwise, in the same file as the class declaration. In that case, each extension **must** have a `// MARK:` comment with a name for easy navigation

It is a good practice to write code for building the view in a separate extension in a new file because building the UI should be separated from the class functionality.
You use the `ConstructViewsProtocol` protocol or you can define your own. The point is that the UI building process in code should be formalized.

```swift
/**
  Formalizes view construction into separate lifecycle steps:
  - creating views - creates and initializes all child views
  - styling views - sets style properties for each child view
  - define the layout for views - sets layout constraints for each view
*/
protocol ConstructViewsProtocol {

    func createViews()

    func styleViews()

    func defineLayoutForViews()

}
```

**Use:**
```swift
// ContentViewController.swift
class ContentViewController: UIViewController {

    var someView: UIView!

    private let presenter: ContentPresenter
    ...

}

extension ContentViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ...
        presenter.doSomething()
        ...
    }

}

// ContentViewController+Design.swift
extension ContentViewController: ConstructViewsProtocol {

    func createViews() {
        someView = UIView()
        view.addSubview(someView)
    }

    func styleViews() {
        ...
    }

    func defineLayoutForViews() {
        ...
    }

}
```

**Avoid:**
```swift
// ContentViewController.swift
class ContentViewController: UIViewController {

    
    let presenter: ContentPresenter // replaced `private` with `internal`

    private var someView: UIView! // replaced `internal` with `private`
    ...

}

extension ContentViewController: ConstructViewsProtocol {

    func createViews() {
        someView = UIView()
        view.addSubview(someView)
    }

    func styleViews() {
        ...
    }

    func defineLayoutForViews() {
        ...
    }

}

// ContentViewController+Scroll.swift
extension ContentViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ...
        presenter.doSomething()
        ...
    }
   
}

// OR
class ContentViewController: UIViewController, ConstructViewsProtocol, UIScrollViewDelegate {

    private let presenter: ContentPresenter
    private var someView: UIView!
    ...

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ...
        presenter.doSomething()
        ...
    }

    func createViews() {
        someView = UIView()
        view.addSubview(someView)
    }

    func styleViews() {
        ...
    }

    func defineLayoutForViews() {
        ...
    }

}
```

### Protocol Conformance
As mentioned in [Extensions](#extensions), when conforming to a protocol, methods should be implemented in an extension. Exceptions are protocols that provide default implementation or protocols without which the object makes no sense. 
In those cases, multiple protocols can be listed after the object name.

**Use:**
```swift
struct Car: Equatable, Codable {

    let id: Int
    let model: String

     enum CodingKeys: String, CodingKey {
        case id = "Id"
        case model = "carModel"
    }

}
```

**Avoid:**
```swift
// Car.swift
struct Car {

    let id: Int
    let model: String

}

// Car+Equatable.swift
extension Car: Equatable {}

// Car+Codable.swift
extension Car: Codable {

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case model = "carModel"
    }

}
```

### Unused Code
All unused or commented code should be removed from the codebase and that includes:
* Xcode template code
* functions that have no callers
  * if they'll have callers in the future they should be implemented then, not before they'll be used
* chunks of code that are incessable
* code that's commented out
* functions that only call `super` implementation
* incomplete functions

**Avoid:**
```swift
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
}

func numberOfItems(in array: [Int]) -> Int {
    // TODO: implement this
    return 0
}
```

Clean all the dead code after you refactor something!

### Imports
Import only modules you're using and remove imports if you've removed their usage.

**Use:**
```swift
import UIKit
import CoreUI

class MyViewController: UIViewController {

    let button: RoundedButton // from CoreUI
    let textView: UITextView

}
```

**Avoid:**
```swift
import UIKit
import CoreUI

class MyViewController: UIViewController {

    let textView: UITextView

}
```

Use the following order when importing:
* Apple frameworks
* Other frameworks (Pods)
* Project modules

and order them alphabetically within every group:

**Use:**
```swift
import SceneKit
import UIKit
import RxCocoa
import RxSwift
import Core
import CoreUI
```

## Spacing
* Indent using 4 spaces rather than tabs. Be sure to set this preference in Xcode and the Project settings.
* Empty lines should contain only a `new line` character without additional spacing.
    * Use XCode Editor settings to enforce this rule (XCode Menu -> Preferences -> Text Editing -> Editing)
    ![Spacing](spacing.jpg)
* Long lines should be wrapped at around 120 characters.
* Add a single newline character after class/struct name definition and before the end of a class body
* Add a new line after `guard` statement
* Colons have no space before and have only one space after. Exceptions are:
    * ternary operator `?:`
    * empty dictionary `[:]`
    * selectors `addTarget(_:action:)`

**Use:**
```swift
struct Person {

    let id: Int
    let name: String

}

func getStringLength(value: String?) -> Int {
    guard let value = value else { return 0 }

    return value.count
}

func·sum(numbers:·[Int?])·{¬
····var·sum:·Int·=·0¬
¬
····for·number·in·numbers·{¬
········guard·let·number·=·number·else·{·continue·}¬
¬
········sum·+=·number¬
····}¬
¬
····return·sum¬
}

class MyViewController: UIViewController {

    let userForId: [Int: User]

}
```

**Avoid:**
```swift
struct Person {
    let id: Int
    let name: String
}

func getStringLength(value: String?) -> Int {
    guard let value = value else { return 0 }
    return value.count
}

func·sum(numbers:·[Int?])·{¬
····var·sum:·Int·=·0¬
····¬
····for·number·in·numbers·{¬
········guard·let·number·=·number·else·{·continue·}¬
········¬
········sum·+=·number¬
····}¬
····¬
····return·sum¬
}
```

## Comments
When they are needed, use comments to explain **why** a particular piece of code does something, not what it does. Comments must be kept up-to-date or deleted.

Avoid block comments inline with code, as the code should be as self-documenting as possible. Exception: This does not apply to those comments used to generate documentation.

Avoid the use of C-style comments (/* ... */). Prefer the use of double- or triple-slash.

## Classes and Structs
### Use of self
Since Swift doesn't require explicit `self` to access an object's properties, don't use `self` in places other than initializers and escaping closures (don't forget to weakly capture `self`).

**Use:**
```swift
class MyClass {

    private let id: Int
    private let name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    func changeName(to newName: String) {
        name = newName
    }

}
```

**Avoid:**
```swift
class MyClass {

    private let id: Int
    private let name: String

    init(objectId: String, objectName: String) {
        id = objectId
        name = objectName
    }

    func changeName(to newName: String) {
        self.name = newName
    }

}
```

## Functions

### Function Declarations
Write function declarations that fit into 120 characters (including leading whitespace) in one line. Function declarations that are over 120 characters should be broken into multiple lines.
Body opening brackets should be in the same line as the return type.

**Use:**
```swift
1······················································································································|
    func isUserLoggedIn() -> Bool {
        ...
    }

    func someFunction(param1: SomeLongLongLongLongType1, param2: SomeLongLongLongLongType2, param3: String) -> ReturnT {
        ...
    }

    func someFunction(
        param1: SomeLongLongLongLongType1,
        param2: SomeLongLongLongLongType2,
        param3: String
    ) -> SomeLongReturnType {
        ...
    }
```

**Avoid:**
```swift
1······················································································································|
    func isUserLoggedIn() -> Bool 
    {
        ...
    }  

    func someFunction(param1: SomeLongLongLongLongType1, param2: SomeLongLongLongLongType2, param3: String) -> SomeLongReturnType {
        ...
    }

    func someFunction(param1: SomeLongLongLongLongType1, 
                      param2: SomeLongLongLongLongType2,
                      param3: String) -> SomeLongReturnType {
        ...
    }
```

Use `()` to denote void **input** and `Void` to denote void **output** for function types, but don't use `Void` in function declaration that returns nothing. 

**Use:**
```swift
    func myFunction() {
        ...
    }

    let onCompleted: () -> Void
```

**Avoid:**
```swift
    func myFunction() -> Void {
        ...
    }

    let onCompleted: () -> ()
```

### Function calls
Similar to function declarations, short function calls should be in one line, and longer broken into multiple lines. The only difference is that the closing bracket for function calls doesn't go into a new line.
The exception is multiple trailing closures which are described in [Closure Expressions](#closure-expressions).

**Use:**
```swift
1······················································································································|
    let result = isUserLoggedIn()

    let result2 = someFunction(
        param1: "SomeLongLongLongLongType1",
        param2: "SomeLongLongLongLongType2",
        param3: "SomeLongLongLongLongType3")
```

**Avoid:**
```swift
1······················································································································|
    let result1 = someFunction(param1: "SomeLongLongLongLongType1", param2: "SomeLongLongLongLongType2", param3: "SomeLongLongLongLongType3")

    let result2 = someFunction(param1: "SomeLongLongLongLongType1",
                               param2: "SomeLongLongLongLongType2",
                               param3: "SomeLongLongLongLongType3")

    let result2 = someFunction(
        param1: "SomeLongLongLongLongType1",
        param2: "SomeLongLongLongLongType2",
        param3: "SomeLongLongLongLongType3"
    )
```

## Closure Expressions
* Use trailing closure syntax only if there's a single closure expression parameter at the end of the argument list. (Swift API <5.3)
* Using multiple trailing closure syntax (Swift API 5.3+) is optional.
* Give closure parameters a meaningful name.
* Use anonymous parameters when the context is clear - naming the parameter wouldn't make the code more readable.
* Don't use `return` for one line closures if using Swift API 5.1+.

**Use:**
```swift
UIView.animate(withDuration: 1.0) {
  self.myView.alpha = 0
}

UIView.animate(
    withDuration: 1.0,
    animations: {
        self.myView.alpha = 0
    },
    completion: { finished in
        self.myView.removeFromSuperview()
    })

let names = users
    .map { $0.name }


let currentYear = 2020
let ages = users
    .map { user in
        self.checkSomething(user)
        return currentYear - user.dob.year
    }

// Multiple trailing closures
UIView.animate(
    withDuration: 1.0,
    delay: 0.0,
    options: .curveEaseIn
) {
    // animate something
} completion: { success in
    if success {
        // do something
    }
}
```

**Avoid:**
```swift
UIView.animate(withDuration: 1.0, animations: { self.myView.alpha = 0 })

UIView.animate(
    withDuration: 1.0,
    animations: {
        self.myView.alpha = 0
    }) { finished in
        self.myView.removeFromSuperview()
    }

let names = users
    .map { user in 
        user.name
    }

let names = users
    .map { user in 
        return user.name
    }

// Multiple trailing closures
UIView.animate(
    withDuration: 1.0,
    delay: 0.0,
    options: .curveEaseIn) {
    // animate something
} 
completion: { success in
    if success {
        // do something
    }
}
```

Chained methods using trailing closures should be clear and easy to read in context. With that in mind, each chained method should be in a new line.

**Use:**
```swift
let value = numbers
  .map { $0 * 2 }
  .filter { $0 > 50 }
  .map { $0 + 10 }
```

**Avoid:**
```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)
```


## Types
### Optionals
Use optional variables only to denote that a certain property is optional (not required in a model or a function). Try to avoid making something optional to accommodate error of any kind or give `nil` value some special meaning - `nil` means there's no value, and that's it. Naming should not indicate that the value is optional since the type already is.

The fact that the address is optional has no meaning, it just won't be shown on the UI.

**Use:**
```swift
struct User {

    let id: Int
    let name: String
    let address: String?

}

userView.nameLabel.text = user.name
userView.addressLabel.text = user.address
```

The fact that the address is `nil` means that the user was added after the worldwide launch and we're not storing non-US addresses.

**Avoid:**
```swift
struct User {

    let id: Int
    let name: String
    let optionalAddress: String?

}

if let address = user.optionalAddress {
    currency = .usd
} else {
    currency = .eur
}
```

When accessing optional values only once, use optional chaining, but unwrap the optional if there is more than one use of the optional or you need to get the value from the optional.

**Use:**
```swift
model?.status?.refresh()

if let model = model {
    model.status?.refresh()
    model.name = "New name"
    model.trySave()
}
```

For unwrapping, use the name of the optional instead of adding something to the name like `strongSelf`, `unwrapedAddress`, `addressWithValue` etc.

### Type Inference
Avoid explicitly declaring the type if the compiler can infer the type. Exceptions can be initialized with static values, enum cases, or if we want a type other than the inferred one.

**Use:**
```swift
let name = "MyName"
let age = 20 // we expect this to be an Int
let rectHeight: CGFloat = .defaultRectHeight
let viewHeight: CGFloat = 100
let day: DayOfWeek = .monday

var names: [String] = []
var lookup: [String: Int] = [:]
```

**Avoid:**
```swift
let name: String = "MyName"
let rectHeight = CGFloat.defaultRectHeight
let viewHeight = CGFloat(100)
let day = DayOfWeek.monday

var names = [String]()
var lookup = [String: Int]()
```

### Syntactic Sugar
Prefer the shortcut versions of type declarations over the full generics syntax.

**Use:**
```swift
var names: [String]
var employees: [Int: String]
var numberOfOffices: Int?
```

**Avoid:**
```swift
var names: Array<String>
var employees: Dictionary<Int, String>
var numberOfOffices: Optional<Int>
```

## Functions vs Methods
Free functions, which aren't attached to a class or type, should be used sparingly. When possible, prefer to use a method instead of a free function. This aids in readability and discoverability.

Free functions are most appropriate when they aren't associated with any particular type or instance.

**Use:**
```swift
let sorted = items.mergeSorted()  // easily discoverable
rocket.launch()  // acts on the model
```

**Avoid:**
```swift
let sorted = mergeSort(items)  // hard to discover
launch(&rocket)
```

Free Function Exceptions

```swift
let tuples = zip(a, b)  // feels natural as a free function (symmetry)
let value = max(x, y, z)  // another free function that feels natural
```

## Memory Management

The code should not create reference cycles. Analyze your object graph and prevent strong cycles with `weak` and `unowned` references. Alternatively, use value types (`struct`, `enum`) to prevent cycles altogether.

### Extending object lifetime

Extend object lifetime using the `[weak self]` and `guard let self = self else { return }` idiom. `[weak self]` is preferred to `[unowned self]` where it is not immediately obvious that `self` outlives the closure. Explicitly extending lifetime is preferred to optional chaining. Capturing `weak self` is **mandatory** when you want to use `self` in `@escaping` closures.

**Use:**
```swift
...
    .subscribe(onNext: { [weak self] viewModel in
        guard let self = self else { return }

        let hasErrors = self.modelHasErrors(viewModel)
        if hasErrors {
            self.showAlert(for: viewModel)
        }

        self.someView.set(viewModel)
    }
...
}
```

**Avoid:**
```swift
// might crash if self is released before `onNext` is sent
...
    .subscribe(onNext: { [unowned self] viewModel in
        let hasErrors = self.modelHasErrors(viewModel)
        if hasErrors {
            self.showAlert(for: viewModel)
        }

        self.someView.set(viewModel)
    }
...
}
```

**Avoid:**
```swift
// `self` could be released between `modelHasErrors` and `someView.set`
...
    .subscribe(onNext: { [weak self] viewModel in
        let hasErrors = self?.modelHasErrors(viewModel)
        if hasErrors {
            self?.showAlert(for: viewModel)
        }

        self?.someView.set(viewModel)
    }
...
```


## Access Control

In most cases, the only modifier you'll need to use is `private`, which is preferred over `fileprivate`.
Write other modifiers if the code organization requires it explicitly. E.g. using `public` when you want something to be visible outside that module in workspaces with multiple modules (projects).

## Property Declaration Order
Nested classes and `typealiases` should be declared before properties, at the top of the class. Order of the declarations should be from least restrictive to most restrictive:
1. `public` -> `internal` -> `private`

<br />

Order of declared properties must follow these rules, ordered by priority:
1. `static` before `non-static`
2. `open` -> `public` -> `internal` -> `file-private` -> `private`
3. `constants` before `variables` (`let` before `var`)
4. properties initialized in the same line as declared before those initialized at some other time
5. `computed properties` after other properties
6. `init` after all properties

The static/non-static group and different visibility groups must be separated by a newline.
If you want, you can extract properties into separate extensions grouped by visibility but `public` properties must be a part of class declaration.
<br/><br/>

**Use:**
```swift
class MyClass {

    enum class Section {
        main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ViewModel>

    static let var1 = "Var1"
    static var var2 = "Var2"

    private static let var3 = "Var3"
    private static var var4 = "Var4"

    public let var5 = "Var5"
    public let var6: String
    public var var7 = "Var7"
    public var var8: String

    let var9 = "Var9"
    let var10: String
    var var11 = "Var11"
    var var12: String

    private let var13 = "Var13"
    private let var14: String
    private var var15 = "Var15"
    private var var16: String

    public var var17: String {
        var5 + "x"
    }

    var var18: String {
        var9 + "10"
    }

    private var var19: String {
        var5 + var7
    }

    init(var6: String, var8: String) {
        self.var6 = var6
        self.var8 = var8
        self.var10 = "Var10"
        self.var12 = "Var12"
        self.var14 = "Var14"
        self.var16 = "Var16"
    }

}
```

## Control Flow

Prefer `guard` over `if` to avoid the pyramid of doom and when the condition blocks execution of the rest of the function.

**Use:**
```swift
func parse(from json: [String: Any]?) -> MyType{
    guard let json = json else { return nil }
    
    guard
        let id = json[idKey],
        let name = json[nameKey]
    else {
        log("missing required values")
        return nil
    }

    ...
    return myTypeObject
}
``` 

**Avoid:**
```swift
func parse(from json: [String: Any]?) -> MyType{
    if let json = json {
        if
            let id = json[idKey],
            let name = json[nameKey]
        {
            ...
            return myTypeObject
        } else {
            log("missing required values")
            return nil
        }
    }
}
``` 

### If Else Statement
Braces `if` and `else` open on the same line as the statement but close on a new line. If there are multiple statements in the `if` clause, braces open in a new line and each condition is in a new line.

**Use:**
```swift
if condition {
    // do something
} else {
    // do something else
}

if 
  condition1,
  condition2,
  condition3
{
    // do something
} else {
    // do something else
}
```

**Avoid:**
```swift
if condition { 
    // do something
}
else {
    // do something else
}

if 
    condition1,
    condition2,
    condition3 {
    // do something
} else {
    // do something else
}

if condition1, condition2, condition3 {
    // do something
} else {
    // do something else
}
```

### Ternary Operator
When assigning value under a specific condition, use the ternary operator instead of `if-else statement` whenever possible. Anything that outputs in `true` or `false` can be considered a `condition`.

**Use:**
```swift
variable = condition ? valueToAssign1 : valueToAssign2
```

**Avoid:**
```swift
if condition {
    variable = valueToAssign1
} else {
    variable = valueToAssign2
}
```

### Multiline Ternary Operator
When using a ternary operator that doesn't fit into 120 characters, use a multiline ternary operator. The second and third lines of the multiline ternary operator must be indented by one tab. 

**Use:**
```swift
variable = someLongLongLongLongCondition ? 
    valueWithVeryLongName1 :
    valueWithVeryLongName2
```

**Avoid:**
```swift
variable = someLongLongLongLongCondition ? 
valueWithVeryLongName1 :
valueWithVeryLongName2
```

### Guard Statement
* Write the `guard` statement in one line if it has only one condition and `else` has only the `return` statement. If it exceeds 120 characters, depending on the length of the condition or the body, both condition and the `else` body go in a new line, or just the `else` body goes in a new line.
* If `else` body has multiple statements, the body goes in a new line.
* If the `guard` statement has multiple conditions, each condition must be in a new line, followed by `else` in a new line. If `else` body is a single line, it should go in the same line as the `else` keyword. Otherwise, `else` body should begin in a new line.
* If the guard statement has only one condition, it can be in one line. Otherwise, each condition must be in a new line.
* Leave an empty line after the `guard` statement(s) block.

**Use:**

<sub>Note: in these examples we use `----------` to mark and end of a single example</sub>
```swift
guard condition else { return }
----------
guard condition else { return Error() }
----------
guard condition else {
    return VeryLongErrorClassNameThatWouldNotFitInSingleLine()
}
----------
guard 
    let variableWithVeryLongName = functionWithVeryLongName(param1: param1, param2: param2)
else { return }

guard 
    let variableWithVeryLongName = functionWithVeryLongName(param1: param1, param2: param2)
else { return nil }

guard 
    let variableWithVeryLongName = functionWithVeryLongName(param1: param1, param2: param2)
else { return .just() }

guard 
    let variableWithVeryLongName = functionWithVeryLongName(param1: param1, param2: param2)
else { 
    return string
        .trimmingCharacters(in: .whitespaces)
}
----------
guard condition else {
    processFirstThing()
    processThatOtherThing()
    return
}
----------
guard
    condition1,
    condition2
else {
    return
}
----------
// Multiple guards should be grouped in a block without newlines
guard condition1 else { return }
guard condition2 else { return Error() }
guard condition3 else { return Error2() }
```

**Avoid:**

<sub>Note: in these examples we use `----------` to mark and end of a single example</sub>
```swift
guard condition else {
    return
}
----------
guard condition
else { return }
----------
guard condition else {
    return Error()
}
----------
guard condition else { return VeryLongErrorClassNameThatWouldNotFitInSingleLine() }
----------
guard condition1, condition2
else { return }
----------
guard
    condition1,
    condition2
else {
    return
}
----------
guard condition1 else { return }

guard condition2 else { return Error() }

guard condition3 else { return Error2() }
```


## Semicolons

Swift requires semicolons only if writing multiple statements in the same line - which you should never do, so semicolons should be avoided.

## Parentheses

Parentheses for conditions should be avoided unless there are multiple conditions. But try to create a variable from each condition and evaluate those variables rather than the conditions themselves. 

**Use:**
```swift
if name == "Name" {

}

if (a > b && a > c) && (d < a) {

}

let isDeveloper = role == .developer
let isStudent = status == .student
if name == "Name" && isDeveloper && isStudent {

} 
```

**Avoid:**
```swift
if (name == "Name") {

}

if a > b && a > c && d < a {

}

if (name == "Name") && (role == .developer) && (status == .student) {

} 
```

## Multi-line String Literals

When creating a long string literal, you should use the multi-line string literal syntax. Open the literal on the same line as the assignment but do not include text on that line. Indent the text block one additional level.

**Use:**
```swift
let message = """
    First line of text \
    Second line \
    Third line.
  """
```

**Avoid:**
```swift
let message = """First line of text \
    Second line \
    Third line.
  """

let message = "First line of text " +
  "Second line " +
  "Third line.."
```
