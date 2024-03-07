from dotenv import load_dotenv
import os
import google.generativeai as genai

# load api key from environment
# check if it is on the system
api_key = os.environ.get('GEMINI_API_KEY')
# if not then load local variable from .env
if api_key is None:
    load_dotenv()
    api_key = os.environ.get('GEMINI_API_KEY')
if api_key is None:
    raise Exception('GEMINI_API_KEY environment variable does not exist')

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
    "threshold": "BLOCK_NONE"
  },
  {
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_NONE"
  },
  {
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_NONE"
  },
  {
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_NONE"
  },
]

model = genai.GenerativeModel(model_name="gemini-1.0-pro",
                              generation_config=generation_config,
                              safety_settings=safety_settings)

def classify_item(item):
    '''
    Given a string item, returns a response of how to dispose of it properly.

        Params:
            item (string): The item to dispose.

        Returns:
            dict: A dict with the following keys: 'classification', 'location'
                and 'specifications'. 'classification' maps to one of 'garbage',
                'compost', 'recycle', 'donate', 'special' or 'LLM unable to 
                properly classify'. 'location' maps to a list of locations to 
                dispose of the item. Note that 'location' is only a key when 
                'classification' is either 'donate' or 'special'.
                'specifications' maps to a string response of how to dispose of
                the item. In the case that classification fails, 
                'classification' will map to 'LLM unable to properly classify' 
                and 'location' and 'specifications' will not be in the dict.
    '''
    response = dict()
    convo = model.start_chat()
    convo.send_message(f"Give a one word classification of how to dispose "
                       f"of " + item + " in Seattle as either garbage bin, "
                       f"compost bin, recycling bin, donate, or special if "
                       f"there are drop-off locations for the item. Suggest "
                       f"garbage only as a last resort if the item cannot "
                       f"possibly be in any of the other categories.")
    classifcation = convo.last.text

    # Cleans up classification
    clean_classification = clean_up_classification(classifcation)

    # Adds clean classification to dictionary
    response["classification"] = clean_classification

    # gets extra information if needed, depending on classification, and adds to
    # the dictionary

    # For donation classification, get 3 locations for donation
    if clean_classification == "donate":
        convo.send_message(f"Give at most 3 locations to donate " + item + " in"
                           f"Seattle, including the address for each one and "
                           f"not including any other text, as a semicolon "
                           f"separated list where each element is of the "
                           f"following format: Location name: location adress")
        locations_string = convo.last.text
        locations_list = locations_string.split('; ')
        response["locations"] = locations_list

    # For special classification, get 3 locations for drop-off centers
    elif clean_classification == "special":
        convo.send_message(f"Give at most 3 locations to drop off " + item +
                           f" in Seattle, including the address for each one "
                           f"and not including any other text, "
                           f"as a semicolon separated list where each element "
                           f"is of the following format: Location name: "
                           f"location adress")
        locations_string = convo.last.text
        locations_list = locations_string.split('; ')
        response["locations"] = locations_list

    # For recycle classification, get all important points user should know to 
    # correctly recycle item
    elif clean_classification == "recycle":
        convo.send_message(f"Give any specifications for how " + item +
                           f"should be recycled in Seattle recycling bins as a "
                           f"semicolon separated list of the format: "
                           f"specification 1; specification 2; etc")
        specification_string = convo.last.text
        specification_list = specification_string.split('; ')
        response["specifications"] = specification_list
    return response


def clean_up_classification(initial_classification):
    '''
    Given a initial string classification, returns a string classification. 

        Params:
            initial_classification (string): An initial classification that maps
                to one of the possible classifications

        Returns:
            string: One of either 'garbage', 'compost', 'recycle', 'donate', 
            'special' or 'LLM unable to properly classify'.
    '''
    # recycle sometimes shows up as recycling, searching for recycl catches this
    # case
    possible_classifications = {
            'garbage': 'garbage',
            'compost': 'compost',
            'recycl': 'recycle',
            'donate': 'donate',
            'special': 'special',
            }
    lower_case = initial_classification.lower()

    for k, v in possible_classifications.items():
        if k in lower_case:
            return v
        
    return "LLM unable to properly classify"


def main():
    classify_item("cardboard box")


if __name__ == "__main__":
    main()
