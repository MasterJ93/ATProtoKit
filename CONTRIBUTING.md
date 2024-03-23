# Contribution Guidelines
## Introduction

Thanks for your interest in contributing to `ATProtoKit`. This project aims to be a leading Swift API library for the AT Protocol and Bluesky and as a go-to choice for Swift developers to build projects for iOS, iPadOS, macOS, tvOS, watchOS, visionOS, and Linux.

## How to Contribute
Contributions to ATProtoKit are welcomed and appreciated. Here are the areas where you can help:
- Code Contributions, such as bug fixes, tweaking the models and methods to fit the latest lexicon changes, and improvements in the efficiency of the library itself.
- Documentation, which includes things such as sourcing the latest documentation from the AT Protocol Specifications, documenting every part of the project, and improving the DocC (creating tutorials, building articles, and making sure things are properly grouped together and organized).
- Testing, which generally means making sure the project can build, run, and work on Apple’s platforms and Linux.

## Contribution Process
### Setting Up Your Environment
Fork the `ATProtoKit` repository and open the project with your IDE of choice.

### Making Changes
For new features and improvements, put these changes into the `develop` branch. If you’re fixing a bug, then it should be in `main`. Be sure to fill out the Pull Request form before sending in a pull request.

### Code Style
Please adhere to the coding standards in the [ATProtoKit API Design Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/API_GUIDELINES.md) as well as the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/). Make sure anything related to asynchronous tasks should be using Swift Concurrency. Later on, `swiftlint` will be used to help with some of these guidelines.

### Documentation
Make sure that all methods, functions, properties, enums, protocols, variables, parameters, and other elements are well-documented and understood. However, please don’t make it overly long: it should be concise and straightforward. There will be opportunities to have a large documentation header, in which case, this should explain important information on the object being used, complete with examples and notes if needed.

### Submitting Your Contribution
Make sure your commits are small and focused. While this isn’t an extremely strict rule, please try to adhere to the [Git commit best practices](https://cbea.ms/git-commit/).

### Submit Your Pull Request
Prefix your pull request title with one of the following:
- “[Feature]” for any new features.
- “[Documentation]” for any documentation changes.
- “[Bug Fix]” for any bug fixes.

Please create a feature request issue before creating a Pull Request. This will allow for potential discussion so that everyone is in the same page. When it’s been approved, you can add the Pull Request with the applicable code. Please make the pull request to be targeted to `develop`, not `main`.

### Code Review
Once submitted, you pull request will be reviewed. Engage with any feedback provided as soon as you can to ensure your contribution meets the project’s standards.

### Automated Checks
Later on, a working version of an automated check will happen upon submitting a pull request. This will check to make sure it’s able to build on the latest version of macOS, iOS, and Ubuntu Linux. When the GitHub Action is working, having your code pass all of the tests will be required.

## Community Standards
This project adopts the [Contributor Covenant Code of Conduct]() to make sure everyone can participate in a welcoming environment. Any form of harassment is not tolerated. Please take a moment to read it when you can.

## Need Help?
If you have any questions or assistance, I’m available at the following places:
- Bluesky [@cjrriley.com](https://bsky.app/profile/cjrriley.com)
- I’m active in the [Bluesky API Touchers Discord server](https://discord.gg/3srmDsHSZJ) as well.
- I’m available for you to email at [chrisjr@cjrriley.com](mailto:chrisjr@cjrriley.com).

---

Your interest, assistance, and feedback help to make `ATProtoKit` a better API library. Thank you very much for your support.
