# API Integration Skill

This skill provides knowledge about integrating with external APIs in this project.

## When to Use

- When creating new API endpoints
- When connecting to third-party services
- When handling authentication flows

## Patterns

### HTTP Client Setup

```typescript
import axios from "axios";

const apiClient = axios.create({
  baseURL: process.env.API_BASE_URL,
  timeout: 30000,
  headers: {
    "Content-Type": "application/json",
  },
});

// Request interceptor for auth
apiClient.interceptors.request.use((config) => {
  const token = getAuthToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response) => response.data,
  (error) => {
    if (error.response?.status === 401) {
      handleUnauthorized();
    }
    throw new ApiError(error.response?.status, error.message);
  },
);
```

### Error Handling

Always wrap API calls in try/catch and provide typed error responses:

```typescript
interface ApiResult<T> {
  data: T | null;
  error: string | null;
  status: number;
}

async function safeApiCall<T>(fn: () => Promise<T>): Promise<ApiResult<T>> {
  try {
    const data = await fn();
    return { data, error: null, status: 200 };
  } catch (err) {
    const message = err instanceof ApiError ? err.message : "Unknown error";
    const status = err instanceof ApiError ? err.status : 500;
    return { data: null, error: message, status };
  }
}
```
