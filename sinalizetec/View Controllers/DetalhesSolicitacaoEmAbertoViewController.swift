//
//  DetalhesSolicitacaoEmAbertoViewController.swift
//  sinalizetec
//
//  Created by Fabricio Curvello on 08/11/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import UIKit
import SDWebImage

class DetalhesSolicitacaoEmAbertoViewController: UIViewController {
    
    var solicitacaoClicada = Solicitacao()
    
    @IBOutlet weak var lbIdOrderSolicitacao: UILabel!
    @IBOutlet weak var lbDataSolicitacao: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDescricao: UILabel!
    @IBOutlet weak var imgFotoSolicitacao: UIImageView!
    @IBOutlet weak var lbEndereco: UILabel!
    @IBOutlet weak var lbReferencia: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Para ocultar a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = true
        
        //print("Solicitação Clicada: ")
        //print(solicitacaoClicada.descricao)
        
        self.lbIdOrderSolicitacao.text = self.solicitacaoClicada.idOrderSolicitacao
        self.lbDataSolicitacao.text = ("Data da solicitação: \(self.solicitacaoClicada.dataSolicitacao)")
        self.lbStatus.text = ("Status: \(self.solicitacaoClicada.status)")
        self.lbDescricao.text = self.solicitacaoClicada.descricao
        
        let urlFotoSolicitacao = URL(string: self.solicitacaoClicada.urlFotoSolicitacao)
        self.imgFotoSolicitacao.sd_setImage(with: urlFotoSolicitacao) { (imagem, erro, cache, url) in
            
            if erro == nil {
                print("Foto da Solicitação exibida OK")
            }
        }
        
        self.lbEndereco.text = self.solicitacaoClicada.endereco
        self.lbReferencia.text = self.solicitacaoClicada.referencia
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
