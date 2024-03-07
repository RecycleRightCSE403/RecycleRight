"""
main.py
"""

import logging
import os

from PIL import Image
from fastapi import FastAPI, File, UploadFile, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware

from cv.classify import classify_image
from ml.gemini_llm import classify_item

app = FastAPI()

origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Directory to store images
UPLOAD_DIRECTORY = "images"


@app.post("/classify_image/")
async def classify_image_endpoint(file: UploadFile = File(...)):
    """
    Takes an input image and returns a map of the proper ways to dispose of
    items in the image.

        Params:
            file (UploadFile): The image file of trash to be disposed of.

        Returns:
            dict: Maps 'filename' to the name of the input file and
                'classification' to the response of how to dispose of the item
                in the image.

        Raises:
            FileNotFoundError: If file is not found in the UPLOAD_DIRECTORY.
            requests.exceptions.HTTPError: If calling the CV api does not
                respond with code 200.
    """
    tmp_filename = "image-to-classify.jpg"
    file_location = os.path.join(UPLOAD_DIRECTORY, tmp_filename)
    # resize image before saving
    with Image.open(file.file) as im:
        width, height = im.size
        scale = max(width, height) / 512
        width = int(width // scale)
        height = int(height // scale)
        im = im.resize((width, height))
        im.save(file_location)
    logging.info("File '%s' saved at '%s'", file.filename, file_location)
    classes = classify_image(tmp_filename)
    if len(classes) == 0:
        return {"filename": file.filename, "classification": "Error"}
    item = classes[0]
    classification_result = classify_item(item)
    logging.info("LLM classified object: %s", item)
    logging.info("Classification: %s", item)
    response = {
            "filename": file.filename,
            "text": item,
            "classification": classification_result
            }
    return response


@app.post("/classify_text/")
async def classify_text(text: str = Body(..., embed=True)):
    """
    Take an input string and returns a map of the proper ways to dispose of it.

        Params:
            text (string): The name of the item.

        Returns:
            dict: Maps 'result' to the response of how to dispose of the item.

        Raises:
            HTTPException: Raises with error code 400 if text is empty.
    """
    if not text:
        raise HTTPException(
                status_code=400,
                detail="Text is required for classification."
                )
    logging.info("Received text for classification: %s", text)
    classification_result = classify_item(text)
    logging.info("LLM classified text: %s as %s", text, classification_result)
    return {"text": text, "classification": classification_result}


@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    """
    Unimplemented
    """
    return { "text": text, "filename": file }
