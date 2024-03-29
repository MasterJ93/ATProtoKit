# ATProtoKit API Design Guidelines
## Introduction
One of the major goals of `ATProtoKit` is to create a well-written and well-documented project. Due to this, guidelines will need to be in place to ensure this standard is met. This document will provide the understanding of how to write code to improve the project. This is a living document and as such, things will change. However, they will work the same way as with the `ATProtoKit` project itself:
- Minor updates to this project should only apply to `ATProtoKit`’s minor updates.
- Major updates to this project should only apply to `ATProtoKit`’s major updates.

> [!NOTE]
> This is a living document. Please re-visit these guidelines when a new minor or major version of this project is released.

## Swift API Design Guidelines
The [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) sets the foundation for these principles. Adherence to these guidelines is strict, and should only deviate from it if it’s 100% necessary and if there’s no other logical way to get around it.


## Fundamentals
- For code, the maximum length of a line is 170 characters. However, this isn’t a strong goal to have: it can be much longer than this.
- For documentation, the maximum length of a line is also 170 characters. However, this _is_ a strict rule: if necessary, break it down into smaller lines.
- Documentation lines should use the triple slashes (`///`) rather than the multi-block delimiter (`/** */`).
- Everything in the project must be written in American English.
- All methods/functions, classes, structs, enums, and properties need to display their access keywords. The only permitted keywords used in this project are `public`, `internal`, `private`, and `fileprivate`:
	- `public` should be used for all API user-facing items.
    - `internal` should be used for any items that aren’t appropriate for the API user to use alone.
    - `fileprivate` is rare. This is only reserved for `ATProtoKit` extensions. This is so other parts of the project don’t have access to it if it should only be used for the method it’s in.
- ***Do NOT force-unwrap***. `if let` and `guard` statements must be used instead.
- As said in the Swift API Design Guidelines, don't shorten the words like with the lexicon. All structs, methods, functions, properties, and enums must especially follow this rule.
    - Abbreviations are fine, however.
    ```swift
    // Always use the full term.
    public func getRepo() // Incorrect.
    
    public func getRepository() // Correct.
    
    // Abbreviations are okay.
    pdsURL // Acceptable.
    
    finalPDSURL // Acceptable.
    
    repositoryCID // Acceptable.
    ```
- File names have some naming conventions:
    - They must be in PascalCase and can't have their words separated.
    - For Lexicon Models and Lexicon Methods (seen below):
        - Files that contain a lexicon model should be based on the lexicon that it's used for. To be more specific, the lexicon's hostname, subdomain, and action name are combined into one.
        Examples:
            - BskyActorDefs.swift
            - BskyRichTextFacet.swift
            - AtprotoSyncSubscribeRepos.swift
            - OzoneCommunicationDefs.swift
        - With respect to file names, files which contain lexicon models don't use the requirement of expanding the shortened name, as they're designed to be closely aligned with the name of the namespaced identifier.
        - Files that contain a lexicon method will be named the same as the method, albeit, in PascalCase.
            - For admin and moderator methods, the file name must have an "-AsAdmin" suffix.
- Folder names will be PascalCase, except for the folders inside the `Models/Lexicons` folder, where the namespace identifier's TLD and hostname are all lowercased.
    - Any folders in the lower level and beyond continue to use PascalCase.

