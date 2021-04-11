import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onPressed;

  ConfirmSheet({this.title, this.subtitle, this.onPressed});

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            spreadRadius: 0.5,
            offset: Offset(
              0.7,0.7
            )
          )
        ]
      ),
      height: 160,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(title,
            textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 15),
            Text(
              subtitle,
              textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black)
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")
                    )
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: title == 'GO ONLINE' ? Colors.green : Colors.redAccent,
                            ),
                            onPressed: onPressed,
                            child: Text("Confirm")
                        )
                    )
                ),
              ]
            )
          ]
        )
      )
    );
  }
}