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

// Nostr SDK client wrapper

use nostr_sdk::client::Client;
use std::sync::Arc;
use tokio::runtime::Runtime;

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
}

#[uniffi::export]
fn rust_hello() -> String {
    "Hello from Rust!".to_string()
}

#[uniffi::export]
pub fn rust_add(a: u32, b: u32) -> u32 {
    a + b
}
