from fastapi import FastAPI, File, UploadFile, HTTPException, Body
import logging
import os
from starlette.responses import FileResponse
from ml.gemini_llm import classify_item
from cv.classify import classify_image

app = FastAPI()

UPLOAD_DIRECTORY = "images"

@app.post("/classify_image/")
async def classify_image_endpoint(file: UploadFile = File(...)):
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
    if not text:
        raise HTTPException(status_code=400, detail="Text is required for classification.")
    logging.info(f"Received text for classification: {text}")
    classification_result = classify_item(text)
    logging.info(f"LLM classified text: {text} as {classification_result}")
    return {"text": text, "classification": classification_result}

@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}
