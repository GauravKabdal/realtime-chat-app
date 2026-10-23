# Real-Time Chat Application with AI Assistant

A full-stack real-time messaging app built with the MERN stack and Socket.IO. Users can sign up, chat one-to-one with instant delivery, see who is online, share images, and use an in-chat AI assistant that summarizes conversations, suggests replies, translates and rewrites text, and answers questions about the chat.

> Screenshot: add an image of the app here, for example `![App screenshot](docs/screenshot.png)`

## Features

**Messaging**

- One-to-one real-time messaging with Socket.IO (no page refresh needed)
- Live online/offline status for every user
- Text and image messages, with images stored on Cloudinary
- Persistent message history stored in MongoDB

**Authentication and security**

- Signup, login and logout with JWT authentication
- JWT stored in an HTTP-only, same-site cookie (7-day expiry), not in local storage
- Passwords hashed with bcrypt
- Protected API routes using Express middleware
- Server-side and client-side error handling

**AI assistant**

- An **AI** button beside the message composer in every conversation
- Five actions: summarize the chat, suggest a reply, translate the latest message, rewrite a draft in a chosen tone, and answer a question using only the conversation context
- Uses the 80 most recent messages of the conversation as context
- Calls an OpenAI-compatible Chat Completions API (tested with NVIDIA Nemotron); the API key stays on the server and is never sent to the browser

**User experience**

- Profile page with profile picture upload
- Settings page with selectable UI themes (DaisyUI)
- Responsive layout built with Tailwind CSS
- Loading skeletons while data is fetched
- Global state management with Zustand

## Tech Stack

| Layer    | Technologies                                             |
| -------- | -------------------------------------------------------- |
| Frontend | React, Vite, Zustand, Tailwind CSS, DaisyUI, Axios       |
| Backend  | Node.js, Express.js, Socket.IO                           |
| Database | MongoDB with Mongoose                                    |
| Auth     | JSON Web Tokens, bcrypt, cookie-parser                   |
| Media    | Cloudinary                                               |
| AI       | OpenAI-compatible Chat Completions API (NVIDIA Nemotron) |

## Project Structure

```
.
├── backend
│   └── src
│       ├── controllers   # auth, message and AI request handlers
│       ├── lib           # database, Socket.IO, Cloudinary and token helpers
│       ├── middleware    # JWT route protection
│       ├── models        # User and Message schemas
│       ├── routes        # auth, message and AI routes
│       ├── seeds         # sample user seed script
│       └── index.js      # server entry point
└── frontend
    └── src
        ├── components    # chat UI, sidebar, AI assistant, skeletons
        ├── pages         # home, login, signup, profile, settings
        ├── store         # Zustand stores (auth, chat, theme)
        ├── lib           # Axios instance and utilities
        └── App.jsx
```

## API Overview

| Method | Endpoint                    | Description                         |
| ------ | --------------------------- | ----------------------------------- |
| POST   | `/api/auth/signup`          | Create an account                   |
| POST   | `/api/auth/login`           | Log in and set the auth cookie      |
| POST   | `/api/auth/logout`          | Clear the auth cookie               |
| GET    | `/api/auth/check`           | Check the current session           |
| PUT    | `/api/auth/update-profile`  | Update the profile picture          |
| GET    | `/api/messages/users`       | List users for the sidebar          |
| GET    | `/api/messages/:id`         | Get the message history with a user |
| POST   | `/api/messages/send/:id`    | Send a message to a user            |
| POST   | `/api/ai/conversations/:id` | Run an AI action on a conversation  |

All routes except signup and login require authentication.

## Getting Started

### Prerequisites

- Node.js 18 or later
- A MongoDB database (local, or a free MongoDB Atlas cluster)
- A Cloudinary account (needed for profile pictures and image messages)
- An API key for an OpenAI-compatible provider (optional, only for the AI assistant)

### 1. Clone and install

```bash
git clone https://github.com/GauravKabdal/realtime-chat-app.git
cd realtime-chat-app

cd backend && npm install
cd ../frontend && npm install
```

### 2. Configure environment variables

Create `backend/.env` (see `backend/.env.example`):

```env
PORT=5001
NODE_ENV=development
JWT_SECRET=your_long_random_secret
MONGODB_URI=mongodb://127.0.0.1:27017/chat_db

# Cloudinary (profile pictures and image messages)
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=

# AI assistant (any OpenAI-compatible Chat Completions provider)
OPENAI_API_KEY=
OPENAI_MODEL=
```

Notes:

- `PORT` must be `5001` for local development, because the frontend calls `http://localhost:5001`.
- The AI assistant is optional. Without an API key the AI endpoint returns a "not configured" error and the rest of the app works normally.

### 3. Run in development

Use two terminals:

```bash
# Terminal 1: backend
cd backend
npm run dev

# Terminal 2: frontend
cd frontend
npm run dev
```

Open http://localhost:5173. To try the chat, sign up two users in two different browsers (or one normal and one private window).

### 4. Production build

From the project root:

```bash
npm run build   # installs dependencies and builds the frontend
npm start       # starts the server, which also serves the built frontend
```

Set `NODE_ENV=production` for this mode. The auth cookie is marked `secure` in production, so serve the app over HTTPS.

## Roadmap

- [ ] Dockerize the application
- [ ] CI/CD pipeline with GitHub Actions
- [ ] Redis caching for the user list and recent messages
- [ ] API rate limiting on login and AI endpoints
- [ ] Socket.IO Redis adapter for horizontal scaling

## Acknowledgements

This project started from an open-source MERN chat tutorial (MIT License, see `LICENSE`) and was extended with the AI assistant and an OpenAI-compatible provider integration.

## License

Released under the MIT License. See the `LICENSE` file for details.
