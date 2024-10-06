local Translations = {
    error = {
        canceled = "Abgebrochen",
        no_coral = "Du hast kein Korallen zum Verkaufen...",
    },
    info = {
        collecting_coral = "Korallen sammeln",
        diving_area = "Tauchgebiet",
        collect_coral = "Korallen sammeln",
        collect_coral_dt = "[E] - Korallen sammeln",
        checking_pockets = "Inventar auf Korallen zum Verkaufen überprüfen...",
        sell_coral = "Korallen verkaufen",
        sell_coral_dt = "[E] - Korallen verkaufen",
    },
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end