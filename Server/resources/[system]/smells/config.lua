Config = {}
Config.Debug = false

-- Seleção do sistema de inventário
-- Valores suportados: 'ox', 'esx', 'qb', 'origen', 'ps', 'ak47', 'vrp'
-- Certifique-se de que isso corresponde ao inventário/framework que você realmente usa no seu servidor.
Config.inventory = 'vrp'

-- Configurações globais
Config.global = {
    baseAlpha = 0.3,
    viewDistance = 10.0, -- Distância de visão padrão para partículas (em unidades)
    trailUpdateDistance = 2.0,
    trailUpdateInterval = 1000, -- Frequência de criação de pontos de rastro (ms)
    decayCheckInterval = 1000, -- Frequência de verificação de rastros expirados (ms)
    syncInterval = 2000, -- Frequência de sincronização de rastros com o servidor (ms)
    motionThreshold = 0.5, -- Limiar de velocidade para objetos em movimento (m/s)
    nighttimeAlphaIncrease = 0.2, -- Aumento de opacidade (Alpha) durante a noite (padrão: 20% = 0.2)
    nighttimeStartHour = 23, -- A noite começa nesta hora
    nighttimeEndHour = 6, -- A noite termina nesta hora
}

-- Configurações do modo de faro (Smell Mode)
Config.smellMode = {
    duration = 5000, -- Duração do modo de faro em ms (padrão: 5 segundos)
    cooldown = 3000, -- Tempo de recarga entre usos em ms (padrão: 3 segundos)
    alphaIncrease = 0.15, -- Porcentagem de aumento de opacidade (padrão: 15% = 0.15)
    command = 'smellmode', -- Nome do comando para ativar o modo de faro
}

Config.presets = {
    weed = {
        color = rgb(0, 1.0, 0),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.2,
        alpha = 0.6 -- nil = usa o alpha base global, ou defina um valor específico (0.0-1.0)
    },
    alcohol = {
        color = rgb(0.8, 0.8, 0),
        dict = 'core',
        particle = 'veh_respray_smoke',
        scale = 0.2,
        alpha = 0.6
    },
    purple_weed = {
        color = rgb(0.7, 0, 1.0),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.5,
        alpha = 0.4
    },
    petrol = {
        color = rgb(1.0, 0.65, 0),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.3,
        alpha = 0.3
    },
    blood = {
        color = rgb(1.0, 0, 0),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.3,
        alpha = 0.2
    },
    gunpowder = {
        color = rgb(0.4, 0.4, 0.4),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.6,
        alpha = nil
    },
    vape = {
        color = rgb(0, 0, 0),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.5,
        alpha = 0.6
    },
    cigarette = {
        color = rgb(0.95, 0.95, 0.95),
        dict = 'scr_paintnspray',
        particle = 'scr_respray_smoke',
        scale = 0.2,
        alpha = 0.8
    },
    vomit = {
        color = rgb(0.9, 0.85, 0.5), -- Champagne / Palha
        dict = 'scr_family5',
        particle = 'scr_trev_puke',
        scale = 0.3,
        alpha = 0.4
    }
}

