# Swedish Gothic OCR Tool

This tool automatically transcribes 18th/19th-century Swedish handwriting (Kurrentstil) using the Swedish National Archives' AI models.

## Prerequisites
* **Mac/Linux** (Terminal access)
* **Python 3.11** installed on your system.

## Files Required
Ensure these three files are in the same folder:
1.  `run_ocr.sh` (The script)
2.  `pipeline.yaml` (The model configuration)
3.  `example_image.jpeg` (The document you want to transcribe)

## Usage Instructions

1. **Open your terminal** and navigate to this folder.

2. **Make the script executable** (you only need to do this once):
   chmod +x run_ocr.sh

3. **Run the transcriber** Replace example_image.jpeg with your actual filename.
    ./run_ocr.sh example_image.jpeg

4. **Output**: the OCR output should be in a file called output