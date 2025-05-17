import vim
from google import genai
from google.genai.types import Tool, GenerateContentConfig, GoogleSearch
import os


def concatenateTextFiles(
        path, \
        file_types = ('.c', '.h', '.cpp', '.py', 'Makefile', '.sh', '.lua', '.js')):

    final_text = ''
    count = 0
    file_names = []

    try:
        file_names = os.listdir(path)
    except e:
        print(f"path error: {file_names}")

    for file in file_names:
        if file.endswith(file_types):
            with open(file, 'r', encoding="utf-8") as f:
                text = f.read()
        final_text = final_text + f"File name: {file}\n\n{text}\n\n\n\n"

    return final_text


def Gemini(prompt, context):
    #pricing
    #https://ai.google.dev/gemini-api/docs/rate-limits
    #
    #gemini-2.0-flash free tier limit:
    #RPM = 15, TPM = 1,000,000, RPD = 1,500

    answer = ''
    context_text = ''
    contents = []

    api_key = os.environ['GEMINI_API_KEY']
    model_id = "gemini-2.0-flash"
    client = genai.Client(api_key=api_key)

    google_search_tool = Tool(
        google_search = GoogleSearch()
    )

    if context != '0':
        contents = [concatenateTextFiles(context), \
                "Based on the provided code, answer the following question: ", \
                    prompt]
    else:
        contents = [prompt]


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

    answer = answer + ("\n\n")

    try:
        for each in response.candidates[0].grounding_metadata.grounding_chunks:
            answer = answer + each.web.title
            answer = answer + each.web.uri
    except:
        pass

    return answer

def main():

    prompt = vim.eval("g:python_gemini_prompt")
    context = vim.eval("g:python_gemini_context")

#    answer = Gemini(prompt, context)
    answer = "porra"
    command_string = f"let python_return={answer}"

    vim.command("let python_return='pnc'")

if __name__ == "__main__":
    main()
