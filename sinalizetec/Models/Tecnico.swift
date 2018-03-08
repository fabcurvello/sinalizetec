//
//  Tecnico.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 27/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import Foundation

class Tecnico {
    
    var nome: String
    var matricula: Int
    var idTecnico: String
    var autorizacao: Bool
    
    init(nome: String, matricula: Int, idTecnico: String, autorizacao: Bool) {
        self.nome = nome
        self.matricula = matricula
        self.idTecnico = idTecnico
        self.autorizacao = autorizacao
    }
}
