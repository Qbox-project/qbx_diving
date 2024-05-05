local Translations = {
    error = {
        canceled = "Cancelado",
        no_coral = "Não tem nenhum coral para vender...",
    },
    info = {
        collecting_coral = "A recolher coral",
        diving_area = "Zona de Mergulho",
        collect_coral = "Recolher coral",
        collect_coral_dt = "[E] - Recolher Coral",
        checking_pockets = "A verificar o inventário por coral para vender...",
        sell_coral = "Vender Coral",
        sell_coral_dt = "[E] - Vender Coral",
    },
}

if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
