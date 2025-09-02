#!/bin/bash
echo "=== Discord Temp-Mail Bot (Mail.tm) Setup ==="

# Ask for bot token
read -s -p "Enter your Discord Bot Token: " TOKEN
echo

# Create project folder
mkdir -p discord_temp_mail_bot
cd discord_temp_mail_bot || exit

# Create requirements.txt
cat > requirements.txt <<EOF
discord.py
requests
EOF

# Create mail_utils.py
cat > mail_utils.py <<'EOF'
import requests

BASE_URL = "https://api.mail.tm"

def generate_temp_email():
    res = requests.post(
        f"{BASE_URL}/accounts",
        json={"address": None, "password": "discordbot123"}
    )
    if res.status_code != 201:
        raise Exception("Failed to create email: " + res.text)
    account = res.json()
    email = account["address"]

    login = requests.post(
        f"{BASE_URL}/token",
        json={"address": email, "password": "discordbot123"}
    )
    if login.status_code != 200:
        raise Exception("Failed to login: " + login.text)
    token = login.json()["token"]
    return email, token

def get_inbox(token):
    headers = {"Authorization": f"Bearer {token}"}
    res = requests.get(f"{BASE_URL}/messages", headers=headers)
    if res.status_code != 200:
        raise Exception("Failed to fetch inbox: " + res.text)
    return res.json().get("hydra:member", [])
EOF

# Create bot.py
cat > bot.py <<EOF
import discord
from discord.ext import commands
from mail_utils import generate_temp_email, get_inbox

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="\$", intents=intents)

user_tokens = {}

@bot.command()
async def mail(ctx):
    try:
        email, token = generate_temp_email()
        user_tokens[ctx.author.id] = token
        await ctx.author.send(f"📧 Your temp email: \`{email}\`\\n🔑 Token saved automatically.")
        await ctx.reply("✅ Check your DMs for your temp email!")
    except Exception as e:
        await ctx.reply(f"❌ Error: {e}")

@bot.command()
async def inbox(ctx):
    try:
        token = user_tokens.get(ctx.author.id)
        if not token:
            await ctx.reply("⚠️ You don’t have a saved token. Use \`$mail\` first.")
            return

        messages = get_inbox(token)
        if not messages:
            await ctx.author.send("📭 Inbox is empty.")
        else:
            reply = "✉️ **Inbox Messages:**\\n"
            for m in messages:
                reply += f"From: \`{m['from']['address']}\`\\n"
                reply += f"Subject: \`{m['subject']}\`\\n"
                reply += f"Text: {m['intro']}\\n"
                reply += "--------------------\\n"
            await ctx.author.send(reply)

        await ctx.reply("✅ Check your DMs for inbox messages!")
    except Exception as e:
        await ctx.reply(f"❌ Error: {e}")

bot.run("${TOKEN}")
EOF

# Install dependencies
pip install -r requirements.txt

# Run the bot
python3 bot.py
