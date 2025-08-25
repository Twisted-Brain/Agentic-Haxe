# bin/python/python_gateway_server.py
from flask import Flask, request, jsonify, send_from_directory
import requests
import json
import os

app = Flask(__name__)

# Serve frontend files (SAME as Node.js/C++)
@app.route('/')
def serve_index():
    return send_from_directory('../frontend', 'index.html')

@app.route('/webapp.js')
def serve_webapp():
    return send_from_directory('../frontend', 'webapp.js')

@app.route('/webapp-styles.css')
def serve_styles():
    return send_from_directory('../frontend', 'webapp-styles.css')

# API endpoints (SAME contract as Node.js/C++)
@app.route('/api/chat', methods=['POST'])
def handle_chat():
    try:
        data = request.get_json()
        message = data.get('message', '')
        model = data.get('model', 'gpt-3.5-turbo')
        
        # OpenRouter API integration
        response = call_openrouter_api(message, model)
        
        return jsonify({
            'content': response,
            'model': model
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'platform': 'python',
        'version': '1.0.0'
    })

def call_openrouter_api(message, model):
    api_key = os.getenv('OPENROUTER_API_KEY')
    if not api_key:
        return f"Python server received: {message} (OpenRouter API key not configured)"
    
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    
    payload = {
        'model': f'openai/{model}',
        'messages': [{'role': 'user', 'content': message}]
    }
    
    try:
        response = requests.post(
            'https://openrouter.ai/api/v1/chat/completions',
            headers=headers,
            json=payload,
            timeout=30
        )
        
        if response.status_code == 200:
            result = response.json()
            return result['choices'][0]['message']['content']
        else:
            return f"API Error {response.status_code}: {response.text}"
    except Exception as e:
        return f"Python server processed: {message} (API call failed: {str(e)})"

if __name__ == '__main__':
    print("Starting Python LLM Gateway Server on port 8080...")
    app.run(host='0.0.0.0', port=8080, debug=True)