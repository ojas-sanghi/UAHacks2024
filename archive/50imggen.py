import requests

import io
from PIL import Image

import time

API_URL = "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0"
headers = {"Authorization": "Bearer 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"}

def query(payload):
	response = requests.post(API_URL, headers=headers, json=payload)
	return response.content


def get_img_prompt(prompt, value):
    import anthropic

    client = anthropic.Anthropic(
        api_key="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",
    )
    message = client.messages.create(
        model="claude-3-haiku-20240307",
        max_tokens=1000,
        temperature=0,
        system=f"I will give you a word or two around which to generate an AI image generation prompt for the Stable Diffusion model. Generate a long, detailed, and high-quality model. IMPORTANT: Make a prompt that generates art that is of such quality that would be \"valued\" according to society as the following value: {value}. For example, if the value is \"Trash\", then make a prompt that makes a really bad piece of art. If the value is \"Common\", then make a prompt that would generate a relatively ordinary piece of art. If the value is \"Valuable\", then make a prompt that would generates a high-quality piece of art. If the value is \"Exceptional\", then make a prompt that makes a gorgeous, beautiful piece of art that would sell for a lot of money. IMPORTANT: Ensure the end picture generated makes it relatively clear what the original prompt was. That is, the one or two-word prompt I feed you. \n\nReturn just the prompt in it's full form. Include nothing else. No text before or after. No quotes. Just the prompt.",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": f"{prompt}"
                    }
                ]
            }
        ]
    )
    
    return message.content[0].text

prompt_dict = {
}

with open("archive/50prompts.txt", "r") as f:
    lines = f.readlines()
    i = 0
    
    art_prompts = {}
    art_values = {}
    
    for l in lines:
        l = l.strip()
        
        l_spl = l.split(" - ")
        
        prompt = l_spl[0]
        value = l_spl[1]
        location = "res://assets/ai-img-" + str(i) + ".jpg"    
        
        # ai_prompt = get_img_prompt(prompt, value)
        # print(ai_prompt)
        
        # image_bytes = query({
        #     "inputs": ai_prompt,
        # })
        
        art_prompts[location] = prompt
        art_values[location] = value
        
        
        # prompt_dict[prompt] = [value, location]
        
        # image = Image.open(io.BytesIO(image_bytes))
        # image.show()
        
        # with open(location, "x") as f:
        #     image.save(location)
        
        # with open("50prompts.json", "w+") as f:
        #     f.write(str(prompt_dict))
        
        i += 1
        
        # time.sleep(15)
        
        
        
print(art_prompts)
print(art_values)