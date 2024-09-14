extension Country {
    enum BrazilState: String, CountryProtocol {
        case acre = "AC"
        case alagoas = "AL"
        case amapa = "AP"
        case amazonas = "AM"
        case bahia = "BA"
        case ceara = "CE"
        case espiritoSanto = "ES"
        case goias = "GO"
        case maranhao = "MA"
        case matoGrosso = "MT"
        case matoGrossoDoSul = "MS"
        case minasGerais = "MG"
        case para = "PA"
        case paraiba = "PB"
        case parana = "PR"
        case pernambuco = "PE"
        case piaui = "PI"
        case rioDeJaneiro = "RJ"
        case rioGrandeDoNorte = "RN"
        case rioGrandeDoSul = "RS"
        case rondonia = "RO"
        case roraima = "RR"
        case santaCatarina = "SC"
        case saoPaulo = "SP"
        case sergipe = "SE"
        case tocantins = "TO"
        case distritoFederal = "DF"
        
        var fullName: String {
            switch self {
            case .acre:
                "Acre"
            case .alagoas:
                "Alagoas"
            case .amapa:
                "Amapa"
            case .amazonas:
                "Amazonas"
            case .bahia:
                "Bahia"
            case .ceara:
                "Ceara"
            case .espiritoSanto:
                "Espirito Santo"
            case .goias:
                "Goias"
            case .maranhao:
                "Maranhão"
            case .matoGrosso:
                "Mato Grosso"
            case .matoGrossoDoSul:
                "Mato Grosso do Sul"
            case .minasGerais:
                "Minas Gerais"
            case .para:
                "Para"
            case .paraiba:
                "Paraiba"
            case .parana:
                "Parana"
            case .pernambuco:
                "Pernambuco"
            case .piaui:
                "Piaui"
            case .rioDeJaneiro:
                "Rio de Janeiro"
            case .rioGrandeDoNorte:
                "Rio Grande do Norte"
            case .rioGrandeDoSul:
                "Rio Grande do Sul"
            case .rondonia:
                "Rondonia"
            case .roraima:
                "Roraima"
            case .santaCatarina:
                "Santa Catarina"
            case .saoPaulo:
                "São Paulo"
            case .sergipe:
                "Sergipe"
            case .tocantins:
                "Tocantins"
            case .distritoFederal:
                "Distrito Federal"
            }
        }
    }
}
