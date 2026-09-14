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

    // SDK Client
    @State private var clientRelayUrl = "wss://relay.damus.io"
    @State private var clientEventJson = ""
    @State private var clientStatus = ""
    @State private var nostrClient: NostrClient? = nil
    @State private var clientRelays: [String] = []

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

                                if !clientStatus.isEmpty {
                                    Text(clientStatus)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(primaryText.opacity(0.84))
                                }
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
