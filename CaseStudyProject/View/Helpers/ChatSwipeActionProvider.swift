//  CaseStudyProject
//  View/Helpers/ChatSwipeActionProvider.swift

//** Bu sınıf, 'UITableView' satırlarında kullanılan swipe(kaydırma) eylemleri için standart bir yapı sağlar. Sağdan veya soldan kaydırıldığında görülen
//   'UIContextualAction' butonlarının ikon, metin ve renkleriyle birlikte özelleştirilmesini kolaylaştırır.

import UIKit

final class ChatSwipeActionProvider {

    static func makeSwipeAction(
        title: String,
        systemImage: String,
        color: UIColor,
        handler: @escaping () -> Void
    ) -> UIContextualAction {

        let action = UIContextualAction(style: .normal, title: "") { _, _, completion in
            handler()
            completion(true)
        }

        let image = makeImageWithIconAndText(systemImage: systemImage, text: title, color: color)
        action.backgroundColor = color
        action.image = image
        return action
    }

    private static func makeImageWithIconAndText(systemImage: String, text: String, color: UIColor) -> UIImage? {
        let size = CGSize(width: 70, height: 70)
        let renderer = UIGraphicsImageRenderer(size: size)

        return renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            if let icon = UIImage(systemName: systemImage)?.withTintColor(.white, renderingMode: .alwaysOriginal) {
                let iconRect = CGRect(x: (size.width - 24)/2, y: 10, width: 24, height: 24)
                icon.draw(in: iconRect)
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            let textRect = CGRect(x: 0, y: 40, width: size.width, height: 20)
            (text as NSString).draw(in: textRect, withAttributes: attributes)
        }
    }
}
