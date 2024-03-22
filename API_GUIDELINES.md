# ATProtoKit API Design Guidelines
## Introduction
One of the major goals of `ATProtoKit` is to create a well-written and well-documented project. Due to this, guidelines will need to be in place to ensure this standard is met. This document will provide the understanding of how to write code to improve the project. This is a living document and as such, things will change. However, they will work the same way as with the `ATProtoKit` project itself:
- Minor updates to this project should only apply to `ATProtoKit`’s minor updates.
- Major updates to this project should only apply to `ATProtoKit`’s major updates.

## Swift API Design Guidelines
The [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) sets the foundation of these guidelines. These guidelines follow the parent guidelines fairly strictly, and should only deviate from it if it’s 100% necessary and if there’s no other logical way to get around it.

## Fundamentals
- For code, the maximum length of a line is 170 characters. However, this isn’t a strong goal to have: it can be much longer than this.
- For documentation, the maximum length of a line is also 170 characters. However, this _is_ a strict rule: if you need to break it down into multiple lines, then that’s fine.
- Documentation lines should use the triple slashes (`///`) rather than the multi-block delimiter (`/** */`).
- Everything in the project must be written in American English.

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
- All models are structs, with one exception:
	- If a lexicon has a `union` type, then the list of values are combined into another model, which will be of type `enum`.
  	  - For these models, they will have the `Union` suffix. (Example: `PreferenceUnion`.)
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
   - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “<#Description#>””, where "<#Description#>” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
 	- After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "<#Lexicon Type ID#>” is the lexicon’s name, and “<#Lexicon link#>” is the link to the lexicon itself:
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
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “<#Description#>””, where "<#Description#>” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "<#Lexicon Type ID#>” is the lexicon’s name, and “<#Lexicon link#>” is the link to the lexicon itself:
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
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “<#Description#>””, where "<#Description#>” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "<#Lexicon Type ID#>” is the lexicon’s name, and “<#Lexicon link#>” is the link to the lexicon itself:
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
    - After an empty `///` in the next line, the following line has the description that’s provided by the lexicon. If there’s no description, then this can be skipped. If there is one, it must say "- Note: According to the AT Protocol specifications: “<#Description#>””, where "<#Description#>” is the description provided by the lexicon:
	```swift
	/// - Note: According to the AT Protocol specifications: "Get detailed profile view of an actor. Does not require auth, but contains relevant metadata with auth."
    ```
    - After another empty `///` in the next line, the following line states where the API user can see the name of the lexicon, followed by the link. The structure must look like this:
    ```swift
	/// - SeeAlso: This is based on the [`<#Lexicon Type ID#>`][github] lexicon.
	///
	/// [github]: <#Lexicon link#>
    ```
    where: "<#Lexicon Type ID#>” is the lexicon’s name, and “<#Lexicon link#>” is the link to the lexicon itself:
	```swift
	/// - SeeAlso: This is based on the [`app.bsky.actor.getProfile`][github] lexicon.
	///
	/// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/app/bsky/actor/getProfile.json
	```

## Model Design
### Regular models


### Lexicon models
- All models must be `public` `struct`s.
- The name of the model must be the namespaced identifier's subdomain, followed by the name of the lexicon's file name, all in PascalCase. For example: `com.atproto.sync.notifyOfUpdate` becomes `SyncNotifyOfUpdate`. Furthermore, the suffix of the name depends on the type of model it is:
    - For main definition and normal definition models, there is no suffix.
    - For output models, they add the `-Output` suffix.
    - For `requestBody` models, add the `-RequestBody` suffix.
- All properties are `public`, unless the `type` property is used (`interal` is used then).
- Default properties are not allowed.
- If `@DateFormatting` and `@DateFormattingOptional` are used in at least one propery, the following must happen:
    - The property affected must be using `var` instead of `let`.
    - In the standard `init()` method, set the value of `wrappedValue` to an underscored (`_`) version of the name of the property.
    - In `init(from decoder: Decoder) throws`, attempt to to decode each `Date` property using `@DateFormatting`/`@DateFormattingOptional's `wrappedValue`:
    - For `CodingKeys`, only override the case if the value doesn't match the required value in the lexicon.

## Uncategorized
- All methods/functions, classes, structs, enums, and properties need to display their access keywords. The only permitted keywords used in this project are `public`, `internal`, `private`, and `fileprivate`:
	- `public` should be used for all API user-facing items.
    - `internal` should be used for any items that aren’t appropriate for the API user to use alone.
    - `fileprivate` is rare. This is only reserved for `ATProtoKit` extensions. This is so other parts of the project don’t have access to it if it should only be used for the method it’s in.
- For methods using `APIClientService`:
    - Each parameter must be separated in each line.
    - If the request and response are the only ones in the `do-catch` block, separate them with a space.
    - If there’s a `return` statement in the `do-catch` block, or if the query method is in there, the request and response methods should be beside each other.
