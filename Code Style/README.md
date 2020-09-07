# FIVE iOS Swift Code Style

This is an official code style guide for FIVE iOS Swift projects. [Ray Wanderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide) was used as base, additional rules were added where necessary and existing ones were modified where needed.

## Table of Contents
- [FIVE iOS Swift Code Style](#five-ios-swift-code-style)
  - [Table of Contents](#table-of-contents)
  - [Naming](#naming)
    - [Delegates](#delegates)
    - [Class prefixes](#class-prefixes)
    - [Type Inferred Context](#type-inferred-context)
    - [Generics](#generics)
  - [Spacing](#spacing)
  - [Closure Expressions](#closure-expressions)
  - [Control Flow](#control-flow)
    - [If Else Statement](#if-else-statement)
    - [Guard Statement](#guard-statement)
  - [Property Declaration Order](#property-declaration-order)


## Naming

Please read official Swift [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) as it is the basis for naming conventions. Some more important rules are:
* use `camelCase` - `UpperCamelCase` for types and protocol and `lowerCamelCase` for variables, constants, function names and everything else
* clarity is more important than brevity - you should use smallest possible number of words that **clearly** describe the type/variable/function so take your time before naming them
* name variables, parameters, and associated types according to their roles, not type
* name functions and methods according to their side-effects
* choose parameter names to serve documentation
* avoid obscure terms and abbreviations
* take advantage of defaulted parameters and orefer to locate parameters with defaults toward the end
* label tuple members and name closure parameters

### Delegates
The first parameter of a custom delegate method should be unnamed and contain the delegate source.

**Use**:
```swift
func imageDownloader(_ imageDownloader: ImageDownloader, didFinishDownloading: Bool)
func imageDownloaderDidStart(_ imageDownloader: ImageDownlaoder) -> Bool
```

**Avoid**:
```swift
func didFinishDownloading(imageDonwloader: ImageDownlaoder)
func imageDownlaoderDidStart() -> Bool
```

### Class prefixes
Do not add prefix to a class. Only exception is if you are extending an existing class from an Apple library, most commonly from UIKit. Nevertheless, you should think and find a good name without using the prefix.

**Use**
```swift
//Onboarding module
import CoreUI

...
let button = CoreUI.RoundedButton()
...
```

**Avoid**
```swift
//Onboarding module
import CoreUI

...
let button = CoreUIRoundedButton()
...
```

### Type Inferred Context
Swift compiler can conclude what is the desired (inferred) type so use that feature when assigning a value.

**Use**:
```swift
let view = UIView(frame: .zero)
view.backgroundColor = .red
```

**Avoid**:
```swift
let view = UIView(frame: CGRect.zero)
view.backgroundColor = UIColor.red
```

### Generics
Generic type parameters should have a descriptive name and it should always have in upper camel case. `T`, `U`, `V` and other one-letter `generic types` can be used only when types don't have a meaning.

**Use**:
```swift
struct Stack<Element> { ... }
func associateBy<Key>(_ keySelector: (Element) -> Key) -> [Key: Element]
func pow<T>(_ a: T, _ b: T)
```

**Avoid**
```swift
struct Stack<E> { ... }
func associateBy<K>(_ keySelector: (Element) -> K) -> [K: Element]
func pow<Number>(_ a: Number, _ b: Number)
```

## Spacing
* Indent using 4 spaces rather than tabs. Be sure to set this preference in Xcode and in the Project settings.
* Empty lines should contain only a `new line` character without additional spacing.
* Long lines should be wrapped at around 120 characters.
* Add a single newline character after class/struct name definition and before end of class body
* Add a new line after `guard` statement

`-` represent single `space` character
**Use**:
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
········sum·+=·number
····}
¬
····return·sum
}
```

**Avoid**:
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
········sum·+=·number
····}
····¬
····return·sum
}
```

## Closure Expressions
Chained methods using trailing closures should be clear and easy to read in context. With that in mind, each chained method should be in new line.

**Use**:
```swift
let value = numbers
  .map { $0 * 2 }
  .filter { $0 > 50 }
  .map { $0 + 10 }
```

**Avoid**:
```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)
```

## Control Flow

### If Else Statement
Braces `if` and `else` open on the same line as the statement but close on a new line. If there are multiple statements in `if` clause, braces open in new line and each condition is in new line.

**Use**:
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

**Avoid**:
```swift
if condition { 
    // do something
}
else {
    // do something else
}

if condition1, condition2, condition3 {
    // do something
} else {
    // do something else
}
```

### Guard Statement
* Write the `guard` statement in one line if it has only one condition and `else` has only `return` statement. If it exceeds 120 chars, `else` body goes in new line.
* If `else` body has multiple statements, the body goes in new line.
* If `guard` statement has multiple conditions, each condition must be in new line, followed by `else` in new line and `else` body in new line.

**Use**:
```swift
guard condition else { return }

guard condition else { return Error() }

guard condition else {
    return VeryLongErrorClassNameThatWouldNotFitInSingleLine()
}

guard condition else {
    processFirstThing()
    processThatOtherThing()
    return
}

guard
    condition1,
    condition2
else {
    return
}
```

**Avoid**:
```swift
guard condition else {
    return
}

guard condition
else { return }

guard condition else {
    return Error()
}

guard condition else { return VeryLongErrorClassNameThatWouldNotFitInSingleLine() }

guard condition1, condition2
else { return }
```

* If the guard statement has only one condition, it can be in one line. Otherwise, each condition must be in new line
Braces `if` and `else` open on the same line as the statement but close on a new line. If there are multiple statements in `if` clause, braces open in new line and each condition is in new line.
**Use**:
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

**Avoid**:
```swift
if condition { 
    // do something
}
else {
    // do something else
}

if condition1, condition2, condition3 {
    // do something
} else {
    // do something else
}
```



## Property Declaration Order
Order of declared properties must follow these rules, ordered by priority:
1. `static` before `non-static`
2. `private` before `internal` and `internal` before `public`
3. `constants` before `variables` (`let` before `var`)
4. properties initialized in the same line as declared before those initialized at some other time
5. `computed properties` after other properties
6. `init` after all properties

Static/non-static group and different visibility group must be separated by newline.

**Use**:
```swift
class MyClass {

    private static let var1 = "Var1"
    private static var var2 = "Var2"

    static let var3 = "Var3"
    static var var4 = "Var4"

    private let var5 = "Var5"
    private let var6: String
    private var var7 = "Var7"
    private var var8: String

    let var9 = "Var9"
    let var10: String
    var var11 = "Var11"
    var var12: String

    public let var13 = "Var13"
    public let var14: String
    public var var15 = "Var15"
    public var var16: String

    private var var17: String {
        var5 + var7
    }

    var var18: String {
        var9 + "10"
    }

    public var var19: String {
        var5 + "x"
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








