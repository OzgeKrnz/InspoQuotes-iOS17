//
//  NavigationBarGradient.swift
//  InspoQuotes
//
//  Created by özge kurnaz on 1.02.2025.
//  Copyright © 2025 London App Brewery. All rights reserved.
//

import UIKit

extension UINavigationBar {
    /// Navigation Bar'a gradient eklemek için fonksiyon
    func setGradientBackground(colors: [UIColor]) {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 88) // Navigation Bar yüksekliği
        if let gradientImage = createGradientImage(colors: colors, size: size) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = gradientImage
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
        }
    }

    /// Gradient görüntüsü oluşturan yardımcı fonksiyon
    private func createGradientImage(colors: [UIColor], size: CGSize) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Sol üst
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Sağ alt

        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
