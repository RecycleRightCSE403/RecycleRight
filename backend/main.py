from fastapi import FastAPI, File, UploadFile, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
import logging
import os
from starlette.responses import FileResponse
from ml.gemini_llm import classify_item
from cv.classify import classify_image

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
    '''
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
    '''
    file_location = os.path.join(UPLOAD_DIRECTORY, file.filename)
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    logging.info(f"File '{file.filename}' saved at '{file_location}'")
    classes = classify_image(file.filename)
    if len(classes) == 0:
        return {"filename": file.filename, "classification": "Error"}
    item = classes[0]
    classification_result = classify_item(item)
    logging.info(f"LLM classified object: {item}")
    logging.info(f"Classification: {item}")
    return {"filename": file.filename, "classification": classification_result}

@app.post("/classify_text/")
async def classify_text(text: str = Body(..., embed=True)):
    '''
    Take an input string and returns a map of the proper ways to dipose of it.

        Params:
            text (string): The name of the item.

        Returns:
            dict: Maps 'result' to the response of how to dispose of the item.

        Raises:
            HTTPException: Raises with error code 400 if text is empty.
    '''
    if not text:
        raise HTTPException(status_code=400, detail="Text is required for classification.")
    logging.info(f"Received text for classification: {text}")
    classification_result = classify_item(text)
    logging.info(f"LLM classified text: {text} as {classification_result}")
    return {"text": text, "classification": classification_result}

@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}
