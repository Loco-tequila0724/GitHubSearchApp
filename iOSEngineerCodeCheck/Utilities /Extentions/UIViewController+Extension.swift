import UIKit

extension UIViewController {
    func errorAlert(message: String) {
        let alert = UIAlertController(
            title: "エラーです。",
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
