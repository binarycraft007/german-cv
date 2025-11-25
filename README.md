# Modern Typst Resume & Cover Letter Template

A clean, professional, and ATS-friendly resume and cover letter bundle built with [Typst](https://typst.app/). The layout is optimized for **Software Engineering** roles and is highly adaptable for the **German/EU market**.

This project uses a Jinja2 templating system to generate the `.typ` files from a central `config.toml` file, making it easy to manage your information and generate documents.

## 📸 Previews

| Resume | Cover Letter |
| :--- | :--- |
| • Two-column grid layout<br>• Dark navy sidebar<br>• Professional typography<br>• Skill progress bars<br>• ATS-parseable text flow<br>• Circular profile picture | • DIN 5008 compliant (German standard)<br>• Positioned address fields for window envelopes<br>• Fold marks for easy mailing<br>• Clean, single-column layout<br>• Matches resume's typography<br>• Separated content and logic |

## 🚀 Features

*   **Data-Driven:** All content is stored in `config.toml`, providing a single source of truth.
*   **Templated:** Jinja2 templates separate content from layout, allowing for flexible and maintainable design.
*   **Streamlined Workflow:** A single script to `build`, `compile`, and `clean` all documents.
*   **Organized Output:** All generated PDFs are stored in a dedicated `output/` directory.
*   **ATS Friendly:** The resume uses a standard text flow that Applicant Tracking Systems can easily parse.
*   **German/EU Ready:**
    *   **Resume:** Supports profile pictures and personal details common in the DACH region.
    *   **Cover Letter:** Compliant with DIN 5008 for professional letter formatting.
*   **Modular & Customizable:** Easily extend or modify the templates and data structure.

## 🛠️ Usage

### 1. Prerequisites
*   **Typst CLI:** Required to compile the generated `.typ` files into PDFs.
    *   [Install via Cargo or download a pre-compiled binary](https://github.com/typst/typst).
*   **Python 3.11+:** Required to run the generation script (uses `tomllib`).

### 2. File Structure

```
.
├── templates/
│   ├── coverletter.typ.j2
│   └── resume.typ.j2
├── coverletter/
│   └── template.typ
├── cv/
│   ├── template.typ
│   ├── lang.toml
│   └── img/
│       └── profile.png
├── output/               # (Generated PDFs appear here)
├── config.toml           # <-- All your content goes here
├── main.py               # (Build script)
├── pyproject.toml
└── README.md
```

### 3. How to Use

#### Step 1: Install Dependencies
This project uses `uv` for package management, as defined in `pyproject.toml`.

With `uv`:
```bash
uv sync
```

#### Step 2: Edit Your Data
Open `config.toml` and fill in your personal information, work experience, skills, and other details. You can also define one or more cover letters.

#### Step 3: Build, Compile, and Clean
Use the `generate.py` script to manage your documents.

**A) Build & Compile Everything**
To generate the `.typ` files and then immediately compile them into PDFs in the `output/` directory, run:
```bash
uv run main.py build
uv run main.py compile
```

**B) Clean Up**
To remove all generated `.typ` and `.pdf` files from the `cv`, `coverletter`, and `output` directories, run:
```bash
uv run generate.py clean
```

This will produce your resume and cover letters as PDFs in the `/output` directory.
