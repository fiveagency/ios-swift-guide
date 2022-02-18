import Combine
import UIKit

extension UITextField {

    var textDidChange: AnyPublisher<String, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }

    var textDidBeginEditing: AnyPublisher<Void, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: self)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    func notifyTextChanged() {
        NotificationCenter
            .default
            .post(name: UITextField.textDidChangeNotification, object: self)
    }

}
