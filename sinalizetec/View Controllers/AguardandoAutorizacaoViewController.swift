//
//  AguardandoAutorizacaoViewController.swift
//  sinalizetec
//
//  Created by Fabrício Curvello on 29/10/2017.
//  Copyright © 2017 Fabrício Curvello. All rights reserved.
//

import UIKit
import FirebaseAuth

class AguardandoAutorizacaoViewController: UIViewController {

    @IBAction func sair(_ sender: Any) {
        
        //Fazer logoff no Firebase
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
            
            //Encerrar esta tela
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao efetuar logoff do usuário")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
