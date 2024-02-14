
from fastapi import FastAPI, File, UploadFile
import logging
import os
from starlette.responses import FileResponse
from ml.llm import classify_item

app = FastAPI()

# Directory to store images
UPLOAD_DIRECTORY = "../cv/images"

@app.post("/classify_image/")
async def classify_image(file: UploadFile = File(...)):
    file_location = os.path.join(UPLOAD_DIRECTORY, file.filename)
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    logging.info(f"File '{file.filename}' saved at '{file_location}'")
    # item = call cv code, and store a single string item in here
    classification_result = "" # delete empty string and replace with: classify_item(item) 
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