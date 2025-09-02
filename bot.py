import os
import discord
from discord.ext import commands
from mail_utils import generate_temp_email, get_inbox

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='$', intents=intents)

TOKEN = os.getenv("DISCORD_TOKEN")
CHANNEL_ID = int(os.getenv("CHANNEL_ID"))

user_emails = {}

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user}')

@bot.command()
async def mail(ctx):
    if ctx.channel.id != CHANNEL_ID:
        return

    await ctx.send("Generating email...")

    login, domain, email = generate_temp_email()
    user_emails[ctx.author.id] = (login, domain)

    await ctx.send(f"Email Generated ✅\nSending the temp mail to {ctx.author.mention}\n`{email}`")

@bot.command()
async def inbox(ctx, email=None):
    if ctx.channel.id != CHANNEL_ID:
        return

    if ctx.author.id not in user_emails:
        await ctx.send("You haven't generated a temp mail yet. Use `$mail` first.")
        return

    login, domain = user_emails[ctx.author.id]
    inbox_data = get_inbox(login, domain)

    if not inbox_data:
        await ctx.send("📭 Inbox is empty.")
        return

    messages = []
    for mail in inbox_data[-5:]:  # Show last 5 messages
        messages.append(f"From: `{mail['from']}` | Subject: `{mail['subject']}`")

    await ctx.send("\n".join(messages))

bot.run(TOKEN)
