# Jonathan Yu-Meng Li — jonli.net

The website stays on GitHub Pages at **www.jonli.net**. Jekyll generates four pages: About, Research, RIO Lab, and Teaching. Papers and people are edited separately from the design.

## Add a paper in GitHub

1. Open [templates/paper.md](templates/paper.md) and copy its contents.
2. In the `_papers` folder, choose **Add file → Create new file**. Use a short filename, such as `new-paper-title.md`.
3. Paste the template and edit the title, coauthors, topics, status, and paper link. Remove `paper_url` if there is no public version yet.
4. Commit the change. When the change reaches the branch configured for GitHub Pages, GitHub rebuilds the site.

```yaml
---
title: "A new paper on generative optimization"
coauthors: "First Author* and Second Author"
status: working
topics: [ai, dro]
order: 0
paper_url: "https://arxiv.org/abs/your-paper"
---
```

`order: 0` places a working paper at the top. Lower numbers appear first. Existing papers use 10, 20, 30, and so on. Put `*` after student coauthors when appropriate.

### Topic choices

| Value | Displayed topic |
| --- | --- |
| `ai` | Generative AI & Machine Learning |
| `dro` | DRO & Optimal Transport |
| `finance` | Asset Pricing & Portfolio Choice |
| `risk` | Risk Measures & Preferences |

Use more than one topic when appropriate: `topics: [ai, dro]`. Keep **one file per paper** regardless of how many topics it has. Topic labels and descriptions live in [_data/topics.yml](_data/topics.yml).

### When a paper is accepted

Edit the existing paper file:

```yaml
status: accepted
journal: "Journal name"
year: 2027
```

It automatically moves into **Accepted / forthcoming**. Its topics, authors, and links remain intact. Do not create a second copy.

### When a paper is published

Update the same record:

```yaml
status: published
journal: "Journal name"
year: 2027
citation: "12(3), 100–120"
```

It moves into **Publications**, sorted by year, newest first. `citation` is optional until volume, issue, and pages are available. A preprint URL may remain in `paper_url`, or it can be replaced with the final paper URL.

### Optional paper details

Add any of these fields above the closing `---`:

```yaml
summary: "One plain-language sentence about the paper's central question or result."
code_url: "https://github.com/your-account/your-code"
data_url: "https://your-data-repository"
resource_note: "Replication files and instructions for this paper."
slides_url: "https://your-slides-url"
```

To add an expandable abstract, paste its text **after** the closing `---`. Markdown formatting is supported. Leave it empty to omit the Abstract control. Preserve the filename after sharing a paper's link: it supplies that paper's anchor on the Research page.

## Add or update a lab member

Copy [templates/person.md](templates/person.md) into a new file in `_people`, such as `_people/first-last.md`.

```yaml
---
name: "Full name"
role: "PhD student"
field: "Finance"
group: phd
status: current
years: "2026–"
order: 0
---
```

- `group`: `phd`, `postdoc`, or `visitor`.
- `status`: `current` or `alumni`. All doctoral students appear together.
- `role`: the displayed label, such as `PhD student` or `Postdoctoral fellow`.
- `years`: keep this in quotes, such as `"2024–2028"`.
- `order`: lower values appear first within each group.

Optional fields are `field` (such as Finance, Digital Transformation and Innovation, or Health Systems), `website`, `interests`, `note`, and `destination`. Only include confirmed information. When someone leaves, change `status` to `alumni`, fill in the end year, and optionally add their destination. Keep the same file.

## Data and code on the lab page

For a paper, add `code_url` and/or `data_url` to its existing file in `_papers`. Both links appear beside that paper and automatically in the lab's **Data & code** section. An optional `resource_note` gives a short description in the lab index. Enter these links once; do not duplicate the paper in the resources list. Links may point to GitHub, a data archive, an institutional repository, or another public host.

For a lab-wide resource that is not tied to a paper, copy [templates/resource.yml](templates/resource.yml) into [_data/resources.yml](_data/resources.yml), replacing the initial `[]`. You can add several entries. Use `code_url`, `data_url`, or `resource_url` as needed and remove unused fields. The resource section shows a simple availability note until the first public resource is added.

## Other updates

| Content | File |
| --- | --- |
| Biography, roles, and contact links | [index.html](index.html) |
| Lab description | [lab.html](lab.html) |
| Current and past courses | [_data/teaching.yml](_data/teaching.yml) |
| Lab research statement | [_data/copy.yml](_data/copy.yml) |
| Standalone lab datasets/software | [_data/resources.yml](_data/resources.yml) |
| Topic labels and descriptions | [_data/topics.yml](_data/topics.yml) |
| Navigation and shared metadata | [_layouts/default.html](_layouts/default.html) |
| Colors, typography, and spacing | [assets/css/site.css](assets/css/site.css) |

## GitHub Pages setup

Keep the existing custom domain and `CNAME` file. This site uses standard Jekyll collections and requires no custom Jekyll plugins.

If Pages already publishes from **main / (root)**, it can continue doing so. In **Settings → Pages**, confirm that the publishing source points to the branch containing these changes. If the repository instead uses a custom GitHub Actions deployment, that workflow must build Jekyll before publishing `_site`; do not publish the unbuilt template files as static HTML.

The included **Validate website** workflow checks content and builds the site on pull requests and pushes. It does not replace your deployment settings. In GitHub Pages settings, keep the website's existing custom domain `www.jonli.net`.

## Local checks

With Ruby and Bundler installed:

```sh
bundle install
ruby scripts/check-content.rb
bundle exec jekyll build --strict_front_matter
```

Generated files are written to `_site` and are not committed. Paper content is in the generated HTML, so the bibliography remains readable without JavaScript. JavaScript adds topic/status filtering, shareable filter URLs, and redirects for the old homepage section links.

To view the site locally, run `bundle exec jekyll serve` and open the address printed in the terminal. It rebuilds when you edit content.

An optional Vite server can also preview the generated `_site` folder: after building Jekyll, run `npm ci` and `npm run dev`. This requires Node.js 20.19+ or 22.12+; it is not needed for GitHub Pages or routine content updates. Rebuild Jekyll after source edits when using this option.

## Content migration notes

The migration preserves all 10 working papers, 13 publications, 8 original people, 9 course entries, and existing paper URLs. The supplied research statement adds three doctoral students, grouped with the current students at the site owner’s request. Doctoral fields follow the site owner’s updates. The statement also supplies corrected page ranges for the 2021 inverse-risk-functions paper and the 2018 worst-case law-invariant-risk paper. Other publication metadata and author/student markers follow the original site. Topic assignments are editorial classifications and can be edited at any time.

No new abstracts, unverified journal links, student research interests, placements, or publication statuses have been invented. Xinqiao Xie's earlier visit appears as a note on the current postdoctoral record. The legacy assets remain in the repository but are excluded from the generated site because the current design does not use them.

## Typography and offline preview

The site pairs locally hosted **Source Serif 4** for headings and paper titles with **Inter** for body text, navigation, and metadata. Regular-weight serif headings keep the academic character light; consistent spacing and readable line lengths establish the hierarchy. The portrait sits beside the biography with a 48 px gap on desktop and 32 px on tablet. The font files and their Open Font License notices are in `assets/fonts`. No external font service is required when browsing the site.

The standalone review HTML embeds both fonts and the portrait, so the downloaded preview matches the site's typography without an internet connection. The production website continues to use the four Jekyll pages and shared content records.
