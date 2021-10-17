//
//  UIViewController+Extension.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/17.
//

import UIKit

protocol ComprehensibleError: Error {
    var message: String { get }
}

extension UIViewController {
    func alertErrorMessage(_ error: ComprehensibleError) {
        let alertController = UIAlertController(title: "에러 발생", message: error.message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okay)
        present(alertController, animated: true, completion: nil)
    }
}
