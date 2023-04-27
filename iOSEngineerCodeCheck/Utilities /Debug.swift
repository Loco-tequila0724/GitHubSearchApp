import Foundation
// swiftlint:disable all
struct Debug {
    static func log(_ obj: Any? = nil, file: String = #file, function: String = #function, line: Int = #line, errorDescription: String) {
        var filename: NSString = file as NSString
        filename = filename.lastPathComponent as NSString
        let text: String
        if let obj = obj {
            text = "[File: \(filename) Func: \(function) Line: \(line)] : \(obj)"
        } else {
            text = "[File: \(filename) Func: \(function) Line:\(line)]"
        }
        print(text, "✨💀", errorDescription)
    }
}
