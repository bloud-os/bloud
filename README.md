# Bloud

your friendly personal cloud

[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-orange.svg)](https://github.com/bloud-os/bloud/releases)

**Your apps know about each other.**

Bloud is a self-hosting OS for your home. You install an app, and the reverse
proxy, the shared login, the database wiring, and the integrations between apps
all happen for you — and they stay correct over time through updates and
reboots.

Self-hosting is kind of unreasonably hard. Not the installing part, everything
after. Bloud is the everything-after part.

## How it works

Every app in bloud declares what it provides and what it needs — a login, a
database, a route, a port. That declaration graph is the product. The engine
reads it and resolves:

- **One login.** One account for your whole stack. Apps that speak their own
  protocol (a Subsonic player, a TV app talking to Jellyfin) keep working the
  way their protocol defines; bloud fronts the web UIs and stays out of the way.
- **Integrations that just exist.** Your media stack knows where your indexer is.
  Your agent can see your calendar. Nobody copy-pasted a password.
- **Whole-system backup.** One action backs up every app *and* the wiring
  between them, so restoring onto a new machine is a migration, not a weekend.

And bloud keeps checking its own work — the configs aren't one time artifacts,
they kept up to date on every install, update, settings change, and reboot.

## Agents, first-class

Most of the catalog ships with an MCP server: your agent can read your calendar,
search your music, answer what was requested and what's stuck in the media
stack, and author documents. These installed MCP apps automatically get wired
into apps that can utilize them, like hermes.

## Try it

Free. Single host. No account, no phone-home — bloud runs fully local.

Debian 13, x86_64.

The script is short, and you should read it before piping it to a shell:
[install.sh](https://github.com/bloud-os/bloud/blob/main/install.sh).
To do it by hand instead, grab the `.deb` from the
[releases page](https://github.com/bloud-os/bloud/releases) and run
`sudo apt install ./bloud_*.deb`.

```bash
curl -fsSL https://github.com/bloud-os/bloud/releases/latest/download/install.sh | sudo sh
```

Open the dashboard at `http://localhost`, set your host under Settings,
and that's it.

**Please don't expose bloud to the public internet yet.** It's alpha, and there
is no mechanism yet for getting security updates to apps in a time-sensitive
manner. Keep it on your LAN for now, and keep your own backups of anything you
cannot lose.

## Catalog

The catalog is small on purpose. A half-supported app is worse than no app at
all, because it looks like an answer right up until the first time you depend
on it. Every entry gets the same treatment, and each one is verified: install,
shared login, persistence, reboot, removal.

**Apps:** AFFiNE · Calino · Hermes · Hermes WebUI · Home Assistant · Immich · Jellyfin · Navidrome ·
Paperless-ngx · Penpot · Podly · Prowlarr · qBittorrent · Radarr · Radicale ·
Seerr · Sonarr · Terminus · Vaultwarden

**MCP servers:** AFFiNE · Arr stack · DAV (CalDAV/CardDAV) · Home Assistant ·
Hindsight memory · Navidrome

## The source

Bloud is closed source at this time. Two promises I will assure while it's closed:
- **It's yours.** Fully local, no cloud account required. If this company dies
  tomorrow, your install keeps working.
- **The updater is sacred.** No telemetry by default

## Feedback

Bugs and requests: [issues](https://github.com/bloud-os/bloud/issues).

## Feedback

Bugs and requests: [issues](https://github.com/bloud-os/bloud/issues).

## License

Bloud is closed source at this time. See [LICENSE](LICENSE) for the terms that apply to the
package and to the files in this repository.
