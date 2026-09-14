uniffi::setup_scaffolding!();

use nostr::prelude::*;

#[derive(uniffi::Record)]
pub struct Nip19Result {
    pub prefix: String,
    pub data: String,
}

#[derive(Debug, uniffi::Error)]
pub enum NostrError {
    Invalid(String),
    Encoding(String),
    Event(String),
}

impl std::fmt::Display for NostrError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            NostrError::Invalid(msg) => write!(f, "Invalid input: {}", msg),
            NostrError::Encoding(msg) => write!(f, "Encoding failed: {}", msg),
            NostrError::Event(msg) => write!(f, "Event error: {}", msg),
        }
    }
}

impl From<Error> for NostrError {
    fn from(e: Error) -> Self {
        NostrError::Invalid(e.to_string())
    }
}

impl From<std::convert::Infallible> for NostrError {
    fn from(_: std::convert::Infallible) -> Self {
        NostrError::Invalid("infallible".to_string())
    }
}

#[uniffi::export]
pub fn generate_keys() -> String {
    let keys = Keys::generate();
    keys.secret_key().to_secret_hex()
}

#[uniffi::export]
pub fn get_public_key(secret_key: String) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    Ok(keys.public_key().to_bech32()?)
}

#[uniffi::export]
pub fn nip19_encode(data_hex: String, prefix: String) -> Result<String, NostrError> {
    match prefix.as_str() {
        "npub" => {
            let pk = PublicKey::from_hex(&data_hex)?;
            Ok(pk.to_bech32()?)
        }
        "nsec" => {
            let sk = SecretKey::from_hex(&data_hex)?;
            Ok(sk.to_bech32()?)
        }
        "note" => {
            let id = EventId::from_hex(&data_hex)?;
            Ok(id.to_bech32()?)
        }
        _ => Err(NostrError::Encoding(format!(
            "Unsupported prefix: {}. Use npub, nsec, or note.",
            prefix
        ))),
    }
}

#[uniffi::export]
pub fn nip19_decode(bech32: String) -> Result<Nip19Result, NostrError> {
    let decoded = Nip19::from_bech32(&bech32)?;
    let result = match decoded {
        Nip19::Secret(sk) => Nip19Result {
            prefix: "nsec".to_string(),
            data: sk.to_secret_hex(),
        },
        Nip19::Pubkey(pk) => Nip19Result {
            prefix: "npub".to_string(),
            data: pk.to_hex(),
        },
        Nip19::EventId(id) => Nip19Result {
            prefix: "note".to_string(),
            data: id.to_hex(),
        },
        Nip19::Event(ev) => Nip19Result {
            prefix: "nevent".to_string(),
            data: ev.event_id.to_hex(),
        },
        Nip19::Profile(pr) => Nip19Result {
            prefix: "nprofile".to_string(),
            data: pr.public_key.to_hex(),
        },
        Nip19::Coordinate(co) => Nip19Result {
            prefix: "naddr".to_string(),
            data: format!("{}:{}:{}", co.kind, co.public_key.to_hex(), co.identifier),
        },
        Nip19::EncryptedSecret(_) => Nip19Result {
            prefix: "ncryptsec".to_string(),
            data: "<encrypted secret key>".to_string(),
        },
    };
    Ok(result)
}

#[uniffi::export]
pub fn create_text_note(secret_key: String, content: String) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event = EventBuilder::new(Kind::TextNote, content).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_metadata_event(
    secret_key: String,
    name: String,
    about: String,
    picture: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let mut metadata = Metadata::new().name(name).about(about);
    if let Ok(url) = Url::parse(&picture) {
        metadata = metadata.picture(url);
    }
    let event = metadata.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn verify_event(event_json: String) -> Result<bool, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.verify_id() && event.verify_signature())
}

#[uniffi::export]
pub fn event_id(event_json: String) -> Result<String, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.id.to_hex())
}

