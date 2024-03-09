import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List itemList1 =  ['papers','manuals','document','textbook','pictures','illustrations','photographs','diagrams','machines','buildings','tools','numbers','formulas','computer programs'];
  String? item1;
  List itemList2 = ['lecturing','advising','counselling','building','repairing','trouble shooting','writing','typing','drawing','evaluating','reasoning','investigating'];
  String? item2 ;
  List itemList3 =['required','not required'] ;
  String? item3 ;
  bool onSubmitting = false;
  String? result;
  Color color = Color(0xFFcaf0f8);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Rule Based Expert System')),
        leading: IconButton(icon: Icon(Icons.refresh), onPressed: () {
          setState(() {
            onSubmitting = false;
            item1 = null;
            item2 = null;
            item3 =null;
            result = null;
          });
        },),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black),
                        color: color),
                child: DropdownButton(
                  dropdownColor: color,

                  value: item1,
                    hint: Text(
                        'What sort of environment is a trainee dealing with on the job?'),
                    isExpanded: true,
                    items: itemList1.map((values) {
                      return DropdownMenuItem(
                          value: values,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(values),
                          ));
                    }).toList(),
                    onChanged: (newVal) {
                    setState(() {
                      item1 = newVal.toString();
                    });

                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black),
                    color: color),
                child: DropdownButton(
                    dropdownColor: color,
                  value: item2,
                    hint: Text(
                        'In what way is a trainee expected to act or respond on the job?'),
                    isExpanded: true,
                    items: itemList2.map((values) {
                      return DropdownMenuItem(
                          value: values,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(values),
                          ));
                    }).toList(),
                    onChanged: (newVal) {
                    setState(() {
                      item2 = newVal.toString();
                    });

                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.black),
                color: color),
                child: DropdownButton(
                    dropdownColor: color,
                  value: item3,
                    hint: Text(
                        "Is feedback on the trainee's progress required during training?"),
                    isExpanded: true,
                    items: itemList3.map((values) {
                      return DropdownMenuItem(
                          value: values,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(values),
                          ));
                    }).toList(),
                    onChanged: (newVal) {
                    setState(() {
                      item3 = newVal.toString();
                    });

                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: () async {
                if(item1==null || item2==null || item3==null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select all the above details'), duration:  Duration(seconds: 2),));
                    } else {
                  setState(() {
                    onSubmitting = true;
                  });
                  if(await postData(item1,item2,item3)) {
                    setState(() {
                      onSubmitting = false;
                      // item1 = null;
                      // item2 = null;
                      // item3 =null;
                    });

                  }
                }
              }, child: onSubmitting? CircularProgressIndicator() :  Text('Submit'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 300.0),
              child: Text("Result: \n", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Center(child: Text(result==null ? '': "$result")),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> postData(item1,item2,item3) async {
    http.Response response;
    try {
      print(item1);
      print(item2);
      print(item3);
      Map<String, dynamic> map = {
        'environ' : item1,
        'job': item2,
        'feedback' : item3,
      };
      String jsonData = json.encode(map);
      response = await http.get(Uri.parse('http://10.0.2.2:5000/expert?environ=$item1&job=$item2&feedback=$item3'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },

      );
      if(response.statusCode == 200) {
        setState(() {
          result = response.body;
        });

        return true;
      } else {
        print(response.body);
        return false;
      }

    } catch(e) {
      print('Error in posting data');
      return false;
    }
  }
}
