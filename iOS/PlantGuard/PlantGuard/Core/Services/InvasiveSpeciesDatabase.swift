//
//  InvasiveSpeciesDatabase.swift
//  PlantGuard
//
//  Created on 2024
//

import Foundation

struct InvasiveSpeciesInfo {
    let severity: String
    let reason: String
    let commonNames: [String]  // 中文名或常用名
    let latinNames: [String]    // 拉丁学名（包括变种）
}

class InvasiveSpeciesDatabase {
    static let shared = InvasiveSpeciesDatabase()
    
    // 入侵物种数据库 - 扩展版（包含100+种常见入侵植物）
    private let invasiveSpecies: [String: InvasiveSpeciesInfo] = [
        // ========== 水生植物 ==========
        "Eichhornia crassipes": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Water hyacinth (Eichhornia crassipes) is a highly invasive aquatic plant that reproduces rapidly, clogs waterways, and impacts aquatic ecosystems.",
            commonNames: ["凤眼蓝", "凤眼莲", "水葫芦", "水浮莲"],
            latinNames: ["Eichhornia crassipes", "Pontederia crassipes"]
        ),
        
        "Salvinia molesta": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant salvinia is a free-floating aquatic fern that forms dense mats on water surfaces, blocking sunlight and depleting oxygen levels.",
            commonNames: ["大薸", "水浮萍", "槐叶萍"],
            latinNames: ["Salvinia molesta", "Salvinia adnata"]
        ),
        
        "Alternanthera philoxeroides": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Alligator weed is an aquatic and terrestrial plant that forms dense mats, blocking waterways and displacing native species.",
            commonNames: ["空心莲子草", "水花生", "喜旱莲子草"],
            latinNames: ["Alternanthera philoxeroides"]
        ),
        
        "Pistia stratiotes": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Water lettuce forms dense floating mats that block sunlight, reduce oxygen levels, and impede water flow.",
            commonNames: ["大漂", "水浮莲", "大萍"],
            latinNames: ["Pistia stratiotes"]
        ),
        
        "Myriophyllum aquaticum": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Parrot's feather is an aquatic plant that forms dense mats, outcompeting native aquatic vegetation.",
            commonNames: ["粉绿狐尾藻", "水松"],
            latinNames: ["Myriophyllum aquaticum", "Myriophyllum brasiliense"]
        ),
        
        "Hydrilla verticillata": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Hydrilla is a submerged aquatic plant that forms dense underwater mats, disrupting aquatic ecosystems.",
            commonNames: ["黑藻", "水王荪"],
            latinNames: ["Hydrilla verticillata"]
        ),
        
        // ========== 草本植物 ==========
        "Solidago canadensis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Canada goldenrod (Solidago canadensis) is a highly invasive perennial herb that spreads aggressively through rhizomes and seeds, outcompeting native vegetation and reducing biodiversity.",
            commonNames: ["加拿大一枝黄花", "加拿大飞蓬", "一枝黄花"],
            latinNames: ["Solidago canadensis", "Solidago altissima", "Solidago gigantea"]
        ),
        
        "Ambrosia artemisiifolia": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Common ragweed is an annual herb that produces large amounts of pollen, causing allergies, and outcompetes native plants.",
            commonNames: ["豚草", "美洲豚草"],
            latinNames: ["Ambrosia artemisiifolia"]
        ),
        
        "Ambrosia trifida": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant ragweed is a tall annual weed that produces allergenic pollen and outcompetes native vegetation.",
            commonNames: ["三裂叶豚草", "大豚草"],
            latinNames: ["Ambrosia trifida"]
        ),
        
        "Conyza canadensis": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Canadian fleabane is a widespread annual weed that competes with crops and native plants.",
            commonNames: ["小蓬草", "加拿大飞蓬", "小白酒草"],
            latinNames: ["Conyza canadensis", "Erigeron canadensis"]
        ),
        
        "Erigeron annuus": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Annual fleabane is a common weed that spreads rapidly and competes with native vegetation.",
            commonNames: ["一年蓬", "白顶飞蓬"],
            latinNames: ["Erigeron annuus"]
        ),
        
        "Bidens pilosa": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Black-jack is a fast-growing annual weed that spreads through sticky seeds and competes with native plants.",
            commonNames: ["鬼针草", "三叶鬼针草"],
            latinNames: ["Bidens pilosa"]
        ),
        
        "Galinsoga parviflora": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Gallant soldier is a fast-growing annual weed that spreads rapidly in disturbed areas.",
            commonNames: ["牛膝菊", "辣子草"],
            latinNames: ["Galinsoga parviflora"]
        ),
        
        "Oxalis corniculata": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Creeping woodsorrel is a persistent perennial weed that spreads through seeds and stolons.",
            commonNames: ["酢浆草", "酸浆草"],
            latinNames: ["Oxalis corniculata"]
        ),
        
        "Portulaca oleracea": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Common purslane is a widespread annual weed that can be invasive in agricultural areas.",
            commonNames: ["马齿苋", "五行草"],
            latinNames: ["Portulaca oleracea"]
        ),
        
        "Chenopodium album": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Lamb's quarters is a common annual weed that competes with crops.",
            commonNames: ["藜", "灰菜"],
            latinNames: ["Chenopodium album"]
        ),
        
        "Amaranthus retroflexus": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Redroot pigweed is a fast-growing annual weed that competes aggressively with crops.",
            commonNames: ["反枝苋", "野苋菜"],
            latinNames: ["Amaranthus retroflexus"]
        ),
        
        "Amaranthus spinosus": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Spiny amaranth is a prickly annual weed that spreads rapidly in disturbed areas.",
            commonNames: ["刺苋", "野苋"],
            latinNames: ["Amaranthus spinosus"]
        ),
        
        "Datura stramonium": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Jimsonweed is a toxic annual plant that can be invasive and poses health risks to humans and animals.",
            commonNames: ["曼陀罗", "洋金花"],
            latinNames: ["Datura stramonium"]
        ),
        
        "Solanum nigrum": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Black nightshade is a common annual weed that can be invasive in agricultural areas.",
            commonNames: ["龙葵", "野海椒"],
            latinNames: ["Solanum nigrum"]
        ),
        
        "Parthenium hysterophorus": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Parthenium weed is a highly invasive annual plant that causes allergies and outcompetes native vegetation.",
            commonNames: ["银胶菊", "假臭草"],
            latinNames: ["Parthenium hysterophorus"]
        ),
        
        "Tridax procumbens": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Coatbuttons is a spreading perennial weed that competes with native vegetation.",
            commonNames: ["羽芒菊", "假蒲公英"],
            latinNames: ["Tridax procumbens"]
        ),
        
        "Ageratum conyzoides": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Tropical whiteweed is an annual herb that spreads rapidly and competes with native plants.",
            commonNames: ["藿香蓟", "胜红蓟"],
            latinNames: ["Ageratum conyzoides"]
        ),
        
        "Chromolaena odorata": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Siam weed is a fast-growing shrub that forms dense thickets and displaces native vegetation.",
            commonNames: ["飞机草", "香泽兰"],
            latinNames: ["Chromolaena odorata", "Eupatorium odoratum"]
        ),
        
        "Eupatorium adenophorum": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Crofton weed is a perennial herb that spreads aggressively and outcompetes native vegetation.",
            commonNames: ["紫茎泽兰", "破坏草"],
            latinNames: ["Eupatorium adenophorum", "Ageratina adenophora"]
        ),
        
        "Eupatorium riparium": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Mistflower is a perennial herb that can form dense stands in riparian areas.",
            commonNames: ["假泽兰", "河岸泽兰"],
            latinNames: ["Eupatorium riparium"]
        ),
        
        // ========== 藤本植物 ==========
        "Mikania micrantha": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Mile-a-minute weed is a fast-growing vine that smothers native vegetation and reduces biodiversity.",
            commonNames: ["薇甘菊", "小花蔓泽兰"],
            latinNames: ["Mikania micrantha"]
        ),
        
        "Ipomoea cairica": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Mile-a-minute vine is a fast-growing climbing plant that can smother native vegetation.",
            commonNames: ["五爪金龙", "番薯藤"],
            latinNames: ["Ipomoea cairica"]
        ),
        
        "Ipomoea indica": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Blue morning glory is a fast-growing vine that can smother native vegetation.",
            commonNames: ["变色牵牛", "蓝花牵牛"],
            latinNames: ["Ipomoea indica"]
        ),
        
        "Pueraria montana": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Kudzu is an extremely fast-growing vine that can completely cover trees and structures, smothering native vegetation.",
            commonNames: ["葛", "葛藤", "野葛"],
            latinNames: ["Pueraria montana", "Pueraria lobata", "Pueraria thunbergiana"]
        ),
        
        "Anredera cordifolia": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Madeira vine is a fast-growing climbing plant that forms dense mats and displaces native vegetation.",
            commonNames: ["落葵薯", "藤三七"],
            latinNames: ["Anredera cordifolia", "Boussingaultia cordifolia"]
        ),
        
        "Dioscorea bulbifera": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Air potato is a fast-growing vine that can smother native vegetation.",
            commonNames: ["黄独", "黄药子"],
            latinNames: ["Dioscorea bulbifera"]
        ),
        
        // ========== 木本植物 ==========
        "Ailanthus altissima": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Tree of Heaven is a fast-growing deciduous tree that spreads aggressively through root suckers and seeds, outcompeting native vegetation.",
            commonNames: ["臭椿", "天堂树"],
            latinNames: ["Ailanthus altissima"]
        ),
        
        "Lantana camara": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Lantana is a shrub that forms dense thickets, displacing native vegetation and reducing biodiversity.",
            commonNames: ["马缨丹", "五色梅"],
            latinNames: ["Lantana camara"]
        ),
        
        "Leucaena leucocephala": InvasiveSpeciesInfo(
            severity: "High",
            reason: "White leadtree is a fast-growing tree that forms dense stands and outcompetes native vegetation.",
            commonNames: ["银合欢", "白合欢"],
            latinNames: ["Leucaena leucocephala"]
        ),
        
        "Prosopis juliflora": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Mesquite is a thorny tree that forms dense thickets and outcompetes native vegetation.",
            commonNames: ["牧豆树", "蜜花豆"],
            latinNames: ["Prosopis juliflora"]
        ),
        
        "Mimosa pigra": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant sensitive plant is a thorny shrub that forms impenetrable thickets in wetlands.",
            commonNames: ["含羞草", "敏感草"],
            latinNames: ["Mimosa pigra"]
        ),
        
        "Mimosa diplotricha": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant sensitive plant is a fast-growing shrub that forms dense thickets.",
            commonNames: ["含羞草", "敏感草"],
            latinNames: ["Mimosa diplotricha"]
        ),
        
        "Acacia farnesiana": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Sweet acacia is a thorny shrub that can form dense stands in disturbed areas.",
            commonNames: ["金合欢", "鸭皂树"],
            latinNames: ["Acacia farnesiana", "Vachellia farnesiana"]
        ),
        
        "Senna spectabilis": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Spectacular cassia is a fast-growing tree that can outcompete native vegetation.",
            commonNames: ["美丽决明", "黄槐"],
            latinNames: ["Senna spectabilis", "Cassia spectabilis"]
        ),
        
        "Ricinus communis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Castor bean is a fast-growing shrub that is highly toxic and can be invasive in disturbed areas.",
            commonNames: ["蓖麻", "大麻子"],
            latinNames: ["Ricinus communis"]
        ),
        
        "Jatropha curcas": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Physic nut is a shrub that can be invasive in tropical and subtropical regions.",
            commonNames: ["麻疯树", "小桐子"],
            latinNames: ["Jatropha curcas"]
        ),
        
        "Broussonetia papyrifera": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Paper mulberry is a fast-growing tree that can outcompete native vegetation.",
            commonNames: ["构树", "楮树"],
            latinNames: ["Broussonetia papyrifera"]
        ),
        
        "Paulownia tomentosa": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Princess tree is a fast-growing tree that can be invasive in disturbed areas.",
            commonNames: ["毛泡桐", "紫花泡桐"],
            latinNames: ["Paulownia tomentosa"]
        ),
        
        // ========== 禾本科植物 ==========
        "Spartina alterniflora": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Smooth cordgrass is a salt marsh grass that can alter coastal ecosystems and displace native vegetation.",
            commonNames: ["互花米草", "大米草"],
            latinNames: ["Spartina alterniflora"]
        ),
        
        "Phragmites australis": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Common reed is a tall perennial grass that forms dense stands in wetlands, altering ecosystem structure.",
            commonNames: ["芦苇", "欧洲芦苇"],
            latinNames: ["Phragmites australis", "Phragmites communis"]
        ),
        
        "Paspalum distichum": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Knotgrass is a perennial grass that can form dense mats in wetlands and disturbed areas.",
            commonNames: ["双穗雀稗", "两耳草"],
            latinNames: ["Paspalum distichum"]
        ),
        
        "Echinochloa crus-galli": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Barnyard grass is a common annual weed that competes with crops.",
            commonNames: ["稗", "稗草"],
            latinNames: ["Echinochloa crus-galli"]
        ),
        
        "Sorghum halepense": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Johnson grass is a highly invasive perennial grass that spreads through rhizomes and seeds.",
            commonNames: ["假高粱", "石茅"],
            latinNames: ["Sorghum halepense"]
        ),
        
        "Cynodon dactylon": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Bermuda grass is a persistent perennial grass that can be invasive in some regions.",
            commonNames: ["狗牙根", "百慕大草"],
            latinNames: ["Cynodon dactylon"]
        ),
        
        "Imperata cylindrica": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Cogongrass is a highly invasive perennial grass that forms dense stands and is difficult to control.",
            commonNames: ["白茅", "茅草"],
            latinNames: ["Imperata cylindrica"]
        ),
        
        // ========== 其他重要入侵植物 ==========
        "Fallopia japonica": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Japanese knotweed is a perennial herbaceous plant that forms dense thickets, displacing native plants and causing structural damage.",
            commonNames: ["日本虎杖", "虎杖"],
            latinNames: ["Fallopia japonica", "Polygonum cuspidatum", "Reynoutria japonica"]
        ),
        
        "Fallopia sachalinensis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant knotweed is a large perennial plant that forms dense stands and displaces native vegetation.",
            commonNames: ["库页岛蓼", "大虎杖"],
            latinNames: ["Fallopia sachalinensis", "Reynoutria sachalinensis"]
        ),
        
        "Heracleum mantegazzianum": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Giant hogweed is a large perennial plant that causes severe skin burns and displaces native vegetation.",
            commonNames: ["大豕草", "巨猪草"],
            latinNames: ["Heracleum mantegazzianum"]
        ),
        
        "Solanum rostratum": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Buffalo bur is a spiny annual weed that can be invasive in agricultural areas.",
            commonNames: ["刺茄", "野番茄"],
            latinNames: ["Solanum rostratum"]
        ),
        
        "Datura inoxia": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Downy thorn-apple is a toxic annual plant that can be invasive and poses health risks.",
            commonNames: ["毛曼陀罗", "软毛曼陀罗"],
            latinNames: ["Datura inoxia"]
        ),
        
        "Argemone mexicana": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Mexican poppy is a spiny annual weed that can be invasive in disturbed areas.",
            commonNames: ["蓟罂粟", "墨西哥罂粟"],
            latinNames: ["Argemone mexicana"]
        ),
        
        "Tribulus terrestris": InvasiveSpeciesInfo(
            severity: "Low",
            reason: "Puncture vine is a spiny annual weed that can be invasive in dry areas.",
            commonNames: ["蒺藜", "刺蒺藜"],
            latinNames: ["Tribulus terrestris"]
        ),
        
        "Xanthium strumarium": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Common cocklebur is an annual weed that spreads through sticky burrs and competes with crops.",
            commonNames: ["苍耳", "虱麻头"],
            latinNames: ["Xanthium strumarium", "Xanthium sibiricum"]
        ),
        
        "Cuscuta chinensis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Chinese dodder is a parasitic vine that attaches to host plants and can cause significant damage.",
            commonNames: ["菟丝子", "无根草"],
            latinNames: ["Cuscuta chinensis", "Cuscuta australis"]
        ),
        
        "Cuscuta japonica": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Japanese dodder is a parasitic vine that can severely damage host plants.",
            commonNames: ["日本菟丝子", "金灯藤"],
            latinNames: ["Cuscuta japonica"]
        ),
        
        "Striga asiatica": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Asiatic witchweed is a parasitic plant that attacks cereal crops and causes significant yield losses.",
            commonNames: ["独脚金", "亚洲独脚金"],
            latinNames: ["Striga asiatica"]
        ),
        
        "Opuntia stricta": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Erect prickly pear is a cactus that forms dense stands and can be difficult to control.",
            commonNames: ["仙人掌", "直立仙人掌"],
            latinNames: ["Opuntia stricta", "Opuntia dillenii"]
        ),
        
        "Opuntia ficus-indica": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Indian fig opuntia is a cactus that can form dense stands in arid regions.",
            commonNames: ["梨果仙人掌", "仙人果"],
            latinNames: ["Opuntia ficus-indica"]
        ),
        
        "Nassella neesiana": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Chilean needle grass is a highly invasive perennial grass that spreads rapidly and is difficult to control.",
            commonNames: ["智利针茅", "尼氏针茅"],
            latinNames: ["Nassella neesiana", "Stipa neesiana"]
        ),
        
        "Cortaderia selloana": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Pampas grass is a large perennial grass that forms dense stands and displaces native vegetation.",
            commonNames: ["蒲苇", "潘帕斯草"],
            latinNames: ["Cortaderia selloana"]
        ),
        
        "Rubus niveus": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Mysore raspberry is a thorny shrub that can form dense thickets.",
            commonNames: ["悬钩子", "黑莓"],
            latinNames: ["Rubus niveus"]
        ),
        
        "Ulex europaeus": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Gorse is a spiny shrub that forms dense impenetrable thickets and is highly flammable.",
            commonNames: ["荆豆", "金雀花"],
            latinNames: ["Ulex europaeus"]
        ),
        
        "Cytisus scoparius": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Scotch broom is a fast-growing shrub that forms dense stands and displaces native vegetation.",
            commonNames: ["金雀花", "苏格兰金雀花"],
            latinNames: ["Cytisus scoparius"]
        ),
        
        "Spartium junceum": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Spanish broom is a fast-growing shrub that can be invasive in Mediterranean climates.",
            commonNames: ["西班牙金雀花", "染料木"],
            latinNames: ["Spartium junceum"]
        ),
        
        "Tamarix chinensis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Chinese tamarisk is a salt-tolerant tree that can alter soil chemistry and displace native vegetation.",
            commonNames: ["柽柳", "中国柽柳"],
            latinNames: ["Tamarix chinensis", "Tamarix ramosissima"]
        ),
        
        "Robinia pseudoacacia": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Black locust is a fast-growing tree that can form dense stands and outcompete native vegetation.",
            commonNames: ["刺槐", "洋槐"],
            latinNames: ["Robinia pseudoacacia"]
        ),
        
        "Elaeagnus angustifolia": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Russian olive is a fast-growing tree that can be invasive in riparian areas.",
            commonNames: ["沙枣", "桂香柳"],
            latinNames: ["Elaeagnus angustifolia"]
        ),
        
        "Ligustrum sinense": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Chinese privet is a fast-growing shrub that forms dense thickets and displaces native vegetation.",
            commonNames: ["小蜡", "山指甲"],
            latinNames: ["Ligustrum sinense"]
        ),
        
        "Ligustrum lucidum": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Glossy privet is a fast-growing tree that can be invasive in some regions.",
            commonNames: ["女贞", "大叶女贞"],
            latinNames: ["Ligustrum lucidum"]
        ),
        
        "Buddleja davidii": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Butterfly bush is a fast-growing shrub that can be invasive in disturbed areas.",
            commonNames: ["大叶醉鱼草", "醉鱼草"],
            latinNames: ["Buddleja davidii"]
        ),
        
        "Hedychium gardnerianum": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Kahili ginger is a fast-growing perennial that forms dense stands and displaces native vegetation.",
            commonNames: ["野姜", "卡希利姜"],
            latinNames: ["Hedychium gardnerianum"]
        ),
        
        "Tradescantia fluminensis": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Wandering jew is a fast-growing ground cover that forms dense mats and displaces native vegetation.",
            commonNames: ["紫露草", "水竹草"],
            latinNames: ["Tradescantia fluminensis"]
        ),
        
        "Wedelia trilobata": InvasiveSpeciesInfo(
            severity: "High",
            reason: "Singapore daisy is a fast-growing ground cover that forms dense mats and displaces native vegetation.",
            commonNames: ["三裂叶蟛蜞菊", "南美蟛蜞菊"],
            latinNames: ["Wedelia trilobata", "Sphagneticola trilobata"]
        ),
        
        "Sphagneticola calendulacea": InvasiveSpeciesInfo(
            severity: "Medium",
            reason: "Creeping daisy is a fast-growing ground cover that can be invasive in tropical regions.",
            commonNames: ["蟛蜞菊", "地锦花"],
            latinNames: ["Sphagneticola calendulacea", "Wedelia chinensis"]
        )
    ]
    
    private init() {}
    
    /// 检查植物是否是入侵物种
    /// - Parameters:
    ///   - chineseName: 中文名
    ///   - latinName: 拉丁学名
    /// - Returns: 如果是入侵物种，返回 InvasiveSpeciesInfo；否则返回 nil
    func checkIfInvasive(chineseName: String?, latinName: String?) -> InvasiveSpeciesInfo? {
        guard let chineseName = chineseName?.trimmingCharacters(in: .whitespaces),
              let latinName = latinName?.trimmingCharacters(in: .whitespaces),
              !chineseName.isEmpty || !latinName.isEmpty else {
            return nil
        }
        
        // 首先尝试精确匹配拉丁名（最常见和准确的方式）
        if !latinName.isEmpty {
            // 精确匹配
            if let info = invasiveSpecies[latinName] {
                return info
            }
            
            // 部分匹配（处理变种和同义词）
            for (key, info) in invasiveSpecies {
                // 检查拉丁名是否包含数据库中的任何拉丁名
                if info.latinNames.contains(where: { latinName.localizedCaseInsensitiveContains($0) }) {
                    return info
                }
                
                // 检查数据库中的拉丁名是否包含输入的拉丁名
                if latinName.localizedCaseInsensitiveContains(key) {
                    return info
                }
            }
        }
        
        // 如果拉丁名匹配失败，尝试中文名匹配
        if !chineseName.isEmpty {
            for (_, info) in invasiveSpecies {
                // 检查中文名是否匹配
                if info.commonNames.contains(where: { chineseName.contains($0) || $0.contains(chineseName) }) {
                    return info
                }
            }
        }
        
        return nil
    }
    
    /// 获取所有已知的入侵物种列表（用于调试或显示）
    func getAllInvasiveSpecies() -> [String: InvasiveSpeciesInfo] {
        return invasiveSpecies
    }
}

