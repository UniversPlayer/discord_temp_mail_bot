#!/bin/bash

echo "Made by ItsNickOp"

# Ask for token and channel ID
read -s -p "Token: " TOKEN
echo
read -s -p "Channel ID: " CHANNEL_ID
echo

# Save these to environment
export DISCORD_TOKEN=$TOKEN
export CHANNEL_ID=$CHANNEL_ID

# Download required files
curl -s -O https://raw.githubusercontent.com/UniversPlayer/discord_temp_mail_bot/main/bot.py
curl -s -O https://raw.githubusercontent.com/UniversPlayer/discord_temp_mail_bot/main/mail_utils.py
curl -s -O https://raw.githubusercontent.com/UniversPlayer/discord_temp_mail_bot/main/requirements.txt

# Install dependencies
pip install -r requirements.txt

# Run the bot
python3 bot.py
