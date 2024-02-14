from fastapi import FastAPI, UploadFile
import sys
# sys.path.insert(0, "../ml")
# from llm import classify_item

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/classify_image/")
async def classify_image(file: UploadFile):
    # classify image
    return {"filename": file.filename}


@app.get("/classify_text/")
async def classify_test(text: str):
    # I commented lines 22 & 23 for now bc I could not figure out how to 
    # call clssify_item from ml file here. But once we merge and move
    # cv and ml into backend, it should be easy to make it work.
    # result = classify_item(text)
    # return {"result": result}
    return {"result": text}


@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}
