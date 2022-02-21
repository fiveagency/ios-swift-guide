# Localization
This folder will contain files needed to formalize retrieving of localized strings.

<br /> 

## Table of Contents
* [Overview](#overview)
* [Setup](#setup)
* [Usage](#usage)

<br /> 

## Overview

A combination of `Localizable` and `LocalizableKeysProtocol` is used to formalize localization.
This combination provides a simple and compact way of retrieving localized strings in single and multi-module projects.

[Localizable](Localizable.swift) is a protocol that links localization keys from `.strings` file with the string enumeration localization cases to be able to retrieve concrete localization strings.

[LocalizableKeysProtocol](LocalizableKeysProtocol.swift) is a protocol that links `String` and `Localizable` enumeration to be able to use enumeration cases in `.localized(_)` and the `.localized(format:_:...)` functions.

<br /> 

## Setup
In `LocalizableStrings.swift` only hold localization keys for that module.

```swift
enum LocalizableStrings: String {

    case firstLocalization
    case secondLocalizationFormat
    case thirdLocalization
    case fourthLocalizationFormat

}
```
In `LocalizableStrings+Localizable.swift`:
 - extend previously created enumeration with `Localizable` and set getters for the `bundle` and the `tableName`.

 - extend `String` with `LocalizableKeysProtocol` to associate concrete `Localizable` type by implementing `LocalizableKeys` typealias. In other words, "register" `LocalizableStrings` enumeration.

See [LocalizableKeysProtocol.swift](LocalizableKeysProtocol.swift) and [Localizable.swift](Localizable.swift) files for more details.

```swift
extension LocalizableStrings: Localizable {

    var bundle: Bundle {
        Bundle.main
    }

    var tableName: String {
        "LocalizationTableName"
    }

}

extension String: LocalizableKeysProtocol {

    typealias LocalizableKeys = LocalizableStrings

}
```

<br /> 

## Usage

After everything is set up, you should be able to access localization strings as follows:

```swift
func styleViews() {
    firstLabel.text = .localized(.firstLocalization)

    secondLabel.text = .localized(format: .secondLocalizationFormat, "A substitute string")
}
```