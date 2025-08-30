import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Regras de Conduta do Clã Carnificina")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              """
            1.Respeito acima de tudo

            1.1 - Não serão toleradas ofensas, preconceito, xingamentos ou qualquer tipo de ataque pessoal.
            1.2 - Discussões são normais, mas devem ser sempre respeitosas e educadas.
            1.3 - É proibido compartilhar conteúdo pornográfico ou assuntos fora do contexto do jogo.

            2.Comunicação

            2.1 - Grupo de WhatsApp é obrigatório.
            2.2 - Uso do grupo apenas para avisos rápidos, organização da tag e assuntos relacionados ao jogo.
            2.3 - Discord é obrigatório: uso para call durante atividades online, organização de drop, boss, party e PvP.
            2.4 - Evite flood ou spam desnecessário nos chats.

            3.Participação

            3.1 - Presença no Bless Castle é obrigatória para as tags Carnificina e secundárias.
            3.2 - É obrigatório participar no mínimo 2 vezes por mês na tag principal. Caso contrário, o membro será rebaixado para subtag. (Se seu char for pilotado por alguém é considerado uma participação).
            3.3 - Ausências devem ser comunicadas antecipadamente à liderança. 
            3.4 - Em caso de ausências longas (viagens, doenças, problemas pessoais), avisar a liderança.

            4. Venda de Itens Valiosos (Endgame / Souls / Boss)
            SUGESTOES DE BOA CONDUTA COMERCIAL ENTRE A TAG

            4.1 - SUGESTOES do comércio de itens valiosos:

            4.1.1 - Todo item de grande procura deve ser oferecido a todos os interessados da tag.

            4.1.2 - A liderança pode intermediar negociações para maior segurança.

            4.1.3 - É proibido realizar leilão de itens.

            4.1.4 - É proibido revender itens obtendo lucro dentro da tag.

            4.1.5 - Comércio entre tags é liberado apenas se ninguém da Carnificina precisar do item ou não puder pagar o valor de mercado. 
            4.1.6 - Considera-se leilão de item colocar membros uns contra os outros para obter vantagem.

            4.2 - O clã não se responsabiliza por compartilhamento de contas ou itens entre membros.
            4.3 - Itens dropados ou craftados devem seguir as mesmas regras de comércio acima.

            5. Hierarquia do Clã

            5.1 - Respeite líderes, sublíderes, staff e todos os membros do clã.
            5.2 - As decisões sempre serão discutidas, mas a palavra final cabe à liderança.
            5.3 - Qualquer problema com outro membro deve ser tratado diretamente com a staff, evitando conflitos.
            5.4 - A staff é identificada com o símbolo 👑.

            6. Conteúdo nos Grupos

            6.1 - São permitidos memes, dicas e novidades sobre o jogo.
            6.2 - Evite assuntos polêmicos (política, religião), links suspeitos e conteúdo NSFW.

            7. Ajuda entre Membros

            7.1 - Sempre que possível, ajude outros membros com dúvidas, quests, ups e conteúdos do jogo.
            7.2 - Não é obrigatório upar outros membros (sug), mas manter o espírito colaborativo é importante.

            8. Proibições

            8.1 - É proibido o uso de hacks, bots, trapaças ou qualquer ação que prejudique a imagem do clã.
            8.2 - Quem for pego será removido imediatamente do clã e denunciado à staff do jogo.

            Considerações Finais

            O Carnificina é um clã extremamente competitivo. As decisões são tomadas visando sempre o melhor para todos.
            Entendemos que nem sempre haverá consenso, mas estamos abertos ao diálogo.

            Nenhum membro será tratado de forma diferente por tempo de jogo ou posição. Todos devem seguir as regras igualmente.
            É responsabilidade de cada um conhecê-las — não será aceita a desculpa de “não sabia”.

            O sistema de penalidade funciona assim:
            1 infração = 1 strike
            Ao acumular 3 strikes, o membro será expulso automaticamente, sem aviso prévio.

            As regras podem ser a alteradas a qualquer momento e avisaremos de tais mudanças.

            Att. FxNick / Abbadon



          
            """,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5, // espaçamento entre linhas
              ),
            ),
          ),
        ),
      ),
    );
  }
}
