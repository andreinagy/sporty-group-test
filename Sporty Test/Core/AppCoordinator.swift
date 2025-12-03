import MockLiveServer
import SwiftUI
import UIKit

@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let gitHubAPI: GitHubAPIWrapper
    private let mockLiveServer: MockLiveServer
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
        gitHubAPI = GitHubAPIWrapper()
        mockLiveServer = MockLiveServer()
    }

    func start() {
        let repositoriesViewController = RepositoriesViewController(
            gitHubAPI: gitHubAPI,
            mockLiveServer: mockLiveServer,
        )
        
        // Add settings button
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: nil,
            action: nil
        )
        settingsButton.action = #selector(repositoriesViewController.showSettings)
        settingsButton.target = repositoriesViewController
        repositoriesViewController.navigationItem.rightBarButtonItem = settingsButton
        
        navigationController.viewControllers = [repositoriesViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    func handleDeepLink(url: URL) {
        guard let (organization, repository) = organizationAndRepo(url) else { return }
        
        Task {
            await openRepository(organization: organization, repository: repository)
        }
    }
    
    private func openRepository(organization: String, repository: String) async {
        do {
            let repositories = try await gitHubAPI.repositoriesForOrganisation(organization)
            if let repository = repositories.first(where: { $0.name == repository }) {
                print(repository)
                let viewController = RepositoryViewController(
                    minimalRepository: repository,
                    gitHubAPI: gitHubAPI,
                    mockLiveServer: mockLiveServer
                )
                navigationController.popToRootViewController(animated: false)
                navigationController.pushViewController(viewController, animated: true)
            }
        } catch {
            print("Error opening repository: \(error)")
        }
    }
}

// Parse organization and repo from deep link URL like `sportytest://swiftlang/swift`
func organizationAndRepo(_ url: URL) -> (String, String)? {
    guard url.scheme == "sportytest", url.host == "repo" else { return nil }
    let pathComponents = url.pathComponents.filter { $0 != "/" }
    guard pathComponents.count >= 2 else { return nil }
    
    let organization = pathComponents[0]
    let repositoryName = pathComponents[1]
    return (organization, repositoryName)
}
