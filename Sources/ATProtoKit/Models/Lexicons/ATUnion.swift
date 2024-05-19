//
//  ATUnion.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-19.
//

import Foundation

/// An object that lists all of the union types for each of the lexicons.
public struct ATUnion {
    
    /// A reference containing the list of message embeds.
    public enum MessageEmbedUnion: Codable {
        case record(AppBskyLexicon.Embed.RecordDefinition)
    }

    /// A reference containing the list of messages.
    public enum MessageViewUnion: Codable {
        case messageView(ChatBskyLexicon.Conversation.MessageView)
        case deletedMessageView(ChatBskyLexicon.Conversation.DeleteMessageView)
    }

    /// A reference containing the list of message logs.
    public enum MessageLogsUnion: Codable {
        case logBeginConversation(ChatBskyLexicon.Conversation.LogBeginConversation)
        case logLeaveConversation(ChatBskyLexicon.Conversation.LogLeaveConversation)
        case logCreateMessage(ChatBskyLexicon.Conversation.LogCreateMessage)
        case logDeleteMessage(ChatBskyLexicon.Conversation.LogDeleteMessage)
    }

    
}
