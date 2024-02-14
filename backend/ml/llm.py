import os
from langchain_community.llms import CTransformers
# from huggingface_hub import hf_hub_download


def classify_item(item):
    '''
    Returns str representing how to dispose of the item properly
    '''
    model_id = 'TheBloke/Mistral-7B-Instruct-v0.2-GGUF'
    os.environ['XDG_CACHE_HOME'] ='./ml/'
    llm = CTransformers(model=model_id, model_type='mistral')
    prompt = "How shoud you get rid of" + item + "in Seattle, WA? Categorize the response as either recycle, compost, garbage, or other based on which option is best for the environment. Give your response as one word, just stating the category. Do not say anything else."
    answer = llm.invoke(prompt)
    print(answer)
    return answer


def main(): 
    classify_item("battery")
  
  
if __name__=="__main__": 
    main() 


'''
HUGGING_FACE_API_KEY = os.environ.get('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')

model_id = "lmsys/fastchat-t5-3b-v1.0"
filenames = [
        "pytorch_model.bin", "added_tokens.json", "config.json", "generation_config.json", 
        "special_tokens_map.json", "spiece.model", "tokenizer_config.json"
]


model_id = "mistralai/Mistral-7B-Instruct-v0.2"
filenames = ["config.json", "generation_config.json", "model-00001-of-00003.safetensors", 
             "model-00002-of-00003.safetensors", "model-00003-of-00003.safetensors", 
             "model.safetensors.index.json", "pytorch_model-00001-of-00003.bin",
             "pytorch_model-00002-of-00003.bin", "pytorch_model-00003-of-00003.bin", 
             "pytorch_model.bin.index.json", "special_tokens_map.json", "tokenizer.json",
             "tokenizer.model", "tokenizer_config.json"
]

for filename in filenames:
        downloaded_model_path = hf_hub_download(
                    repo_id=model_id,
                    filename=filename,
                    token=HUGGING_FACE_API_KEY
        )
        print(downloaded_model_path)
'''