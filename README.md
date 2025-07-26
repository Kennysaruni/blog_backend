# Bloggr Backend

A Ruby on Rails API backend for the Bloggr application, providing RESTful endpoints for creating, reading, updating, and deleting posts and comments. It supports user association via `user_id` and uses `ActiveModelSerializers` to include author names in responses, meeting internship test requirements for post/comment CRUD and author name display. The backend uses SQLite3 for lightweight database storage.

## Features

- RESTful API endpoints: `/api/posts`, `/api/comments`, `/api/posts/:post_id/comments`.
- Comment creation via `POST /api/comments` with `{ body, user_id, post_id }`.
- Serializes comments with `user.name` and `created_at` using `CommentSerializer`.
- Error handling for invalid posts, comments, or users.
- Supports user association via `user_id` for posts and comments.

## Prerequisites

- Ruby 3.4.2
- Rails 7.x
- SQLite3
- Bundler

## Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd <repository-dir>/ruby-backend
   ```

2. **Install Dependencies**:

   ```bash
   bundle install
   ```

3. **Set Up the Database**:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Seed Test Data (Optional)**: Create a test user and post:

   ```ruby
   # rails console
   user = User.find_or_create_by(name: "Sam")
   Post.create(title: "Test Post", body: "This is a test post", user: user)
   ```

5. **Run the Server**:

   ```bash
   rails server
   ```

   The API is available at `http://localhost:3000`.

## Project Structure

- `app/controllers/comments_controller.rb`: Handles comment CRUD, including `POST /api/comments`.
- `app/controllers/posts_controller.rb`: Manages post CRUD operations.
- `app/serializers/comment_serializer.rb`: Serializes comments with `user` and `created_at`.
- `app/serializers/post_serializer.rb`: Serializes posts with `user` and `comments`.
- `app/serializers/user_serializer.rb`: Serializes users with `id` and `name`.
- `config/routes.rb`: Defines API routes (`scope :api`).

## API Endpoints

- **Posts**:
  - `GET /api/posts`: List all posts with user and comments.
  - `POST /api/posts`: Create a post (`{ title, body, user: { name } }`).
  - `GET /api/posts/:id`: Show a post.
  - `PUT /api/posts/:id`: Update a post.
  - `DELETE /api/posts/:id`: Delete a post.
- **Comments**:
  - `POST /api/comments`: Create a comment (`{ body, user_id, post_id }`).
  - `GET /api/comments`: List all comments.
  - `GET /api/comments/:id`: Show a comment.
  - `PUT /api/comments/:id`: Update a comment.
  - `DELETE /api/comments/:id`: Delete a comment.
  - `POST /api/posts/:post_id/comments`: Alternative comment creation endpoint.

## Usage

- **Create a Post**:

  ```bash
  curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test Post","body":"This is a test","user":{"name":"Sam"}}'
  ```

- **Create a Comment**:

  ```bash
  curl -X POST http://localhost:3000/api/comments \
  -H "Content-Type: application/json" \
  -d '{"body":"Great post!","user_id":1,"post_id":1}'
  ```

- **Response Example** (Comment):

  ```json
  {
    "id": 1,
    "body": "Great post!",
    "created_at": "2025-07-26T17:29:38.418712Z",
    "user": { "id": 1, "name": "Sam" }
  }
  ```

## Troubleshooting

- **Comment Response Lacks** `user.name`:

  - Verify `CommentSerializer` includes `belongs_to :user, serializer: UserSerializer`.
  - Check response: `curl -X POST http://localhost:3000/api/comments -H "Content-Type: application/json" -d '{"body":"Test","user_id":1,"post_id":1}'`.

- **404 for Post ID**:

  - Check posts: `Post.all.pluck(:id, :title)` in `rails console`.

  - Create a post if needed:

    ```ruby
    user = User.find_or_create_by(name: "Sam")
    Post.create(title: "Test Post", body: "Test body", user: user)
    ```

- **Unique Constraint Error**:

  - Check for duplicate IDs: `Post.all.pluck(:id)`.

  - Delete or use a new ID:

    ```ruby
    Post.find(6).destroy rescue nil
    Post.create(id: 6, title: "Test Post", body: "Test body", user: User.find_or_create_by(name: "Sam"))
    ```

## Dependencies

- `gem 'rails'`
- `gem 'sqlite3'`
- `gem 'active_model_serializers', '~> 0.10'`

## License

# MIT License. See `LICENSE` for details.