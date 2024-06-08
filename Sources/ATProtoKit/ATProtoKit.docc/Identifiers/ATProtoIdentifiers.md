# Identifying and Validating Identifiers and Schemes

Find out the requirements for each identifier within the AT Protocol.

## Overview

These identifiers and schemes (we'll call them "identifiers" for short) are part of what makes the AT Protocol work. Not only is validation within the scope of best practices with respect to Swift, but it'll help to reduce less potenital bugs and errors.

## Validation

Regardless of the manager struct you're using, you'll be able to find a `validate()` method within them. This is the quickest way to determine whether the identifier is valid. If the method doesn't respond, then it means the identifier is valid. Otherwise, an error would occur.

```swift
do {
    try HandleManager.validate(bsky.social)
    // If no errors are made, then the handle is valid.
} catch {
    return error
}
```

## Identifier Requirements
Each identifier has various requirements in order to be valid. A short list for each will be available below, but it's highly encouraged to read the [AT Protocol Specifications](https://atproto.com) for more information.

### AT URI


Further reading: [AT URI Syntax](https://atproto.com/specs/at-uri-scheme)

### Content Identifier (CID)


Further reading: [IPFS Docs: Content Identifiers](https://docs.ipfs.tech/concepts/content-addressing/#identifier-formats)

### Decentralized Identifier (DID)

Decentralized Identifiers (DIDs) have two sets of requirements: the ones defined by the [W3C](https://www.w3.org/TR/did-core/#did-syntax) and the ones defined in the AT Protocol.

For the W3C:
- The entire URI must be ASCII. This includes:
  - Letters and digits (both uppercase and lowercase).
  - Periods (.).
  - Underscores (\_).
  - Colons (:).
  - Percentage signs (%).
  - Hypens (-).
- The first segment must be `did:`. It must all be lowercased.
- The second segment (the method) should have at least one lowercased letter, followed by a colon (:).
- The final segment can be of any allowed characters, except for the colon (:).
- Multiple colons (:) can be included without spaces.
- The pencentage sign (%) is only used for percent encoding and must be followed up with two hexidecimal characters. It can't end with a percentage sign (%).
- Queries ("?") and fragments ("#") are defined for "DID URIs", but are not part of the identifier itself.
- The current specification does not impose a maximum length for a DID.

- Note: ``DIDManager`` can normalize the the DID to ensure the first segment is lowercased.

In addition, the AT Protocol makes the following requirements:
- `did:plc` and `did:web` are currently the only two types that are valid. This is not enforced at the lexicon layer.
- A hard limit of 8 KB is put in place.

- Note: ``DIDManager`` can't validate percent encoding at this time.

Further reading: [DID Syntax](https://atproto.com/specs/did)

### Handle

Handles in the AT Protocol must conform to the following rules to be valid:
- The handle should be a valid domain name as per the RFC standards (e.g.: RFC-3696 (Section 2), RFC-3986 (Section 3)).
- Each segment of a handle can only include letters and digits from the ASCII standard, as well as hypens (-).
  - They can't begin or end with a hypen.
  - The last segment (the TLD; e.g.: .com, .net, .social, etc.) shouldn't start with a digit.
  - The TLD (last component) must not start with a digit.
  - Must not contain whitespace, null bytes, or joining characters.
  - Punycode is allowed for internationalized domain names.
- The length requirements include:
  - Between 1 to 63 characters for each segment (excluding periods).
  - Between 1 and 253 characters in total (including periods).
- Each segment is separated by ASCII periods and can't start or end with a period.
- Handles are case-insensitive, so it doesn't matter whether the letter is capitalized or not.

``HandleManager`` can check if you're using an invalid TLD by using ``HandleManager/isValidTLD(handle:)``.

- Important: ATProtoKit won't be able to check for punycode domains at this time.

Futher reading: [Handle Syntax](https://atproto.com/specs/handle)

### Namespaced Identifier (NSID)

Namespaced Identifiers (NSIDs) have specific requirements: rules for the overall identifier, and rules for each segment.

**Overall**
- All characters must be in ASCII.
- All segments should be separated by an ASCII period (.).
- There's a minimum of three segments: the TLD, the domain name (which, combined, are referred as the "Domain Authority"), and the name (otherwise called the "subdomain").
- The NSID can't be over 317 characters.

**Domain Authority**
- Consists of the TLD and domain name, separated by a period (.).
- Can't be longer than 253 characters.
- Each segment can be between 1 and 63 characters long (excluding periods).
- Allowed characters are ASCII letters (only lowercased), digits (0-9), and hyphens (-).
- Segments can't start or end with a hyphen (-).
- The first segment (the TLD) cannot start with a numeric digit.
- The domain authority is _not_ case-sensitive. Be sure to normalize all letters to lowercase.

**Name**
- Must be between 1 and 63 characters long.
- Can be in ASCII letters (both uppercase and lowercase).
- The name _is_ case-sensitive. Do not normalize them.

- Note: ``NSIDManager`` can help to automatically normalize the domain authority segments while leaving the name segment alone.

Further reading: [NSID Syntax](https://atproto.com/specs/nsid)

### Record Key

Record Keys have various types: `tid`, `any`, and `literal:<value>`. All Record Keys need to conform to the following:
- All characters include letters (both uppercase and lowercase), digits, periods (.), hypens (-), underscores (\_), colons (:), and tildes (~).
- Must be at least 1 character and at most 512 characters long.
- Record Keys can _not_ be _just_ `.` or `..`.
- Must be a permissible part of a repository MST path string.
- Must be valid as a path component of a URI, adhering to RFC-3986, section 3.3. These constraints align with the "unreserved" characters allowed in generic URI paths.
- Record Keys are case-sensitive.

The above requirements satisfies the requirements for the `any` Record Key.

In addition to this, each type has additional requirements.

**`tid`**

- Represented as a 64-bit integer. More specifically:
  - The top bit is always set to `0`.
    - The next 53 bits represent the number of microseconds since the UNIX epoch. This choice of 53 bits ensures maximum safe integer precision in 64-bit floating point numbers, as used in JavaScript.
    - The final 10 bits are a random "clock identifier."
- Uses big-endian byte ordering.
- Encoded as base32-sortable, specifically using the characters `234567abcdefghijklmnopqrstuvwxyz`.
- Special padding (such as using the equals sign (=)) are used, and all digits are encoded, resulting in a fixed length of 13 ASCII characters. For example, the TID corresponding to the integer zero is `2222222222222`.
- The use of hypens (-) shouldn't be used for a `tid` Record Key.

**`literal:<value>`**

Record Key type is used when there should be only a single record in the collection, with a fixed, well-known Record Key.



Further reading: [Record Key Syntax](https://atproto.com/specs/record-key)


## Topics

### AT URIs



### Content Identifiers (CIDs)



### Decentralized Identifiers (DIDs)
- ``DIDManager``

### Handles
- ``HandleManager``

### Namespaced Identifiers (NSIDs)
- ``NSIDManager``

### Record Keys
- ``RecordKeyManager``
