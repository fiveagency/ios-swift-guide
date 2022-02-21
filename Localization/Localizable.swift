import Foundation

/// Formalizes resolving localizations in feature module oriented codebase.
/// - Note: Implement this protocol when adding new localizable file in a feature module.
protocol Localizable {

    /// Gets name of the table file containing localized strings
    var tableName: String { get }

    /// Gets localized string for provided localization key
    var localized: String { get }

    /// Set it to module bundle to be able to retrieve localization files from module's bundle.
    var bundle: Bundle { get }

}


/// Provides default implementation for `localized` property
extension Localizable where Self: RawRepresentable, Self.RawValue == String {

    /// Gets localized string from configured `tableName`
    var localized: String {
        NSLocalizedString(rawValue, tableName: tableName, bundle: bundle, value: "**\(rawValue)**", comment: "")
    }

}
