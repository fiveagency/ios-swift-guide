# Custom rule documentation

## newline_after_definition_start and newline_before_definition_end

These rules enforce our code style for having a newline after opening and before closing braces when defining new types.

<br/>

NOTE: The newline_before_definition_end will not catch nested type definitions, only the most outer closing braces. I was not able to construct a regex that will stop at the proper closing brace and also check if there is not an empty line before it.

<br/>

### Won't trigger warning:

```swift
class VeryLongNameThisIsForAViewController: BaseViewController<VeryLongNameThisIsForAViewState,
                                                               VeryLongNameThisIsForAViewModel> {

    let defaultPadding: CGFloat = 16

    ...

    }

}
```
```swift
class ViewController: BaseViewController<ViewState,  ViewModel> {

    let defaultPadding: CGFloat = 16

    ...

    }

}
```
```swift
class ViewController: UIViewController {

    let defaultPadding: CGFloat = 16

    ...

    }

}
```

```swift
class ViewController: UIViewController {

    let defaultPadding: CGFloat = 16
    
    struct someStruct {
       
        let dataString: String
        ...
        let dataInt: Int

    }

}
```
This one is a limitation of a regex:
```swift
class ViewController: UIViewController {

    let defaultPadding: CGFloat = 16

    struct someStruct {
       
        let dataString: String
        ...
        let dataInt: Int
    }

}
```

<br/>

### Will trigger warning:

```swift
class VeryLongNameThisIsForAViewController: BaseViewController<VeryLongNameThisIsForAViewState,
                                                               VeryLongNameThisIsForAViewModel> {
    let defaultPadding: CGFloat = 16

    ...

    }

}
```
```swift
class VeryLongNameThisIsForAViewController: BaseViewController<VeryLongNameThisIsForAViewState,
                                                               VeryLongNameThisIsForAViewModel> {

    let defaultPadding: CGFloat = 16

    ...

    }
}
```
```swift
class VeryLongNameThisIsForAViewController: BaseViewController<VeryLongNameThisIsForAViewState,
                                                               VeryLongNameThisIsForAViewModel> {
    let defaultPadding: CGFloat = 16

    ...

    }
}
```
```swift
class ViewController: BaseViewController<ViewState,  ViewModel> {
    let defaultPadding: CGFloat = 16

    ...

    }
}
```
```swift
class ViewController: UIViewController {

    let defaultPadding: CGFloat = 16

    ...

    }
}
```
```swift
class ViewController: UIViewController {
    let defaultPadding: CGFloat = 16

    ...

    }

}
```
```swift
class ViewController: UIViewController {

    let defaultPadding: CGFloat = 16

    struct someStruct {
        let dataString: String
        ...
        let dataInt: Int

    }

}
```