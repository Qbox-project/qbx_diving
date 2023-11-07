local Translations = {
    error = {
        canceled = "Canceled",
        ["911_chatmessage"] = "911 MESSAGE",
        no_coral = "You don't have any coral to sell...",
        not_standing_up = "You need to be on solid ground to put this on...",
        need_otube = "you need to refill your oxygen! Get a replacement air supply!",
        oxygenlevel = "Your air level is %{oxygenlevel}, it must be at 0 to refill!",
    },
    success = {
        took_out = "You took your diving gear off.",
        tube_filled = "You've successfully refilled your air tank!"
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
        put_suit = "Putting on your diving suit...",
        pullout_suit = "Taking off your diving suit...",
        cop_msg = "This coral looks freshly stolen...",
        cop_title = "Illegal Diving",
    },
    warning = {
        oxygen_one_minute = "You have less than one minute of air remaining!",
        oxygen_running_out = "Your air tank is running out of air!",
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
