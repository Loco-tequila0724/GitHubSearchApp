import UIKit

// View
protocol GitHubDetailView: AnyObject {
    var presenter: GitHubDetailPresenter! { get }
    func configure()
}

// Presentation
protocol GitHubDetailPresentation: AnyObject {
    var view: GitHubDetailView? { get }
    var router: GitHubDetailRouter? { get }
    var item: Item? { get }
    func viewDidLoad()
}

// Router
protocol GitHubDetailWireFrame: AnyObject {
    static func assembleModules(item: Item) -> UIViewController
}
