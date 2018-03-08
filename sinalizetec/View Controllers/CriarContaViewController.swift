//
//  CriarContaViewController.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 26/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth  //Autenticação
import FirebaseDatabase  //Banco de Dados

class CriarContaViewController: UIViewController {
    
    @IBOutlet weak var tfNome: UITextField!
    @IBOutlet weak var tfMatricula: UITextField!
    @IBOutlet weak var tfSenha: UITextField!
    @IBOutlet weak var tfConfirmarSenha: UITextField!
    
    @IBAction func criarConta(_ sender: Any) {
  
        //Validações locais
        if validarNome() {
            if validarMatricula() {
                if validarSenha() {
                    print("Validações Locais OK")
                    criarContaNoFirebase(nome: tfNome.text!, matricula: tfMatricula.text!, senha: tfSenha.text!)
                }
            }
        }
    } //fim criarConta()
    
    
    func validarNome() -> Bool {
        if let nome = self.tfNome.text {
            if nome == "" {
                self.dispararAlerta(tipoAlerta: "nome")
                return false
            } else {
                // print ("Validação NOME OK")
                return true
            }
        }
        return false
    } //fim validarNome()
    
    
    func validarMatricula() -> Bool {
        if let matricula = self.tfMatricula.text {
            // Matrícula não pode ficar em branco
            if matricula != "" {
                
                // Matrícula precisa ser um número
                if let numMatricula = Int (matricula) {
                    
                    // Matrícula precisa ser maior ou igual a 1000
                    if numMatricula >= 1000 {
                        // print (numMatricula)
                        return true
                        
                    } else {
                        self.dispararAlerta(tipoAlerta: "matricula")
                        return false
                    }
                } else {
                    self.dispararAlerta(tipoAlerta: "matricula")
                    return false
                }
            } else {
                self.dispararAlerta(tipoAlerta: "matricula")
                return false
            }
        } else {
            self.dispararAlerta(tipoAlerta: "matricula")
            return false
        }
    } //fim validarMatricula()
    
    
    func validarSenha() -> Bool {
        
        if let senha = self.tfSenha.text {
            if let senhaConfirmacao = self.tfConfirmarSenha.text {
                
                if senha == senhaConfirmacao {
                    //print("Senhas iguais, validação ok")
                    return true
                    
                } else {
                    // print("Senhas diferentes. As senhas precisam ser iguais")
                    self.dispararAlerta(tipoAlerta: "senha")
                    return false
                }
            }
        }
        return false
    }  //fim validarSenha()
    
    
    func criarContaNoFirebase(nome: String, matricula: String, senha: String) {
        
        let email: String = matricula + "@sinalizetec.com"
        
        let autenticacao = Auth.auth()
        autenticacao.createUser(withEmail: email, password: senha, completion: { (tecnico, erro) in
            
            if erro == nil {
                
                if tecnico == nil {
                    self.dispararAlerta(tipoAlerta: "autenticacao")
                    
                } else {

                    // Acessar raiz da referência do Database no Firebase
                    let database = Database.database().reference()
                    
                    // Acessar (ou criar) nó chamado tecnicos
                    let tecnicos = database.child("tecnicos")
                    
                    // Criar dicionário de dados com nome e matrícula do técnico
                    let tecnicoDados = [ "nome": nome, "matricula": matricula, "autorizacao": "negado"]
                    
                    // Criar um nó com o id do técnico e salvar nome e matrícula do técnico
                    tecnicos.child( (tecnico?.uid)! ).setValue(tecnicoDados)
                    
                    //Alerta informando que a conta foi criada, mas precisa de validação do administrador
                    self.dispararAlerta(tipoAlerta: "contaCriadaSucesso")
                    
                    //Zerar campos
                    self.tfNome.text = ""
                    self.tfMatricula.text = ""
                    self.tfSenha.text = ""
                    self.tfConfirmarSenha.text = ""
                }
                
            } else {
                print("Erro ao cadastrar técnico.")
                
                let erroFirebase = erro! as NSError
                if let codigoErro = erroFirebase.userInfo["error_name"] {
                    
                    let erroTexto = codigoErro as! String
                    
                    self.dispararAlerta(tipoAlerta: erroTexto)
                }
            }
        })
    }
    
    
    func dispararAlerta(tipoAlerta: String) {
        //Varificando tipos de alertas
        
        var tituloAlerta = "Erro de cadastro:"
        var mensagemAlerta = ""
        
        switch tipoAlerta {
        case "nome" :
            mensagemAlerta = "Necessário inserir o seu nome completo. Tente novamente!"
            break
            
        case "matricula" :
            mensagemAlerta = "Necessário inserir matrícula válida. Tente novamente!"
            break
            
        case "senha" :
            mensagemAlerta = "As senhas não são iguais. Digite novamente!"
            break
            
        case "autenticacao" :
            tituloAlerta = "Erro de autenticação:"
            mensagemAlerta = "Problemas ao realizar a autenticação. Tente novamente!"
            break
            
        case "ERROR_INVALID_EMAIL" :
            tituloAlerta = "Erro de autenticação:"
            mensagemAlerta = "Matrícula inválida. Procure o administrador do Sinalize Área Técnica!"
            break
            
        case "ERROR_WEAK_PASSWORD" :
            tituloAlerta = "Erro de autenticação:"
            mensagemAlerta = "A senha precisa ter no mínimo 6 caracteres."
            break
            
        case "ERROR_EMAIL_ALREADY_IN_USE" :
            tituloAlerta = "Erro de autenticação:"
            mensagemAlerta = "Esta matrícula já foi cadastrada. Procure o administrador do app Sinalize Área Técnica."
            break
            
        case "contaCriadaSucesso":
            tituloAlerta = "Conta criada com sucesso!"
            mensagemAlerta = "Procure o administrador do app Sinalize Área Técnica. ELE PRECISA VALIDAR SUA CONTA PARA QUE VOCÊ POSSA UTILIZAR O APP."
            
        default :
            mensagemAlerta = "Dados digitados estão incorretos."
        }
        
        let alerta = Alerta(titulo: tituloAlerta, mensagem: mensagemAlerta)
        self.present(alerta.getAlerta(), animated: true, completion: nil)
    } //fim dispararAlerta()
    
    
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
