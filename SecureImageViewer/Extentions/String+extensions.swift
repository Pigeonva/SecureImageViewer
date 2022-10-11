//
//  String+extensions.swift
//  SecureImageViewer
//
//  Created by Артур Фомин on 11.10.2022.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
