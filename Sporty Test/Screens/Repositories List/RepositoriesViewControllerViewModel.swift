import Combine
import GitHubAPI
import MockLiveServer

@MainActor
final class RepositoriesViewControllerViewModel {
    @Published var repositories: [GitHubMinimalRepository] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let gitHubAPI: GitHubAPI
    private let mockLiveServer: MockLiveServer
    private let organization: String

    init(
        gitHubAPI: GitHubAPI,
        mockLiveServer: MockLiveServer,
        organization: String = "swiftlang"
    ) {
        self.gitHubAPI = gitHubAPI
        self.mockLiveServer = mockLiveServer
        self.organization = organization
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
