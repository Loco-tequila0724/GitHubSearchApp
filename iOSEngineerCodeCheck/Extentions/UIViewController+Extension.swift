import UIKit

extension UIViewController {
    func errorAlert(message: String) {
        let alert = UIAlertController(
            title: "エラーです。",
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(title: "OK", style: .default)// swiftlint:disable:this all
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func setupNavigationBar(title: String, fontSize: CGFloat = 18) {
        navigationItem.title = title

        navigationItem.backBarButtonItem =
            UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //        appearance.backgroundColor = #colorLiteral(red: 0.1089240834, green: 0.09241241962, blue: 0.1406958103, alpha: 1)
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: fontSize, weight: .bold), .foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}
