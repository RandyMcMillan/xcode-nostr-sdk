//
//  ContentView.swift
//  swiftyapp
//
//  Created by Jonathan McKenzie on 7/9/24.
//

import RustyLib
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var firstValue = 10
    @State private var secondValue = 32

    // Nostr state
    @State private var nsecKey = ""
    @State private var npubKey = ""
    @State private var nip19Input = ""
    @State private var nip19Prefix = "npub"
    @State private var nip19HexInput = ""
    @State private var nip19Result: Nip19Result?
    @State private var noteContent = "Hello Nostr from Rust + Swift!"
    @State private var textNoteJson = ""
    @State private var metadataName = "Alice"
    @State private var metadataAbout = "Building on Nostr"
    @State private var metadataPicture = "https://example.com/avatar.png"
    @State private var metadataJson = ""
    @State private var verifyInput = ""
    @State private var verifyResult: Bool?
    @State private var extractedEventId = ""

    // Encryption
    @State private var encryptRecipient = ""
    @State private var encryptContent = ""
    @State private var encryptedOutput = ""
    @State private var decryptSender = ""
    @State private var decryptPayload = ""
    @State private var decryptedOutput = ""

    // Contact list
    @State private var contactListPubkeys = ""
    @State private var contactListJson = ""

    // NIP-21
    @State private var nip21HexInput = ""
    @State private var nip21Prefix = "npub"
    @State private var nip21UriInput = ""
    @State private var nip21Result: Nip19Result? = nil

    // Reactions / Reposts / Deletion / Auth
    @State private var reactionEventId = ""
    @State private var reactionAuthor = ""
    @State private var reactionKind: UInt16 = 1
    @State private var reactionContent = "+"
    @State private var reactionJson = ""
    @State private var repostEventJson = ""
    @State private var repostResultJson = ""
    @State private var deleteEventIds = ""
    @State private var deleteReason = ""
    @State private var deleteJson = ""
    @State private var authChallenge = ""
    @State private var authRelay = "wss://relay.damus.io"
    @State private var authJson = ""

    // Relay list
    @State private var relayListInput = "wss://relay.damus.io read, wss://relay.nostr.band write"
    @State private var relayListJson = ""

    // Zap Request (NIP-57)
    @State private var zapRecipient = ""
    @State private var zapRelays = "wss://relay.damus.io"
    @State private var zapMessage = "Great post!"
    @State private var zapAmount: UInt64 = 21000
    @State private var zapEventId = ""
    @State private var zapJson = ""

    // Filters
    @State private var filterAuthors = ""
    @State private var filterKinds = "0,1"
    @State private var filterIds = ""
    @State private var filterSince: UInt64 = 0
    @State private var filterUntil: UInt64 = 0
    @State private var filterLimit: UInt64 = 100
    @State private var filterJson = ""
    @State private var filterMatchEvent = ""
    @State private var filterMatchResult: Bool? = nil

    // Event Metadata
    @State private var metadataEventInput = ""
    @State private var metadataCreatedAt: UInt64 = 0
    @State private var metadataKind: UInt16 = 0
    @State private var metadataPubkey = ""

    // NIP-05
    @State private var nip05Address = ""
    @State private var nip05Pubkey = ""
    @State private var nip05Json = ""
    @State private var nip05VerifyResult: Bool? = nil
    @State private var nip05Profile: Nip05ProfileResult? = nil

    // Gift Wrap (NIP-59)
    @State private var gwRecipient = ""
    @State private var gwKind: UInt16 = 1
    @State private var gwContent = "Secret message"
    @State private var gwJson = ""

    // Private Message (NIP-17)
    @State private var pmRecipient = ""
    @State private var pmMessage = "Hello privately!"
    @State private var pmJson = ""

    // HTTP Auth (NIP-98)
    @State private var authUrl = "https://example.com/api"
    @State private var authMethod = "GET"
    @State private var authPayload = ""
    @State private var httpAuthJson = ""

    // Long-form (NIP-23)
    @State private var lfTitle = "My Article"
    @State private var lfContent = "This is a long-form article..."
    @State private var lfSummary = "A summary"
    @State private var lfImage = ""
    @State private var lfPublishedAt: UInt64 = 0
    @State private var lfJson = ""

    // Reporting (NIP-56)
    @State private var reportEventId = ""
    @State private var reportPubkey = ""
    @State private var reportType = "spam"
    @State private var reportJson = ""

    // Badges (NIP-58)
    @State private var badgeId = "my-badge"
    @State private var badgeName = "Early Adopter"
    @State private var badgeDescription = "For early supporters"
    @State private var badgeImage = "https://example.com/badge.png"
    @State private var badgeJson = ""
    @State private var badgeAwardPubkeys = ""
    @State private var badgeAwardJson = ""

    // Lists (NIP-51)
    @State private var mutePubkeys = ""
    @State private var muteEventIds = ""
    @State private var muteWords = ""
    @State private var muteJson = ""
    @State private var bookmarkEventIds = ""
    @State private var bookmarkJson = ""

    // Event Utilities
    @State private var utilEventInput = ""
    @State private var utilContent = ""
    @State private var utilSigValid: Bool? = nil

    // NIP-19 Advanced Encoding
    @State private var neventId = ""
    @State private var neventAuthor = ""
    @State private var neventKind: UInt16 = 1
    @State private var neventRelays = ""
    @State private var neventResult = ""
    @State private var nprofilePubkey = ""
    @State private var nprofileRelays = ""
    @State private var nprofileResult = ""
    @State private var naddrKind: UInt16 = 30023
    @State private var naddrPubkey = ""
    @State private var naddrIdentifier = "my-article"
    @State private var naddrRelays = ""
    @State private var naddrResult = ""

    // NIP-19 Advanced Decode
    @State private var decodeBech32 = ""
    @State private var decodedNevent: Nip19EventResult? = nil
    @State private var decodedNprofile: Nip19ProfileResult? = nil
    @State private var decodedNaddr: Nip19CoordinateResult? = nil

    // NIP-94 File Metadata
    @State private var fileDescription = "My file"
    @State private var fileUrl = "https://example.com/file.png"
    @State private var fileMime = "image/png"
    @State private var fileHash = ""
    @State private var fileJson = ""

    // Event Tags & Expiration
    @State private var tagsEventInput = ""
    @State private var tagsJsonOutput = ""
    @State private var expEventInput = ""
    @State private var expSeconds: UInt64 = 3600
    @State private var expEventOutput = ""

    // Pinned Notes
    @State private var pinnedEventIds = ""
    @State private var pinnedJson = ""

    // Interests & Relay Set (NIP-51)
    @State private var interestHashtags = "nostr, rust, swift"
    @State private var interestJson = ""
    @State private var relaySetId = "my-relays"
    @State private var relaySetUrls = "wss://relay.damus.io, wss://relay.nostr.band"
    @State private var relaySetJson = ""

    // Thread Reply
    @State private var replyContent = "Great point!"
    @State private var replyRootId = ""
    @State private var replyToId = ""
    @State private var replyToAuthor = ""
    @State private var replyJson = ""

    // Event Add Tag
    @State private var addTagEvent = ""
    @State private var addTagValues = ""
    @State private var addTagResult = ""

    // Quote Repost
    @State private var quoteContent = "This is amazing!"
    @State private var quoteEventId = ""
    @State private var quoteJson = ""

    // Live Event (NIP-53)
    @State private var liveId = "my-live-event"
    @State private var liveTitle = "My Live Stream"
    @State private var liveStreamUrl = "https://stream.example.com/live"
    @State private var liveStatus = "live"
    @State private var liveJson = ""
    @State private var liveMsgEventId = ""
    @State private var liveMsgHost = ""
    @State private var liveMsgContent = "Hello viewers!"
    @State private var liveMsgJson = ""

    // Proxy & External Content
    @State private var proxyContent = "Proxy post"
    @State private var proxyId = ""
    @State private var proxyProtocol = "activitypub"
    @State private var proxyJson = ""
    @State private var extContent = "Check this out"
    @State private var extId = "https://example.com"
    @State private var extHint = ""
    @State private var extJson = ""

    // Polls (NIP-88)
    @State private var pollTitle = "What's your favorite language?"
    @State private var pollType = "singlechoice"
    @State private var pollOptions = "Rust, Swift, Python"
    @State private var pollEndsAt: UInt64 = 0
    @State private var pollJson = ""
    @State private var pollResponseId = ""
    @State private var pollResponseValue = ""
    @State private var pollResponseJson = ""

    // Vanish Request (NIP-62)
    @State private var vanishReason = ""
    @State private var vanishRelays = ""
    @State private var vanishJson = ""

    // SDK Client
    @State private var clientRelayUrl = "wss://relay.damus.io"
    @State private var clientEventJson = ""
    @State private var clientStatus = ""
    @State private var nostrClient: NostrClient? = nil
    @State private var clientRelays: [String] = []
    @State private var clientFilterJson = ""
    @State private var clientFetchedEvents: [String] = []
    @State private var clientTargetRelay = "wss://relay.damus.io"
    @State private var clientRemoveRelay = ""

    // NIP-38 User Status
    @State private var userStatusType = "general"
    @State private var userStatusContent = "Building on Nostr"
    @State private var userStatusRef = ""
    @State private var userStatusJson = ""

    // NIP-39 External Identities
    @State private var metadataIdentities = "github:alice:proof123"
    @State private var metadataWithIdentitiesJson = ""

    // NIP-49 ncryptsec
    @State private var nip49Password = ""
    @State private var nip49LogN: UInt8 = 16
    @State private var nip49Ncryptsec = ""
    @State private var nip49Decrypted = ""

    // NIP-30 Custom Emoji
    @State private var emojiList = "rust:https://example.com/rust.png,swift:https://example.com/swift.png"
    @State private var emojiListJson = ""

    // NIP-89 App Handler
    @State private var appKind: UInt16 = 1
    @State private var appHandlerId = ""
    @State private var appHandlerPubkey = ""
    @State private var appHandlerJson = ""

    // Generic Event Builder
    @State private var genericKind: UInt16 = 1
    @State private var genericContent = "Hello Nostr"
    @State private var genericTags = "[[\"p\",\"0000...\"]]"
    @State private var genericJson = ""

    // Filter with Search
    @State private var searchFilterAuthors = ""
    @State private var searchFilterKinds = "0,1"
    @State private var searchQuery = "nostr"
    @State private var searchFilterJson = ""

    // NIP-46 Nostr Connect
    @State private var nconnectMessage = ""
    @State private var nconnectParsed = ""
    @State private var nconnectReqId = ""
    @State private var nconnectResponse = ""

    // Event Tag Values
    @State private var tagEventInput = ""
    @State private var tagName = "p"
    @State private var tagValuesResult: [String] = []

    // NIP-34 Git Issue
    @State private var gitRepoPubkey = ""
    @State private var gitIssueSubject = "Bug report"
    @State private var gitIssueContent = "Found a bug in the repo"
    @State private var gitIssueLabels = "bug,urgent"
    @State private var gitIssueJson = ""

    // NIP-22 Comments
    @State private var commentContent = "Great post!"
    @State private var commentTargetId = ""
    @State private var commentTargetKind: UInt16 = 1
    @State private var commentTargetAuthor = ""
    @State private var commentRootId = ""
    @State private var commentJson = ""

    // NIP-35 Torrents
    @State private var torrentTitle = "My Torrent"
    @State private var torrentDescription = "A cool file"
    @State private var torrentInfoHash = ""
    @State private var torrentFiles = "file.txt:1024"
    @State private var torrentTrackers = "https://tracker.example.com"
    @State private var torrentCategories = "video,movie"
    @State private var torrentHashtags = "open-source"
    @State private var torrentJson = ""

    // NIP-60 Cashu Wallet
    @State private var cashuWalletPrivkey = ""
    @State private var cashuMints = "https://mint.example.com"
    @State private var cashuWalletJson = ""
    @State private var cashuTokenMint = ""
    @State private var cashuTokenProofs = "[{\"id\":\"abc\",\"amount\":100,\"secret\":\"secret\",\"c\":\"cval\"}]"
    @State private var cashuTokenJson = ""

    private var sum: Int {
        Int(rustAdd(a: UInt32(firstValue), b: UInt32(secondValue)))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    colorScheme == .dark
                        ? Color(red: 0.05, green: 0.05, blue: 0.07)
                        : Color(red: 0.95, green: 0.96, blue: 0.98),
                    colorScheme == .dark
                        ? Color(red: 0.10, green: 0.08, blue: 0.06)
                        : Color(red: 0.90, green: 0.92, blue: 0.96),
                    colorScheme == .dark
                        ? Color(red: 0.18, green: 0.09, blue: 0.03)
                        : Color(red: 0.82, green: 0.86, blue: 0.93)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            if colorScheme == .dark {
                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 0.60, blue: 0.15).opacity(0.20),
                        .clear
                    ],
                    center: .topTrailing,
                    startRadius: 20,
                    endRadius: 340
                )
                .ignoresSafeArea()
            } else {
                RadialGradient(
                    colors: [
                        Color(red: 0.77, green: 0.86, blue: 1.0).opacity(0.34),
                        .clear
                    ],
                    center: .topTrailing,
                    startRadius: 24,
                    endRadius: 360
                )
                .ignoresSafeArea()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    glassCard {
                        HStack(alignment: .center, spacing: 16) {
                            Image(colorScheme == .dark ? "RustOrb" : "RustOrbLight")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 84, height: 84)
                                .padding(8)
                                .background(
                                    colorScheme == .dark
                                        ? .white.opacity(0.04)
                                        : .white.opacity(0.70),
                                    in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(
                                            colorScheme == .dark
                                                ? Color(red: 1.0, green: 0.66, blue: 0.24).opacity(0.28)
                                                : Color(red: 0.52, green: 0.62, blue: 0.72).opacity(0.22),
                                            lineWidth: 1
                                        )
                                )

                            VStack(alignment: .leading, spacing: 10) {
                                Label("Rust bridge", systemImage: "sparkles")
                                    .font(.headline)
                                    .foregroundStyle(accentText)

                                Text(rustHello())
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(primaryText)

                                Text("SwiftUI talking to Rust, dressed up in the same warm palette as the icon.")
                                    .font(.subheadline)
                                    .foregroundStyle(primaryText.opacity(0.74))
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("Live calculator", systemImage: "function")
                                    .font(.headline)
                                    .foregroundStyle(accentText)
                                Spacer()
                                Text("Rust powered")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(accentFill.opacity(colorScheme == .dark ? 0.18 : 0.12), in: Capsule())
                                    .foregroundStyle(accentText)
                            }

                            stepperRow(
                                title: "First value",
                                value: $firstValue,
                                range: 0...100
                            )

                            stepperRow(
                                title: "Second value",
                                value: $secondValue,
                                range: 0...100
                            )

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Result")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(primaryText.opacity(0.68))
                                    Text("\(firstValue) + \(secondValue)")
                                        .font(.title3.weight(.semibold))
                                        .foregroundStyle(primaryText)
                                }

                                Spacer()

                                Text("\(sum)")
                                    .font(.system(size: 42, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: colorScheme == .dark
                                                ? [.white, Color(red: 1.0, green: 0.76, blue: 0.42)]
                                                : [Color(red: 0.10, green: 0.16, blue: 0.24), Color(red: 0.38, green: 0.45, blue: 0.58)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }

                            Button {
                                firstValue = Int.random(in: 0...100)
                                secondValue = Int.random(in: 0...100)
                            } label: {
                                Label("Randomize values", systemImage: "dice.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("What this proves", systemImage: "checkmark.seal.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            ForEach([
                                "SwiftUI rendering",
                                "State-driven interactions",
                                "Native Rust function calls",
                            ], id: \.self) { item in
                                HStack(spacing: 10) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(accentFill)
                                    Text(item)
                                        .foregroundStyle(primaryText.opacity(colorScheme == .dark ? 0.88 : 0.84))
                                    Spacer()
                                }
                                .font(.subheadline)
                            }
                        }
                    }

                    // MARK: - Nostr Toolkit

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("Nostr Keys", systemImage: "key.fill")
                                    .font(.headline)
                                    .foregroundStyle(accentText)
                                Spacer()
                                Text("nostr crate")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(accentFill.opacity(colorScheme == .dark ? 0.18 : 0.12), in: Capsule())
                                    .foregroundStyle(accentText)
                            }

                            Button {
                                let sk = generateKeys()
                                nsecKey = sk
                                npubKey = (try? getPublicKey(secretKey: sk)) ?? ""
                            } label: {
                                Label("Generate Keys", systemImage: "arrow.clockwise.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())

                            if !nsecKey.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    keyRow(label: "Secret Key (hex)", value: nsecKey)
                                    keyRow(label: "Public Key (npub)", value: npubKey)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("NIP-19 Codec", systemImage: "number")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Decode")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("npub1... / nsec1... / note1...", text: $nip19Input)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    nip19Result = try? nip19Decode(bech32: nip19Input)
                                } label: {
                                    Label("Decode", systemImage: "arrow.down.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let res = nip19Result {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Prefix: \(res.prefix)")
                                        Text("Data: \(res.data)")
                                    }
                                    .font(.caption.monospaced())
                                    .foregroundStyle(primaryText.opacity(0.84))
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Encode")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Hex data", text: $nip19HexInput)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Picker("Prefix", selection: $nip19Prefix) {
                                    Text("npub").tag("npub")
                                    Text("nsec").tag("nsec")
                                    Text("note").tag("note")
                                }
                                .pickerStyle(.segmented)
                                Button {
                                    nip19Result = Nip19Result(
                                        prefix: nip19Prefix,
                                        data: (try? nip19Encode(dataHex: nip19HexInput, prefix: nip19Prefix)) ?? ""
                                    )
                                } label: {
                                    Label("Encode", systemImage: "arrow.up.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let res = nip19Result, !res.data.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Result:")
                                        Text(res.data)
                                            .font(.caption.monospaced())
                                            .foregroundStyle(primaryText.opacity(0.84))
                                    }
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Events", systemImage: "doc.text")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Text Note")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $noteContent)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    textNoteJson = (try? createTextNote(secretKey: nsecKey, content: noteContent)) ?? ""
                                } label: {
                                    Label("Sign Text Note", systemImage: "pencil.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !textNoteJson.isEmpty {
                                    jsonBlock(textNoteJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Metadata (Kind 0)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Name", text: $metadataName)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("About", text: $metadataAbout)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Picture URL", text: $metadataPicture)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    metadataJson = (try? createMetadataEvent(
                                        secretKey: nsecKey,
                                        name: metadataName,
                                        about: metadataAbout,
                                        picture: metadataPicture
                                    )) ?? ""
                                } label: {
                                    Label("Sign Metadata", systemImage: "person.crop.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !metadataJson.isEmpty {
                                    jsonBlock(metadataJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Verify / Inspect")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $verifyInput)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                HStack(spacing: 12) {
                                    Button {
                                        verifyResult = try? verifyEvent(eventJson: verifyInput)
                                    } label: {
                                        Label("Verify", systemImage: "checkmark.shield.fill")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())

                                    Button {
                                        extractedEventId = (try? eventId(eventJson: verifyInput)) ?? ""
                                    } label: {
                                        Label("Event ID", systemImage: "number.circle.fill")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                }
                                if let valid = verifyResult {
                                    HStack(spacing: 6) {
                                        Image(systemName: valid ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        Text(valid ? "Signature valid" : "Signature invalid")
                                    }
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(valid ? .green : .red)
                                }
                                if !extractedEventId.isEmpty {
                                    Text("Event ID: \(extractedEventId)")
                                        .font(.caption.monospaced())
                                        .foregroundStyle(primaryText.opacity(0.84))
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Encryption", systemImage: "lock.shield.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Encrypt (NIP-44)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Recipient pubkey (hex)", text: $encryptRecipient)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Content", text: $encryptContent)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    encryptedOutput = (try? nip44Encrypt(
                                        secretKey: nsecKey,
                                        recipientPubkey: encryptRecipient,
                                        content: encryptContent
                                    )) ?? ""
                                } label: {
                                    Label("Encrypt", systemImage: "lock.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !encryptedOutput.isEmpty {
                                    keyRow(label: "Encrypted payload", value: encryptedOutput)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Decrypt (NIP-44)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Sender pubkey (hex)", text: $decryptSender)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Payload", text: $decryptPayload)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    decryptedOutput = (try? nip44Decrypt(
                                        secretKey: nsecKey,
                                        senderPubkey: decryptSender,
                                        payload: decryptPayload
                                    )) ?? ""
                                } label: {
                                    Label("Decrypt", systemImage: "lock.open.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !decryptedOutput.isEmpty {
                                    keyRow(label: "Decrypted content", value: decryptedOutput)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Legacy NIP-04")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                HStack(spacing: 12) {
                                    Button {
                                        encryptedOutput = (try? nip04Encrypt(
                                            secretKey: nsecKey,
                                            recipientPubkey: encryptRecipient,
                                            content: encryptContent
                                        )) ?? ""
                                    } label: {
                                        Label("Encrypt", systemImage: "lock.fill")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(nsecKey.isEmpty)

                                    Button {
                                        decryptedOutput = (try? nip04Decrypt(
                                            secretKey: nsecKey,
                                            senderPubkey: decryptSender,
                                            encryptedContent: decryptPayload
                                        )) ?? ""
                                    } label: {
                                        Label("Decrypt", systemImage: "lock.open.fill")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(nsecKey.isEmpty)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Contact List", systemImage: "person.2.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            Text("Comma-separated pubkeys (hex)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(primaryText)
                            TextField("pubkey1, pubkey2, ...", text: $contactListPubkeys)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let keys = contactListPubkeys
                                    .split(separator: ",")
                                    .map { $0.trimmingCharacters(in: .whitespaces) }
                                    .filter { !$0.isEmpty }
                                contactListJson = (try? createContactList(secretKey: nsecKey, pubkeysHex: keys)) ?? ""
                            } label: {
                                Label("Build Contact List", systemImage: "person.crop.circle.badge.plus")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !contactListJson.isEmpty {
                                jsonBlock(contactListJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("NIP-21 URI", systemImage: "link")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Encode")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Hex data", text: $nip21HexInput)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Picker("Prefix", selection: $nip21Prefix) {
                                    Text("npub").tag("npub")
                                    Text("note").tag("note")
                                }
                                .pickerStyle(.segmented)
                                Button {
                                    nip21Result = Nip19Result(
                                        prefix: nip21Prefix,
                                        data: (try? nip21Encode(dataHex: nip21HexInput, prefix: nip21Prefix)) ?? ""
                                    )
                                } label: {
                                    Label("Encode URI", systemImage: "arrow.up.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let res = nip21Result, !res.data.isEmpty {
                                    keyRow(label: "URI", value: res.data)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Decode")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("nostr:...", text: $nip21UriInput)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    nip21Result = try? nip21Decode(nostrUri: nip21UriInput)
                                } label: {
                                    Label("Decode URI", systemImage: "arrow.down.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let res = nip21Result, !res.data.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Prefix: \(res.prefix)")
                                        Text("Data: \(res.data)")
                                    }
                                    .font(.caption.monospaced())
                                    .foregroundStyle(primaryText.opacity(0.84))
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Event Metadata", systemImage: "info.circle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $metadataEventInput)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            Button {
                                metadataCreatedAt = (try? eventCreatedAt(eventJson: metadataEventInput)) ?? 0
                                metadataKind = (try? eventKindValue(eventJson: metadataEventInput)) ?? 0
                                metadataPubkey = (try? eventPubkeyHex(eventJson: metadataEventInput)) ?? ""
                            } label: {
                                Label("Extract Metadata", systemImage: "magnifyingglass")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            if metadataCreatedAt > 0 {
                                keyRow(label: "Created At", value: "\(metadataCreatedAt)")
                            }
                            if metadataKind > 0 {
                                keyRow(label: "Kind", value: "\(metadataKind)")
                            }
                            if !metadataPubkey.isEmpty {
                                keyRow(label: "Pubkey", value: metadataPubkey)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("NIP-05 Verification", systemImage: "checkmark.seal.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Verify")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("NIP-05 address", text: $nip05Address)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Pubkey (hex)", text: $nip05Pubkey)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextEditor(text: $nip05Json)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    if let result = try? verifyNip05(pubkeyHex: nip05Pubkey, address: nip05Address, jsonRaw: nip05Json) {
                                        nip05VerifyResult = result
                                    } else {
                                        nip05VerifyResult = nil
                                    }
                                } label: {
                                    Label("Verify NIP-05", systemImage: "checkmark.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let result = nip05VerifyResult {
                                    Text(result ? "Verified ✓" : "Not verified ✗")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(result ? .green : .red)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Parse Profile")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                Button {
                                    nip05Profile = try? parseNip05Profile(address: nip05Address, jsonRaw: nip05Json)
                                } label: {
                                    Label("Parse Profile", systemImage: "person.crop.circle.badge.checkmark")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if let profile = nip05Profile {
                                    keyRow(label: "Pubkey", value: profile.pubkeyHex)
                                    if !profile.relays.isEmpty {
                                        keyRow(label: "Relays", value: profile.relays.joined(separator: ", "))
                                    }
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("More Events", systemImage: "bolt.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Reaction (Kind 7)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Event ID (hex)", text: $reactionEventId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Author pubkey (hex)", text: $reactionAuthor)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                HStack {
                                    TextField("Kind", value: $reactionKind, format: .number)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                        .frame(width: 80)
                                    TextField("Content (+, -, emoji)", text: $reactionContent)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                }
                                Button {
                                    reactionJson = (try? createReaction(
                                        secretKey: nsecKey,
                                        eventIdHex: reactionEventId,
                                        authorPubkeyHex: reactionAuthor,
                                        eventKind: reactionKind,
                                        content: reactionContent
                                    )) ?? ""
                                } label: {
                                    Label("Create Reaction", systemImage: "face.smiling.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !reactionJson.isEmpty {
                                    jsonBlock(reactionJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Repost (NIP-18)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $repostEventJson)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    repostResultJson = (try? createRepost(secretKey: nsecKey, eventJson: repostEventJson)) ?? ""
                                } label: {
                                    Label("Create Repost", systemImage: "arrow.2.squarepath")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !repostResultJson.isEmpty {
                                    jsonBlock(repostResultJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Deletion Request (NIP-09)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Event IDs (comma-separated hex)", text: $deleteEventIds)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Reason", text: $deleteReason)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let ids = deleteEventIds.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    deleteJson = (try? createDeletionRequest(secretKey: nsecKey, eventIdsHex: ids, reason: deleteReason)) ?? ""
                                } label: {
                                    Label("Request Deletion", systemImage: "trash.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !deleteJson.isEmpty {
                                    jsonBlock(deleteJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Auth Event (NIP-42)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Challenge", text: $authChallenge)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Relay URL", text: $authRelay)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    authJson = (try? createAuthEvent(secretKey: nsecKey, challenge: authChallenge, relayUrl: authRelay)) ?? ""
                                } label: {
                                    Label("Create Auth", systemImage: "shield.lefthalf.filled")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !authJson.isEmpty {
                                    jsonBlock(authJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Zap Request (NIP-57)", systemImage: "bolt.horizontal.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Recipient pubkey (hex)", text: $zapRecipient)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Relays (comma-separated)", text: $zapRelays)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Message", text: $zapMessage)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Amount (millisats)", value: $zapAmount, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Event ID (optional hex)", text: $zapEventId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let relays = zapRelays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                let eventIdOpt: String? = zapEventId.isEmpty ? nil : zapEventId
                                zapJson = (try? createZapRequest(
                                    secretKey: nsecKey,
                                    recipientPubkeyHex: zapRecipient,
                                    relayUrls: relays,
                                    message: zapMessage,
                                    amountMillisats: zapAmount,
                                    eventIdHex: eventIdOpt
                                )) ?? ""
                            } label: {
                                Label("Create Zap Request", systemImage: "bolt.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !zapJson.isEmpty {
                                jsonBlock(zapJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Gift Wrap (NIP-59)", systemImage: "gift.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Recipient pubkey (hex)", text: $gwRecipient)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Rumor kind", value: $gwKind, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Rumor content", text: $gwContent)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                gwJson = (try? createGiftWrap(
                                    secretKey: nsecKey,
                                    recipientPubkeyHex: gwRecipient,
                                    rumorKind: gwKind,
                                    rumorContent: gwContent
                                )) ?? ""
                            } label: {
                                Label("Create Gift Wrap", systemImage: "gift.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !gwJson.isEmpty {
                                jsonBlock(gwJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Private Message (NIP-17)", systemImage: "envelope.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Recipient pubkey (hex)", text: $pmRecipient)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Message", text: $pmMessage)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                pmJson = (try? createPrivateMessage(
                                    secretKey: nsecKey,
                                    recipientPubkeyHex: pmRecipient,
                                    message: pmMessage
                                )) ?? ""
                            } label: {
                                Label("Create Private Message", systemImage: "envelope.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !pmJson.isEmpty {
                                jsonBlock(pmJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("HTTP Auth (NIP-98)", systemImage: "lock.shield.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("URL", text: $authUrl)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Method (GET/POST/PUT/PATCH)", text: $authMethod)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Payload hash (optional)", text: $authPayload)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let payloadOpt: String? = authPayload.isEmpty ? nil : authPayload
                                httpAuthJson = (try? createHttpAuth(
                                    secretKey: nsecKey,
                                    url: authUrl,
                                    method: authMethod,
                                    payloadHash: payloadOpt
                                )) ?? ""
                            } label: {
                                Label("Create HTTP Auth", systemImage: "lock.shield.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !httpAuthJson.isEmpty {
                                jsonBlock(httpAuthJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Long-form Content (NIP-23)", systemImage: "doc.text.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Title", text: $lfTitle)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextEditor(text: $lfContent)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Summary", text: $lfSummary)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Image URL", text: $lfImage)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Published At (unix secs)", value: $lfPublishedAt, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                lfJson = (try? createLongForm(
                                    secretKey: nsecKey,
                                    title: lfTitle,
                                    content: lfContent,
                                    summary: lfSummary,
                                    image: lfImage,
                                    publishedAt: lfPublishedAt
                                )) ?? ""
                            } label: {
                                Label("Create Article", systemImage: "doc.text.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !lfJson.isEmpty {
                                jsonBlock(lfJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Relay List (NIP-65)", systemImage: "network")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            Text("Format: url mode (read/write), comma-separated")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(primaryText)
                            TextField("wss://relay.damus.io read, ...", text: $relayListInput)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let entries: [RelayEntry] = relayListInput.split(separator: ",").compactMap { item in
                                    let parts = item.trimmingCharacters(in: .whitespaces).split(separator: " ", omittingEmptySubsequences: true)
                                    guard parts.count >= 1 else { return nil }
                                    let url = String(parts[0])
                                    let mode = parts.count >= 2 ? String(parts[1]) : ""
                                    return RelayEntry(url: url, mode: mode)
                                }
                                relayListJson = (try? createRelayList(secretKey: nsecKey, relays: entries)) ?? ""
                            } label: {
                                Label("Build Relay List", systemImage: "server.rack")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !relayListJson.isEmpty {
                                jsonBlock(relayListJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Filters", systemImage: "line.3.horizontal.decrease.circle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Build Filter")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Authors (comma-separated hex)", text: $filterAuthors)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Kinds (comma-separated)", text: $filterKinds)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("IDs (comma-separated hex)", text: $filterIds)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                HStack(spacing: 12) {
                                    TextField("Since", value: $filterSince, format: .number)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                    TextField("Until", value: $filterUntil, format: .number)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                    TextField("Limit", value: $filterLimit, format: .number)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                }
                                Button {
                                    let authors = filterAuthors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    let kinds = filterKinds.split(separator: ",").compactMap { UInt16($0.trimmingCharacters(in: .whitespaces)) }
                                    let ids = filterIds.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    filterJson = (try? buildFilter(
                                        authorsHex: authors,
                                        kinds: kinds,
                                        idsHex: ids,
                                        sinceSecs: filterSince,
                                        untilSecs: filterUntil,
                                        limit: filterLimit
                                    )) ?? ""
                                } label: {
                                    Label("Build Filter", systemImage: "doc.text.magnifyingglass")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if !filterJson.isEmpty {
                                    jsonBlock(filterJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Match Event")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $filterMatchEvent)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    if let result = try? filterMatchesEvent(filterJson: filterJson, eventJson: filterMatchEvent) {
                                        filterMatchResult = result
                                    } else {
                                        filterMatchResult = nil
                                    }
                                } label: {
                                    Label("Test Match", systemImage: "checkmark.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(filterJson.isEmpty || filterMatchEvent.isEmpty)
                                if let result = filterMatchResult {
                                    Text(result ? "Matches ✓" : "No match ✗")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(result ? .green : .red)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Reporting (NIP-56)", systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Event ID (hex)", text: $reportEventId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Pubkey (hex)", text: $reportPubkey)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Type (spam/nudity/malware/profanity/illegal/impersonation/other)", text: $reportType)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let eventOpt: String? = reportEventId.isEmpty ? nil : reportEventId
                                let pubkeyOpt: String? = reportPubkey.isEmpty ? nil : reportPubkey
                                reportJson = (try? createReportEvent(
                                    secretKey: nsecKey,
                                    targetEventId: eventOpt,
                                    targetPubkey: pubkeyOpt,
                                    reportType: reportType
                                )) ?? ""
                            } label: {
                                Label("Create Report", systemImage: "exclamationmark.triangle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !reportJson.isEmpty {
                                jsonBlock(reportJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Badges (NIP-58)", systemImage: "rosette")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Define Badge")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Badge ID", text: $badgeId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Name", text: $badgeName)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Description", text: $badgeDescription)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Image URL", text: $badgeImage)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    badgeJson = (try? createBadgeDefinition(
                                        secretKey: nsecKey,
                                        badgeId: badgeId,
                                        name: badgeName,
                                        description: badgeDescription,
                                        imageUrl: badgeImage
                                    )) ?? ""
                                } label: {
                                    Label("Create Badge", systemImage: "rosette")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !badgeJson.isEmpty {
                                    jsonBlock(badgeJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Award Badge")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                Text("Paste the badge definition JSON above")
                                    .font(.caption)
                                    .foregroundStyle(primaryText.opacity(0.68))
                                TextField("Awarded pubkeys (comma-separated)", text: $badgeAwardPubkeys)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let keys = badgeAwardPubkeys.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    badgeAwardJson = (try? createBadgeAward(
                                        secretKey: nsecKey,
                                        badgeDefinitionJson: badgeJson,
                                        awardedPubkeysHex: keys
                                    )) ?? ""
                                } label: {
                                    Label("Award Badge", systemImage: "rosette")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty || badgeJson.isEmpty)
                                if !badgeAwardJson.isEmpty {
                                    jsonBlock(badgeAwardJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Lists (NIP-51)", systemImage: "list.bullet.rectangle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mute List")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Pubkeys (comma-separated)", text: $mutePubkeys)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Event IDs (comma-separated)", text: $muteEventIds)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Words (comma-separated)", text: $muteWords)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let pks = mutePubkeys.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    let ids = muteEventIds.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    let words = muteWords.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    muteJson = (try? createMuteList(
                                        secretKey: nsecKey,
                                        pubkeysHex: pks,
                                        eventIdsHex: ids,
                                        words: words
                                    )) ?? ""
                                } label: {
                                    Label("Create Mute List", systemImage: "speaker.slash.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !muteJson.isEmpty {
                                    jsonBlock(muteJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bookmarks")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Event IDs (comma-separated)", text: $bookmarkEventIds)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let ids = bookmarkEventIds.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    bookmarkJson = (try? createBookmarks(
                                        secretKey: nsecKey,
                                        eventIdsHex: ids
                                    )) ?? ""
                                } label: {
                                    Label("Create Bookmarks", systemImage: "bookmark.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !bookmarkJson.isEmpty {
                                    jsonBlock(bookmarkJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Event Utilities", systemImage: "wrench.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $utilEventInput)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            HStack(spacing: 12) {
                                Button {
                                    utilContent = (try? eventContent(eventJson: utilEventInput)) ?? ""
                                } label: {
                                    Label("Get Content", systemImage: "doc.text")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())

                                Button {
                                    if let result = try? eventSignatureValid(eventJson: utilEventInput) {
                                        utilSigValid = result
                                    } else {
                                        utilSigValid = nil
                                    }
                                } label: {
                                    Label("Check Sig", systemImage: "checkmark.shield")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                            if !utilContent.isEmpty {
                                keyRow(label: "Content", value: utilContent)
                            }
                            if let valid = utilSigValid {
                                Text(valid ? "Signature valid ✓" : "Signature invalid ✗")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(valid ? .green : .red)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("NIP-19 Advanced Encoding", systemImage: "qrcode")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("nevent")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Event ID (hex)", text: $neventId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Author (hex, optional)", text: $neventAuthor)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Kind", value: $neventKind, format: .number)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Relays (comma-separated)", text: $neventRelays)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let authorOpt: String? = neventAuthor.isEmpty ? nil : neventAuthor
                                    let relays = neventRelays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    neventResult = (try? nip19EncodeEvent(
                                        eventIdHex: neventId,
                                        authorPubkeyHex: authorOpt,
                                        kind: neventKind,
                                        relayUrls: relays
                                    )) ?? ""
                                } label: {
                                    Label("Encode nevent", systemImage: "qrcode")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if !neventResult.isEmpty {
                                    keyRow(label: "nevent", value: neventResult)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("nprofile")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Pubkey (hex)", text: $nprofilePubkey)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Relays (comma-separated)", text: $nprofileRelays)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let relays = nprofileRelays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    nprofileResult = (try? nip19EncodeProfile(
                                        pubkeyHex: nprofilePubkey,
                                        relayUrls: relays
                                    )) ?? ""
                                } label: {
                                    Label("Encode nprofile", systemImage: "qrcode")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if !nprofileResult.isEmpty {
                                    keyRow(label: "nprofile", value: nprofileResult)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("naddr")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Kind", value: $naddrKind, format: .number)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Pubkey (hex)", text: $naddrPubkey)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Identifier (d tag)", text: $naddrIdentifier)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Relays (comma-separated)", text: $naddrRelays)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let relays = naddrRelays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    naddrResult = (try? nip19EncodeCoordinate(
                                        kind: naddrKind,
                                        pubkeyHex: naddrPubkey,
                                        identifier: naddrIdentifier,
                                        relayUrls: relays
                                    )) ?? ""
                                } label: {
                                    Label("Encode naddr", systemImage: "qrcode")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if !naddrResult.isEmpty {
                                    keyRow(label: "naddr", value: naddrResult)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("NIP-19 Advanced Decode", systemImage: "barcode.viewfinder")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("bech32 string", text: $decodeBech32)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                decodedNevent = try? nip19DecodeEvent(bech32: decodeBech32)
                                decodedNprofile = try? nip19DecodeProfile(bech32: decodeBech32)
                                decodedNaddr = try? nip19DecodeCoordinate(bech32: decodeBech32)
                            } label: {
                                Label("Decode", systemImage: "barcode.viewfinder")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            if let ev = decodedNevent, !ev.eventIdHex.isEmpty {
                                Text("nevent")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(accentText)
                                keyRow(label: "Event ID", value: ev.eventIdHex)
                                if !ev.authorHex.isEmpty {
                                    keyRow(label: "Author", value: ev.authorHex)
                                }
                                if ev.kind > 0 {
                                    keyRow(label: "Kind", value: "\(ev.kind)")
                                }
                                if !ev.relays.isEmpty {
                                    keyRow(label: "Relays", value: ev.relays.joined(separator: ", "))
                                }
                            }
                            if let profile = decodedNprofile, !profile.pubkeyHex.isEmpty {
                                Text("nprofile")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(accentText)
                                keyRow(label: "Pubkey", value: profile.pubkeyHex)
                                if !profile.relays.isEmpty {
                                    keyRow(label: "Relays", value: profile.relays.joined(separator: ", "))
                                }
                            }
                            if let coord = decodedNaddr, coord.kind > 0 {
                                Text("naddr")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(accentText)
                                keyRow(label: "Kind", value: "\(coord.kind)")
                                keyRow(label: "Pubkey", value: coord.pubkeyHex)
                                keyRow(label: "Identifier", value: coord.identifier)
                                if !coord.relays.isEmpty {
                                    keyRow(label: "Relays", value: coord.relays.joined(separator: ", "))
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("File Metadata (NIP-94)", systemImage: "doc.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Description", text: $fileDescription)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("URL", text: $fileUrl)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("MIME type", text: $fileMime)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("SHA256 hash (hex)", text: $fileHash)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                fileJson = (try? createFileMetadata(
                                    secretKey: nsecKey,
                                    description: fileDescription,
                                    url: fileUrl,
                                    mimeType: fileMime,
                                    hashHex: fileHash
                                )) ?? ""
                            } label: {
                                Label("Create File Metadata", systemImage: "doc.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !fileJson.isEmpty {
                                jsonBlock(fileJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Event Tags & Expiration", systemImage: "tag.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Extract Tags")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $tagsEventInput)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    tagsJsonOutput = (try? eventTagsJson(eventJson: tagsEventInput)) ?? ""
                                } label: {
                                    Label("Get Tags JSON", systemImage: "tag.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                if !tagsJsonOutput.isEmpty {
                                    jsonBlock(tagsJsonOutput)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Add Expiration (NIP-40)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextEditor(text: $expEventInput)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                TextField("Expiration (seconds from now)", value: $expSeconds, format: .number)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    expEventOutput = (try? addExpirationToEvent(
                                        secretKey: nsecKey,
                                        eventJson: expEventInput,
                                        expirationSecs: expSeconds
                                    )) ?? ""
                                } label: {
                                    Label("Add Expiration", systemImage: "clock.badge.xmark")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !expEventOutput.isEmpty {
                                    jsonBlock(expEventOutput)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Pinned Notes (NIP-51)", systemImage: "pin.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Event IDs (comma-separated hex)", text: $pinnedEventIds)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let ids = pinnedEventIds.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                pinnedJson = (try? createPinnedNotes(
                                    secretKey: nsecKey,
                                    eventIdsHex: ids
                                )) ?? ""
                            } label: {
                                Label("Create Pinned Notes", systemImage: "pin.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !pinnedJson.isEmpty {
                                jsonBlock(pinnedJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Interests & Relay Set (NIP-51)", systemImage: "star.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Interests")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Hashtags (comma-separated)", text: $interestHashtags)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let tags = interestHashtags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    interestJson = (try? createInterests(
                                        secretKey: nsecKey,
                                        hashtags: tags
                                    )) ?? ""
                                } label: {
                                    Label("Create Interests", systemImage: "star.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !interestJson.isEmpty {
                                    jsonBlock(interestJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Relay Set")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Identifier (d tag)", text: $relaySetId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Relay URLs (comma-separated)", text: $relaySetUrls)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let urls = relaySetUrls.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    relaySetJson = (try? createRelaySet(
                                        secretKey: nsecKey,
                                        identifier: relaySetId,
                                        relayUrls: urls
                                    )) ?? ""
                                } label: {
                                    Label("Create Relay Set", systemImage: "server.rack")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !relaySetJson.isEmpty {
                                    jsonBlock(relaySetJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Thread Reply", systemImage: "bubble.left.and.bubble.right.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Content", text: $replyContent)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Root Event ID (hex)", text: $replyRootId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Reply To Event ID (hex)", text: $replyToId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Reply To Author Pubkey (hex)", text: $replyToAuthor)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                replyJson = (try? createThreadReply(
                                    secretKey: nsecKey,
                                    content: replyContent,
                                    rootEventIdHex: replyRootId,
                                    replyToEventIdHex: replyToId,
                                    replyToAuthorPubkeyHex: replyToAuthor
                                )) ?? ""
                            } label: {
                                Label("Create Reply", systemImage: "bubble.left.and.bubble.right.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !replyJson.isEmpty {
                                jsonBlock(replyJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Event Add Tag", systemImage: "plus.viewfinder")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $addTagEvent)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Tag values (comma-separated)", text: $addTagValues)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let values = addTagValues.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                addTagResult = (try? eventAddTag(
                                    secretKey: nsecKey,
                                    eventJson: addTagEvent,
                                    tagValues: values
                                )) ?? ""
                            } label: {
                                Label("Add Tag & Re-sign", systemImage: "plus.viewfinder")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !addTagResult.isEmpty {
                                jsonBlock(addTagResult)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Quote Repost", systemImage: "quote.bubble.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Content", text: $quoteContent)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Quoted Event ID (hex)", text: $quoteEventId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                quoteJson = (try? createQuoteRepost(
                                    secretKey: nsecKey,
                                    content: quoteContent,
                                    quotedEventIdHex: quoteEventId
                                )) ?? ""
                            } label: {
                                Label("Create Quote Repost", systemImage: "quote.bubble.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !quoteJson.isEmpty {
                                jsonBlock(quoteJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Live Event (NIP-53)", systemImage: "video.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Create Live Event")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Identifier (d tag)", text: $liveId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Title", text: $liveTitle)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Streaming URL", text: $liveStreamUrl)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Status (planned/live/ended)", text: $liveStatus)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    liveJson = (try? createLiveEvent(
                                        secretKey: nsecKey,
                                        identifier: liveId,
                                        title: liveTitle,
                                        streamingUrl: liveStreamUrl,
                                        status: liveStatus
                                    )) ?? ""
                                } label: {
                                    Label("Create Live Event", systemImage: "video.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !liveJson.isEmpty {
                                    jsonBlock(liveJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Live Event Message")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Live Event ID (d tag)", text: $liveMsgEventId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Host Pubkey (hex)", text: $liveMsgHost)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Content", text: $liveMsgContent)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    liveMsgJson = (try? createLiveEventMessage(
                                        secretKey: nsecKey,
                                        liveEventId: liveMsgEventId,
                                        liveEventHostPubkeyHex: liveMsgHost,
                                        content: liveMsgContent
                                    )) ?? ""
                                } label: {
                                    Label("Send Message", systemImage: "message.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !liveMsgJson.isEmpty {
                                    jsonBlock(liveMsgJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Proxy & External Content", systemImage: "globe")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Proxy Event (NIP-48)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Content", text: $proxyContent)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Proxy ID", text: $proxyId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Protocol (activitypub/atproto/rss/web)", text: $proxyProtocol)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    proxyJson = (try? createProxyEvent(
                                        secretKey: nsecKey,
                                        content: proxyContent,
                                        proxyId: proxyId,
                                        protocol: proxyProtocol
                                    )) ?? ""
                                } label: {
                                    Label("Create Proxy Event", systemImage: "globe")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !proxyJson.isEmpty {
                                    jsonBlock(proxyJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("External Content (NIP-73)")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Content", text: $extContent)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("External ID (URL, ISBN, etc.)", text: $extId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Hint URL (optional)", text: $extHint)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let hintOpt: String? = extHint.isEmpty ? nil : extHint
                                    extJson = (try? createExternalContentEvent(
                                        secretKey: nsecKey,
                                        content: extContent,
                                        externalId: extId,
                                        hintUrl: hintOpt
                                    )) ?? ""
                                } label: {
                                    Label("Create External Content", systemImage: "link")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !extJson.isEmpty {
                                    jsonBlock(extJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Polls (NIP-88)", systemImage: "chart.bar.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Create Poll")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Title", text: $pollTitle)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Type (singlechoice/multiplechoice)", text: $pollType)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Options (comma-separated)", text: $pollOptions)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Ends At (unix secs, 0 for none)", value: $pollEndsAt, format: .number)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    let opts = pollOptions.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                    pollJson = (try? createPoll(
                                        secretKey: nsecKey,
                                        title: pollTitle,
                                        pollType: pollType,
                                        options: opts,
                                        endsAtSecs: pollEndsAt
                                    )) ?? ""
                                } label: {
                                    Label("Create Poll", systemImage: "chart.bar.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !pollJson.isEmpty {
                                    jsonBlock(pollJson)
                                }
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Poll Response")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(primaryText)
                                TextField("Poll Event ID (hex)", text: $pollResponseId)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                TextField("Response (option ID)", text: $pollResponseValue)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                Button {
                                    pollResponseJson = (try? createPollResponse(
                                        secretKey: nsecKey,
                                        pollEventIdHex: pollResponseId,
                                        response: pollResponseValue,
                                        isMultipleChoice: pollType == "multiplechoice"
                                    )) ?? ""
                                } label: {
                                    Label("Submit Response", systemImage: "checkmark.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nsecKey.isEmpty)
                                if !pollResponseJson.isEmpty {
                                    jsonBlock(pollResponseJson)
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Vanish Request (NIP-62)", systemImage: "flame.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Reason", text: $vanishReason)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Relays (comma-separated, empty for all)", text: $vanishRelays)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let relays = vanishRelays.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                vanishJson = (try? createVanishRequest(
                                    secretKey: nsecKey,
                                    reason: vanishReason,
                                    relayUrls: relays
                                )) ?? ""
                            } label: {
                                Label("Request Vanish", systemImage: "flame.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !vanishJson.isEmpty {
                                jsonBlock(vanishJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("SDK Client", systemImage: "antenna.radiowaves.left.and.right")
                                    .font(.headline)
                                    .foregroundStyle(accentText)
                                Spacer()
                                Text("nostr-sdk")
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(accentFill.opacity(colorScheme == .dark ? 0.18 : 0.12), in: Capsule())
                                    .foregroundStyle(accentText)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                TextField("Relay URL", text: $clientRelayUrl)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                HStack(spacing: 12) {
                                    Button {
                                        if nostrClient == nil {
                                            nostrClient = NostrClient()
                                        }
                                        let _ = try? nostrClient?.addRelay(url: clientRelayUrl)
                                        nostrClient?.connect()
                                        clientStatus = "Connected to \(clientRelayUrl)"
                                    } label: {
                                        Label("Connect", systemImage: "link")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())

                                    Button {
                                        nostrClient?.disconnect()
                                        clientStatus = "Disconnected"
                                    } label: {
                                        Label("Disconnect", systemImage: "link.badge.minus")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                }
                                TextEditor(text: $clientEventJson)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    if let eventId = try? nostrClient?.publishEvent(eventJson: clientEventJson) {
                                        clientStatus = "Published: \(eventId)"
                                    } else {
                                        clientStatus = "Publish failed"
                                    }
                                } label: {
                                    Label("Publish Event", systemImage: "paperplane.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nostrClient == nil)

                                Button {
                                    clientRelays = nostrClient?.getRelays() ?? []
                                    clientStatus = "Relays: \(clientRelays.joined(separator: ", "))"
                                } label: {
                                    Label("Get Relays", systemImage: "network")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nostrClient == nil)

                                TextEditor(text: $clientFilterJson)
                                    .frame(minHeight: 60)
                                    .padding(8)
                                    .background(cardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                    )
                                Button {
                                    clientFetchedEvents = (try? nostrClient?.fetchEvents(filterJson: clientFilterJson, timeoutSecs: 10)) ?? []
                                    clientStatus = "Fetched \(clientFetchedEvents.count) events"
                                } label: {
                                    Label("Fetch Events", systemImage: "arrow.down.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(PrimaryButtonStyle())
                                .disabled(nostrClient == nil || clientFilterJson.isEmpty)
                                if !clientFetchedEvents.isEmpty {
                                    ForEach(clientFetchedEvents.indices, id: \.self) { i in
                                        jsonBlock(clientFetchedEvents[i])
                                    }
                                }

                                TextField("Target relay", text: $clientTargetRelay)
                                    .textFieldStyle(RoundedTextFieldStyle())
                                HStack(spacing: 12) {
                                    Button {
                                        if let result = try? nostrClient?.sendEventTo(eventJson: clientEventJson, relayUrls: [clientTargetRelay]) {
                                            clientStatus = result
                                        } else {
                                            clientStatus = "Send failed"
                                        }
                                    } label: {
                                        Label("Send To", systemImage: "arrow.up.forward")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(nostrClient == nil)

                                    Button {
                                        if let result = try? nostrClient?.broadcastEvent(eventJson: clientEventJson) {
                                            clientStatus = result
                                        } else {
                                            clientStatus = "Broadcast failed"
                                        }
                                    } label: {
                                        Label("Broadcast", systemImage: "antenna.radiowaves.left.and.right")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(nostrClient == nil)
                                }

                                HStack(spacing: 12) {
                                    TextField("Remove relay URL", text: $clientRemoveRelay)
                                        .textFieldStyle(RoundedTextFieldStyle())
                                    Button {
                                        let _ = try? nostrClient?.removeRelay(url: clientRemoveRelay)
                                        clientStatus = "Removed \(clientRemoveRelay)"
                                    } label: {
                                        Label("Remove", systemImage: "minus.circle.fill")
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .disabled(nostrClient == nil)
                                }

                                if !clientStatus.isEmpty {
                                    Text(clientStatus)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(primaryText.opacity(0.84))
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("User Status (NIP-38)", systemImage: "person.fill.checkmark")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Status type (general/music/custom)", text: $userStatusType)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Status content", text: $userStatusContent)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Reference URL (optional)", text: $userStatusRef)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                userStatusJson = (try? createUserStatus(
                                    secretKey: nsecKey,
                                    statusType: userStatusType,
                                    content: userStatusContent,
                                    expirationSecs: 0,
                                    referenceUrl: userStatusRef
                                )) ?? ""
                            } label: {
                                Label("Create Status", systemImage: "person.fill.checkmark")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !userStatusJson.isEmpty {
                                jsonBlock(userStatusJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Metadata + Identities (NIP-39)", systemImage: "person.crop.circle.badge.checkmark")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Name", text: $metadataName)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("About", text: $metadataAbout)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Picture URL", text: $metadataPicture)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Identities (comma-separated platform:ident:proof)", text: $metadataIdentities)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let ids = metadataIdentities.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                metadataWithIdentitiesJson = (try? createMetadataWithIdentities(
                                    secretKey: nsecKey,
                                    name: metadataName,
                                    about: metadataAbout,
                                    picture: metadataPicture,
                                    identities: ids
                                )) ?? ""
                            } label: {
                                Label("Create Metadata", systemImage: "person.crop.circle.badge.checkmark")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !metadataWithIdentitiesJson.isEmpty {
                                jsonBlock(metadataWithIdentitiesJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("ncryptsec (NIP-49)", systemImage: "lock.shield.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Password", text: $nip49Password)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("log_n (default 16)", value: $nip49LogN, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                nip49Ncryptsec = (try? nip49Encrypt(secretKey: nsecKey, password: nip49Password, logN: nip49LogN)) ?? ""
                            } label: {
                                Label("Encrypt nsec", systemImage: "lock.shield.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || nip49Password.isEmpty)
                            if !nip49Ncryptsec.isEmpty {
                                keyRow(label: "ncryptsec", value: nip49Ncryptsec)
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            TextField("ncryptsec", text: $nip49Ncryptsec)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                nip49Decrypted = (try? nip49Decrypt(ncryptsec: nip49Ncryptsec, password: nip49Password)) ?? ""
                            } label: {
                                Label("Decrypt nsec", systemImage: "lock.open.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nip49Ncryptsec.isEmpty || nip49Password.isEmpty)
                            if !nip49Decrypted.isEmpty {
                                keyRow(label: "Decrypted nsec", value: nip49Decrypted)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Custom Emoji (NIP-30)", systemImage: "face.smiling.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Emojis (name:url, ...)", text: $emojiList)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let emojis = emojiList.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                emojiListJson = (try? createCustomEmojiList(secretKey: nsecKey, emojis: emojis)) ?? ""
                            } label: {
                                Label("Create Emoji List", systemImage: "face.smiling.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !emojiListJson.isEmpty {
                                jsonBlock(emojiListJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("App Handler (NIP-89)", systemImage: "app.badge.checkmark.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("App Kind", value: $appKind, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Handler Event ID (hex)", text: $appHandlerId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Handler Pubkey (hex)", text: $appHandlerPubkey)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                appHandlerJson = (try? createAppHandlerRecommendation(
                                    secretKey: nsecKey,
                                    appKind: appKind,
                                    handlerEventIdHex: appHandlerId,
                                    handlerPubkeyHex: appHandlerPubkey,
                                    relayUrls: []
                                )) ?? ""
                            } label: {
                                Label("Recommend Handler", systemImage: "app.badge.checkmark.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || appHandlerId.isEmpty || appHandlerPubkey.isEmpty)
                            if !appHandlerJson.isEmpty {
                                jsonBlock(appHandlerJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Generic Event Builder", systemImage: "hammer.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Kind", value: $genericKind, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Content", text: $genericContent)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextEditor(text: $genericTags)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            Button {
                                genericJson = (try? createGenericEvent(
                                    secretKey: nsecKey,
                                    kind: genericKind,
                                    content: genericContent,
                                    tagsJson: genericTags
                                )) ?? ""
                            } label: {
                                Label("Build Event", systemImage: "hammer.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty)
                            if !genericJson.isEmpty {
                                jsonBlock(genericJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Filter + Search (NIP-50)", systemImage: "magnifyingglass.circle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Authors (comma-separated hex)", text: $searchFilterAuthors)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Kinds (comma-separated)", text: $searchFilterKinds)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Search query", text: $searchQuery)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let authors = searchFilterAuthors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                let kinds = searchFilterKinds.split(separator: ",").compactMap { UInt16($0.trimmingCharacters(in: .whitespaces)) }
                                searchFilterJson = (try? buildFilterWithSearch(
                                    authorsHex: authors,
                                    kinds: kinds,
                                    search: searchQuery,
                                    sinceSecs: 0,
                                    untilSecs: 0,
                                    limit: 100
                                )) ?? ""
                            } label: {
                                Label("Build Search Filter", systemImage: "magnifyingglass.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            if !searchFilterJson.isEmpty {
                                jsonBlock(searchFilterJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Nostr Connect (NIP-46)", systemImage: "link.circle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $nconnectMessage)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            Button {
                                nconnectParsed = (try? nostrConnectParseRequest(messageJson: nconnectMessage)) ?? ""
                            } label: {
                                Label("Parse Request", systemImage: "doc.text.magnifyingglass")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nconnectMessage.isEmpty)
                            if !nconnectParsed.isEmpty {
                                Text(nconnectParsed)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(primaryText.opacity(0.84))
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            TextField("Request ID", text: $nconnectReqId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                nconnectResponse = (try? nostrConnectCreateResponse(reqId: nconnectReqId, result: "ack", error: nil)) ?? ""
                            } label: {
                                Label("Create Response", systemImage: "arrowshape.turn.up.left.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nconnectReqId.isEmpty)
                            if !nconnectResponse.isEmpty {
                                jsonBlock(nconnectResponse)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Event Tag Values", systemImage: "tag.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $tagEventInput)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Tag name", text: $tagName)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                tagValuesResult = (try? eventTagValues(eventJson: tagEventInput, tagName: tagName)) ?? []
                            } label: {
                                Label("Extract Tags", systemImage: "tag.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(tagEventInput.isEmpty)
                            if !tagValuesResult.isEmpty {
                                ForEach(tagValuesResult.indices, id: \.self) { i in
                                    Text(tagValuesResult[i])
                                        .font(.caption.monospaced())
                                        .foregroundStyle(primaryText.opacity(0.84))
                                }
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Git Issue (NIP-34)", systemImage: "curlybraces.square.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Repo Pubkey (hex)", text: $gitRepoPubkey)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Subject", text: $gitIssueSubject)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextEditor(text: $gitIssueContent)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Labels (comma-separated)", text: $gitIssueLabels)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let labels = gitIssueLabels.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                gitIssueJson = (try? createGitIssue(
                                    secretKey: nsecKey,
                                    repoPubkeyHex: gitRepoPubkey,
                                    content: gitIssueContent,
                                    subject: gitIssueSubject,
                                    labels: labels
                                )) ?? ""
                            } label: {
                                Label("Create Issue", systemImage: "curlybraces.square.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || gitRepoPubkey.isEmpty)
                            if !gitIssueJson.isEmpty {
                                jsonBlock(gitIssueJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Comments (NIP-22)", systemImage: "bubble.left.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextEditor(text: $commentContent)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Target Event ID (hex)", text: $commentTargetId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Target Kind", value: $commentTargetKind, format: .number)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Target Author (hex)", text: $commentTargetAuthor)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Root Event ID (optional)", text: $commentRootId)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let rootOpt: String? = commentRootId.isEmpty ? nil : commentRootId
                                commentJson = (try? createCommentEvent(
                                    secretKey: nsecKey,
                                    content: commentContent,
                                    targetEventIdHex: commentTargetId,
                                    targetKind: commentTargetKind,
                                    targetAuthorPubkeyHex: commentTargetAuthor,
                                    rootEventIdHex: rootOpt
                                )) ?? ""
                            } label: {
                                Label("Create Comment", systemImage: "bubble.left.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || commentTargetId.isEmpty || commentTargetAuthor.isEmpty)
                            if !commentJson.isEmpty {
                                jsonBlock(commentJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Torrents (NIP-35)", systemImage: "arrow.down.circle.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Title", text: $torrentTitle)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextEditor(text: $torrentDescription)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            TextField("Info Hash (hex)", text: $torrentInfoHash)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Files (name:size, ...)", text: $torrentFiles)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Trackers (comma-separated URLs)", text: $torrentTrackers)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Categories (comma-separated)", text: $torrentCategories)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Hashtags (comma-separated)", text: $torrentHashtags)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let files = torrentFiles.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                let trackers = torrentTrackers.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                let cats = torrentCategories.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                let tags = torrentHashtags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                torrentJson = (try? createTorrentEvent(
                                    secretKey: nsecKey,
                                    title: torrentTitle,
                                    description: torrentDescription,
                                    infoHashHex: torrentInfoHash,
                                    files: files,
                                    trackers: trackers,
                                    categories: cats,
                                    hashtags: tags
                                )) ?? ""
                            } label: {
                                Label("Create Torrent", systemImage: "arrow.down.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || torrentInfoHash.isEmpty)
                            if !torrentJson.isEmpty {
                                jsonBlock(torrentJson)
                            }
                        }
                    }

                    glassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Label("Cashu Wallet (NIP-60)", systemImage: "wallet.pass.fill")
                                .font(.headline)
                                .foregroundStyle(accentText)

                            TextField("Wallet Privkey", text: $cashuWalletPrivkey)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextField("Mints (comma-separated URLs)", text: $cashuMints)
                                .textFieldStyle(RoundedTextFieldStyle())
                            Button {
                                let mints = cashuMints.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                                cashuWalletJson = (try? createCashuWallet(
                                    secretKey: nsecKey,
                                    walletPrivkey: cashuWalletPrivkey,
                                    mintUrls: mints
                                )) ?? ""
                            } label: {
                                Label("Create Wallet", systemImage: "wallet.pass.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || cashuWalletPrivkey.isEmpty)
                            if !cashuWalletJson.isEmpty {
                                jsonBlock(cashuWalletJson)
                            }

                            Divider()
                                .overlay(accentFill.opacity(colorScheme == .dark ? 0.22 : 0.16))

                            TextField("Token Mint URL", text: $cashuTokenMint)
                                .textFieldStyle(RoundedTextFieldStyle())
                            TextEditor(text: $cashuTokenProofs)
                                .frame(minHeight: 60)
                                .padding(8)
                                .background(cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
                                )
                            Button {
                                cashuTokenJson = (try? createCashuToken(
                                    secretKey: nsecKey,
                                    mintUrl: cashuTokenMint,
                                    proofsJson: cashuTokenProofs
                                )) ?? ""
                            } label: {
                                Label("Create Token", systemImage: "bitcoinsign.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(nsecKey.isEmpty || cashuTokenMint.isEmpty)
                            if !cashuTokenJson.isEmpty {
                                jsonBlock(cashuTokenJson)
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Swifty Rust")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(primaryText)

                    Text("A polished SwiftUI shell with the same warm tone as the new icon.")
                        .font(.subheadline)
                        .foregroundStyle(primaryText.opacity(0.74))
                }

                Spacer()

                Image(colorScheme == .dark ? "RustOrb" : "RustOrbLight")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 76, height: 76)
                    .padding(12)
                    .background(
                        colorScheme == .dark
                            ? .white.opacity(0.04)
                            : .white.opacity(0.78),
                        in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(
                                colorScheme == .dark
                                    ? Color(red: 1.0, green: 0.66, blue: 0.24).opacity(0.26)
                                    : Color(red: 0.52, green: 0.62, blue: 0.72).opacity(0.22),
                                lineWidth: 1
                            )
                    )
            }

            HStack(spacing: 8) {
                pill(text: "SwiftUI")
                pill(text: "UniFFI")
                pill(text: "Rust")
                pill(text: "Nostr")
            }
        }
        .padding(.bottom, 4)
    }

    private func pill(text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(accentFill.opacity(colorScheme == .dark ? 0.14 : 0.10), in: Capsule())
            .foregroundStyle(accentText)
    }

    private func glassCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(accentFill.opacity(colorScheme == .dark ? 0.20 : 0.14), lineWidth: 1)
            )
            .shadow(color: .black.opacity(colorScheme == .dark ? 0.28 : 0.12), radius: 18, x: 0, y: 10)
    }

    private func stepperRow(title: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(primaryText.opacity(0.92))
                Text("Tap +/- or use the randomizer")
                    .font(.caption)
                    .foregroundStyle(primaryText.opacity(0.62))
            }

            Spacer()

            Stepper(value: value, in: range) {
                Text("\(value.wrappedValue)")
                    .font(.title3.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(primaryText)
                    .frame(minWidth: 44, alignment: .trailing)
            }
            .labelsHidden()
            .tint(accentFill)
        }
    }

    private func keyRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(primaryText.opacity(0.68))
                Spacer()
                Button {
                    UIPasteboard.general.string = value
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(accentFill)
                }
            }
            Text(value)
                .font(.caption.monospaced())
                .foregroundStyle(primaryText.opacity(0.84))
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding(10)
        .background(cardBackground)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(accentFill.opacity(colorScheme == .dark ? 0.15 : 0.10), lineWidth: 1)
        )
    }

    private func jsonBlock(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("JSON Output")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(primaryText.opacity(0.68))
                Spacer()
                Button {
                    UIPasteboard.general.string = text
                } label: {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                        .foregroundStyle(accentFill)
                }
            }
            ScrollView(.horizontal, showsIndicators: true) {
                Text(text)
                    .font(.caption2.monospaced())
                    .foregroundStyle(primaryText.opacity(0.84))
                    .lineLimit(nil)
            }
            .padding(10)
            .background(cardBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(accentFill.opacity(colorScheme == .dark ? 0.15 : 0.10), lineWidth: 1)
            )
        }
    }

    private var primaryText: Color {
        colorScheme == .dark ? .white : Color(red: 0.10, green: 0.14, blue: 0.20)
    }

    private var accentFill: Color {
        colorScheme == .dark ? Color(red: 1.0, green: 0.66, blue: 0.24) : Color(red: 0.82, green: 0.38, blue: 0.10)
    }

    private var accentText: Color {
        colorScheme == .dark ? Color(red: 1.0, green: 0.86, blue: 0.62) : Color(red: 0.42, green: 0.24, blue: 0.12)
    }

    private var cardBackground: Color {
        colorScheme == .dark ? .white.opacity(0.05) : .white.opacity(0.76)
    }
}

private struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white.opacity(0.06))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .padding(.vertical, 14)
            .foregroundStyle(.white)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 1.0, green: 0.56, blue: 0.12),
                        Color(red: 0.93, green: 0.30, blue: 0.08)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
    }
}

#Preview {
    ContentView()
}
