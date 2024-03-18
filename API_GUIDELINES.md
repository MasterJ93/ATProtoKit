# ATProtoKit API Design Guidelines
## Introduction
One of the major goals of `ATProtoKit` is to create a well-written and well-documented project. Due to this, guidelines will need to be in place to ensure this standard is met. This document will provide the understanding of how to write code to improve the project. This is a living document and as such, things will change. However, they will work the same way as with the `ATProtoKit` project itself:
- Minor updates to this project should only apply to `ATProtoKit`’s minor updates.
- Major updates to this project should only apply to `ATProtoKit`’s major updates.

## Swift API Design Guidelines
The [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) sets the foundation of these guidelines. These guidelines follow the parent guidelines pretty much strictly, and should only deviate from it if it’s 100% necessary and if there’s no other logical way to get around it.

## Fundamentals
- For code, the maximum length of a line is 170 characters. However, this isn’t a strong goal to have: it can be much longer than this.
- For documentation, the maximum length of a line is also 170 characters. However, this _is_ a strict rule: if you need to break it down into multiple lines, then that’s fine.
- Documentation lines should use the triple slashes (`///`) rather than the multi-block delimiter (`/** */`).
- Everything in the project must be written in American English.

## Lexicons
Lexicons are JSON-formatted schemas used as a mediator between the client and the AT Protocol. It states what inputs and outputs it needs and the client will build itself to satisfy the requirements. For `ATProtoKit`, it’s extremely important to follow the requirements, but it has its own way to do this.

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
	/// The main model definition for getting a detailed profile view for the user.
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
    where: "<#Lexicon Type ID#>” is the lexicon’s name, and “<#Lexicon link#” is the link to the lexicon itself:
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
   The requirements remain the same for the AT Protocol lexicon descriptions, the lexicon type ID, and the GitHub link.
- For the models themselves, they have the following requirements:
	- The name of the struct is exactly the same as the with the Main model name, but the suffix is the property name within the lexicon itself, and `defs` is removed. For example, `com.atproto.admin.defs` contains a property named `modEventView`. Therefore, the name of the struct is called `AdminModEventView`.
    - 

### Output Models


### `requestBody` Models

## Uncategorized
- When writing documentation, make sure it's clear, understandable, and comprehensible enough for users (both experienced and new) to understand it.
- If you're creating a method in `ATProtoKit`'s class and authentication is either not required or optional, it must be a `static` method. Otherwise, it must be an instance method.
- All methods/functions, classes, structs, enums, and properties need to display their access keywords. The only permitted keywords used in this project are `public`, `internal`, `private`, and `fileprivate`:
	- `public` should be used for all API user-facing items.
    - `internal` should be used for any items that aren’t appropriate for the API user to use alone.
    - `fileprivate` is rare. This is only reserved for `ATProtoKit` extensions. This is so other parts of the project don’t have access to it if it should only be used for the method it’s in.
- Documentation must link to other parts of `ATProtoKit` if it’s mentioned. You surround the name with two backticks on the left and right side. (Example: ``ATProtoError``.)
- For methods using `APIClientService`:
    - Each parameter must be separated in each line.
    - If the request and response are the only ones in the `do-catch` block, separate them with a space.
    - If there’s a `return` statement in the `do-catch` block, or if the query method is in there, the request and response methods should be beside each other.
