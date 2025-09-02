#!/bin/bash

echo "Made by ItsNickOp"

# Ask for token and channel ID (input will be hidden)
read -s -p "Token: " TOKEN
echo
read -s -p "Channel ID: " CHANNEL_ID
echo

# Save these to environment for bot.py to use
export DISCORD_TOKEN=$TOKEN
export CHANNEL_ID=$CHANNEL_ID

# Install required libraries
pip install -r requirements.txt

# Start the bot
python3 bot.py
