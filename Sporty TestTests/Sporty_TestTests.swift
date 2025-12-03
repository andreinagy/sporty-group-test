import Foundation
import Testing
@testable import Sporty_Test

struct Sporty_UIKit_TestTests {
    @Test func organizationAndRepoWithValidURL() throws {
        // Given
        let url = URL(string: "sportytest://repo/apple/swift")!
        
        // When
        let (organization, repository) = organizationAndRepo(url) ?? ("", "")
        
        // Then
        #expect(organization == "apple")
        #expect(repository == "swift")
    }
    
    @Test func organizationAndRepoWithDifferentOrganization() throws {
        // Given
        let url = URL(string: "sportytest://repo/swiftlang/swift")!
        
        // When
        let (organization, repository) = organizationAndRepo(url) ?? ("", "")
        
        // Then
        #expect(organization == "swiftlang")
        #expect(repository == "swift")
    }
    
    @Test func organizationAndRepoWithInvalidScheme() throws {
        // Given
        let url = URL(string: "https://repo/apple/swift")!
        
        // When
        let result = organizationAndRepo(url)
        
        // Then
        #expect(result == nil)
    }
    
    @Test func organizationAndRepoWithInvalidHost() throws {
        // Given
        let url = URL(string: "sportytest://invalid/apple/swift")!
        
        // When
        let result = organizationAndRepo(url)
        
        // Then
        #expect(result == nil)
    }
    
    @Test func organizationAndRepoWithMissingRepository() throws {
        // Given
        let url = URL(string: "sportytest://repo/apple")!
        
        // When
        let result = organizationAndRepo(url)
        
        // Then
        #expect(result == nil)
    }
    
    @Test func organizationAndRepoWithOnlySchemeAndHost() throws {
        // Given
        let url = URL(string: "sportytest://repo")!
        
        // When
        let result = organizationAndRepo(url)
        
        // Then
        #expect(result == nil)
    }
    
    @Test func organizationAndRepoWithExtraPathComponents() throws {
        // Given
        let url = URL(string: "sportytest://repo/apple/swift/extra/components")!
        
        // When
        let (organization, repository) = organizationAndRepo(url) ?? ("", "")
        
        // Then
        #expect(organization == "apple")
        #expect(repository == "swift")
    }
    
    @Test func organizationAndRepoWithSpecialCharacters() throws {
        // Given
        let url = URL(string: "sportytest://repo/org-name/repo-name")!
        
        // When
        let (organization, repository) = organizationAndRepo(url) ?? ("", "")
        
        // Then
        #expect(organization == "org-name")
        #expect(repository == "repo-name")
    }
}
