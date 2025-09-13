# RPG Annotator API

This is the **Rails API** that powers [RPG Annotator](https://rpg-annotator-frontend.onrender.com).  
It stores documents and annotations, and serves them to the React frontend.

Live API example: [https://rpg-annotator-api.onrender.com/api/v1/documents/1](https://rpg-annotator-api.onrender.com/api/v1/documents/1)

## Setup

```bash
bundle install
rails db:setup
rails server

# API will be available at http://localhost:3000
```

## API Overview

### Documents
- **GET `/api/v1/documents/:id`**  
  Returns a document and its annotations.

  **Example response:**
  ```json
  {
    "document": {
      "id": 1,
      "title": "Sample Document",
      "rendered_content": "<p>...</p>"
    },
    "annotations": [
      {
        "id": 1,
        "selection_text": "lorem ipsum",
        "annotation_text": "example note",
        "author": "user",
        "created_at": "2025-09-13T18:00:00Z"
      }
    ]
  }
### Annotations

#### POST `/api/v1/annotations` Create a new annotation.
Body (JSON):
```json
{
"annotation": 
  {
    "document_id": 1,
    "selection_text": "lorem ipsum",
    "start_offset": 42,
    "end_offset": 53,
    "annotation_text": "my note",
    "author": "current_user"
  }
}
```

#### PUT `/api/v1/annotations/:id` Update an annotation.

#### DELETE `/api/v1/annotations/:id` Remove an annotation.


Frontend: [RPG Annotator](https://rpg-annotator-frontend.onrender.com)