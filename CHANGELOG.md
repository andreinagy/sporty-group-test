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