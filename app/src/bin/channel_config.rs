//! Tools for loading a [`ChannelConfig`] from the external config generator binary.
//!
//! For non-bundled builds, the generator is invoked at runtime. For bundled builds, the config
//! is embedded at compile time via the build script.
use warp_core::AppId;
use warp_core::channel::{ChannelConfig, OzConfig, WarpServerConfig};

#[macro_export]
#[cfg(windows)]
macro_rules! path_concat {
    ($path:expr, $file:expr) => {
        concat!($path, "\\", $file)
    };
}
#[macro_export]
#[cfg(not(windows))]
macro_rules! path_concat {
    ($path:expr, $file:expr) => {
        concat!($path, "/", $file)
    };
}

#[macro_export]
macro_rules! load_config {
    ($channel:expr) => {{
        #[cfg(feature = "release_bundle")]
        {
            channel_config::load_config_from_embedded(include_str!($crate::path_concat!(
                env!("OUT_DIR"),
                concat!($channel, "_config.json")
            )))
        }

        #[cfg(not(feature = "release_bundle"))]
        {
            channel_config::load_config_from_generator($channel)
        }
    }};
}
pub use load_config;

/// Invokes the config generator binary at runtime and deserializes its JSON output into a
/// [`ChannelConfig`].
#[cfg_attr(feature = "release_bundle", expect(dead_code))]
pub fn load_config_from_generator(_channel: &str) -> ChannelConfig {
    ChannelConfig {
        app_id: AppId::new("dev.warp", "Warp-Local", "WarpLocal"),
        logfile_name: "warp_local.log".into(),
        server_config: WarpServerConfig::production(),
        oz_config: OzConfig::production(),
        telemetry_config: None,
        autoupdate_config: None,
        crash_reporting_config: None,
        mcp_static_config: None,
    }
}

/// Deserializes a [`ChannelConfig`] from a JSON string embedded at compile time.
///
/// This is used to load the channel configuration in release bundles, where configuration
/// is embedded at compile time instead of being generated at runtime.
#[cfg_attr(not(feature = "release_bundle"), expect(dead_code))]
pub fn load_config_from_embedded(json: &str) -> ChannelConfig {
    serde_json::from_str(json)
        .unwrap_or_else(|err| panic!("Failed to parse embedded channel config: {err}"))
}
