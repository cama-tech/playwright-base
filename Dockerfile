FROM mcr.microsoft.com/playwright:v1.59.1-jammy

RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:99
