# 🏛️ California Museums & Exhibitions Explorer

An interactive R Shiny application powered by **Shinylive** (WASM) to explore current exhibitions, art genres, artifact types, admission costs, and metadata across 30 major California museums.

Hosted on **GitHub Pages**: [https://rcurty.github.io/museum-agents/](https://rcurty.github.io/museum-agents/)

---

## 🌟 Key Features

- **🗺️ Interactive Leaflet Map**: Visualizes 30 museums across Los Angeles, SF Bay Area, San Diego, Sacramento, and the Central Coast.
- **🎯 Dynamic Filtering**:
  - **Region**: Filter by geographic region.
  - **Exhibition Genre**: Filter by art/science genre (European Fine Art, Contemporary, Aerospace, Paleontology, etc.).
  - **Artifact / Art Type**: Filter by artifact category (Paintings, Sculptures, Fossils, Spacecraft, Costumes, etc.).
  - **Age Group**: Filter for All Ages, Kids & Families, or Adults.
  - **Admission Cost**: Filter by Free Admission vs Paid.
  - **Keyword Search**: Instant text search across titles, artists, and descriptions.
- **⚡ Serverless WebAssembly Architecture**: Built with `shinylive` in R, running 100% inside the browser via WebAssembly without requiring an active R server.

---

## 📁 Repository Structure

```
.
├── app.R                  # R Shiny application source code
├── data/
│   ├── exhibitions.csv    # Scraped museum exhibition dataset & metadata
│   └── museum_coords.csv  # Geolocation coordinates & museum details
├── docs/                  # Shinylive static build exported for GitHub Pages
└── prepare_data.py        # Data preparation script
```

---

## 🚀 GitHub Pages Setup

To deploy the Shinylive site on GitHub Pages:

1. Go to repository **Settings** -> **Pages**.
2. Under **Build and deployment**:
   - **Source**: Deploy from a branch
   - **Branch**: `main` / Folder: `/docs`
3. Save. The site will be live at `https://rcurty.github.io/museum-agents/`.
