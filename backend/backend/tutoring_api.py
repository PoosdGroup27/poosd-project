from fastapi import FastAPI
import uvicorn

app = FastAPI()


@app.get("/")
async def root():
    return {"messsage": "Basic FastApi scaffolding"}


def start():
    uvicorn.run("backend.tutoring_api:app", host="127.0.0.1", port=8000, reload=True)