Config = {}

Config.OltaItem = 'fishingrod'

Config.IllegalKaraParaMiVersin = true
Config.Karaparaitem = "karapara" -- yada markedbills karapara vb. şeyler olabilir


Config.Baliklar = {
    {
        item = "kilicbaligi",
        label = "Kılıç Balığı",
        fiyat = 5000,
        sans = 40,
        illegal = false
    },
    {
        item = "bluefish",
        label = "Lüfer",
        fiyat = 6000,
        sans = 30,
        illegal = false
    },
    {
        item = "kefal",
        label = "Kefal",
        fiyat = 7500,
        sans = 20,
        illegal = false
    },
    {
        item = "carettacaretta",
        label = "Kaplumbaga",
        fiyat = 15000,
        sans = 10,
        illegal = true
    }
}

Config.NPCler = {
    satici = {
        model = 'cs_old_man2',
        coords = vector4(-1836.39, -1230.13, 13.02, 323.01),
        label = "[ALT] Balık Satıs"
    },
    oltaci = {
        model = 'a_m_m_farmer_01',
        coords = vector4(-1847.43, -1220.81, 13.02, 318.05),
        label = "[ALT] Olta Satın Al"
    },
    illegal = {
        model = 's_m_y_dealer_01',
        coords = vector4(1544.83, 6333.44, 23.08, 60.13),
        label = "[ALT] İllegal Balık Alıcısı"
    }
}

Config.Blips = {
    iskele = {
        coords = vector3(-1849.05, -1230.93, 13.02),
        sprite = 68,
        color = 3,
        scale = 0.7,
        label = "İskele"
    },
    illegalsatis = {
        coords = vector3(1544.83, 6333.44, 23.08),
        sprite = 429,
        color = 1,
        scale = 0.7,
        label = "İllegal Balık Satış"
    },
}

Config.BalikTutmaAlani = {
    merkez = vector3(-1849.05, -1230.93, 13.02),
    radius = 50.0
} 