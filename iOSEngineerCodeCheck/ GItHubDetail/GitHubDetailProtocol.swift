import UIKit
// View
protocol GitHubDetailView: AnyObject {
    var presenter: GitHubDetailPresenter { get }
}
// Presentation
protocol GitHubDetailPresentation: AnyObject {
    var view: GitHubDetailView? { get }
    var router: GitHubDetailRouter? { get }
}
// Router
protocol GitHubDetailWireFrame: AnyObject {
    static func assembleModules(gitHub: User) -> UIViewController
}
