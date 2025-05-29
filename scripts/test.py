import vim
from google import genai
from google.genai.types import Tool, GenerateContentConfig, GoogleSearch
import os
import re

def Gemini(prompt, context):
    #pricing
    #https://ai.google.dev/gemini-api/docs/rate-limits
    #
    #gemini-2.0-flash free tier limit:
    #RPM = 15, TPM = 1,000,000, RPD = 1,500


    answer = ''
    context_text = ''                   #acho que tem que tirar isso
    contents = []

    api_key = os.environ['GEMINI_API_KEY']
    model_id = "gemini-2.0-flash"
    client = genai.Client(api_key=api_key)

    google_search_tool = Tool(
        google_search = GoogleSearch()
    )


    if prompt == 'null':
        prompt = "Give me one single tip to improve this thing."

    if context != '0':
        contents = [context, \
                "Based on the provided code, answer the following: ", \
                    prompt]
    else:
        contents = [prompt]

    #make the call
    response = client.models.generate_content(
        model=model_id,
        contents=contents,
        config=GenerateContentConfig(
            tools=[google_search_tool],
            response_modalities=["TEXT"],
            system_instruction="You are a very concise and helpful programmer assistant. You aways try to ilustrate your point with good examples"
        )
    )

    answer = answer + f"Google search: {response.candidates[0].grounding_metadata.web_search_queries}\n"

    for each in response.candidates[0].content.parts:
        answer = answer + each.text + "\n"
#
#    answer = answer + ("\n\n")
#
#    try:
#        for each in response.candidates[0].grounding_metadata.grounding_chunks:
#            answer = answer + each.web.title
#            answer = answer + each.web.uri
#    except:
#        pass

    return answer

def main():

    context = vim.eval('context')
    prompt = vim.eval('prompt')
#
    answer = Gemini(prompt, context)
    answer = re.sub(r'[^a-zA-Z0-9\s]', '', answer)
    vim.command(f"let python_call_returns = '{answer}'")
#    test = "whaterver]"
#    vim.command(f"let python_call_returns = '{test}'")

if __name__ == "__main__":
    main()
