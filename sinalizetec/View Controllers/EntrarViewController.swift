//
//  EntrarViewController.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 26/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EntrarViewController: UIViewController {
    
    var TecnicoTentandoLogar: Tecnico!
    
    @IBOutlet weak var tfMatricula: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    
    @IBAction func entrar(_ sender: Any) {
        
        // Recuperar dados digitados pelo usuário
        if let matricula = self.tfMatricula.text {
            if let senha = self.tfSenha.text {
                
                let email = String (matricula) + "@sinalizetec.com"
                
                    // Autenticar técnico no Firebase
                    let autenticacao = Auth.auth()
                    autenticacao.signIn(withEmail: email, password: senha, completion: { (tecnico, erro) in
                        if erro == nil {
                            if tecnico == nil {
                                let alerta = Alerta(titulo: "Erro ao autenticar:", mensagem: "Problema ao realizar a autenticação. Tente novamente!")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                                
                            } else {
                                print("Sucesso ao realizar login")
                                
                                //Verificar se o técnico tem autorização para utilizar o app
                                //Pegar id fo técnico logado
                                if let idTecnicoLogado = autenticacao.currentUser?.uid {
                                    
                                    //Acessar o Database do Firebase e pegar a referência
                                    let database = Database.database().reference()
                                    
                                    //Acessar o nó de técnicos
                                    let tecnicos = database.child("tecnicos").child(idTecnicoLogado).child("autorizacao")
                                    
                                    //Criar ouvinte único de tecnicos
                                    tecnicos.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                        //print("----- SNAPSHOT TECNICO LOGADO -----")
                                        //print(snapshot)
                                        
                                        //Recupera snapshot com a autorização do tecnico
                                        let autorizacaoSnapshot = snapshot.value as! String
                                        //print (autorizacaoSnapshot)
                                        if autorizacaoSnapshot == "ok" {
                                            // Encaminhar para a tela de Solicitações em Aberto
                                            self.performSegue(withIdentifier: "EntrarSegue", sender: nil)
                                            
                                        } else {
                                            // Encaminhar para a tela Aguardando autorização do Administrador
                                            self.performSegue(withIdentifier: "UsuarioSemAutorizacaoSegue", sender: nil)
                                        }
                                        
                                    })
                                    
                                }
                                
                                // Redirecionar técnico para a tela principal
                                //self.performSegue(withIdentifier: "EntrarSegue", sender: nil)
                                
                            }
                        } else {
                            let alerta = Alerta(titulo: "Dados incorretos:", mensagem: "Verifique os dados digitados e tente novamente!")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                        }
                    })
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Para que o teclado recolha ao final clicar fora da Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
