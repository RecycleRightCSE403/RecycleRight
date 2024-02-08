from fastapi import FastAPI, UploadFile

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
    return {"result": text}


@app.post("/report_image/")
async def report_image(file: UploadFile, text: str):
    return {"filename": file}