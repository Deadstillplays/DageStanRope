--!strict
local AssetCatalog = {}

-- Base endpoints for asset resolution
AssetCatalog.RAW_BASE_URL = "https://raw.githubusercontent.com/Deadstillplays/DageStanRope/main"
AssetCatalog.LOCAL_BASE_URL = "http://localhost:8089"
AssetCatalog.PreferLocal = false

-- Helper to construct full URL
function AssetCatalog.GetUrl(relPath: string): string
    local base = AssetCatalog.PreferLocal and AssetCatalog.LOCAL_BASE_URL or AssetCatalog.RAW_BASE_URL
    return string.format("%s/%s", base, relPath)
end

-- Manifest endpoint
function AssetCatalog.GetManifestUrl(): string
    return AssetCatalog.GetUrl("manifest.json")
end

-- Backgrounds mapping
AssetCatalog.Backgrounds = {
    Classroom = "backgrounds/bgd_002.png",
    Incinerator = "backgrounds/bgd_003.png",
    HallwayCorner = "backgrounds/bgd_004.png",
    Library = "backgrounds/bgd_007.png",
    DormHallway = "backgrounds/bgd_009.png",
    Cafeteria = "backgrounds/bgd_010.png",
    MainHallway = "backgrounds/bgd_013.png",
    Gymnasium = "backgrounds/bgd_014.png",
    Courtroom = "backgrounds/bgd_015.png",
    MakotoRoom = "backgrounds/bgd_020.png",
    DormBathroom = "backgrounds/bgd_021.png",
    HeadmasterOffice = "backgrounds/bgd_022.png",
    ControlRoom = "backgrounds/bgd_024.png",
    Sauna = "backgrounds/bgd_025.png",
    LockerRoom = "backgrounds/bgd_026.png",
    ArchiveRoom = "backgrounds/bgd_027.png",
    SchoolExterior = "backgrounds/bgd_030.png",
    SchoolCourtyard = "backgrounds/bgd_031.png",
    Pool = "backgrounds/bgd_033.png",
}

-- Character Folders & Key Expressions
AssetCatalog.Characters = {
    ["makoto_naegi"] = {
        Name = "Makoto Naegi",
        Color = Color3.fromRGB(46, 204, 113),
        Folder = "characters/makoto_naegi",
        DefaultSprite = "characters/makoto_naegi/makoto_naegi_00.png",
        Shock = "characters/makoto_naegi/makoto_naegi_01.png",
    },
    ["sayaka_maizono"] = {
        Name = "Sayaka Maizono",
        Color = Color3.fromRGB(0, 210, 211),
        Folder = "characters/sayaka_maizono",
        DefaultSprite = "characters/sayaka_maizono/sayaka_maizono_00.png",
        Worried = "characters/sayaka_maizono/sayaka_maizono_03.png",
        Smile = "characters/sayaka_maizono/sayaka_maizono_05.png",
    },
    ["kyoko_kirigiri"] = {
        Name = "Kyoko Kirigiri",
        Color = Color3.fromRGB(155, 89, 182),
        Folder = "characters/kyoko_kirigiri",
        DefaultSprite = "characters/kyoko_kirigiri/kyoko_kirigiri_00.png",
        Analytical = "characters/kyoko_kirigiri/kyoko_kirigiri_02.png",
    },
    ["byakuya_togami"] = {
        Name = "Byakuya Togami",
        Color = Color3.fromRGB(241, 196, 15),
        Folder = "characters/byakuya_togami",
        DefaultSprite = "characters/byakuya_togami/byakuya_togami_00.png",
        Glasses = "characters/byakuya_togami/byakuya_togami_01.png",
    },
    ["toko_fukawa"] = {
        Name = "Toko Fukawa",
        Color = Color3.fromRGB(142, 68, 173),
        Folder = "characters/toko_fukawa",
        DefaultSprite = "characters/toko_fukawa/toko_fukawa_00.png",
        Nervous = "characters/toko_fukawa/toko_fukawa_01.png",
    },
    ["genocider_jack"] = {
        Name = "Genocider Jack",
        Color = Color3.fromRGB(253, 121, 168),
        Folder = "characters/genocider_jack",
        DefaultSprite = "characters/genocider_jack/genocider_jack_00.png",
        Tongue = "characters/genocider_jack/genocider_jack_01.png",
    },
    ["aoi_asahina"] = {
        Name = "Aoi Asahina",
        Color = Color3.fromRGB(230, 126, 34),
        Folder = "characters/aoi_asahina",
        DefaultSprite = "characters/aoi_asahina/aoi_asahina_00.png",
    },
    ["chihiro_fujisaki"] = {
        Name = "Chihiro Fujisaki",
        Color = Color3.fromRGB(39, 174, 96),
        Folder = "characters/chihiro_fujisaki",
        DefaultSprite = "characters/chihiro_fujisaki/chihiro_fujisaki_00.png",
    },
    ["mondo_owada"] = {
        Name = "Mondo Owada",
        Color = Color3.fromRGB(211, 84, 0),
        Folder = "characters/mondo_owada",
        DefaultSprite = "characters/mondo_owada/mondo_owada_00.png",
    },
    ["celestia_ludenberg"] = {
        Name = "Celestia Ludenberg",
        Color = Color3.fromRGB(192, 57, 43),
        Folder = "characters/celestia_ludenberg",
        DefaultSprite = "characters/celestia_ludenberg/celestia_ludenberg_00.png",
    },
    ["junko_enoshima"] = {
        Name = "Junko Enoshima",
        Color = Color3.fromRGB(231, 76, 60),
        Folder = "characters/junko_enoshima",
        DefaultSprite = "characters/junko_enoshima/junko_enoshima_00.png",
    },
    ["sakura_ogami"] = {
        Name = "Sakura Ogami",
        Color = Color3.fromRGB(127, 140, 141),
        Folder = "characters/sakura_ogami",
        DefaultSprite = "characters/sakura_ogami/sakura_ogami_00.png",
    },
    ["monokuma"] = {
        Name = "Monokuma",
        Color = Color3.fromRGB(235, 47, 6),
        Folder = "characters/monokuma",
        DefaultSprite = "characters/monokuma/monokuma_00.png",
        Laugh = "characters/monokuma/monokuma_01.png",
        Angry = "characters/monokuma/monokuma_02.png",
    },
    ["narrator"] = {
        Name = "Narrator / Inner Monologue",
        Color = Color3.fromRGB(160, 192, 255),
        Folder = "",
        DefaultSprite = "",
    },
}

-- Audio SFX
AssetCatalog.SFX = {
  TextClick = "audio/sfx/text_click.wav",
  Select = "audio/sfx/select.wav",
  Confirm = "audio/sfx/confirm.wav",
  Cancel = "audio/sfx/cancel.wav",
  PageTurn = "audio/sfx/page_turn.wav",
  DoorOpen = "audio/sfx/door_open.wav",
  DoorClose = "audio/sfx/door_close.wav",
  ShockSting = "audio/sfx/shock_sting.wav",
  Heartbeat = "audio/sfx/heartbeat.wav",
  Chime = "audio/sfx/chime.wav",
  Objection = "audio/sfx/objection.wav",
  Gavel = "audio/sfx/gavel.wav",
  MonokumaLaugh = "audio/sfx/monokuma_laugh.wav",
}

-- Parsed Stories
AssetCatalog.Scripts = {
  PrologueEntrance = "scripts/prologue_entrance.json",
  PrologueHallMeeting = "scripts/prologue_hall_meeting.json",
  PrologueGymMonokuma = "scripts/prologue_gym_monokuma.json",
}

return AssetCatalog
