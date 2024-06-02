<?php
$session = "SUASESSAO"; // Sua sessão de acesso ao api do WPP WOD
$keywpp = "SEUKEY"; // Sua chave de acesso do api WPP WOD
$url = 'http://seuatlas/core/apiatlas.php'; // Seu dominio do atlas
$keypainel= 'suachavewppatlas'; // Sua chave gerada na aba whatsapp do seu painel atlas
$dias = 5; // Quantos dias perto da expiração para avisar o cliente
$text = "Seu Usuario: {user} \nSenha: {senha} \nira expirar em: {validade}"; //Mensagem para ser enviado ao cliente