# FIVE iOS Swift Code Style

This is an official code style guide for FIVE iOS Swift projects.

> Code is more often read than written. Style is not about code correctness. What style does is create a consistent experience that enables a reader to abstract away a file’s line-by-line layout and focus on the underlying meaning, intent, and implementation.

## Table of Contents

* [Base rules](#baserules)
* [Spacing](#spacing)
* [Closure Expressions](#closure-expressions)
    * [Trailing closures](#trailing-closures)
* [Control Flow](#control-flow)
    * [If Else Statement](#if-else-statement)
    * [Guard Statement](#guard-statement)
    * [Colinear braces (single-line)](#colinear-braces--single-line)
* [Property Declaration Order](#property-declaration-order)
* [Collections](#collections)
* [Ternaries](#ternaries)
* [Semicolons](#semicolons)
    * [Defer](#defer)
* [Coaligning Assignments](#coaligning-assignments)


## Base rules
We are using [Ray Wanderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide) as a base guide. Most of the code style rules are on that page but we will list additional rules and/or exception to some of the rules.

## Spacing
* Indent using 4 spaces rather than tabs. Be sure to set this preference in Xcode and in the Project settings.
* Long lines should be wrapped at around 120 characters.
* Add a single newline character after class/struct name definition and before end of class body
* Add a new line after `guard` statement

**Preferred**:
```swift
struct Person {

    let id: Int
    let name: String

}

func getStringLength(value: String?) -> Int {
    guard let value = value else { return 0 }

    return value.count
}
```

**Not Preferred**:
```swift
struct Person {
    let id: Int
    let name: String
}

func getStringLength(value: String?) -> Int {
    guard let value = value else { return 0 }
    return value.count
}
```

## Closure Expressions

* Reserve closure shorthand for short and simple elements.
* Prefer to name arguments for nontrivial implementations.
* Omit `return` keyword from single-line closures.
* Each chained method should be in new line.

**Preferred:**
```swift
.onNext { value in
    // nontrivial implementation
}

perform(a: 1, b: 2) ({
    Int(pow(Double($0), Double($1)))
})

let value = numbers
  .map({ $0 * 2 })
  .filter({ $0 > 50 })
  .map({ $0 + 10 })
```

**Not Preferred**:
```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)
```

### Trailing closures
* Place paratheses around trailing closures when argument is functional (returns a value, avoids state change and mutating data). 
* Do not place parentheses around trailing closures when argument is procedural (updates state or has side effects).
* Stay consistent with functions that incorporate more than one closure argument. Don't parenthesize one and let another trail.

This style creates consistent readability by letting parentheses tell you if a value is expected to be returned.

**Preferred**
```swift
// Functional
let even = (1...10)
    .filter({ $0 % 2 == 0 })
    .map({ "\($0)" })
    
// Procedural
UIView.animate(
    withDuration: duration,
    animations: {
        // perform animation 
    },
    completion: {
        // perform completion
    })
```

**Not Preferred**
```swift
UIView.animate(
    withDuration: duration,
    animations: { 
        // perform animations 
    }) { 
        // perform completion 
    }
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

// Xcode is really bad at aligning `guard` and `else` keywords. Instead of fighting with it, we'll leave it indented.
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

### Colinear braces (single-line)
Look for situation where breaking down function calls into three or more separate lines would detract from your code story rather than enhance it.

* Give space to each brace.
* Avoid single-line clauses just to cut back on vertical space. Vertical space is cheap; readability is precious.

**Preferred**
```swift
let even = (1...10)
    .filter({ $0 % 2 == 0 })
    .map({ "\($0)" })
```

**Not Preferred**
```swift
let even = (1...10)
    .filter({ 
        $0 % 2 == 0 
    })
    .map({
        "\($0)"
    })
```

##### Catch and else clauses
Single-line is applicable if braced statements are short and simple.

* A `return`, `continue`, `break`, or `throw` doesn’t need multiple lines.

**Preferred**
```swift
do {
    ...
} catch { print(error) }

guard let self = self else { return }
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

## Collections
* For collections that don't fit on the single line, use multiline layout. Individual lines are easier to comment out and provide better diffs in version control.
* In multiline layouts, prefer trailing commas after the last element. You are less likely to introduce errors when commenting out lines or adding new items.
* In multiline layouts, closing brackets go onto their own line. It makes it easier to add new items without having to move the closing bracket.

**Preferred**
```swift
let fruits = ["apple", "banana", "pear"]

let colors: [String: UIColor]  = [
    "Red": .red,
    "Blue": .blue,
    "White": .white,
    "Black": .black,
    "Purple": .purple,
    "Green": .green,
]
```

## Ternaries
* Use a single line for simple values.
* When using multiple lines, align the ? and : characters.
* Prefer nil coalescing to ternary statements.

**Preferred**
```swift
return value > 0 ? 1 : -1

return style == .left
    ? padString + self
    : self + padString
    
return optValue ?? fallack // yes
return optValue == nil ? fallback : optValue! // no
```

## Semicolons
Semicolons should never be used for terminating statements. They are only useful when joining related concepts.

Two ways to know if two statements should be connected with a semicolon:
* If they read better as a single semicolon-delimited group rather than as one line following the other, join them.
* If they perform two unrelated jobs or two lines of a sequential task (or they’re too long), place them on separate lines without semicolons.

### Defer
A common use for semicolons is in conjuction with defer clauses. They allow us to pair setup with corresponding tear-down statements.

**Preferred**
```swift
UIGraphicsPushContext(context); defer { UIGraphicsPopContext() }
```

**Not Preferred**
```swift
func foo() {
    statement1;
    statement2;
    statement3;
}
```

## Coaligning assignments
It's unnecessary and fragile. Maintaining this practice is not feasible and therefore a counter to a good style practice.

**Preferred**
```swift
let name = "John"
let surname = "Doe"
```

**Not Preferred**
```swift
let name    = "John"
let surname = "Doe"
```


