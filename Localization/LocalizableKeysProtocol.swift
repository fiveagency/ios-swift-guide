protocol LocalizableKeysProtocol {

    associatedtype LocalizableKeys: Localizable

}

extension LocalizableKeysProtocol {

    static func localized(_ key: LocalizableKeys) -> String {
        key.localized
    }

    static func localized(_ key: LocalizableKeys, arguments: [CVarArg]) -> String {
        String(format: key.localized, arguments: arguments)
    }

}
