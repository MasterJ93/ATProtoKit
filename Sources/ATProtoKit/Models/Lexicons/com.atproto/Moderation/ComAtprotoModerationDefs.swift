//
//  ComAtprotoModerationDefs.swift
//
//
//  Created by Christopher Jr Riley on 2024-05-20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ComAtprotoLexicon.Moderation {

    /// A definition model for the types of reasons for the report.
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/defs.json
    public enum ReasonTypeDefinition: String, Sendable, Codable {

        /// Indicates spam as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Spam: frequent unwanted
        /// promotion, replies, mentions."
        case spam = "reasonSpam"

        /// Indicates a rule violation as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Direct violation of server rules,
        /// laws, terms of service."
        case violation = "reasonViolation"

        /// Indicates misleading content as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Misleading identity,
        /// affiliation, or content."
        case misleading = "reasonMisleading"

        /// Indicates mislabeled/unwanted sexual content as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Unwanted or mislabeled
        /// sexual content."
        case sexual = "reasonSexual"

        /// Indicates rude behavior as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Rude, harassing, explicit, or
        /// otherwise unwelcoming behavior."
        case rude = "reasonRude"

        /// Indicates a reason not otherwise specified.
        ///
        /// - Note: According to the AT Protocol specifications: "Other: reports not falling under
        /// another report category."
        case other = "reasonOther"

        /// Indicates an appeal to a previous moderation ruling as the reason.
        ///
        /// - Note: According to the AT Protocol specifications: "Appeal: appeal a previously taken
        /// moderation action."
        case appeal = "reasonAppeal"

        /// Indicates an appeal to a previous moderation ruling as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Appeal: appeal a previously taken
        /// moderation action."
        case reasonAppeal = "tools.ozone.report.defs#reasonAppeal"

        /// Indicates a reason not otherwise specified (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other: reports not falling under
        /// another report category."
        case reasonOther = "tools.ozone.report.defs#reasonOther"

        /// Indicates animal welfare concerns as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Animal welfare: violence or
        /// cruelty against animals."
        case reasonViolenceAnimal = "tools.ozone.report.defs#reasonViolenceAnimal"

        /// Indicates threats or incitement to violence as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Threats or incitement to
        /// violence."
        case reasonViolenceThreats = "tools.ozone.report.defs#reasonViolenceThreats"

        /// Indicates graphic violent content as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Graphic violent content:
        /// disturbing or gory images or videos."
        case reasonViolenceGraphicContent = "tools.ozone.report.defs#reasonViolenceGraphicContent"

        /// Indicates glorification of violence as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Glorification of violence:
        /// content that celebrates or promotes violent acts."
        case reasonViolenceGlorification = "tools.ozone.report.defs#reasonViolenceGlorification"

        /// Indicates extremist content as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Extremist content: material
        /// promoting or produced by extremist groups."
        case reasonViolenceExtremistContent = "tools.ozone.report.defs#reasonViolenceExtremistContent"

        /// Indicates human trafficking as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Human trafficking: content
        /// facilitating or promoting the trafficking of persons."
        case reasonViolenceTrafficking = "tools.ozone.report.defs#reasonViolenceTrafficking"

        /// Indicates violent content not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other violent content not covered
        /// by more specific categories."
        case reasonViolenceOther = "tools.ozone.report.defs#reasonViolenceOther"

        /// Indicates adult sexual abuse content as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Adult sexual abuse content."
        case reasonSexualAbuseContent = "tools.ozone.report.defs#reasonSexualAbuseContent"

        /// Indicates non-consensual intimate imagery (NCII) as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Non-consensual intimate imagery
        /// (NCII): sharing intimate images without the subject's consent."
        case reasonSexualNCII = "tools.ozone.report.defs#reasonSexualNCII"

        /// Indicates a sexual deepfake as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Deepfake adult content:
        /// AI-generated or manipulated sexual imagery."
        case reasonSexualDeepfake = "tools.ozone.report.defs#reasonSexualDeepfake"

        /// Indicates sexual content involving animals as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Animal sexual abuse: sexual
        /// content involving animals."
        case reasonSexualAnimal = "tools.ozone.report.defs#reasonSexualAnimal"

        /// Indicates unlabeled adult content as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Unlabeled adult content: explicit
        /// material posted without appropriate content labels."
        case reasonSexualUnlabeled = "tools.ozone.report.defs#reasonSexualUnlabeled"

        /// Indicates sexual content not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other sexual content not covered
        /// by more specific categories."
        case reasonSexualOther = "tools.ozone.report.defs#reasonSexualOther"

        /// Indicates child sexual abuse material (CSAM) as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Child Sexual Abuse Material
        /// (CSAM)."
        case reasonChildSafetyCSAM = "tools.ozone.report.defs#reasonChildSafetyCSAM"

        /// Indicates grooming or predatory behavior targeting minors as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Grooming or predatory behavior
        /// targeting minors."
        case reasonChildSafetyGroom = "tools.ozone.report.defs#reasonChildSafetyGroom"

        /// Indicates a privacy violation involving a minor as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Privacy violation of a minor:
        /// exposing a child's personal information without consent."
        case reasonChildSafetyPrivacy = "tools.ozone.report.defs#reasonChildSafetyPrivacy"

        /// Indicates harassment or bullying of a minor as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Minor harassment or bullying."
        case reasonChildSafetyHarassment = "tools.ozone.report.defs#reasonChildSafetyHarassment"

        /// Indicates a child safety concern not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other child safety concern not
        /// covered by more specific categories."
        case reasonChildSafetyOther = "tools.ozone.report.defs#reasonChildSafetyOther"

        /// Indicates trolling as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Trolling: disruptive or
        /// provocative behavior intended to upset others."
        case reasonHarassmentTroll = "tools.ozone.report.defs#reasonHarassmentTroll"

        /// Indicates targeted harassment as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Targeted harassment: sustained
        /// abusive behavior directed at a specific individual."
        case reasonHarassmentTargeted = "tools.ozone.report.defs#reasonHarassmentTargeted"

        /// Indicates hate speech as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Hate speech: content attacking
        /// individuals or groups based on protected characteristics."
        case reasonHarassmentHateSpeech = "tools.ozone.report.defs#reasonHarassmentHateSpeech"

        /// Indicates doxxing as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Doxxing: publishing private or
        /// personal information without the subject's consent."
        case reasonHarassmentDoxxing = "tools.ozone.report.defs#reasonHarassmentDoxxing"

        /// Indicates harassing or hateful content not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other harassing or hateful
        /// content not covered by more specific categories."
        case reasonHarassmentOther = "tools.ozone.report.defs#reasonHarassmentOther"

        /// Indicates a fake account or bot as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Fake account or bot: inauthentic
        /// account that is automated or misrepresents its identity."
        case reasonMisleadingBot = "tools.ozone.report.defs#reasonMisleadingBot"

        /// Indicates impersonation as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Impersonation: falsely claiming
        /// to be another person or entity."
        case reasonMisleadingImpersonation = "tools.ozone.report.defs#reasonMisleadingImpersonation"

        /// Indicates misleading spam as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Spam: frequent unwanted
        /// promotion, replies, or mentions."
        case reasonMisleadingSpam = "tools.ozone.report.defs#reasonMisleadingSpam"

        /// Indicates a scam as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Scam: deceptive content intended
        /// to defraud users."
        case reasonMisleadingScam = "tools.ozone.report.defs#reasonMisleadingScam"

        /// Indicates false information about elections as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "False information about elections:
        /// misleading content related to electoral processes or voting."
        case reasonMisleadingElections = "tools.ozone.report.defs#reasonMisleadingElections"

        /// Indicates misleading content not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other misleading content not
        /// covered by more specific categories."
        case reasonMisleadingOther = "tools.ozone.report.defs#reasonMisleadingOther"

        /// Indicates a site security violation as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Site security violation: hacking,
        /// phishing, or other attacks on the network or its users."
        case reasonRuleSiteSecurity = "tools.ozone.report.defs#reasonRuleSiteSecurity"

        /// Indicates the promotion or sale of prohibited items or services as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Promoting or selling prohibited
        /// items or services."
        case reasonRuleProhibitedSales = "tools.ozone.report.defs#reasonRuleProhibitedSales"

        /// Indicates ban evasion as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Ban evasion: a previously banned
        /// user returning with a new account."
        case reasonRuleBanEvasion = "tools.ozone.report.defs#reasonRuleBanEvasion"

        /// Indicates a rule violation not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other network rule violation not
        /// covered by more specific categories."
        case reasonRuleOther = "tools.ozone.report.defs#reasonRuleOther"

        /// Indicates content promoting or depicting self-harm as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Content promoting or depicting
        /// self-harm."
        case reasonSelfHarmContent = "tools.ozone.report.defs#reasonSelfHarmContent"

        /// Indicates eating disorder-related content as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Eating disorders: material
        /// promoting or glorifying disordered eating behaviors."
        case reasonSelfHarmED = "tools.ozone.report.defs#reasonSelfHarmED"

        /// Indicates dangerous challenges or activities as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Dangerous challenges or
        /// activities: content encouraging high-risk physical stunts."
        case reasonSelfHarmStunts = "tools.ozone.report.defs#reasonSelfHarmStunts"

        /// Indicates dangerous substance use or drug abuse as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Dangerous substances or drug
        /// abuse: content promoting harmful substance use."
        case reasonSelfHarmSubstances = "tools.ozone.report.defs#reasonSelfHarmSubstances"

        /// Indicates dangerous content not otherwise specified as the reason (Ozone reporting system).
        ///
        /// - Note: According to the AT Protocol specifications: "Other dangerous content not
        /// covered by more specific categories."
        case reasonSelfHarmOther = "tools.ozone.report.defs#reasonSelfHarmOther"
    }

    /// A definition model for a tag describing a possible subject for reporting.
    ///
    /// - Note: According to the AT Protocol specifications: "Tag describing a type of subject
    /// that might be reported."
    ///
    /// - SeeAlso: This is based on the [`com.atproto.moderation.defs`][github] lexicon.
    ///
    /// [github]: https://github.com/bluesky-social/atproto/blob/main/lexicons/com/atproto/moderation/defs.json
    public enum SubjectTypeDefinition: String, Sendable, Codable {

        /// Indicates the subject to be reported is a user account.
        case account

        /// Indicates the subject to be reported is a record.
        case record

        /// Indicates the subject to be reported is a chat message.
        case chat
    }
}
