import tomllib
from jinja2 import Environment, FileSystemLoader
import os
import argparse
import subprocess
import glob

OUTPUT_DIR = "output"
CV_DIR = "cv"
COVERLETTER_DIR = "coverletter"
TEMPLATES_DIR = "templates"
CONFIG_FILE = "config.toml"


def get_generated_files():
    """Returns a list of all generated .typ files."""
    cv_files = glob.glob(os.path.join(CV_DIR, "resume.typ"))
    letter_files = glob.glob(os.path.join(COVERLETTER_DIR, "*.typ"))
    # Exclude template files
    letter_files = [f for f in letter_files if not f.endswith("template.typ")]
    return cv_files + letter_files


def get_pdf_files():
    """Returns a list of all generated .pdf files."""
    return glob.glob(os.path.join(OUTPUT_DIR, "*.pdf"))


def clean():
    """
    Cleans up generated .typ and .pdf files.
    """
    print("Cleaning generated files...")
    files_to_delete = get_generated_files() + get_pdf_files()

    for f in files_to_delete:
        try:
            os.remove(f)
            print(f"Removed {f}")
        except OSError as e:
            print(f"Error removing {f}: {e}")

    # Remove output dir if it's empty
    if os.path.exists(OUTPUT_DIR) and not os.listdir(OUTPUT_DIR):
        os.rmdir(OUTPUT_DIR)
        print(f"Removed empty directory: {OUTPUT_DIR}")


def build():
    """
    Generates .typ files from Jinja2 templates and data.
    """
    print("Generating .typ files...")
    # Create output directories if they don't exist
    os.makedirs(CV_DIR, exist_ok=True)
    os.makedirs(COVERLETTER_DIR, exist_ok=True)

    # Set up Jinja2 environment
    env = Environment(
        loader=FileSystemLoader(TEMPLATES_DIR), trim_blocks=True, lstrip_blocks=True
    )

    # Load data from TOML file
    with open(CONFIG_FILE, "rb") as f:
        data = tomllib.load(f)

    # Render CV
    cv_template = env.get_template("resume.typ.j2")
    cv_output = cv_template.render(data)
    cv_output_path = os.path.join(CV_DIR, "resume.typ")
    with open(cv_output_path, "w") as f:
        _ = f.write(cv_output)
    print(f"Generated {cv_output_path}")

    # Render cover letters
    cover_letter_template = env.get_template("coverletter.typ.j2")
    for letter_data in data.get("cover_letters", []):
        context = {**data, "letter": letter_data}
        letter_output = cover_letter_template.render(context)
        output_filename = os.path.join(COVERLETTER_DIR, f"{letter_data['id']}.typ")
        with open(output_filename, "w") as f:
            _ = f.write(letter_output)
        print(f"Generated {output_filename}")


def compile():
    """
    Compiles the generated .typ files into PDFs.
    """
    print("Compiling .typ files to PDF...")
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    generated_files = get_generated_files()

    if not generated_files:
        print("No .typ files found to compile. Run 'build' first.")
        return

    for typ_file in generated_files:
        try:
            # The `typst` command requires the input path and the output path.
            # We derive the output filename from the input filename.
            base_name = os.path.basename(typ_file)
            pdf_name = os.path.splitext(base_name)[0] + ".pdf"
            output_path = os.path.join(OUTPUT_DIR, pdf_name)

            command = ["typst", "compile", typ_file, output_path]
            print(f"Running command: {' '.join(command)}")

            result = subprocess.run(command, check=True, capture_output=True, text=True)

            if result.returncode == 0:
                print(f"Successfully compiled {typ_file} to {output_path}")
            if result.stdout:
                print(result.stdout)
            if result.stderr:
                print(result.stderr)

        except FileNotFoundError:
            print(
                "Error: 'typst' command not found. Please ensure Typst is installed and in your PATH."
            )
            return
        except subprocess.CalledProcessError as e:
            print(f"Error compiling {typ_file}:")
            print(e.stderr)


def main():
    parser = argparse.ArgumentParser(description="CV and Cover Letter Generator")
    _ = parser.add_argument(
        "command", choices=["build", "compile", "clean"], help="The command to execute."
    )
    args = parser.parse_args()

    if args.command == "build":
        build()
    elif args.command == "compile":
        compile()
    elif args.command == "clean":
        clean()


if __name__ == "__main__":
    main()