-- Lista de todos os cenários pode ser encontrada aqui: https://wiki.rage.mp/wiki/Scenarios
Config.scenarios = {
    WORLD_HUMAN_DRUG_DEALER = {
        preset = 'purple_weed',
        ttl = 5000,
        alpha = 0.2,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    PROP_HUMAN_SEAT_BENCH_DRINK_BEER = {
        preset = 'alcohol',
        ttl = 5000,
        alpha = 0.2,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    }
}

-- Configurações de odores para animações
-- Estes dados são usados quando AddAnimationTrail é chamado via evento (ex: smells:startDrugSmell)
-- A chave é um identificador personalizado.
Config.animations = {
    joint_smoking = {
        animDict = 'amb@world_human_aa_smoke@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro de Maconha',
        preset = 'weed',
        ttl = 50000,
        alpha = 0.5,
        scale = 0.4,
        offset = vec3(0, 0, 0.7)
    },
    cocaine_snorting = {
        animDict = 'anim@amb@nightclub@peds@',
        animName = 'missfbi3_party_snort_coke_b_male3',
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        ttl = 10000,
        alpha = 0.3,
        scale = 0.2,
        offset = vec3(0, 0, 0.7)
    },
    meth_inhaling = {
        animDict = 'amb@world_human_clipboard@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        ttl = 15000,
        alpha = 0.4,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    heroin_taking = {
        animDict = 'amb@world_human_clipboard@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        ttl = 15000,
        alpha = 0.4,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    crack_smoking = {
        animDict = 'amb@world_human_clipboard@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        ttl = 15000,
        alpha = 0.4,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    drinking_alcohol = {
        animDict = 'amb@world_human_drinking@beer@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        ttl = 10000,
        alpha = 0.5,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    coffee_idle = {
        animDict = 'amb@world_human_drinking@coffee@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro de Café',
        preset = 'alcohol',
        ttl = 50000,
        alpha = 0.1,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    vape_using = {
        animDict = 'anim@heists@humane_labs@finale@keycards',
        animName = 'ped_a_enter_loop',
        label = 'Cheiro de Vape',
        preset = 'vape',
        ttl = 30000,
        alpha = 0.4,
        scale = 0.3,
        offset = vec3(0, 0, 0.7)
    },
    cigarette_smoking = {
        animDict = 'amb@world_human_aa_smoke@male@idle_a',
        animName = 'idle_c',
        label = 'Cheiro de Cigarro',
        preset = 'cigarette',
        ttl = 30000,
        alpha = nil,
        scale = 0.2,
        offset = vec3(0, 0, 0.7)
    },
    vomit = {
        animDict = 'missfam5_blackout',
        animName = 'vomit',
        label = 'Cheiro de Vômito',
        preset = 'vomit',
        ttl = 15000,
        alpha = 0.3,
        scale = 0.3,
        offset = vec3(0, 0, 0.5)
    },
    metadone_taking = {
        animDict = 'mp_suicide',
        animName = 'pill',
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        ttl = 10000,
        alpha = 0.3,
        scale = 0.2,
        offset = vec3(0, 0, 0.7)
    }
}

Config.events = {
    -- Quando o jogador recebe dano
    CEventNetworkEntityDamage = {
        label = 'Cheiro de Sangue',
        preset = 'blood',
        ttl = 50000,
        attachToPlayer = true,
        offset = nil
    }
}

-- Configuração de cheiro para estado ferido (Writhe)
Config.writhe = {
    enabled = true,
    label = 'Cheiro de Sangue',
    preset = 'blood',
    ttl = 5000, -- Duração em ms
    attachToPlayer = true,
    offset = nil,
    scale = 0.5
}

-- Itens que produzem cheiro no chão ou quando carregados
-- A chave é o identificador do item no seu sistema de inventário
Config.smelly_items = {
    joint = {
        label = 'Cheiro de Maconha',
        preset = 'weed',
        scale = 0.4,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    cocaine = {
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        scale = 0.2,
        alpha = 0.2,
        offset = vec3(0,0,0.8)
    },
    crack = {
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        scale = 0.3,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    ls_weed = {
        label = 'Cheiro de Maconha',
        preset = 'weed',
        viewDistance = nil,
        dict = '',
        particle = '',
        scale = 0.4,
        color = nil,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    meth = {
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        scale = 0.3,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    heroin = {
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        scale = 0.3,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    metadone = {
        label = 'Cheiro Químico',
        preset = 'gunpowder',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    beer = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    tequila = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    vodka = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    whisky = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    cognac = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    rum = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    gin = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    absinthe = {
        label = 'Cheiro de Álcool',
        preset = 'alcohol',
        scale = 0.2,
        alpha = 0.3,
        offset = vec3(0,0,0.8)
    },
    vape = {
        label = 'Cheiro de Vape',
        preset = 'vape',
        scale = 0.3,
        alpha = 0.4,
        offset = vec3(0,0,0.8)
    },
    cigarette = {
        label = 'Cheiro de Cigarro',
        preset = 'cigarette',
        scale = 0.2,
        alpha = nil,
        offset = vec3(0,0,0.8)
    }
}

-- Objetos que produzem cheiro (nomes dos modelos)
Config.smelly_props = {
    prop_weed_01 = {
        preset = 'weed',
        label = 'Cheiro de Maconha',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        offset = vec3(0,0,1)
    },
    prop_bbq_1 = {
        preset = 'weed',
        label = 'Cheiro de Churrasco',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        color = rgb(0,0,1),
        scale = 0.5,
        alpha = 0.5,
        offset = vec3(0,0,1)
    },
    bkr_prop_weed_med_01b = {
        preset = 'weed',
        label = 'Cheiro de Maconha',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        offset = vec3(0,0,1)
    },
    bkr_prop_weed_med_01a = {
        preset = 'weed',
        label = 'Cheiro de Maconha',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        offset = vec3(0,0,1)
    },
    prop_gas_pump_old2 = {
        preset = 'petrol',
        label = 'Cheiro de Combustível',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        offset = vec3(0,0,1)
    },
    prop_bin_07c = {
        preset = 'weed',
        label = 'Cheiro de Lixo',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        color = rgb(0, 1.8, 0),
        offset = vec3(0,0,1)
    },
    prop_rub_binbag_06 = {
        preset = 'weed',
        label = 'Cheiro de Lixo',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        scale = 0.2,
        offset = vec3(0,0,0.4)
    },
    p_cs_joint_01 = {
        preset = 'weed',
        label = 'Cheiro de Maconha',
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        scale = 0.4,
        alpha = 0.5,
        offset = vec3(0,0,0.2)
    },
    prop_weed_02 = {
        preset = 'weed',
        label = 'Plantação de Maconha',
        color = rgb(0.345, 0.545, 0.086),
        viewDistance = nil,
        emitWhenStationary = true,
        emitWhenMoving = true,
        scale = 0.4,
        alpha = 0.5,
        offset = vec3(0,0,1.0)
    }
}
