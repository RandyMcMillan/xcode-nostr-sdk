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
fn rust_hello() -> String {
    "Hello from Rust!".to_string()
}

#[uniffi::export]
pub fn rust_add(a: u32, b: u32) -> u32 {
    a + b
}
