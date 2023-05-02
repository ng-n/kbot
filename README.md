# kbot
# devops application from scratch

## My Telegram Bot t.me/ng_n_bot

This is a Telegram bot built with Go and Cobra library.

## Usage

To use the bot, you need a Telegram account and follow these steps:

1. Start a chat with [@BotFather](https://t.me/botfather) and create a new bot.
2. Type down `/newbot`, then write a name of your new bot, ex. `kbot`.
3. Then type down a username for your bot ex. `ng-n_bot`.
4. Copy the bot token provided by @BotFather and save it as an environment variable named `TELE_TOKEN`.
``` 
    export TELE_TOKEN=<token>
```
5. Clone this repository and navigate to the project directory called `kbot`.
6. Install the required dependencies and run the bot by executing the following commands:
```
    go get 
    go build -ldflags "-X="github.com/ng-n/kbot/cmd.appVersion=v1.0.0
    ./kbot start
```
7. Go to your bot t.me/ng_n_bot and send a message to the bot:
```
    /start
    /start hello
```
8. Check bitcoin price:
```
    /getbitcoinprice
```


