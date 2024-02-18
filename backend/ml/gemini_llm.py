import os
import google.generativeai as genai

api_key = os.environ.get('GEMINI_API_KEY')
genai.configure(api_key=api_key)

# Set up the model
generation_config = {
  "temperature": 0.9,
  "top_p": 1,
  "top_k": 1,
  "max_output_tokens": 2048,
}

safety_settings = [
  {
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
]

model = genai.GenerativeModel(model_name="gemini-1.0-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)


def classify_item(item):
    '''
    Given an item, asks llm to classify it as one of: garbage, compost, recycle, donate, or special.
    Returns this classification.
    '''
    convo = model.start_chat()
    # convo.send_message(f"Give a one word classification of how to dispose of the following item, either recycle, "
                       # f"compost, garbage, or other: {item}")
    convo.send_message(f"Give a one word classification of how to dispose of" + item + " in Seattle as either garbage bin, "
                       f"compost bin, recycling bin, donate, or special if there are drop-off locations for the item. Suggest "
                       f"garbage only as a last resort if the item cannot possibly be in any of the other categories.")
    print(convo.last.text)
    return convo.last.text

def clean_up_classification(initial_classification):
    '''
    Given an item, cleans up classification and returns clean version.
    '''


def main():
    classification = classify_item("battery")



if __name__ == "__main__":
    main()
