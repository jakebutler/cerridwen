# 🔌 API Documentation

The AI Rules Database provides a comprehensive REST API for accessing coding rulesets programmatically.

## 🚀 Getting Started

### Base URL
```
Production: https://your-deployed-app.replit.app/api/v1
Development: http://localhost:5000/api/v1
```

### Authentication
All API endpoints require authentication using Bearer tokens:

```bash
Authorization: Bearer your-api-key-here
```

### Request API Key
1. Register and login to the web interface
2. Contact administrator for API key approval
3. Use the provided API key in all requests

## 📊 Rate Limits
- Default: 1000 requests per hour per API key
- Rate limits are configurable per API key
- Exceeding limits returns `429 Too Many Requests`

## 🛠 Endpoints

### Get Rulesets
Retrieve a paginated list of rulesets with optional filtering.

```http
GET /api/v1/rulesets
```

#### Query Parameters
| Parameter | Type | Description | Default |
|-----------|------|-------------|---------|
| `search` | string | Search in ruleset content and names | - |
| `technology` | string | Filter by technology (e.g., "React", "Python") | - |
| `type` | string | Filter by type ("global" or "project") | - |
| `source` | string | Filter by source repository | - |
| `limit` | integer | Number of results per page (max 100) | 20 |
| `offset` | integer | Number of results to skip | 0 |

#### Example Request
```bash
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets?technology=React&limit=10"
```

#### Response
```json
{
  "data": [
    {
      "id": 1,
      "name": "React TypeScript Rules",
      "type": "project",
      "technologies": ["React", "TypeScript"],
      "content": "# React TypeScript Rules\n\nUse functional components...",
      "sourceRepo": "PatrickJS/awesome-cursorrules",
      "sourceUrl": "https://github.com/PatrickJS/awesome-cursorrules/blob/main/rules/react-typescript.md",
      "author": "PatrickJS",
      "description": "Best practices for React with TypeScript",
      "createdAt": "2025-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "total": 515,
    "limit": 10,
    "offset": 0
  }
}
```

### Get Single Ruleset
Retrieve detailed information about a specific ruleset.

```http
GET /api/v1/rulesets/{id}
```

#### Example Request
```bash
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets/123"
```

#### Response
```json
{
  "data": {
    "id": 123,
    "name": "Python FastAPI Rules",
    "type": "project", 
    "technologies": ["Python", "FastAPI", "SQLAlchemy"],
    "content": "# FastAPI Best Practices\n\n## Project Structure...",
    "sourceRepo": "steipete/agent-rules",
    "sourceUrl": "https://github.com/steipete/agent-rules/blob/main/python-fastapi.md",
    "author": "steipete",
    "description": "Comprehensive rules for FastAPI development",
    "createdAt": "2025-01-10T14:22:00Z"
  }
}
```

### Get Technologies
Retrieve a list of all available technologies.

```http
GET /api/v1/technologies
```

#### Response
```json
{
  "data": [
    "Angular",
    "C#", 
    "Django",
    "Docker",
    "FastAPI",
    "JavaScript",
    "Node.js",
    "Python",
    "React",
    "TypeScript",
    "Vue.js"
  ]
}
```

### Get Sources
Retrieve a list of all source repositories.

```http
GET /api/v1/sources
```

#### Response
```json
{
  "data": [
    "PatrickJS/awesome-cursorrules",
    "steipete/agent-rules", 
    "cursorrules.org",
    "codingrules.ai"
  ]
}
```

## 📝 Response Format

### Success Response
All successful responses follow this format:
```json
{
  "data": "...", // Response data (object or array)
  "meta": "..."  // Optional metadata (pagination, etc.)
}
```

### Error Response
Error responses include details about what went wrong:
```json
{
  "error": "Error message describing what went wrong",
  "code": "ERROR_CODE",
  "details": "Additional error details if available"
}
```

## 🚨 Error Codes

| Code | Description |
|------|-------------|
| `400` | Bad Request - Invalid parameters |
| `401` | Unauthorized - Invalid or missing API key |
| `403` | Forbidden - API key lacks required permissions |
| `404` | Not Found - Resource doesn't exist |
| `429` | Too Many Requests - Rate limit exceeded |
| `500` | Internal Server Error - Server-side error |

## 🔍 Example Use Cases

### Search for React Rules
```bash
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets?search=React&technology=React&limit=5"
```

### Get All Python Rules
```bash
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets?technology=Python"
```

### Paginate Through All Rules
```bash
# First page
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets?limit=50&offset=0"

# Second page  
curl -H "Authorization: Bearer your-api-key" \
  "https://your-app.replit.app/api/v1/rulesets?limit=50&offset=50"
```

## 🔧 API Client Examples

### JavaScript/Node.js
```javascript
const API_KEY = 'your-api-key';
const BASE_URL = 'https://your-app.replit.app/api/v1';

async function getRulesets(params = {}) {
  const url = new URL(`${BASE_URL}/rulesets`);
  Object.keys(params).forEach(key => url.searchParams.append(key, params[key]));
  
  const response = await fetch(url, {
    headers: {
      'Authorization': `Bearer ${API_KEY}`,
      'Content-Type': 'application/json'
    }
  });
  
  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }
  
  return response.json();
}

// Usage
getRulesets({ technology: 'React', limit: 10 })
  .then(data => console.log(data))
  .catch(error => console.error(error));
```

### Python
```python
import requests

API_KEY = 'your-api-key'
BASE_URL = 'https://your-app.replit.app/api/v1'

def get_rulesets(**params):
    headers = {
        'Authorization': f'Bearer {API_KEY}',
        'Content-Type': 'application/json'
    }
    
    response = requests.get(f'{BASE_URL}/rulesets', params=params, headers=headers)
    response.raise_for_status()
    return response.json()

# Usage
data = get_rulesets(technology='Python', limit=10)
print(data)
```

### PHP
```php
<?php
$apiKey = 'your-api-key';
$baseUrl = 'https://your-app.replit.app/api/v1';

function getRulesets($params = []) {
    global $apiKey, $baseUrl;
    
    $url = $baseUrl . '/rulesets?' . http_build_query($params);
    
    $context = stream_context_create([
        'http' => [
            'header' => "Authorization: Bearer $apiKey\r\n",
            'method' => 'GET'
        ]
    ]);
    
    $response = file_get_contents($url, false, $context);
    return json_decode($response, true);
}

// Usage
$data = getRulesets(['technology' => 'PHP', 'limit' => 10]);
print_r($data);
?>
```

## 📈 Usage Analytics

API usage is tracked automatically. Administrators can view:
- Request counts per API key
- Response times
- Error rates
- Popular endpoints and filters

## 🔒 Security Best Practices

1. **Keep API keys secure** - Never commit them to version control
2. **Use environment variables** for API key storage
3. **Implement proper error handling** for rate limits and failures
4. **Cache responses** when appropriate to reduce API calls
5. **Use HTTPS** for all production requests

## 📞 Support

For API support:
- Check error messages for specific guidance
- Contact system administrator for API key issues
- Report bugs through the web interface
- Request rate limit increases through admin panel

---

Happy coding! 🚀