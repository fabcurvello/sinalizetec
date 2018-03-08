//
//  Solicitacao.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 29/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import Foundation

class Solicitacao {
    
    var endereco: String = ""
    var referencia: String = ""
    var descricao: String = ""
    var urlFotoSolicitacao: String = ""
    var nomeUsuario: String = ""
    var emailUsuario: String = ""
    var idUsuario: String = ""
    var dataSolicitacao: String = ""
    var status: String = ""
    var nomeTecnicoAtendimento: String = ""
    var dataAtendimento: String = ""
    var urlFotoAtendimento: String = ""
    var idSolicitacao: String = "" // É o id String gerado no Firebase
    var idOrderSolicitacao: String = "" // Gerado no app sinalize. Usado para ordenar soliciatções na table do sinalize e para ser transmitido ao usuário como id da sua solicitação

}