#[uniffi::export]
pub fn nip04_encrypt(
    secret_key: String,
    recipient_pubkey: String,
    content: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let pk = PublicKey::from_hex(&recipient_pubkey)?;
    Ok(keys.nip04_encrypt(&pk, &content)?)
}

#[uniffi::export]
pub fn nip04_decrypt(
    secret_key: String,
    sender_pubkey: String,
    encrypted_content: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let pk = PublicKey::from_hex(&sender_pubkey)?;
    Ok(keys.nip04_decrypt(&pk, &encrypted_content)?)
}

#[uniffi::export]
pub fn nip44_encrypt(
    secret_key: String,
    recipient_pubkey: String,
    content: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let pk = PublicKey::from_hex(&recipient_pubkey)?;
    Ok(keys.nip44_encrypt(&pk, &content)?)
}

#[uniffi::export]
pub fn nip44_decrypt(
    secret_key: String,
    sender_pubkey: String,
    payload: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let pk = PublicKey::from_hex(&sender_pubkey)?;
    Ok(keys.nip44_decrypt(&pk, &payload)?)
}

#[uniffi::export]
pub fn create_contact_list(
    secret_key: String,
    pubkeys_hex: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let contacts: Vec<Contact> = pubkeys_hex
        .into_iter()
        .map(|hex| Ok(Contact::new(PublicKey::from_hex(&hex)?)))
        .collect::<Result<Vec<Contact>, Error>>()?;
    let event = ContactListBuilder::new(contacts).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn nip21_encode(data_hex: String, prefix: String) -> Result<String, NostrError> {
    match prefix.as_str() {
        "npub" => {
            let pk = PublicKey::from_hex(&data_hex)?;
            Ok(pk.to_nostr_uri()?)
        }
        "note" => {
            let id = EventId::from_hex(&data_hex)?;
            Ok(id.to_nostr_uri()?)
        }
        _ => Err(NostrError::Encoding(format!(
            "Unsupported NIP-21 prefix: {}. Use npub or note.",
            prefix
        ))),
    }
}

#[uniffi::export]
pub fn nip21_decode(nostr_uri: String) -> Result<Nip19Result, NostrError> {
    if let Ok(pk) = PublicKey::from_nostr_uri(&nostr_uri) {
        return Ok(Nip19Result {
            prefix: "npub".to_string(),
            data: pk.to_hex(),
        });
    }
    if let Ok(id) = EventId::from_nostr_uri(&nostr_uri) {
        return Ok(Nip19Result {
            prefix: "note".to_string(),
            data: id.to_hex(),
        });
    }
    Err(NostrError::Invalid(
        "Unsupported NIP-21 URI variant".to_string(),
    ))
}

#[derive(uniffi::Record)]
pub struct RelayEntry {
    pub url: String,
    pub mode: String,
}

#[uniffi::export]
pub fn create_reaction(
    secret_key: String,
    event_id_hex: String,
    author_pubkey_hex: String,
    event_kind: u16,
    content: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event_id = EventId::from_hex(&event_id_hex)?;
    let author = PublicKey::from_hex(&author_pubkey_hex)?;
    let kind = Kind::from(event_kind);
    let event = EventBuilder::new(Kind::Reaction, content)
        .tags([
            Tag::event(event_id),
            Tag::public_key(author),
            Tag::parse(["k", &kind.as_u16().to_string()])?,
        ])
        .finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_repost(secret_key: String, event_json: String) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event = Event::from_json(event_json)?;
    let repost = RepostBuilder::new(&event).finalize(&keys)?;
    Ok(repost.as_json())
}

#[uniffi::export]
pub fn create_relay_list(
    secret_key: String,
    relays: Vec<RelayEntry>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let list: Vec<(RelayUrl, Option<RelayMetadata>)> = relays
        .into_iter()
        .map(|r| {
            let url = RelayUrl::parse(&r.url)?;
            let meta = match r.mode.as_str() {
                "read" => Some(RelayMetadata::Read),
                "write" => Some(RelayMetadata::Write),
                _ => None,
            };
            Ok((url, meta))
        })
        .collect::<Result<Vec<_>, Error>>()?;
    let event = RelayList::new(list).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_deletion_request(
    secret_key: String,
    event_ids_hex: Vec<String>,
    reason: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let ids: Vec<EventId> = event_ids_hex
        .into_iter()
        .map(|hex| EventId::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let request = EventDeletionRequest::new().ids(ids).reason(reason);
    let event = request.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_auth_event(
    secret_key: String,
    challenge: String,
    relay_url: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let relay = RelayUrl::parse(&relay_url)?;
    let auth = ClientAuthentication::new(challenge, relay);
    let event = auth.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_zap_request(
    secret_key: String,
    recipient_pubkey_hex: String,
    relay_urls: Vec<String>,
    message: String,
    amount_millisats: u64,
    event_id_hex: Option<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let recipient = PublicKey::from_hex(&recipient_pubkey_hex)?;
    let relays: Vec<RelayUrl> = relay_urls
        .into_iter()
        .map(|url| RelayUrl::parse(&url))
        .collect::<Result<Vec<_>, _>>()?;
    let mut data = ZapRequestData::new(recipient, relays).message(message).amount(amount_millisats);
    if let Some(hex) = event_id_hex {
        data = data.event_id(EventId::from_hex(&hex)?);
    }
    let event = data.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn build_filter(
    authors_hex: Vec<String>,
    kinds: Vec<u16>,
    ids_hex: Vec<String>,
    since_secs: u64,
    until_secs: u64,
    limit: u64,
) -> Result<String, NostrError> {
    let mut filter = Filter::new();
    if !authors_hex.is_empty() {
        let authors: Vec<PublicKey> = authors_hex
            .into_iter()
            .map(|hex| PublicKey::from_hex(&hex))
            .collect::<Result<Vec<_>, _>>()?;
        filter = filter.authors(authors);
    }
    if !kinds.is_empty() {
        let kind_set: Vec<Kind> = kinds.into_iter().map(Kind::from).collect();
        filter = filter.kinds(kind_set);
    }
    if !ids_hex.is_empty() {
        let ids: Vec<EventId> = ids_hex
            .into_iter()
            .map(|hex| EventId::from_hex(&hex))
            .collect::<Result<Vec<_>, _>>()?;
        filter = filter.ids(ids);
    }
    if since_secs > 0 {
        filter = filter.since(Timestamp::from_secs(since_secs));
    }
    if until_secs > 0 {
        filter = filter.until(Timestamp::from_secs(until_secs));
    }
    if limit > 0 {
        filter = filter.limit(limit as usize);
    }
    Ok(filter.as_json())
}

#[uniffi::export]
pub fn filter_matches_event(filter_json: String, event_json: String) -> Result<bool, NostrError> {
    let filter = Filter::from_json(filter_json)?;
    let event = Event::from_json(event_json)?;
    Ok(filter.match_event(&event, MatchEventOptions::new()))
}

#[uniffi::export]
pub fn event_created_at(event_json: String) -> Result<u64, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.created_at.as_secs())
}

#[uniffi::export]
pub fn event_kind_value(event_json: String) -> Result<u16, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.kind.as_u16())
}

#[uniffi::export]
pub fn event_pubkey_hex(event_json: String) -> Result<String, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.pubkey.to_hex())
}

