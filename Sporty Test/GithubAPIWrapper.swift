import Foundation
import GitHubAPI

final class GitHubAPIWrapper {
    var gitHubAPI: GitHubAPI
    let keychainWrapper = KeychainWrapper()
    
    init() {
        let token = try? keychainWrapper.getToken()
        print("GitHubAPIWrapper init using token: \(token ?? "")")
        gitHubAPI = GitHubAPI(authorisationToken: token)
    }
    
    func saveToken(_ token: String) throws {
        print("GitHubAPIWrapper saveToken: \(token)")
        try keychainWrapper.saveToken(token)
        gitHubAPI = GitHubAPI(authorisationToken: token)
    }
    
    func getToken() throws -> String? {
        let token = try keychainWrapper.getToken()
        print("GitHubAPIWrapper getToken: \(token ?? "")")
        return token
    }
    
    func deleteToken() throws {
        print("GitHubAPIWrapper deleteToken")
        try keychainWrapper.deleteToken()
        gitHubAPI = GitHubAPI(authorisationToken: nil)
    }
    
    func repositoriesForOrganisation(_ organisation: String) async throws -> [GitHubMinimalRepository] {
        print("GitHubAPIWrapper repositoriesForOrganisation \(organisation)")
        return try await gitHubAPI.repositoriesForOrganisation(organisation)
    }
    
    func repository(_ fullName: String) async throws -> GitHubFullRepository {
        print("GitHubAPIWrapper repository \(fullName)")
        return try await gitHubAPI.repository(fullName)
    }
}
