# @DateFormatting

Convert dates to and from the ISO8601 format.

@Metadata {
    @PageColor(blue)
}

## Overview

AT Protocol requires that dates must be formatted in the ISO8601 format. ATProtoKit gives you the tools to convert from `Date` to ISO8601 formatted dates and vice versa with the ``ATProtoKit/DateFormatting`` and ``ATProtoKit/DateFormattingOptional`` property wrappers.

To use them, simply attached the property wrapper onto a property that's of type `Date` or `Date?`:
```swift
@DateFormatting public var createdAt: Date
@DateFormattingOptional public var createdAt: Date?
```

Naturally, ``ATProtoKit/DateFormatting`` works only for `Date`, while ``ATProtoKit/DateFormattingOptional`` is for `Date?`.

> Note: In a future update of ATProtoKit, both of these property wrappers will be merged into one, single `@DateFormatting` property wrapper.

When adding the property wrapper, make sure the property itself is mutable. Failure to do so while cause the build to fail.

## Property Wrappers

- ``ATProtoKit/DateFormatting``
- ``ATProtoKit/DateFormattingOptional``
