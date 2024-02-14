from fastapi import FastAPI, File, UploadFile
import logging
import os
from starlette.responses import FileResponse

app = FastAPI()

# Directory to store images
UPLOAD_DIRECTORY = "../cv/images"

@app.post("/uploadfile/")
async def create_upload_file(file: UploadFile = File(...)):
    file_location = os.path.join(UPLOAD_DIRECTORY, file.filename)
    with open(file_location, "wb+") as file_object:
        file_object.write(file.file.read())
    return {"info": f"File '{file.filename}' saved at '{file_location}'"}

@app.get("/files/{file_name}")
async def read_file(file_name: str):
    file_location = os.path.join(UPLOAD_DIRECTORY, file_name)
    return FileResponse(path=file_location, filename=file_name)

@app.post("/classify_image/")
async def classify_image(file: UploadFile = File(...)):
    logging.info(f"Received file: {file.filename}")
    return {"filename": file.filename}

@app.get("/classify_text/")
async def classify_text(text: str = ""):
    return {"result": text}

@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}
