// ios/String+Extension.swift
import UIKit

extension String {
    func font(size: CGFloat = 16) -> UIFont? {
        return UIFont(name: self, size: size)
    }
}
