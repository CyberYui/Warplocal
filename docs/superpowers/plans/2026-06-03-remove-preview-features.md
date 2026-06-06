# Remove Preview Features Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove Cloud platform, Referrals, Warpify, and Warp Drive settings pages and their associated feature flags from the Warplocal codebase.

**Architecture:** This is a surgical removal of 4 settings pages (Cloud platform umbrella with CloudEnvironments+OzCloudAPIKeys, Referrals, Warpify, Warp Drive) and 2 feature flags (CloudEnvironments, OzCloudAPIKeys/OzPlatformSkills). We remove the page modules, their feature flag references, nav entries, enum variants, settings page registrations, and all related bindings/actions. We do NOT remove the feature flag enum variants from `FeatureFlag` since they're used in arrays elsewhere — we just stop referencing them.

**Tech Stack:** Rust, warpui UI framework

---

## Pre-flight: Verify Build Baseline

- [ ] **Step 1: Verify the project builds before making changes**

Run: `cd /Users/yui/Documents/GitHub/Warplocal && cargo check -p warp_features 2>&1 | tail -5`
Expected: Successful compilation (or at least no errors in files we'll touch)

---

## Task 1: Remove Cloud platform umbrella from settings nav

**Files:**
- Modify: `app/src/settings_view/mod.rs:1240-1246`

- [ ] **Step 1: Remove the Cloud platform umbrella from nav_items**

In `SettingsView::new()`, remove the `SettingsNavItem::Umbrella` entry for "Cloud platform" that contains `CloudEnvironments` and `OzCloudAPIKeys`. This is the block at lines 1240-1246:

```rust
// REMOVE this entire block:
SettingsNavItem::Umbrella(SettingsUmbrella::new(
    "Cloud platform",
    vec![
        SettingsSection::CloudEnvironments,
        SettingsSection::OzCloudAPIKeys,
    ],
)),
```

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove Cloud platform umbrella from settings nav"
```

---

## Task 2: Remove Referrals page from settings nav and pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:1252`

- [ ] **Step 1: Remove Referrals from nav_items**

In the `nav_items` vector in `SettingsView::new()`, remove the line:
```rust
SettingsNavItem::Page(SettingsSection::Referrals),
```

- [ ] **Step 2: Remove Referrals from settings_pages**

In the `settings_pages` vector in `SettingsView::new()`, remove:
```rust
SettingsPage::new(referrals_page_handle),
```

- [ ] **Step 3: Remove the referrals_page_handle subscription and construction**

Find and remove the block that creates `referrals_page_handle` and subscribes to it (search for `referrals_page_handle =` and `ctx.subscribe_to_view(&referrals_page_handle`).

- [ ] **Step 4: Remove handle_referrals_page_event method**

Remove the entire `handle_referrals_page_event` method from `impl SettingsView`.

- [ ] **Step 5: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 6: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove Referrals page from settings"
```

---

## Task 3: Remove Warpify page from settings nav and pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:1251`

- [ ] **Step 1: Remove Warpify from nav_items**

In the `nav_items` vector, remove:
```rust
SettingsNavItem::Page(SettingsSection::Warpify),
```

- [ ] **Step 2: Remove Warpify from settings_pages**

In the `settings_pages` vector, remove:
```rust
SettingsPage::new(warpify_page_handle),
```

- [ ] **Step 3: Remove the warpify_page_handle construction and subscription**

Find and remove the block that creates `warpify_page_handle` and subscribes to it.

- [ ] **Step 4: Remove handle_warpify_page_event method**

Remove the entire `handle_warpify_page_event` method from `impl SettingsView`.

- [ ] **Step 5: Remove WarpifyPageAction import and SettingsAction::WarpifyPageToggle variant usage**

In `SettingsAction` enum, remove the `WarpifyPageToggle(WarpifyPageAction)` variant. Also remove it from the `handle_action` match in `TypedActionView`.

- [ ] **Step 6: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 7: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove Warpify page from settings"
```

---

## Task 4: Remove Warp Drive page from settings nav and pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:1254`

- [ ] **Step 1: Remove WarpDrive from nav_items**

In the `nav_items` vector, remove:
```rust
SettingsNavItem::Page(SettingsSection::WarpDrive),
```

- [ ] **Step 2: Remove WarpDrive from settings_pages**

In the `settings_pages` vector (the `settings_pages.extend` block), remove:
```rust
SettingsPage::new(warp_drive_page_handle),
```

- [ ] **Step 3: Remove the warp_drive_page_handle construction and subscription**

Find and remove the block that creates `warp_drive_page_handle` and subscribes to it.

- [ ] **Step 4: Remove handle_warp_drive_page_event method**

Remove the entire `handle_warp_drive_page_event` method.

- [ ] **Step 5: Remove WarpDrive from SettingsAction**

Remove `WarpDrive(warp_drive_page::WarpDriveSettingsPageAction)` from the `SettingsAction` enum and its handling in `handle_action`.

- [ ] **Step 6: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 7: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove Warp Drive page from settings"
```

---

## Task 5: Remove CloudEnvironments page from settings pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:1219`

- [ ] **Step 1: Remove CloudEnvironments from settings_pages**

In the `settings_pages.extend` block, remove:
```rust
SettingsPage::new(environments_page_handle.clone()),
```

- [ ] **Step 2: Remove environments_page_handle construction and subscription**

Remove the block that creates `environments_page_handle` and subscribes to it. Also remove the `handle_environments_page_event` method.

- [ ] **Step 3: Remove environments_page_handle field from SettingsView struct**

Remove `environments_page_handle: ViewHandle<EnvironmentsPageView>,` from the `SettingsView` struct.

- [ ] **Step 4: Remove environment-related modal rendering from render()**

In the `render()` method, remove the blocks that render:
- environment setup mode selector overlay
- agent-assisted environment modal overlay

These reference `self.environments_page_handle`.

- [ ] **Step 5: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 6: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove CloudEnvironments page from settings"
```

---

## Task 6: Remove OzCloudAPIKeys (Platform) page from settings pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:1210`

- [ ] **Step 1: Remove platform_page from settings_pages**

In the `settings_pages` vector, remove:
```rust
SettingsPage::new(platform_page_handle),
```

- [ ] **Step 2: Remove platform_page_handle construction and subscription**

Remove the block that creates `platform_page_handle` and subscribes to it. Also remove `handle_platform_page_event`.

- [ ] **Step 3: Remove OzCloudAPIKeys from SettingsPageViewHandle enum**

Remove the `OzCloudAPIKeys(ViewHandle<super::platform_page::PlatformPageView>)` variant from `SettingsPageViewHandle` and all its match arms (`child_view`, `From` impl, `should_render_page`, `update_page!` macro, `get_modal_content_for_page`).

- [ ] **Step 4: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 5: Commit**

```bash
git add app/src/settings_view/mod.rs app/src/settings_view/settings_page.rs
git commit -m "refactor: remove OzCloudAPIKeys (Platform) page from settings"
```

---

## Task 7: Remove SettingsSection enum variants for removed pages

**Files:**
- Modify: `app/src/settings_view/mod.rs:226-262`

- [ ] **Step 1: Remove variants from SettingsSection enum**

Remove these variants from the `SettingsSection` enum:
- `CloudEnvironments`
- `OzCloudAPIKeys`
- `Referrals`
- `WarpDrive`
- `Warpify`

- [ ] **Step 2: Remove Display impl arms for removed variants**

Remove the corresponding match arms in `impl Display for SettingsSection`.

- [ ] **Step 3: Remove FromStr impl arms for removed variants**

Remove the corresponding match arms in `impl FromStr for SettingsSection`.

- [ ] **Step 4: Remove is_cloud_platform_subpage and cloud_platform_subpages**

Remove the `is_cloud_platform_subpage()` method and `cloud_platform_subpages()` associated function. Update `is_subpage()` to only check `is_ai_subpage() || is_code_subpage()`.

- [ ] **Step 5: Remove parent_page_section mapping for CloudEnvironments and OzCloudAPIKeys**

The `parent_page_section` method already returns `*other` for non-subpages, so CloudEnvironments and OzCloudAPIKeys will just return themselves. No additional change needed beyond removing the variants.

- [ ] **Step 6: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 7: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove SettingsSection variants for removed pages"
```

---

## Task 8: Remove feature flag references from mod.rs imports

**Files:**
- Modify: `app/src/settings_view/mod.rs:77-116`

- [ ] **Step 1: Remove module declarations for removed pages**

Remove these `mod` declarations:
```rust
mod billing_and_usage;
mod billing_and_usage_dispatch;
mod billing_and_usage_page;
mod billing_and_usage_page_v2;
mod environments_page;
mod platform;
mod platform_page;
mod privacy;
mod privacy_page;
mod referrals_page;
mod warp_drive_page;
mod warpify_page;
```

Wait — keep `privacy` and `privacy_page` (Privacy is NOT being removed). Keep `billing_and_usage*` (Billing is NOT being removed). Only remove:
```rust
mod environments_page;
mod platform;
mod platform_page;
mod referrals_page;
mod warp_drive_page;
mod warpify_page;
```

- [ ] **Step 2: Remove pub(crate) mod handoff_environment_creation_modal and related**

Check if `handoff_environment_creation_modal`, `delete_environment_confirmation_dialog`, `agent_assisted_environment_modal`, `update_environment_form` are only used by the environments page. If so, remove them too.

- [ ] **Step 3: Remove unused imports**

Remove imports that reference the removed modules:
- `use billing_and_usage_dispatch::BillingAndUsageDispatchView;` — KEEP (BillingAndUsage still exists)
- `use environments_page::EnvironmentsPageView;` — REMOVE
- `use platform_page::PlatformPageView;` — REMOVE (but check if used elsewhere first)
- `use privacy_page::{PrivacyPageView, PrivacyPageViewEvent};` — KEEP
- `use referrals_page::{ReferralsPageEvent, ReferralsPageView};` — REMOVE
- `use warp_drive_page::WarpDriveSettingsPageView;` — REMOVE
- `use warpify_page::{WarpifyPageAction, WarpifyPageView};` — REMOVE

- [ ] **Step 4: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 5: Commit**

```bash
git add app/src/settings_view/mod.rs
git commit -m "refactor: remove imports and module declarations for removed pages"
```

---

## Task 9: Remove feature flag checks from workspace bindings

**Files:**
- Modify: `app/src/workspace/mod.rs:1487-1500`

- [ ] **Step 1: Remove the environments page binding**

Remove:
```rust
EditableBinding::new(
    "workspace:show_settings_environments_page",
    BindingDescription::new("Open Settings: Environments"),
    WorkspaceAction::ShowSettingsPage(SettingsSection::CloudEnvironments),
)
.with_group(bindings::BindingGroup::Settings.as_str())
.with_context_predicate(id!("Workspace")),
```

- [ ] **Step 2: Remove the MCP servers binding**

Remove:
```rust
EditableBinding::new(
    "workspace:show_mcp_servers_settings_page",
    BindingDescription::new("Open Settings: MCP Servers"),
    WorkspaceAction::ShowSettingsPage(SettingsSection::MCPServers),
)
.with_group(bindings::BindingGroup::Settings.as_str())
.with_context_predicate(id!("Workspace")),
```

- [ ] **Step 3: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 4: Commit**

```bash
git add app/src/workspace/mod.rs
git commit -m "refactor: remove environment and MCP server settings bindings"
```

---

## Task 10: Remove feature flags from warp_features

**Files:**
- Modify: `crates/warp_features/src/lib.rs`

- [ ] **Step 1: Add #[deprecated] to CloudEnvironments and OzPlatformSkills feature flags**

Since FeatureFlag is a Sequence enum used in arrays, we can't remove the variants. Instead, deprecate them and force-disable:

```rust
/// DEPRECATED: Cloud Environments settings page has been removed.
#[deprecated = "Cloud Environments settings page has been removed"]
CloudEnvironments,

/// DEPRECATED: Oz Cloud API Keys settings page has been removed.
#[deprecated = "Oz Cloud API Keys settings page has been removed"]
OzPlatformSkills,
```

- [ ] **Step 2: Force-disable the deprecated flags**

In the `is_enabled()` method, add to the force-disable match:
```rust
FeatureFlag::CloudEnvironments | FeatureFlag::OzPlatformSkills => return false,
```

- [ ] **Step 3: Verify it compiles**

Run: `cargo check -p warp_features 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 4: Commit**

```bash
git add crates/warp_features/src/lib.rs
git commit -m "refactor: deprecate and force-disable CloudEnvironments and OzPlatformSkills feature flags"
```

---

## Task 11: Remove feature flag references from features_page.rs

**Files:**
- Modify: `app/src/settings_view/features_page.rs`

- [ ] **Step 1: Search for CloudEnvironments and OzPlatformSkills references**

Search the file for any references to the removed feature flags and remove the code blocks that use them.

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/settings_view/features_page.rs
git commit -m "refactor: remove feature flag references from features page"
```

---

## Task 12: Remove feature flag references from ai_page.rs

**Files:**
- Modify: `app/src/settings_view/ai_page.rs`

- [ ] **Step 1: Search for CloudEnvironments and OzPlatformSkills references**

Search the file for any references to the removed feature flags and remove the code blocks that use them.

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/settings_view/ai_page.rs
git commit -m "refactor: remove feature flag references from AI page"
```

---

## Task 13: Remove feature flag references from code_page.rs

**Files:**
- Modify: `app/src/settings_view/code_page.rs`

- [ ] **Step 1: Search for CloudEnvironments and OzPlatformSkills references**

Search the file for any references to the removed feature flags and remove the code blocks that use them.

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/settings_view/code_page.rs
git commit -m "refactor: remove feature flag references from code page"
```

---

## Task 14: Remove feature flag references from main_page.rs

**Files:**
- Modify: `app/src/settings_view/main_page.rs`

- [ ] **Step 1: Search for CloudEnvironments and OzPlatformSkills references**

Search the file for any references to the removed feature flags and remove the code blocks that use them.

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/settings_view/main_page.rs
git commit -m "refactor: remove feature flag references from main page"
```

---

## Task 15: Clean up workspace/view.rs references

**Files:**
- Modify: `app/src/workspace/view.rs`

- [ ] **Step 1: Search for CloudEnvironments, WarpDrive, Warpify, Referrals references**

Search the file for any references to the removed sections/feature flags and remove them.

- [ ] **Step 2: Verify it compiles**

Run: `cargo check -p app 2>&1 | tail -10`
Expected: Successful compilation

- [ ] **Step 3: Commit**

```bash
git add app/src/workspace/view.rs
git commit -m "refactor: remove feature flag references from workspace view"
```

---

## Task 16: Final cleanup and full build verification

- [ ] **Step 1: Remove unused module files**

Check if the module files are still referenced anywhere. If not, they can be deleted:
- `app/src/settings_view/environments_page.rs`
- `app/src/settings_view/platform_page.rs`
- `app/src/settings_view/referrals_page.rs`
- `app/src/settings_view/warp_drive_page.rs`
- `app/src/settings_view/warpify_page.rs`
- `app/src/settings_view/platform/` (directory)
- `app/src/settings_view/handoff_environment_creation_modal.rs`
- `app/src/settings_view/delete_environment_confirmation_dialog.rs`
- `app/src/settings_view/agent_assisted_environment_modal.rs`

- [ ] **Step 2: Full cargo check**

Run: `cargo check 2>&1 | tail -20`
Expected: Successful compilation with no errors

- [ ] **Step 3: Search for any remaining references**

Run: `rg -l "CloudEnvironments\|OzCloudAPIKeys\|WarpDrive\|Warpify\|Referrals" --type rust app/src/settings_view/ crates/warp_features/src/`
Expected: Only deprecated enum definitions and dead code remain

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "refactor: final cleanup of removed feature references"
```

---

## Summary of Changes

| File | Change |
|------|--------|
| `app/src/settings_view/mod.rs` | Remove nav items, page registrations, enum variants, imports, module declarations, event handlers, action variants |
| `app/src/settings_view/settings_page.rs` | Remove OzCloudAPIKeys from SettingsPageViewHandle enum |
| `app/src/workspace/mod.rs` | Remove environment and MCP server settings bindings |
| `crates/warp_features/src/lib.rs` | Deprecate and force-disable CloudEnvironments and OzPlatformSkills |
| `app/src/settings_view/features_page.rs` | Remove feature flag references |
| `app/src/settings_view/ai_page.rs` | Remove feature flag references |
| `app/src/settings_view/code_page.rs` | Remove feature flag references |
| `app/src/settings_view/main_page.rs` | Remove feature flag references |
| `app/src/workspace/view.rs` | Remove feature flag references |
