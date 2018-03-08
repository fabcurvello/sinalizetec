//
//  SolicitacoesEmAbertoTableViewController.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 29/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SolicitacoesEmAbertoTableViewController: UITableViewController {
    
    var solicitacoesEmAberto: [Solicitacao] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Recupera id do técnico logado
        let autenticacao = Auth.auth()
        
        if let idTecnicoLogado = autenticacao.currentUser?.uid {
            
            //Acessar o Database do Firebase e pegar a referência
            let database = Database.database().reference()
            
            //Acessar o nó de solicitaçoes
            let solicitacoes = database.child("solicitacoes")
            
            //Cria ouvinte para solicitacoes
            solicitacoes.observe(DataEventType.childAdded, with: { (snapshot) in
                //print("----- SNAPSHOT SOLICITACOES -----")
                //print(snapshot)
                
                //Recupera os dados da solicitacao
                let dadosSolicitacao = snapshot.value as! NSDictionary
                
                //converte em objeto
                let solicitacao = Solicitacao()
                
                //Adiciona ao array de solicitaçoes caso a solicitacao esteja com status = "Aguardando atendimento"
                if dadosSolicitacao["status"] as! String == "Aguardando atendimento" {
                    
                    solicitacao.endereco = dadosSolicitacao["endereco"] as! String
                    solicitacao.referencia = dadosSolicitacao["referencia"] as! String
                    solicitacao.descricao = dadosSolicitacao["descricao"] as! String
                    solicitacao.urlFotoSolicitacao = dadosSolicitacao["urlFotoSolicitacao"] as! String
                    solicitacao.nomeUsuario = dadosSolicitacao["nomeUsuario"] as! String
                    solicitacao.emailUsuario = dadosSolicitacao["emailUsuario"] as! String
                    solicitacao.idUsuario = dadosSolicitacao["idUsuario"] as! String
                    solicitacao.dataSolicitacao = dadosSolicitacao["dataSolicitacao"] as! String
                    solicitacao.status = dadosSolicitacao["status"] as! String
                    solicitacao.nomeTecnicoAtendimento = dadosSolicitacao["nomeTecnicoAtendimento"] as! String
                    solicitacao.dataAtendimento = dadosSolicitacao["dataAtendimento"] as! String
                    solicitacao.urlFotoAtendimento = dadosSolicitacao["urlFotoAtendimento"] as! String
                    solicitacao.idOrderSolicitacao = dadosSolicitacao["idOrderSolicitacao"] as! String
                    solicitacao.idSolicitacao = snapshot.key
                    
                    self.solicitacoesEmAberto.append( solicitacao )
                }
                
                //Ordena o array da solicitação mais antiga para a mais atual pelo idOrdenador
                self.solicitacoesEmAberto.sort(by: { (a: Solicitacao, b: Solicitacao) -> Bool in
                    return a.idOrderSolicitacao < b.idOrderSolicitacao
                })
                
                //Recarrega a table, pois o Firebase demora a retornar os dados
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //Número de seções da tabela
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Número de linhas da tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Quando não houver solicitações deverá existir uma linha na tabela
        //para exibir mensagem de que não há solicitações
        
        let totalSolicitacoes = solicitacoesEmAberto.count
        if totalSolicitacoes == 0 {
            return 1
        } else {
            return self.solicitacoesEmAberto.count
        }
    }

    //Monta conteúdo da célula da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Quando não houver solicitações deverá existir uma linha na tabela
        //para exibir mensagem de que não há solicitações

        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath) as! SolicitacaoEmAbertoTableViewCell

        let totalSolicitacoes = solicitacoesEmAberto.count
        if totalSolicitacoes != 0 {

            let solicitacao : Solicitacao = self.solicitacoesEmAberto[ indexPath.row ]

            //Fazer a imagem preencher toda a celula
            celula.imgFotoSolicitacao.contentMode = UIViewContentMode.scaleAspectFill

            let urlFotoSolicitacao = URL(string: solicitacao.urlFotoSolicitacao)
            celula.imgFotoSolicitacao.sd_setImage(with: urlFotoSolicitacao, completed: { (imagem, erro, cache, url) in
                if erro == nil {
                    print("Foto da Solicitação exibida OK")
                }
            })

            celula.lbDescricao.text = solicitacao.descricao
            celula.lbEndereco.text = solicitacao.endereco
            celula.lbReferencia.text = solicitacao.referencia
            celula.lbDataSolicitacao.text = "Data da solicitação: \(solicitacao.dataSolicitacao)"
            celula.lbReferencia.textColor = UIColor.black
            celula.lbDataSolicitacao.textColor = UIColor.darkGray

        } else {
            //Fazer a imagem caber totalmente dentro da celula
            celula.imgFotoSolicitacao.contentMode = UIViewContentMode.scaleAspectFit

            celula.imgFotoSolicitacao.image = #imageLiteral(resourceName: "LOGOMARCA")
            celula.lbDescricao.text = "Nenhuma solicitação em aberto."
            celula.lbEndereco.text = "Tente novamente em alguns minutos!"
            celula.lbReferencia.text = ""
            celula.lbDataSolicitacao.text = "--- App Sinalize Área Técnica ---"
            celula.lbReferencia.textColor = UIColor.blue
            celula.lbDataSolicitacao.textColor = UIColor.blue

        }

        return celula

    }
    
    
    @IBAction func sair(_ sender: Any) {
    
        //Fazer logoff no Firebase
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
            
            //Encerrar esta tela
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao efetuar logoff do técnico")
        }
    
    }
    
    //Recuperar a célula clicada pelo usuário e colocar o objeto da solicitacao clicada no sender
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Lembrando que, quando não existirem solicitações, existirá uma linha sendo exibida na table.
        //Esta linha não pode ser clicável.
        let totalSolicitacoes = solicitacoesEmAberto.count
        if totalSolicitacoes > 0 {
            let solicitacao = self.solicitacoesEmAberto[ indexPath.row ]
            self.performSegue(withIdentifier: "DetalhesSolicitacaoEmAbertoSegue", sender: solicitacao)
        }
    }
    
    //Enviar os dados da solicitação clicada pelo usuário para a DetalhesSolicitacaoViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetalhesSolicitacaoEmAbertoSegue" {
            
            let detalhesSolicitacaoEmAbertoVC = segue.destination as! DetalhesSolicitacaoEmAbertoViewController
            detalhesSolicitacaoEmAbertoVC.solicitacaoClicada = sender as! Solicitacao
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Para exibir a tabBar (barra de rodapé)
        self.tabBarController?.tabBar.isHidden = false
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
