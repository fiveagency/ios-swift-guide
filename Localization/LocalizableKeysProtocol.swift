/// Formalizes accessing localization keys through `Localizable` in feature module oriented codebase.
/// - Note: Extend `Strings` with this protocol when adding new localizable file in a feature module.
protocol LocalizableKeysProtocol {

    /// Concrete `Localizable` enumeration type used for accessing cases.
    associatedtype LocalizableKeys: Localizable

}

/// Provides default implementations for transforming `Localizable` case into a concrete String.
extension LocalizableKeysProtocol {

    /// Returns concrete localized String for the given localization key
    ///
    /// - parameter key: Localization key as enumeration case in `Localizable` enumeration
    static func localized(_ key: LocalizableKeys) -> String {
        key.localized
    }

    /// Returns concrete localized `String` for the given localization key using it as a template
    /// into which the remaining argument values are substituted
    ///
    /// - parameter format: Localization key as enumeration case in `Localizable` enumeration used as a template
    /// - parameter arguments: Values used as format substitutes
    static func localized(format: LocalizableKeys, _ arguments: CVarArg...) -> String {
        String(format: format.localized, arguments: arguments)
    }

}
