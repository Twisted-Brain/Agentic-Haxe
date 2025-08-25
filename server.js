const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const axios = require('axios');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_PORT = process.env.BACKEND_PORT || 8080;
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const OPENROUTER_BASE_URL = process.env.OPENROUTER_BASE_URL || 'https://openrouter.ai/api/v1';

// Validate API key
if (!OPENROUTER_API_KEY || OPENROUTER_API_KEY === 'your_openrouter_api_key_here') {
  console.warn('⚠️  Warning: OpenRouter API key not configured. Please set OPENROUTER_API_KEY in .env file.');
  console.warn('   Copy your API key from ~/.env to ./.env in the project directory.');
}

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Serve static files from bin/frontend
app.use(express.static(path.join(__dirname, 'bin/frontend')));

// API endpoint for real OpenRouter chat
app.post('/api/chat', async (req, res) => {
  try {
    const { message, model = 'openai/gpt-3.5-turbo' } = req.body;
    
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    if (!OPENROUTER_API_KEY || OPENROUTER_API_KEY === 'your_openrouter_api_key_here') {
      return res.status(500).json({ 
        error: 'OpenRouter API key not configured. Please set OPENROUTER_API_KEY in .env file.' 
      });
    }

    console.log(`Making real OpenRouter API call with model: ${model}`);
    
    // Make actual OpenRouter API request
    const openRouterResponse = await axios.post(
      `${OPENROUTER_BASE_URL}/chat/completions`,
      {
        model: model,
        messages: [
          {
            role: 'user',
            content: message
          }
        ],
        max_tokens: 150,
        temperature: 0.7
      },
      {
        headers: {
          'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
          'Content-Type': 'application/json',
          'HTTP-Referer': 'http://localhost:3000',
          'X-Title': 'Haxe AI Chat Gateway'
        },
        timeout: 30000
      }
    );

    const aiResponse = openRouterResponse.data.choices[0].message.content;
    const tokensUsed = openRouterResponse.data.usage?.total_tokens || 0;

    console.log(`OpenRouter API response received (${tokensUsed} tokens used)`);

    res.json({
      model: model,
      response: aiResponse,
      tokensUsed: tokensUsed
    });

  } catch (error) {
    console.error('Error with OpenRouter API:', error.response?.data || error.message);
    
    if (error.response?.status === 401) {
      res.status(401).json({ error: 'Invalid OpenRouter API key' });
    } else if (error.response?.status === 429) {
      res.status(429).json({ error: 'Rate limit exceeded. Please try again later.' });
    } else if (error.code === 'ECONNABORTED') {
      res.status(408).json({ error: 'Request timeout. Please try again.' });
    } else {
      res.status(500).json({ error: 'OpenRouter API error: ' + (error.response?.data?.error?.message || error.message) });
    }
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Serve index.html for all other routes (SPA support)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'bin/frontend/index.html'));
});

app.listen(PORT, () => {
  console.log(`Node.js server running on http://localhost:${PORT}`);
  console.log(`Serving frontend from: ${path.join(__dirname, 'bin/frontend')}`);
});

module.exports = app;