FROM mcr.microsoft.com/playwright:v1.59.1-jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Lima

RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:99
