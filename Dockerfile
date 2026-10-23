# ---------- Stage 1: build the React frontend ----------
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# ---------- Stage 2: production image ----------
FROM node:20-alpine
ENV NODE_ENV=production
# The server resolves ../frontend/dist from its working directory,
# so it must run from /app/backend.
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci --omit=dev
COPY backend/ ./
COPY --from=frontend-build /app/frontend/dist /app/frontend/dist

ENV PORT=5001
EXPOSE 5001
USER node
CMD ["node", "src/index.js"]
