import Combine
import GitHubAPI
import MockLiveServer

@MainActor
final class RepositoriesViewControllerViewModel {
    @Published var repositories: [GitHubMinimalRepository] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var organization: String = "swiftlang"

    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer

    init(
        gitHubAPI: GitHubAPI,
        mockLiveServer: MockLiveServer,
        organization: String = "swiftlang"
    ) {
        self.gitHubAPI = gitHubAPI
        self.mockLiveServer = mockLiveServer
        self.organization = organization
    }

    func setOrganization(_ org: String) {
        organization = org
    }

    func loadRepositories() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            repositories = try await gitHubAPI.repositoriesForOrganisation(organization)
            error = nil
        } catch {
            self.error = error
            print("Error loading repositories: \(error)")
        }
    }
}
