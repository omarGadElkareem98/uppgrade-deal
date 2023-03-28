
import 'package:flutter/material.dart';

import 'DrawerScreen.dart';

class Education extends StatelessWidget {
  const Education({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Education')),
        backgroundColor: Colors.black,
        elevation: 0,

      ),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(

              decoration: InputDecoration(

                  label: Text('Search here..'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),

                  )


              ),

            ),

          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25)

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text("Deal Card",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.amber,
                          fontStyle: FontStyle.italic

                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        MaterialButton(
                          onPressed: (){},
                          child: Text('Discount 50%'),
                          color: Colors.amber,

                        ),
                        SizedBox(width: 40,),
                        TextButton(onPressed: (){},
                            child: Text('Deal Card',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ) ,
                            )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ) ,
    );
  }
}