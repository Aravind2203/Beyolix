from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware 
import uvicorn 
import boto3
import requests 
import os
import joblib 
import requests
 
app = FastAPI() 

model = joblib.load('knn_model_drug.h5')

origins = [
    "http://localhost",
    "http://localhost:3000",
    '*'
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
) 

def getReactions(drugName):
    url = f'https://api.fda.gov/drug/event.json?search=patient.drug.medicinalproduct:"{drugName}"'
    results = requests.get(url).json()['results']

    substancename = set()
    for res in results:
        for drug in res["patient"]["drug"]:
            if drug.get("activesubstance"):
                substancename.add(drug.get("activesubstance").get("activesubstancename"))
    
    substances = {'adalimumab': 1, 'secukinumab': 2, 'ranitidine': 3, 'hydrochloride': 4, 'hydrochloride,': 5, 'sodium': 6, 'acetate': 7, 'prednisone,': 8, 'certolizumab': 9, 'sulfate,': 10, 'calcium': 11, 'sodium,': 12, 'adalimumab,': 13, 'upadacitinib': 14, 'fingolimod': 15, 'pegol': 16, 'insulin': 17, 'glargine': 18, 'levonorgestrel': 19, 'human': 20, 'oxycodone': 21, 'palbociclib': 22, 'leuprolide': 23, 'tozinameran': 24, 'others': 25}

    xres = [0]*len(substances)
    for sub in substancename:
        for s in sub.split():
            if s.lower() in substances.keys():
                xres[substances[s.lower()]-1] = 1
#            else:
 #               xres[substances["others"]-1] = 1

    yres = model.predict([xres])[0]

    reactions = ['cough', 'drug ineffective', 'headache', 'pyrexia', 'nausea', 'pain in extremity', 'fatigue', 'diarrhoea', 'injection site pain', 'dizziness', 'asthenia', 'rash', 'pain', 'malaise', 'arthralgia', 'condition aggravated', 'pruritus', 'vomiting', 'dyspnoea', 'illness', 'weight decreased', 'others']

    res = []
    for i in range(len(yres)):
        if yres[i] == 1:
            res.append(reactions[i])

    return res

@app.get("/")
async def root():
    return {"message": "Hello World Summarize"} 

@app.post("/uploadfile/")
async def create_upload_file(file: UploadFile):       
    print(file)
    # convert to byte array 
    file_bytes = await file.read()
    imageBytes = bytearray(file_bytes) 

    textract = boto3.client('textract' , 
    region_name = "us-east-1",
    aws_access_key_id="AKIAXKSSZE6XKZRKRQZJ",
    aws_secret_access_key="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"
)
    response = textract.detect_document_text(
    Document={
            'Bytes': imageBytes,
        # 'S3Object': { 
        #     'Bucket': os.environ['BUCKET_NAME'],
        #     'Name': file.filename
        # }
    }) 

    text = ""
    for item in response["Blocks"]:
        if item["BlockType"] == "LINE":
            print ('\033[94m' +  item["Text"] + '\033[0m')
            text = text + " " + item["Text"]

    # Amazon Comprehend client
    comprehend = boto3.client('comprehendmedical',
        region_name = "us-east-1",
    aws_access_key_id="AKIAXKSSZE6XKZRKRQZJ",
    aws_secret_access_key="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"
    )
    rxnorm = comprehend.infer_rx_norm(Text = text) 
    tablets = []
    
    #get tablets
    for entity in rxnorm["Entities"]:
        print("- {}".format(entity["Text"]))
        print ("   Type: {}".format(entity["Type"]))
        print ("   Category: {}".format(entity["Category"])) 
        if(entity["Category"] == "MEDICATION"):
                    tablets.append(entity["Text"])

    #get age
    entities =  comprehend.detect_entities(Text=text)  
    age = 0 
    for entity in entities["Entities"]: 
        if entity['Type'] == "AGE" :  
            age = int(entity["Text"])    

    symptoms = [] 
    for tablet in tablets: 
        symp = getReactions(tablet)  
        json = { 
            "drug": tablet, 
            "symptoms": symp
        }
        symptoms.append(json)

    print(symptoms)

    return {"symptoms": symptoms}   


@app.post("/test")
async def test(url: str ):
    return {"message": "Hello World Summarize" + url}   

 
if __name__ == "__main__":
    uvicorn.run(app, host='0.0.0.0', port=8000)

