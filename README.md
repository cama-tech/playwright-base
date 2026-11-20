# Playwright noVNC Docker Base

A reusable Docker base image for browser automation with Microsoft Playwright, plus installed virtual-display and remote-desktop components. Built and published to GitHub Container Registry (GHCR) through GitHub Actions.

> **Project status:** This is a **base image**, not a ready-to-use browser desktop. Xvfb, x11vnc, Fluxbox, noVNC and websockify are installed, but the image does **not** start these services automatically, expose a web port, or configure VNC authentication. Additional configuration is required before remote desktop access works.

## Included software

| Component | Purpose |
| --- | --- |
| Microsoft Playwright `v1.59.1-jammy` | Browser automation base image |
| Xvfb | Virtual X display |
| x11vnc | VNC server for the virtual display |
| Fluxbox | Lightweight window manager |
| noVNC | Browser-based VNC client |
| websockify | WebSocket-to-VNC bridge |

The Dockerfile sets `DISPLAY=:99`, `TZ=America/Lima`, and `DEBIAN_FRONTEND=noninteractive`.

## Repository layout

```text
playwright-novnc-docker/
├── .github/
│   └── workflows/
│       └── docker.yml
└── Dockerfile
```

## Build locally

Requirements: Docker and access to the Microsoft Container Registry.

```bash
git clone https://github.com/cama-tech/playwright-novnc-docker.git
cd playwright-novnc-docker
docker build -t playwright-novnc:local .
```

> The clone URL assumes the repository has been renamed to `playwright-novnc-docker`. Until then, use the existing repository URL.

## Inspect the image

Start a shell to verify the installed components:

```bash
docker run --rm -it playwright-novnc:local bash
```

Inside the container:

```bash
command -v Xvfb
command -v x11vnc
command -v fluxbox
command -v websockify
```

These checks verify that commands are installed; they do not start a browser or a remote desktop.

## GitHub Actions and GHCR

The included `.github/workflows/docker.yml` runs on pushes to the `main` branch. It:

1. Checks out the repository.
2. Authenticates to GHCR using the GitHub-provided `GITHUB_TOKEN`.
3. Builds the Docker image.
4. Pushes the image to GHCR.

The current workflow uses this image tag:

```text
ghcr.io/<owner>/<repository>/playwright-novnc:1.0
```

For a repository named `cama-tech/playwright-novnc-docker`, that becomes:

```text
ghcr.io/cama-tech/playwright-novnc-docker/playwright-novnc:1.0
```

This is the tag **configured by the workflow**, not confirmation that a package has been published. Check the repository's **Actions** and **Packages** sections for build status and package visibility. A public GitHub repository does not necessarily mean its GHCR package is public.

The workflow requests `contents: read` and `packages: write` permissions. Repository and organization policies can affect package publication.

## Enabling remote access (additional work required)

The current Dockerfile installs the necessary packages but does not launch the display stack. To offer a usable noVNC environment, a future image or Compose setup should:

- Start Xvfb on display `:99`.
- Start Fluxbox against that display.
- Start x11vnc with authentication.
- Start websockify/noVNC on a configured port.
- Start the intended browser or Playwright application.
- Provide a reliable startup process and health checks.

**Security:** Do not expose unauthenticated VNC or noVNC to the Internet. Prefer localhost-only port bindings, strong authentication, and a trusted network or authenticated proxy.

## Intended use

- Browser automation experiments.
- End-to-end testing infrastructure.
- Building customized Playwright containers with virtual-display support.
- Internal, authorized security testing and browser-based demonstrations.

## Limitations

- No automatic Xvfb, VNC, Fluxbox, or noVNC startup.
- No configured VNC password or HTTPS endpoint.
- No application entrypoint or example Playwright script.
- No exposed port or Docker Compose configuration.
- No automated tests in the supplied repository.
- The base image version is pinned in the Dockerfile; update and test dependencies periodically.

## Contributing

Issues and pull requests are welcome. Useful contributions include a secure startup script, an example Compose configuration, health checks, automated smoke tests, and documentation for browser access.

## License

No project license is included in the supplied repository. Add an explicit license if you want others to reuse or modify this repository under defined terms. Review the upstream image and bundled software licenses separately.

## Attribution

This is a community-maintained Docker customization using the Microsoft Playwright base image. It is not an official Microsoft Playwright or noVNC distribution.
