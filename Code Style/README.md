# FIVE iOS Swift Code Style

This is an official code style guide for FIVE iOS Swift projects.

## Table of Contents

* [Base rules](#baserules)
* [Spacing](#spacing)
* [Closure Expressions](#closure-expressions)
* [Control Flow](#control-flow)
    * [If Else Statement](#if-else-statement)
* [Property Declaration Order](#property-declaration-order)


## Base rules
We are using [Ray Wanderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide) as a base guide. Most of the code style rules are on that page but we will list additional rules and/or exception to some of the rules.

## Spacing
* Indent using 4 spaces rather than tabs. Be sure to set this preference in Xcode and in the Project settings.
* Long lines should be wrapped at around 120 characters.
* Add a single newline character after class/struct name definition and before end of class body

**Preferred**:
```swift
struct Person {

    let id: Int
    let name: String

}
```

**Not Preferred**:
```swift
struct Person {
    let id: Int
    let name: String
}
```

## Closure Expressions
Chained methods using trailing closures should be clear and easy to read in context. With that in mind, each chained method should be in new line.

**Preferred**:
```swift
let value = numbers
  .map { $0 * 2 }
  .filter { $0 > 50 }
  .map { $0 + 10 }
```

**Not Preferred**:
```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)
```

## Control Flow

### If Else Statement
Braces `if` and `else` open on the same line as the statement but close on a new line. If there are multiple statements in `if` clause, braces open in new line and each condition is in new line.
**Preferred**:
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

**Not Preferred**:
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

**Preferred**:
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

**Not Preferred**:
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
**Preferred**:
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

**Not Preferred**:
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

**Preferred**:
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








