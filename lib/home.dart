
import 'package:flutter/material.dart';

import 'game_logic.dart';

class  MyHomePage extends StatefulWidget {
  const  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int turn =0;
  bool gameOver =false;
  String activePlayer ="X";
  bool isSwitched =false;
  String result ='';
  final Game _game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
     body: SafeArea(
       child: MediaQuery.of(context).orientation ==Orientation.portrait? Column(
         children: [
              ...firstBlock(),
               buildExpanded(context),
                ...lastBlock(),
         ],
       ): Row(
         children: [
           Expanded(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 ...firstBlock(),
                 ...lastBlock(),
               ],
             ),
           ),
           buildExpanded(context),
         ],
       ),
     ),
    );
  }
  List<Widget>firstBlock(){
    return[
      SwitchListTile.adaptive(
          title:  const Text(
            "Turn on/off two player",
            style: TextStyle(color: Colors.white,fontSize: 26.0),textAlign: TextAlign.center,),
          value: isSwitched, onChanged: (newVal){
        setState(() {
          isSwitched= newVal;
        });
      }),
      Text(
        " It's $activePlayer Turn ".toUpperCase(),
        style:const TextStyle(color: Colors.white,fontSize: 52.0),textAlign: TextAlign.center,),

    ];
  }

  List<Widget> lastBlock(){
    return [

      Text(
        result,
        style:const TextStyle(color: Colors.white,fontSize: 42.0),textAlign: TextAlign.center,),

      ElevatedButton.icon(
        onPressed: (){
          setState(() {
            Player.playerO =[];
            Player.playerX =[];
            turn =0;
            gameOver =false;
            activePlayer ="X";

            result ='';
          });
        },
        icon:const  Icon(Icons.replay),
        label:const Text(" Repeat the game"),
        style: ButtonStyle(
            backgroundColor:  MaterialStateProperty.all(Theme.of(context).splashColor)
        ),
      )
    ];
  }
  Expanded buildExpanded(BuildContext context) {
    return Expanded(

               child: GridView.count(
                 padding: EdgeInsets.all(16.0),
                   crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                 crossAxisSpacing: 8.0,
                 childAspectRatio: 1.0,
                 children: List.generate(9, (index) =>
                 InkWell(
                   onTap:gameOver? null:()=>_onTap(index),
                     borderRadius: BorderRadius.circular(15.0),
                     child: Container(
                     decoration: BoxDecoration(
                       color: Theme.of(context).shadowColor,
                       borderRadius: BorderRadius.circular(15.0)
                     ),
                     child: Center(
                       child: Text(
                           Player.playerX.contains(index) ?"X":
                           Player.playerO.contains(index)?"O": "",
                         style:
                         TextStyle(color: Player.playerX.contains(index)?Colors.blue:Colors.pink,fontSize: 27.0)),
                     )

                   ),
                 ),

                 )
               ),
             );
  }

  _onTap(int index) async {
    if((Player.playerX.isEmpty|| !Player.playerX.contains(index))&&(Player.playerO.isEmpty||!Player.playerO.contains(index))) {
      _game.playGame(index,activePlayer);
    }
    updateState();
    if(!isSwitched&& !gameOver&&turn !=9){
      await _game.autoPlay(activePlayer);
      updateState();
    }

  }
  void updateState() {
     setState(() {
      activePlayer= (activePlayer=="X")?"O":"X";
      turn++;
      String winnerPlayer =_game.checkWinner();
      if(winnerPlayer!= ''){
        result  ="$winnerPlayer is the winner";
        gameOver =true;
      }else if(!gameOver&& turn ==9){
        result =" its Draw";
      }


    });
  }
}
