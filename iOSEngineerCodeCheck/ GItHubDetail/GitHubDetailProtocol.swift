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
    var gitHub: User? { get }
    func viewDidLoad()
}
// Router
protocol GitHubDetailWireFrame: AnyObject {
    static func assembleModules(gitHub: User) -> UIViewController
}
