# bloud

[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-orange.svg)]()

A home server, inspired by kubernetes. Self-hosting is kind of unreasonably hard.
Not the installing part, but everything after.

In bloud, you install an app and the reverse proxy, unified login, and all
inter-app integrations happen for you.

## try it

Debian 13, x86_64.

The script is short, and you should read it before piping it to a shell:
[install.sh](https://github.com/d-buckner/bloud/releases/latest/download/install.sh).
To do it by hand instead, grab the `.deb` from the
[releases page](https://github.com/d-buckner/bloud/releases) and run
`sudo apt install ./bloud_*.deb`.

```bash
curl -fsSL https://github.com/d-buckner/bloud/releases/latest/download/install.sh | sudo sh
```

Open the dashboard at `http://<machine address>`, set your host under Settings,
and that's it.

**Please don't expose bloud to the public internet yet.** It's alpha, it serves
plain HTTP, and there is no mechanism yet for getting security updates to apps
or to bloud itself. Keep it on your LAN for now, and keep your own backups of
anything you cannot lose.

## why

Getting a container running isn't the hard part, `podman run` will do that. The
hard part is everything the container needs from the rest of the system: a route
to it, a login it trusts, a database with a password nobody has to copy by hand,
and all of it still correct a year later.

That's the part bloud does. You pick an app, and it gets an address you can open
from any device, a login that works across the catalog, and its own storage.
bloud also keeps checking its own work, which is the difference between a config
file that was right in March and one that is right now.

## catalog

The catalog is small on purpose. A half-supported app is worse than no app at
all, because it looks like an answer right up until the first time you depend on
it. Every entry gets the same treatment, and each one is verified: install,
shared login, persistence, reboot, removal.

- **AFFiNE**: AI-native knowledge base that unifies docs, databases, and whiteboards
- **AFFiNE MCP**: Full read-write MCP tool server for AFFiNE, for agents that author documents, databases, and canvases
- **Arr MCP**: MCP tool server over the request and arr stack, so an agent can answer what was requested and what is stuck
- **Calino**: Browser calendar for the CalDAV calendars Bloud already serves
- **DAV MCP**: MCP tool server for the calendars and contacts Bloud already serves, so agents read and write events, to-dos, and address books
- **Hermes**: Self-improving AI agent with persistent memory, scheduled automations, and a web dashboard
- **Hermes Web UI**: Browser and mobile front end for the Hermes agent, with SSO sign-in and a dedicated client password
- **Hindsight**: Agent memory server that lets an AI agent retain facts, recall them, and reflect on them
- **Home Assistant**: Open-source home automation platform
- **Home Assistant MCP**: MCP tool server for Home Assistant, so an agent can search entities and design automations against the instance Bloud already runs
- **Immich**: Self-hosted photo and video management
- **Jellyfin**: Free software media system for streaming movies, TV, and music
- **Navidrome**: Modern music server and streamer compatible with Subsonic/Airsonic clients
- **Navidrome MCP**: MCP tool server over a Navidrome library, so an agent can search music, build playlists, and report what you actually listen to
- **Paperless-ngx**: Document management system that turns scans and PDFs into a searchable archive
- **Penpot**: Open-source design platform for interfaces, design systems, and prototypes
- **Podly**: Removes ads from podcasts and serves the ad-free versions as RSS feeds
- **Prowlarr**: Indexer manager that syncs indexers to Sonarr, Radarr, and other PVRs
- **qBittorrent**: BitTorrent client with a web interface
- **Radarr**: Movie collection manager for Usenet and BitTorrent users
- **Radicale**: CalDAV and CardDAV server for calendars, contacts, and to-do lists
- **Seerr**: Request and discovery manager for your media server
- **Sonarr**: PVR for TV series that monitors, grabs, and organises episodes
- **Vaultwarden**: Lightweight, Bitwarden-compatible password manager

## one login

Most apps sign in through bloud, and there is one account to make. Clients that
speak a native protocol, a Subsonic player or a TV app talking to Jellyfin, keep
the login path their protocol defines. bloud fronts the web UIs and stays out of
the way of those.

The exceptions are honest ones: a few apps keep an account of their own. The MCP
servers are machine endpoints guarded by a token bloud mints, and Podly cannot
join a provider at all, so its password is one bloud generates and shows you
once from its menu on the dashboard.

## feedback

Bugs and requests: [issues](https://github.com/d-buckner/bloud/issues).

## license

Bloud is closed source. See [LICENSE](LICENSE) for the terms that apply to the
package and to the files in this repository.
