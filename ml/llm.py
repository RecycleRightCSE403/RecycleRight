import os
from langchain_community.llms import CTransformers
# from huggingface_hub import hf_hub_download


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

model_id = 'TheBloke/Mistral-7B-Instruct-v0.2-GGUF'
os.environ['XDG_CACHE_HOME'] ='./ml/'
llm = CTransformers(model=model_id,
                    model_type='mistral')
prompt = "How shoud you get rid of food waste in Seattle, WA?"

response = llm.invoke(prompt)
print(type(response))
print(response)

