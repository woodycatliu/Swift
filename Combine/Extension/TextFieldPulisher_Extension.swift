//  Created by Woody Liu on 2022/1/3.

import UIKit
import Combine

extension UITextField {
    func textPublisher()-> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}