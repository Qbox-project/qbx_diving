local Translations = {
    error = {
        canceled = "Zrušeno",
        no_coral = "Nemáte žádný korál k prodeji...",
    },
    info = {
        collecting_coral = "Sbírání korálu",
        diving_area = "Plocha potápění",
        collect_coral = "Sbírejte korál",
        collect_coral_dt = "[E] - Sbírat korál",
        checking_pockets = "Kontrola inventáře pro prodej korálu...",
        sell_coral = "Prodej korálu",
        sell_coral_dt = "[E] - Prodat korál",
    },
}

if GetConvar('qb_locale', 'en') == 'cs' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
--translate by stepan_valic