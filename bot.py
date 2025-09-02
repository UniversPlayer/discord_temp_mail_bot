import discord
from discord.ext import commands
from mail_utils import generate_temp_email, get_inbox

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="$", intents=intents)

# Store user tokens so they don't need to copy-paste
user_tokens = {}

# Command to generate new email (sends in DM)
@bot.command()
async def mail(ctx):
    try:
        email, token = generate_temp_email()
        user_tokens[ctx.author.id] = token
        await ctx.author.send(f"📧 Your temp email: `{email}`\n🔑 Token saved automatically.")
        await ctx.reply("✅ Check your DMs for your temp email!")
    except Exception as e:
        await ctx.reply(f"❌ Error: {e}")

# Command to check inbox (uses saved token, sends in DM)
@bot.command()
async def inbox(ctx):
    try:
        token = user_tokens.get(ctx.author.id)
        if not token:
            await ctx.reply("⚠️ You don’t have a saved token. Use `$mail` first.")
            return

        messages = get_inbox(token)
        if not messages:
            await ctx.author.send("📭 Inbox is empty.")
        else:
            reply = "✉️ **Inbox Messages:**\n"
            for m in messages:
                reply += f"From: `{m['from']['address']}`\n"
                reply += f"Subject: `{m['subject']}`\n"
                reply += f"Text: {m['intro']}\n"
                reply += "--------------------\n"
            await ctx.author.send(reply)

        await ctx.reply("✅ Check your DMs for inbox messages!")
    except Exception as e:
        await ctx.reply(f"❌ Error: {e}")

bot.run("PASTE_YOUR_REAL_TOKEN_HERE")  # <-- put your Discord bot token here
