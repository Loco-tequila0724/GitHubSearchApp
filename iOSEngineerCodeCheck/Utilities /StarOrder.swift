import UIKit

enum StarOrder {
    case desc
    case ask
    case none

    var urlText: String {
        switch self {
        case .desc: return "&sort=stars&order=desc" // スターの数が多い順
        case .ask: return "&sort=stars&order=ask" // スターの数が少ない順
        case .none: return ""
        }
    }

    var buttonText: String {
        switch self {
        case .desc: return "☆ Star数 ⍋"
        case .ask: return "☆ Star数 ⍒"
        case .none: return "☆ Star数 "
        }
    }

    var color: UIColor {
        switch self {
        case .desc: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .ask: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .none: return .lightGray
        }
    }
}
