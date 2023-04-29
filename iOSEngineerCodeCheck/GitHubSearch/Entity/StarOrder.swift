import UIKit

// MARK: - Star数ボタンに関する -
enum StarOrder {
    case desc
    case ask
    case `default`

    var text: String {
        switch self {
        case .desc: return "☆ Star数 ⍋"
        case .ask: return "☆ Star数 ⍒"
        case .`default`: return "☆ Star数 "
        }
    }

    var color: UIColor {
        switch self {
        case .desc: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .ask: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .`default`: return .lightGray
        }
    }
}
