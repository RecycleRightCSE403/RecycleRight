from dotenv import load_dotenv
load_dotenv()
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
    Given an item, asks llm to classify it as one of: garbage, compost, recycle, donate, or special.
    Returns this classification.
    '''
    response = dict()
    convo = model.start_chat()
    # convo.send_message(f"Give a one word classification of how to dispose of the following item, either recycle, "
                       # f"compost, garbage, or other: {item}")
    convo.send_message(f"Give a one word classification of how to dispose of " + item + " in Seattle as either garbage bin, "
                       f"compost bin, recycling bin, donate, or special if there are drop-off locations for the item. Suggest "
                       f"garbage only as a last resort if the item cannot possibly be in any of the other categories.")
    classifcation = convo.last.text
    print("Classification: ", classifcation)

    # Cleans up classification
    clean_classification = clean_up_classification(classifcation)
    print("Classification: ", clean_classification)

    # Adds clean classification to dictionary
    response["classification"] = clean_classification

    # gets extra information if needed, depending on classification, and adds to the dictionary

    # For donation classification, get 3 locations for donation
    if clean_classification == "donate":
        convo.send_message(f"Give at most 3 locations to donate " + item + " in Seattle, including the address for each one and not including any other text, "
                           f"as a semicolon separated list where each element is of the following format: Location name: location adress")
        locations_string = convo.last.text
        print("Donation Locations String", locations_string)
        locations_list = get_list_from_string(locations_string)
        print("Donation Locations List", locations_list)
        response["locations"] = locations_list

    # For special classification, get 3 locations for drop-off centers
    elif clean_classification == "special":
        convo.send_message(f"Give at most 3 locations to drop off " + item + " in Seattle, including the address for each one and not including any other text, "
                           f"as a semicolon separated list where each element is of the following format: Location name: location adress")
        locations_string = convo.last.text
        print("Special Locations String", locations_string)
        locations_list = get_list_from_string(locations_string)
        print("Special Locations List", locations_list)
        response["locations"] = locations_list

    # For recycle classification, get all important points user should know to correctly recycle item
    elif clean_classification == "recycle":
        convo.send_message(f"Give any specifications for how " + item + " should be recycled in Seattle recycling bins as a semicolon separated list "
                           f"of the format: specification 1; specification 2; etc")
        specification_string = convo.last.text
        print("Recycling Specification String", specification_string)
        specification_list = get_list_from_string(specification_string)
        print("Recycling Specification List", specification_list)
        response["specifications"] = specification_list
    return response


def get_list_from_string(string_list):
    '''
    Given a string list where each item is separated by a semicolon, returns a python list with those elements
    '''
    return string_list.split("; ")
    

def clean_up_classification(initial_classification):
    '''
    Given an item, cleans up classification and returns clean version.
    '''
    lower_case = initial_classification.lower()

    if "garbage" in lower_case:
        return "garbage"
    elif "compost" in lower_case:
        return "compost"
    elif "recycl" in lower_case:
        return "recycle"
    elif "donate" in lower_case:
        return "donate"
    elif "special" in lower_case:
        return "special"
    else:
        return "LLM unable to properly classify"

def main():
    classify_item("cardboard box")


if __name__ == "__main__":
    main()
