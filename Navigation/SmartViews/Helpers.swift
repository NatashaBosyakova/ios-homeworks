//
//  Helpers.swift
//  Navigation
//
//  Created by Наталья Босякова on 08.12.2022.
//

import Foundation
import UIKit

func presentAlert(title: String, message: String, controller: UIViewController) {
        
    let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
    alert.view.tintColor = .black
    
    controller.present(alert, animated: true, completion: nil)
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    func isValidEmail() -> Bool {
      let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
      let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
      return emailValidationPredicate.evaluate(with: self)
    }
}

