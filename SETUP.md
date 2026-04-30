# Deployment Guide

How to take this folder from zero to a live URL on `github.io`.

---

## TL;DR (for the impatient)

```bash
# 1. Create empty repo on GitHub (no README, no .gitignore — we have our own)
#    Repo name: unified-fluid-robot-multiphysics

# 2. From inside this folder:
bash scripts/setup_pages.sh

# 3. Enable GitHub Pages in repo Settings → Pages → Source: main / root

# 4. Wait 1 min, your page is at
#    https://<username>.github.io/unified-fluid-robot-multiphysics/
```

Then iterate on `index.html` and assets, `git push`, GitHub re-deploys automatically.

---

## Step-by-step

### 1. Create the GitHub repo

Go to [github.com/new](https://github.com/new) and create a new repository.

- **Name:** `unified-fluid-robot-multiphysics` (or whatever you prefer)
- **Visibility:** Public (required for free GitHub Pages)
- **Do NOT check** "Add a README", "Add .gitignore", or "Choose a license" — we have our own files already.

Click **Create repository**.

### 2. Push this folder to that repo

You have two options for authentication. Pick one.

#### Option A — HTTPS with Personal Access Token (simplest if you don't already have SSH set up)

```bash
cd unified-fluid-robot-multiphysics
git init -b main
git add .
git commit -m "Initial project page"
git remote add origin https://github.com/<YOUR-USERNAME>/unified-fluid-robot-multiphysics.git
git push -u origin main
```

Git will prompt for username and password. For password, use a [Personal Access Token](https://github.com/settings/tokens) with `repo` scope, **not** your GitHub login password (which doesn't work for git auth anymore).

#### Option B — SSH (if you've added your SSH key to GitHub)

```bash
cd unified-fluid-robot-multiphysics
git init -b main
git add .
git commit -m "Initial project page"
git remote add origin git@github.com:<YOUR-USERNAME>/unified-fluid-robot-multiphysics.git
git push -u origin main
```

Or just run the helper script which automates all of the above:

```bash
bash scripts/setup_pages.sh
```

### 3. Enable GitHub Pages

1. Go to your repo on github.com
2. **Settings** (top tab on the right)
3. **Pages** (left sidebar)
4. Under **Source**, choose **Deploy from a branch**
5. **Branch:** `main`, folder: `/ (root)`
6. **Save**

Wait ~1 minute, refresh, the page tells you:

> Your site is live at `https://<username>.github.io/unified-fluid-robot-multiphysics/`

### 4. Add real assets

Most of the page works with no assets thanks to graceful fallbacks, but you'll want to drop in real videos and figures.

**Videos** — place `.mov` / `.mp4` files in a folder called `raw_videos/` (which is gitignored), then run:

```bash
bash scripts/encode_videos.sh raw_videos
```

This re-encodes them to web-friendly looping `.mp4` (≤8s, h264, no audio, faststart) into `static/videos/`, and extracts a poster frame for each into `static/images/`.

**Figures from the paper** — place the original PDF figures in a folder called `paper_figures/`, then run:

```bash
bash scripts/extract_figures.sh paper_figures
```

This rasterizes them to 300dpi PNG into `static/images/`.

The filenames the page expects:

| File | Source |
|---|---|
| `static/videos/teaser.mp4` | The Fig. 1 three-row C-start stack, looped |
| `static/videos/overview.mp4` | The supplementary video |
| `static/videos/undulation_{hw,ours,baseline}.mp4` | 40° forward swimming demos |
| `static/videos/cstart_{hw,ours}.mp4` | Optimized C-start, hardware vs. simulation |
| `static/images/method_overview.png` | Fig. 3 |
| `static/images/rmse_bars.png` | Fig. 7 |
| `static/images/cstart_trajectories.png` | Fig. 9 |
| `static/images/hardware_setup.png` | Fig. 6 |

### 5. Fill in the placeholders

Open `index.html` and search-replace:

- The 5 button `href="#"` values → real URLs (Paper, arXiv, Code, Video)
- The venue badge `Robotics: Science and Systems · 2026` → `Under Review` if anonymized
- BibTeX block at the bottom → final citation key
- `[Add funding sources and individual acknowledgments here.]`

### 6. Iterate

```bash
# After any local change:
git add .
git commit -m "Add C-start hardware video"
git push
```

GitHub re-deploys automatically. Hard-refresh your browser (Cmd+Shift+R / Ctrl+F5) to see updates.

---

## Local preview

Don't want to push every tiny change? Spin up a local server:

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

KaTeX and Google Fonts are loaded from CDN, so you need internet for math and typography to render correctly — but the page still loads fine without it (KaTeX `throwOnError: false`).

---

## Custom domain (optional)

If you want `unifiedfluidrobotmultiphysics.com` or similar:

1. Buy the domain (Cloudflare/Namecheap/etc.)
2. In your DNS, add a `CNAME` record pointing to `<your-username>.github.io`
3. In the repo, create a file named `CNAME` (no extension) at the root with one line: your domain
4. Commit and push
5. In repo Settings → Pages, fill in the custom domain field and check **Enforce HTTPS**

For a student project page the default `*.github.io` URL is totally fine and what most RSS/CoRL/T-RO papers use.

---

## Common gotchas

- **Asset 404s** — paths are case-sensitive on the GitHub server. `Static/Images/` ≠ `static/images/`. Mac filesystem isn't case-sensitive by default so it'll work locally and break on push.
- **Videos won't autoplay on iOS Safari** — they need both `muted` and `playsinline` attributes. The current HTML has both.
- **KaTeX fails to render** — usually the CDN is being slow. The page sets `throwOnError: false` so you'll see raw `$...$` instead of a crash. Refresh.
- **Page doesn't update after push** — wait 1-2 min for the Pages deploy, then hard-refresh to bypass cache.
