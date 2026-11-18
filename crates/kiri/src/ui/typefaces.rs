//! The window's own typefaces (fonts/README.md): Space Grotesk for the
//! interface, JetBrains Mono for labels and code. The page is too close to
//! WebView2's 2 MB limit to carry them (assemble.rs), so it asks once it's up
//! (`typefaces`) and the host answers with [`js`], as it answers `langwords`.
//! The Mac and Linux window (crates/kiri) and Windows (kiri-win includes this
//! file) send the same answer, and scripts/ui-test.py's host does too.

use std::sync::OnceLock;

/// Each face's family, as the page's font stacks name it, and its file.
/// Variable fonts: one file covers weights 400 to 700.
const FACES: [(&str, &[u8]); 2] = [
    ("Space Grotesk", include_bytes!("fonts/space-grotesk.woff2")),
    ("JetBrains Mono", include_bytes!("fonts/jetbrains-mono.woff2")),
];

/// The host's answer to the page's `typefaces`: JS that hands the page each
/// face as a data URL, for `kiriTypefaces` to add to `document.fonts`.
pub fn js() -> String {
    static JS: OnceLock<String> = OnceLock::new();
    JS.get_or_init(|| {
        let faces: Vec<_> = FACES.iter().map(|(family, woff2)| serde_json::json!({ "family": family, "weight": "400 700", "src": format!("data:font/woff2;base64,{}", base64(woff2)) })).collect();
        format!("window.kiriTypefaces && kiriTypefaces({})", serde_json::Value::from(faces))
    })
    .clone()
}

/// Standard base64, padded (RFC 4648 §4): what a data URL takes.
fn base64(bytes: &[u8]) -> String {
    const ABC: &[u8; 64] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let mut out = String::with_capacity(bytes.len().div_ceil(3) * 4);
    for chunk in bytes.chunks(3) {
        let n = chunk.iter().enumerate().fold(0u32, |n, (i, b)| n | (u32::from(*b) << (16 - 8 * i)));
        for i in 0..4 {
            out.push(if i <= chunk.len() { char::from(ABC[((n >> (18 - 6 * i)) & 63) as usize]) } else { '=' });
        }
    }
    out
}

#[cfg(test)]
mod tests {
    #[test]
    fn base64_is_rfc_4648() {
        // RFC 4648 §10's test vectors.
        for (raw, enc) in [("", ""), ("f", "Zg=="), ("fo", "Zm8="), ("foo", "Zm9v"), ("foob", "Zm9vYg=="), ("fooba", "Zm9vYmE="), ("foobar", "Zm9vYmFy")] {
            assert_eq!(super::base64(raw.as_bytes()), enc);
        }
    }

    #[test]
    fn every_face_is_a_woff2_the_page_can_add() {
        for (family, woff2) in super::FACES {
            assert_eq!(&woff2[..4], b"wOF2", "{family} isn't a woff2");
        }
        let js = super::js();
        assert!(js.starts_with("window.kiriTypefaces && kiriTypefaces([{"));
        assert!(js.contains(r#""family":"Space Grotesk""#) && js.contains(r#""family":"JetBrains Mono""#));
        // The page names them in its font stacks by these families.
        let page = include_str!("index.html");
        assert!(page.contains(r#""Space Grotesk""#) && page.contains(r#""JetBrains Mono""#), "index.html doesn't name the faces");
    }
}
