from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import logging
import os
from starlette.responses import FileResponse
from ml.gemini_llm import classify_item
from cv.classify import get_highest_predictions
import cv.classify

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
async def classify_image(file: UploadFile = File(...)):
    file_location = os.path.join(UPLOAD_DIRECTORY, file.filename)
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    logging.info(f"File '{file.filename}' saved at '{file_location}'")
    json_response = cv.classify.classify_image(file.filename)
    classes = get_highest_predictions(json_response)
    if len(classes) == 0:
        return {"filename": file.filename, "classification": "Error"}
    item = classes[0]
    classification_result = classify_item(item)
    # logging.info(f"LLM classified object: {item}")
    return {"filename": file.filename, "classification": classification_result}

@app.get("/classify_text/")
async def classify_text(text: str = ""):
    result = classify_item(text)
    logging.info(f"LLM classified object: {text}")
    return {"result": result}

@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}
