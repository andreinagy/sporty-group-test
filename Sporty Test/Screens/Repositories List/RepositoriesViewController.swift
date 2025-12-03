import Combine
import GitHubAPI
import MockLiveServer
import SwiftUI
import UIKit

/// A view controller that displays a list of GitHub repositories for the "swiftlang" organization.
final class RepositoriesViewController: UITableViewController {
    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer
    private let viewModel: RepositoriesViewControllerViewModel
    private var cancellables = Set<AnyCancellable>()

    init(gitHubAPI: GitHubAPI, mockLiveServer: MockLiveServer) {
        self.gitHubAPI = gitHubAPI
        self.mockLiveServer = mockLiveServer
        self.viewModel = RepositoriesViewControllerViewModel(
            gitHubAPI: gitHubAPI,
            mockLiveServer: mockLiveServer
        )

        super.init(style: .insetGrouped)

        title = "swiftlang"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: "RepositoryCell")

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewModel.$repositories
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.tableView.refreshControl?.beginRefreshing()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        awaitLoadRepositories()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repository = viewModel.repositories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryTableViewCell

        cell.name = repository.name
        cell.descriptionText = repository.description
        cell.starCountText = repository.stargazersCount.formatted()

        let repoId = repository.id
        let currentStars = repository.stargazersCount
        Task {
            do {
                cell.starCancellable = try await mockLiveServer.subscribeToRepo(repoId: repoId, currentStars: currentStars) { [weak cell] updatedStars in
                    DispatchQueue.main.async {
                        cell?.starCountText = updatedStars.formatted()
                    }
                }
            } catch {
                print("Failed to subscribe to repo \(repository.name): \(error)")
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        let viewController = RepositoryViewController(
            minimalRepository: repository,
            gitHubAPI: gitHubAPI,
            mockLiveServer: mockLiveServer
        )
        show(viewController, sender: self)
    }

    private func awaitLoadRepositories() {
        Task {
            await viewModel.loadRepositories()
        }
    }
    
    @objc private func refreshControlValueChanged() {
        awaitLoadRepositories()
    }
}
