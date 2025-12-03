# Changelog

E: Implement pull-to-refresh.
- Classical implementation of pull to refresh.

D: Implement deep links to a specific repo.
- Implemented deep links such as `sportytest://repo/swiftlang/swift`
- Tested the app being closed or another details being visible to illustrate an approach to a real task.
- Moved URL parsing in `func organizationAndRepo(_ url: URL) -> (String, String)?` so it's testable.
- AI Generated unit tests.

G: Implement real-time updates of the star count using the provided `MockLiveServer`.
- Added live uptates to the cell.
- Added live updates to the repo details view.

C: Refactor the `ReposViewController` to use an architecture of your choosing.
- Copilot assisted refactor to MVVM followed by manual cleanup.
- In practice I would suggest converting UIKit files to SwiftUI if there is budget for it so that the code base would eventually become uniform.

B: Add UI to request the repos for a different user.
- Decided on a header view so it would scroll with the content as the the user views the list of repos.
- Copilot generated initial files and manually adapted.
- After testing, added an alert for errors and a red border on the organization textInput, so there is some UI feedback, and I didn't insist more on handling errors (eg. selective error for organization without repos).

A: Add UI to store the authorisation token used to access the GitHub API.
- Copilot generated View and Keychain wrapper. Removed singleton and adapted to have dependency injection.
- Added GithubAPIWrapper. I suppose this is a 3rd party library which I can't edit and we need to work around it's limitations until they provide a fixed version.
    - The working assumption is that there is no issue with using the GithubAPI models.
- GithubAPIWrapper and KeychainWrapper could be absttracted wtih protocols if it would be useful to unit test code relying on them.

F: Modify `RepositoryTableViewCell` to modify its layout when the title and star count cannot fit on a single line.
- I think the purpose of the test is more than just allow multiple lines in the title label, in real projects I would advise against doing conditional layout because of aestetic integrity.
- For the purpose of showing constraints manipulation, I think the cases would be stars inline with the text and stars under the text.
- Moved the name, stars image and stars text to a separate view so it can be easier to maintain.
- Implemented with Copilot boilerplate and manual adaptation.