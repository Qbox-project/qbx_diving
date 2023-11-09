local Translations = {
    error = {
        canceled = "Canceled",
        ["911_chatmessage"] = "911 MESSAGE",
        no_coral = "You don't have any coral to sell...",
    },
    info = {
        collecting_coral = "Collecting coral",
        diving_area = "Diving Area",
        collect_coral = "Collect coral",
        collect_coral_dt = "[E] - Collect Coral",
        checking_pockets = "Checking Inventory for Coral to Sell...",
        sell_coral = "Sell Coral",
        sell_coral_dt = "[E] - Sell Coral",
        blip_text = "911 - Dive Site",
        cop_msg = "This coral looks freshly stolen...",
        cop_title = "Illegal Diving",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
