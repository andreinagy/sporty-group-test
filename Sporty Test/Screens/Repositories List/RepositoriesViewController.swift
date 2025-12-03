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
    private var headerView: RepositoriesHeaderView?

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
        setupRefreshControl()
        setupOrganizationView()
        
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
        
        viewModel.$organization
            .sink { [weak self] org in
                DispatchQueue.main.async {
                    self?.title = org
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .sink { [weak self] error in
                DispatchQueue.main.async {
                    self?.headerView?.setError(error != nil)
                    if let error {
                        self?.showErrorAlert(error)
                    }
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
    
    private func setupOrganizationView() {
        let headerView = RepositoriesHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        self.headerView = headerView
        headerView.setOrganization(viewModel.organization)
        headerView.onGoTapped = { [weak self] organization in
            self?.viewModel.setOrganization(organization)
            self?.awaitLoadRepositories()
        }
        tableView.tableHeaderView = headerView
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshControlValueChanged() {
        awaitLoadRepositories()
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