#[derive(uniffi::Record)]
pub struct Nip05ProfileResult {
    pub pubkey_hex: String,
    pub relays: Vec<String>,
}

#[uniffi::export]
pub fn verify_nip05(pubkey_hex: String, address: String, json_raw: String) -> Result<bool, NostrError> {
    let pk = PublicKey::from_hex(&pubkey_hex)?;
    let addr = Nip05Address::parse(&address)?;
    Ok(verify_from_raw_json(&pk, &addr, &json_raw)?)
}

#[uniffi::export]
pub fn parse_nip05_profile(address: String, json_raw: String) -> Result<Nip05ProfileResult, NostrError> {
    let addr = Nip05Address::parse(&address)?;
    let profile = Nip05Profile::from_raw_json(&addr, &json_raw)?;
    Ok(Nip05ProfileResult {
        pubkey_hex: profile.public_key.to_hex(),
        relays: profile.relays.into_iter().map(|r| r.to_string()).collect(),
    })
}

#[uniffi::export]
pub fn create_gift_wrap(
    secret_key: String,
    recipient_pubkey_hex: String,
    rumor_kind: u16,
    rumor_content: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let recipient = PublicKey::from_hex(&recipient_pubkey_hex)?;
    let rumor = EventBuilder::new(Kind::from(rumor_kind), rumor_content)
        .finalize_unsigned(keys.public_key());
    let gift_wrap = GiftWrapBuilder::new(recipient, rumor).finalize(&keys)?;
    Ok(gift_wrap.as_json())
}