## Documentation
### General
- When writing documentation, make sure it's clear, understandable, and comprehensible enough for users (both experienced and new) to understand it.
- Documentation must link to other parts of `ATProtoKit` if it’s mentioned. You surround the name with two backticks on the left and right side. (Example: ``ATProtoError``.)
- The top line must summarize what the object is doing.
- All paragraphs must be clearly separated by a line that contains `///`.
- Paragraphs should give additional context of what's happening with the object or method. This means using examples of how to use the method.
```swift
/// This is the summary line
///
/// This is a new paragraph.
```
- The are a limited number of keywords that can be used in the [symbol command syntax](https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/SymbolDocumentation.html) are as follows:
    - [`Bug`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Bug.html): Use this when there's a known bug in `ATProtoKit` or in the AT Protocol itself.
    - [`Important`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Important.html): Use this if the user requires context for the object they're going to use.
    - [`Note`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Note.html): Use this for sharing documentation directly from the AT Protocol specifications, or if the user should keep something in mind when using the object.
    - [`Parameter`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Parameter.html): Use this if there's only one parameter for the method.
    - [`Parameters`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Parameters.html): Use this if there's more than one parameter for the method.'
    - [`Returns`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Returns.html): Use this to note that the method will return. When doing so, make sure a short description is stated for what the output is. The only exception is if the method is returning a choice of multiple values.
    ```swift
    A `Result`, containing either a `[success model]` if successful, or an `ATProtoError`, if not.
    ```
    - [`SeeAlso`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/SeeAlso.html): Use this when referncing the link for the lexicon associated with the object. Reference the link by using `[\`[Lexicon NSID]\`][github]`, then create another paprgraph and link it.
    ```swift
    /// - SeeAlso: This is based on the [`com.atproto.server.activateAccount`][github] lexicon.
    /// 
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/server/activateAccount.json
    ```
    - [`Throws`](https://developer.apple.com/library/prerelease/mac/documentation/Xcode/Reference/xcode_markup_formatting_ref/Throws.html): Use this if a method can throw an error. When using this, ensure that all of the ways the method can throw are listed in bullet point form.
    - [`Warning`](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Warning.html): Use this if the user must know something, and failure to do so will cause something major to break.

## Lexicon Models
Lexicons are relevant to models and methods. Here are some general guidelines:
- Models follow the reverse DNS style of naming, but it removes the domain name and the periods. (Example: for the lexicon `app.bsky.actor.profile`, instead of naming the model as “app.bsky.actor.profile”, you name it as “ActorProfile”.)
- All models are `struct`s, with one exception:
	- If a lexicon has a `union` type, then the list of values are combined into another model, which will be of type `enum`.
- All models must conform to `Codable`, but depending on the model, it may only need to conform to either `Encodable` or `Decodable`.
- Properties that are of type `Date` must use the `@DateFormatting` property wrapper. Likewise, properties that are of type `Date?` must use the `@DateFormattingOptional` property wrapper. There are a number of things that need to be done when doing this:
	- In the initialization method, set the value of an underscored (_) version of the property name to an instance of `@DateFormatting` or `@DateFormattingOptional` (which will henceforth be named "`@DateFormatting` group”). The `wrappedValue` parameter’s should have the value of the initializer’s version of the non-underscored property:
	```swift
	self._indexedAt = DateFormatting(wrappedValue: indexedAt)
    self._indexedAt = DateFormattingOptional(wrappedValue: indexedAt)
	```
	- In the `Decodable` initializer, set the property normally, but using `@DateFormatting` group`.self` for the `type` parameter. After that, at the end of the line, add `.wrappedValue`. For `@DateFormattingOptional`, put `?` in between the method and `.wrappedValue`.
	```swift
    self.indexedAt = try container.decode(DateFormatting.self, forKey: .indexedAt).wrappedValue
    self.indexedAt = try container.decodeIfPresent(DateFormattingOptional.self, forKey: .indexedAt)?.wrappedValue
    ```swift
 	- For the `encode` method, set the underscored version of the property in the `value` parameter’s value for both `encode` and `encodeIfPresent` methods:
	```swift
    try container.encode(self._indexedAt, forKey: .indexedAt)
	try container.encodeIfPresent(self._indexedAt, forKey: .indexedAt)
    ```

There are multiple kinds of models: main models, definition models, output models, and requestBody models.

### Main Models
- Documentation for the models are as follows:
	- The first line should say “The main model definition for “, followed by a short, one sentence description of what the lexicon is for:
   ```swift
	/// The main model for getting a detailed profile view for the user.
   ```
   - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “`<#Description#>`””, where "`<#Description#>`” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
 	- After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "`<#Lexicon Type ID#>`” is the lexicon’s name, and “`<#Lexicon link#>`” is the link to the lexicon itself:
	```swift
	/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
	///
	/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
	```
- The models themselves have the following guidelines:
	- All models are `public` and must not be instead of a class or struct.

### Definition Models
- Documentation for the models are as follows:
	- The first line must be structured as "A data model definition for “, followed by a short, one sentence description of what the lexicon is for:
   ```swift
	/// A data model definition for the output of checking the user's account status.
   ```
   The requirements remain the same for the AT Protocol lexicon descriptions, the lexicon's NSID', and the GitHub link.
- For the models themselves, they have the following requirements:
	- The name of the struct is exactly the same as the with the Main model name, but the suffix is the property name within the lexicon itself, and `defs` is removed. For example, `com.atproto.admin.defs` contains a property named `modEventView`. Therefore, the name of the struct is called `AdminModEventView`.
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “`<#Description#>`””, where "`<#Description#>`” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "`<#Lexicon Type ID#>`” is the lexicon’s name, and “`<#Lexicon link#>`” is the link to the lexicon itself:
	```swift
	/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
	///
	/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
	```

### Output Models
- Documentation for the model are as follows:
    - The first line must be structured as "An output model for ", followed by a short, one sentence desctiption of what the lexicon is for:
    ```swift
    /// An output model for checking the user's account status.
    ```
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “`<#Description#>`””, where "`<#Description#>`” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "`<#Lexicon Type ID#>`” is the lexicon’s name, and “`<#Lexicon link#>`” is the link to the lexicon itself:
	```swift
	/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
	///
	/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
	```

### `requestBody` Models
- Documentation for the model are as follows:
    - The first line must be structured as "A request body model for ", followed by a short, one sentence desctiption of what the lexicon is for:
    ```swift
    /// A request body model for checking the user's account status.
    ```
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “`<#Description#>`””, where "`<#Description#>`” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "`<#Lexicon Type ID#>`” is the lexicon’s name, and “`<#Lexicon link#>`” is the link to the lexicon itself:
	```swift
	/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
	///
	/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
	```

## Model Designs
### Regular models
_TBD..._

### Lexicon models
- All models must be `public` `struct`s and should conform to `Codable`, `Decodable`, or `Encodable`.
    - If the model should only be used to be encoded or decoded, but not both, then the model must _only_ be conforming to `Encodable` or `Decodable` respectively; they can't conform to `Codable`.
- The name of the model must be the namespaced identifier's subdomain, followed by the name of the lexicon's file name, all in PascalCase. For example: `com.atproto.sync.notifyOfUpdate` becomes `SyncNotifyOfUpdate`. Furthermore, the suffix of the name depends on the type of model it is:
    - For main definition and normal definition models, there is no suffix.
    - For output models, they add the `-Output` suffix.
    - For `requestBody` models, add the `-RequestBody` suffix.
- All properties are `public`, unless the `type` property is used (`interal` is used then).
- Default properties are not allowed.
- If `@DateFormatting` and `@DateFormattingOptional` are used in at least one propery, the following must happen:
    - The property affected must be using `var` instead of `let`.
    - In the standard `init()` method, set the value of `wrappedValue` to an underscored (`_`) version of the name of the property.
    - In `init(from decoder: Decoder) throws`, attempt to to decode each `Date` property using `@DateFormatting`/`@DateFormattingOptional`'s `wrappedValue`:
    - For `CodingKeys`, only override the case if the value doesn't match the required value in the lexicon.

## Lexicon Union Designs
- All union types must be `public` `enum`s and should conform to `Codable`, `Decodable`, or `Encodable`.
- The name of the union must have the `Union` suffix.
- For documentation, It should say "A reference containing a list of " followed by the name of the list.
```swift
/// A reference containing the list of preferences.
```

## Lexicon Method Designs
### Documentation
- The first line should summarize what the method will do in one sentence.
- All paragraphs will be separated by a space.
- Any reference links will be added between the last paragraph of explanation and the group of `Parameter(s)`, `Returns`, and `Throws` values.
```swift
/// - SeeAlso: This is based on the [`com.atproto.repo.createRecord`][github] lexicon.
///
/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/repo/createRecord.json
///
/// - Parameters:
/// [...]
```
- The documentation parameter associated with the method parameter must only have one sentence. There are exceptions:
    - If the method parameter's data type is optional, then the word "Optional." Will be added to the documentation parameter's explanation.
    ```swift
    ///   - sources: An array of decentralized identifiers (DIDs) for label sources. Optional.
    ```
    - If the method parameter has a default value, then the the following will be added as an addition sentence: "Defaults to `[value]`", where `[value]` is the default value.

### Lexicon Methods
- All methods must be inside an `extension` for `ATProtoKit`, unless it's related to adminstration or moderation, in which case, it needs to be inside the `extension` of `ATProtoAdmin`.
- The method's name must be the name of the namespaced identifier of the lexicon, if the TLD, doman, and subdomain was removed.
    - If there's a conflict (there's more than one method with the same name in a class), the sub-domain will be addedin a way that somewhat makes grammatical sense at least. For example: `getRepositoryRecord()` and `getSyncRecord()`.
- The list of parameters should be inline with the lexicon's parameter list. Any additional parameters that need to be added should be at the end.
    - The only exception to this rule is if there's an order that makes more sense and is in alignment with the Swift API Deisgn Guideline's "Strive for Fluent Usage" guidelines.
- There are three types of lexicon methods: methods where authentication is required (will henceforth be called "AuthRequired"), methods where authentication is optional (will henceforth be called "AuthOptional"), and methods where authentication is not used (will henceforth be called "AuthUnneeded").
- For AuthUnneeded lexicon methods:
    - An additional parameter is added at the end: `pdsURL.
        - `pdsURL` is a `String?` parameter and defaults to `nil`. This is used for if the method call needs to use a Personal Data Server other than the one attached to the `UserSession` instance.
- For AuthOptional lexicon methods:
    - Two additional parameters are added at the end: `pdsURL` and `shouldAuthenticate`.
        - `pdsURL` is a `String?` parameter and defaults to `nil`. This is used for if the method call needs to use a Personal Data Server other than the one attached to the `UserSession` instance.
        - `shouldAuthenticate` is a `Bool` parameter and defaults to `false`. This is used for is the method call wants the access token to be part of the request payload.
- If the method is AuthRequired, use a `guard` statement. In it, `session` must not be `nil`, and a variable `accessToken` will have the value `session?.accessToken. In the `else` block, the method will either `return` a `.failure` case containing `ATRequestPrepareError.missingActiveSession` (if the method returns either a response or error) or `throw`s `ATRequestPrepareError.missingActiveSession` (if the method only throws errors).
```swift
guard session != nil,
      let accessToken = session?.accessToken else {
        return .failure(ATRequestPrepareError.missingActiveSession)
}
```
- There must be a `guard` statement.
    - `sessionURL` defines the Personal Data Server's hostname.
        - For AuthOptional, a terniary operator is used: `pdsURL` is set to the method parameter version of `pdsURL` (if it's not `nil`), or `session?.pdsURL` if `pdsURL` is `nil`).
        ```swift
        guard let pdsURL != nil ? pdsURL : session?.pdsURL,
        ```
    - `requestURL` combines `sessionURL` and the endpoint, which, after `sessionURL` contains "xrpc/" followed by the namespaced identifier of the lexicon.
    - Depending on whether the lexicon method can `return` a response/error or just `throw` an error, the `else` block will either `throw` `ATRequestPrepareError.missingActiveSession` (if the method only throws errors) or `return`s a `.failure()` enum of `ATRequestPrepareError.missingActiveSession` (if it can `return` a response or error).
    ```swift
    guard let sessionURL = session?.pdsURL,
          let requestURL = URL(string: "\(sessionURL)/xrpc/com.atproto.repo.createRecord") else {
        return .failure(ATRequestPrepareError.invalidRequestURL)
    }
    ```
- If the method uses a request body:
    - Call the variable `requestBody`, while using the value of the `requestBody` model associated with the method.
    - All of the parameters of the model must be in separate lines. The closing paranthesis must also have a separate line.
    Example:
    ```swift
    let requestBody = RepoCreateRecord(
            repositoryDID: repositoryDID,
            collection: collection,
            recordKey: recordKey,
            shouldValidate: shouldValidate,
            record: record,
            swapCommit: swapCommit
    )
    ```
- If the method uses a query:
    - Create a variable (named `queryItems`) and set the value of `[(String, String)]()`.
    ```swift
    var queryItems = [(String, String)]()
    ```
    - For each query item:
        - Append `queryItems` with `(String, String)`, where the first `String` contains the real query variable the lexicon specifies, and the second `String` contains the parameter associated with the query item.
        ```swift
        queryItems.append(("q", query))
        ```
        - If the query is optional, use an `if let` statement.
        ```swift
        if let cursor {
            queryItems.append(("cursor", cursor))
        }
        ```
        - If the query is an array, use `Array.map()` to loop through all elements. The element will be denoted by `$0`.
        ```swift
        queryItems += uriPatterns.map { ("uriPatterns", $0) }
        ``` 
        - If the query is related to a date, then an `if let` statement will be used to unwrap the variable Use `CustomDateFormatter` to convert the `Date` object to an ISO8601 format. After that, the standard rules apply.
        ```swift
        if let createdAfterDate = createdAfter, let formattedCreatedAfter = CustomDateFormatter.shared.string(from: createdAfterDate) {
            queryItems.append(("createdAfter", formattedCreatedAfter))
        }
        ```
        - If the query is `limit`, grab the `limit` parameter and put it inside of `min(x, y)`, where `x` is `limit` and `y` is the highest number the lexicon allows for the property. Then put `min()` inside of `max(x, y)`, where `x` is the lowest number the lexicon allows for the property and `y` is the `min()` function. This will be the value for `finalLimit`, which will be used for value of the second `String` of the query item.
        ```swift
        if let limit {
            let finalLimit = max(1, min(limit, 100))
            queryItems.append(("limit", "\(finalLimit)"))
        }
        ```
    - Create a `queryURL` variable of type `URL`. Don't add a value to it.
    ```swift
    let queryURL: URL
    ```
    - Inside the `do` block, set the value of `queryURL` to `APIClientService.setQueryItems()`, inserting `requestURL` and `queryItems` respectively. Each parameter, and the closing paranthesis, must have a separate line.
    ```swift
    do {
    queryURL = try APIClientService.setQueryItems(
                for: requestURL,
                with: queryItems
    )
    ```
## Logging
_TBD..._

## Uncategorized
- For methods using `APIClientService`:
    - Each parameter in `createRequest()` and `sendRequest()` must be separated in each line, unless there is only one parameter being used.
    - If `createRequest()` and `sendRequest()` are the only ones in the `do-catch` block, separate them with a space; `createRequest()` must be the first line in the `do` block, followed by a space. `sendRequest()` must be at the last line of the `do` block.
    ```swift
    do {
        let request = APIClientService.createRequest(forRequest: queryURL,
                                                         andMethod: .post,
                                                         acceptValue: "application/json",
                                                         contentTypeValue: nil,
                                                         authorizationValue: accessToken)
        try await APIClientService.sendRequest(request,
                                               decodeTo: LabelQueryLabelsOutput.self)
    }
    ```
        - If there’s a `return` statement in the `do-catch` block, or if the query method is in there, the request and response methods should be beside each other.
        - If any additional method calls are being made, put them beside `createRequest()` and `sendRequest()` if they're strongly related to them.
        
