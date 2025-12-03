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

B: Add UI to request the repos for a different user.
- Decided on a header view so it would scroll with the content as the the user views the list of repos.
- Copilot generated initial files and manually adapted.
- After testing, added an alert for errors and a red border on the organization textInput, so there is some UI feedback, and I didn't insist more on handling errors (eg. selective error for organization without repos).

