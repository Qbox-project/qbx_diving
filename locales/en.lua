local Translations = {
    error = {
        canceled = "Canceled",
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
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