#[uniffi::export]
pub fn create_private_message(
    secret_key: String,
    recipient_pubkey_hex: String,
    message: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let recipient = PublicKey::from_hex(&recipient_pubkey_hex)?;
    let event = PrivateDirectMessageBuilder::new(recipient, message).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_http_auth(
    secret_key: String,
    url: String,
    method: String,
    payload_hash: Option<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let url = Url::parse(&url).map_err(|e| NostrError::Invalid(e.to_string()))?;
    let method = match method.as_str() {
        "GET" => HttpMethod::GET,
        "POST" => HttpMethod::POST,
        "PUT" => HttpMethod::PUT,
        "PATCH" => HttpMethod::PATCH,
        _ => return Err(NostrError::Invalid("Unsupported HTTP method".to_string())),
    };
    let payload = payload_hash.map(|h| Sha256Hash::from_hex(&h)).transpose()?;
    let data = HttpData { url, method, payload };
    let event = data.into_event_builder().finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_long_form(
    secret_key: String,
    title: String,
    content: String,
    summary: String,
    image: String,
    published_at: u64,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let mut tags: Vec<Tag> = vec![Tag::parse(["title", &title])?];
    if !summary.is_empty() {
        tags.push(Tag::parse(["summary", &summary])?);
    }
    if let Ok(img_url) = Url::parse(&image) {
        tags.push(Tag::parse(["image", img_url.as_str()])?);
    }
    if published_at > 0 {
        tags.push(Tag::parse(["published_at", &published_at.to_string()])?);
    }
    let event = EventBuilder::new(Kind::LongFormTextNote, content)
        .tags(tags)
        .finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_report_event(
    secret_key: String,
    target_event_id: Option<String>,
    target_pubkey: Option<String>,
    report_type: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let report = match report_type.as_str() {
        "nudity" => Report::Nudity,
        "malware" => Report::Malware,
        "profanity" => Report::Profanity,
        "illegal" => Report::Illegal,
        "spam" => Report::Spam,
        "impersonation" => Report::Impersonation,
        _ => Report::Other,
    };
    let tag = if let Some(hex) = target_event_id {
        Tag::parse(["e", &hex, &report.to_string()])?
    } else if let Some(hex) = target_pubkey {
        Tag::parse(["p", &hex, &report.to_string()])?
    } else {
        return Err(NostrError::Invalid("Provide either target_event_id or target_pubkey".to_string()));
    };
    let event = EventBuilder::new(Kind::Reporting, "").tags([tag]).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_badge_definition(
    secret_key: String,
    badge_id: String,
    name: String,
    description: String,
    image_url: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let mut badge = nip58::BadgeDefinition::new(badge_id);
    if !name.is_empty() {
        badge = badge.name(name);
    }
    if !description.is_empty() {
        badge = badge.description(description);
    }
    if let Ok(url) = Url::parse(&image_url) {
        badge = badge.image(url, None);
    }
    let event = badge.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_badge_award(
    secret_key: String,
    badge_definition_json: String,
    awarded_pubkeys_hex: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let badge_event = Event::from_json(badge_definition_json)?;
    let pubkeys: Vec<PublicKey> = awarded_pubkeys_hex
        .into_iter()
        .map(|hex| PublicKey::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let award = nip58::BadgeAward::new(&badge_event, pubkeys)?;
    let event = award.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_mute_list(
    secret_key: String,
    pubkeys_hex: Vec<String>,
    event_ids_hex: Vec<String>,
    words: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let pubkeys: Vec<PublicKey> = pubkeys_hex
        .into_iter()
        .map(|hex| PublicKey::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let event_ids: Vec<EventId> = event_ids_hex
        .into_iter()
        .map(|hex| EventId::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let list = MuteList {
        public_keys: pubkeys,
        hashtags: Vec::new(),
        event_ids,
        words,
    };
    let event = list.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_bookmarks(
    secret_key: String,
    event_ids_hex: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event_ids: Vec<EventId> = event_ids_hex
        .into_iter()
        .map(|hex| EventId::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let bookmarks = Bookmarks {
        event_ids,
        coordinate: Vec::new(),
    };
    let event = bookmarks.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn event_content(event_json: String) -> Result<String, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.content)
}

#[uniffi::export]
pub fn event_signature_valid(event_json: String) -> Result<bool, NostrError> {
    let event = Event::from_json(event_json)?;
    Ok(event.verify_signature())
}

#[uniffi::export]
pub fn nip19_encode_event(
    event_id_hex: String,
    author_pubkey_hex: Option<String>,
    kind: Option<u16>,
    relay_urls: Vec<String>,
) -> Result<String, NostrError> {
    let event_id = EventId::from_hex(&event_id_hex)?;
    let mut nevent = Nip19Event::new(event_id);
    if let Some(hex) = author_pubkey_hex {
        nevent = nevent.author(PublicKey::from_hex(&hex)?);
    }
    if let Some(k) = kind {
        nevent = nevent.kind(Kind::from(k));
    }
    let relays: Vec<RelayUrl> = relay_urls
        .into_iter()
        .map(|url| RelayUrl::parse(&url))
        .collect::<Result<Vec<_>, _>>()?;
    nevent = nevent.relays(relays);
    Ok(nevent.to_bech32()?)
}

#[uniffi::export]
pub fn nip19_encode_profile(
    pubkey_hex: String,
    relay_urls: Vec<String>,
) -> Result<String, NostrError> {
    let pk = PublicKey::from_hex(&pubkey_hex)?;
    let relays: Vec<RelayUrl> = relay_urls
        .into_iter()
        .map(|url| RelayUrl::parse(&url))
        .collect::<Result<Vec<_>, _>>()?;
    let profile = Nip19Profile::new(pk, relays);
    Ok(profile.to_bech32()?)
}

#[uniffi::export]
pub fn nip19_encode_coordinate(
    kind: u16,
    pubkey_hex: String,
    identifier: String,
    relay_urls: Vec<String>,
) -> Result<String, NostrError> {
    let pk = PublicKey::from_hex(&pubkey_hex)?;
    let coordinate = Coordinate::new(Kind::from(kind), pk).identifier(identifier);
    let relays: Vec<RelayUrl> = relay_urls
        .into_iter()
        .map(|url| RelayUrl::parse(&url))
        .collect::<Result<Vec<_>, _>>()?;
    let naddr = Nip19Coordinate::new(coordinate, relays);
    Ok(naddr.to_bech32()?)
}

#[derive(uniffi::Record)]
pub struct Nip19EventResult {
    pub event_id_hex: String,
    pub author_hex: String,
    pub kind: u16,
    pub relays: Vec<String>,
}

#[derive(uniffi::Record)]
pub struct Nip19ProfileResult {
    pub pubkey_hex: String,
    pub relays: Vec<String>,
}

#[derive(uniffi::Record)]
pub struct Nip19CoordinateResult {
    pub kind: u16,
    pub pubkey_hex: String,
    pub identifier: String,
    pub relays: Vec<String>,
}

#[uniffi::export]
pub fn nip19_decode_event(bech32: String) -> Result<Nip19EventResult, NostrError> {
    let ev = Nip19Event::from_bech32(&bech32)?;
    Ok(Nip19EventResult {
        event_id_hex: ev.event_id.to_hex(),
        author_hex: ev.author.map(|a| a.to_hex()).unwrap_or_default(),
        kind: ev.kind.map(|k| k.as_u16()).unwrap_or(0),
        relays: ev.relays.into_iter().map(|r| r.to_string()).collect(),
    })
}

#[uniffi::export]
pub fn nip19_decode_profile(bech32: String) -> Result<Nip19ProfileResult, NostrError> {
    let profile = Nip19Profile::from_bech32(&bech32)?;
    Ok(Nip19ProfileResult {
        pubkey_hex: profile.public_key.to_hex(),
        relays: profile.relays.into_iter().map(|r| r.to_string()).collect(),
    })
}

#[uniffi::export]
pub fn nip19_decode_coordinate(bech32: String) -> Result<Nip19CoordinateResult, NostrError> {
    let coord = Nip19Coordinate::from_bech32(&bech32)?;
    Ok(Nip19CoordinateResult {
        kind: coord.kind.as_u16(),
        pubkey_hex: coord.public_key.to_hex(),
        identifier: coord.identifier.clone(),
        relays: coord.relays.into_iter().map(|r| r.to_string()).collect(),
    })
}

#[uniffi::export]
pub fn create_file_metadata(
    secret_key: String,
    description: String,
    url: String,
    mime_type: String,
    hash_hex: String,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let url = Url::parse(&url).map_err(|e| NostrError::Invalid(e.to_string()))?;
    let hash = Sha256Hash::from_hex(&hash_hex)?;
    let metadata = FileMetadata::new(url, mime_type, hash);
    let event = FileMetadataEventBuilder::new(description, metadata).finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn event_tags_json(event_json: String) -> Result<String, NostrError> {
    let event = Event::from_json(event_json)?;
    let mut result = String::from("[");
    for (i, tag) in event.tags.iter().enumerate() {
        if i > 0 { result.push_str(", "); }
        result.push('[');
        for (j, s) in tag.as_slice().iter().enumerate() {
            if j > 0 { result.push_str(", "); }
            result.push_str(&format!("\"{}\"", s.replace('"', "\\\"")));
        }
        result.push(']');
    }
    result.push(']');
    Ok(result)
}

#[uniffi::export]
pub fn add_expiration_to_event(
    secret_key: String,
    event_json: String,
    expiration_secs: u64,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event = Event::from_json(event_json)?;
    let mut tags = event.tags.to_vec();
    tags.push(Tag::parse(["expiration", &expiration_secs.to_string()])?);
    let new_event = EventBuilder::new(event.kind, event.content).tags(tags).finalize(&keys)?;
    Ok(new_event.as_json())
}

#[uniffi::export]
pub fn create_pinned_notes(
    secret_key: String,
    event_ids_hex: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let event_ids: Vec<EventId> = event_ids_hex
        .into_iter()
        .map(|hex| EventId::from_hex(&hex))
        .collect::<Result<Vec<_>, _>>()?;
    let pinned = PinnedNotes::new(event_ids);
    let event = pinned.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_interests(
    secret_key: String,
    hashtags: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let interests = Interests {
        hashtags,
        coordinate: Vec::new(),
    };
    let event = interests.finalize(&keys)?;
    Ok(event.as_json())
}

#[uniffi::export]
pub fn create_relay_set(
    secret_key: String,
    identifier: String,
    relay_urls: Vec<String>,
) -> Result<String, NostrError> {
    let keys = Keys::parse(&secret_key)?;
    let relays: Vec<RelayUrl> = relay_urls
        .into_iter()
        .map(|url| RelayUrl::parse(&url))
        .collect::<Result<Vec<_>, _>>()?;
    let set = RelaySet::new(identifier, relays);
    let event = set.finalize(&keys)?;
    Ok(event.as_json())
}

// Nostr SDK client wrapper

use nostr_sdk::client::Client;
use std::sync::Arc;
use tokio::runtime::Runtime;
use std::time::Duration;

#[derive(uniffi::Object)]
pub struct NostrClient {
    runtime: Runtime,
    client: Client,
}

#[uniffi::export]
impl NostrClient {
    #[uniffi::constructor]
    pub fn new() -> Arc<Self> {
        let runtime = Runtime::new().expect("Failed to create Tokio runtime");
        let client = Client::new();
        Arc::new(Self { runtime, client })
    }

    pub fn add_relay(&self, url: String) -> Result<bool, NostrError> {
        self.runtime.block_on(async {
            self.client
                .add_relay(&url)
                .await
                .map_err(|e| NostrError::Invalid(e.to_string()))
        })
    }

    pub fn connect(&self) {
        self.runtime.block_on(async {
            self.client.connect().await;
        });
    }

    pub fn publish_event(&self, event_json: String) -> Result<String, NostrError> {
        let event = Event::from_json(event_json)?;
        let output = self.runtime.block_on(async {
            self.client
                .send_event(&event)
                .await
                .map_err(|e| NostrError::Invalid(e.to_string()))
        })?;
        Ok(output.id().to_hex())
    }

    pub fn disconnect(&self) {
        self.runtime.block_on(async {
            self.client.disconnect().await;
        });
    }

    pub fn get_relays(&self) -> Vec<String> {
        self.runtime.block_on(async {
            let relays = self.client.relays().all().await;
            relays.keys().map(|url| url.to_string()).collect()
        })
    }

    pub fn fetch_events(&self, filter_json: String, timeout_secs: u64) -> Result<Vec<String>, NostrError> {
        let filter = Filter::from_json(filter_json)?;
        let events = self.runtime.block_on(async {
            let fetch = self.client.fetch_events(filter);
            let fetch = if timeout_secs > 0 {
                fetch.timeout(Duration::from_secs(timeout_secs))
            } else {
                fetch
            };
            fetch.await.map_err(|e| NostrError::Invalid(e.to_string()))
        })?;
        Ok(events.into_iter().map(|e| e.as_json()).collect())
    }

    pub fn send_event_to(&self, event_json: String, relay_urls: Vec<String>) -> Result<String, NostrError> {
        let event = Event::from_json(event_json)?;
        let urls: Vec<RelayUrl> = relay_urls
            .into_iter()
            .map(|url| RelayUrl::parse(&url).map_err(|e| NostrError::Invalid(e.to_string())))
            .collect::<Result<Vec<_>, _>>()?;
        let output = self.runtime.block_on(async {
            self.client
                .send_event(&event)
                .to(urls)
                .await
                .map_err(|e| NostrError::Invalid(e.to_string()))
        })?;
        let success: Vec<String> = output.success.keys().map(|u| u.to_string()).collect();
        let failed: Vec<String> = output.failed.keys().map(|u| u.to_string()).collect();
        Ok(format!("Sent to {} relays, failed on {} relays", success.len(), failed.len()))
    }

    pub fn broadcast_event(&self, event_json: String) -> Result<String, NostrError> {
        let event = Event::from_json(event_json)?;
        let output = self.runtime.block_on(async {
            self.client
                .send_event(&event)
                .broadcast()
                .await
                .map_err(|e| NostrError::Invalid(e.to_string()))
        })?;
        let success: Vec<String> = output.success.keys().map(|u| u.to_string()).collect();
        let failed: Vec<String> = output.failed.keys().map(|u| u.to_string()).collect();
        Ok(format!("Broadcast to {} relays, failed on {} relays", success.len(), failed.len()))
    }

    pub fn remove_relay(&self, url: String) -> Result<bool, NostrError> {
        self.runtime.block_on(async {
            self.client
                .remove_relay(&url)
                .await
                .map_err(|e| NostrError::Invalid(e.to_string()))?;
            Ok(true)
        })
    }
}

#[uniffi::export]
fn rust_hello() -> String {
    "Hello from Rust!".to_string()
}

#[uniffi::export]
pub fn rust_add(a: u32, b: u32) -> u32 {
    a + b
}
