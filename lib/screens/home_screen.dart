
import 'dart:convert';

import 'package:assesment/const/color_const.dart';
import 'package:assesment/const/txt_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<dynamic> listApi = [];
  List<dynamic> listFilter = [];

  bool isSearch = false;
  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiList().then((value) {
      // print(value.toString());
      var response = json.decode(value.body.toString());
      for(int i=0; i<response.length; i++){
        listApi.add(response[i]);
      }
      listFilter.addAll(listApi);
      setState(() {

      });
      // print(response.length.toString());
    });
  }

  onClear(){
    listFilter.clear();
    setState(() {

    });
  }

  onSearch(String txt){
    listFilter = listApi.where((element) => element['category'].toString().contains(txt.toString()) || element['price'].toString().contains(txt.toString())).toList();
    setState(() {

    });
    print(listFilter);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.headerColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
           Get.back();
          },
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              //to handel search functionality
              if(isSearch){
                isSearch = false;
              }else{
                isSearch = true;
              }
              setState(() {

              });
            },
            child: Icon(
              isSearch ? Icons.close : CupertinoIcons.search,
              color: Colors.black,
            ),
          ),
        ],
        title: !isSearch ? Text(
          'academy',
          style: TextStyle(
            color: Colors.black
          ),
        ) : TxtField(
          ctr: searchCtr,
          icon: CupertinoIcons.search,
          txtInputType: TextInputType.text,
          hintTxt: 'Search Item',
          onChanged: (value) {
            //on search items
            onClear();
            onSearch(value);
          },
        ),
      ),
      backgroundColor: ColorConst.headerColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              for(int i=0; i<listFilter.length; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: ColorConst.headerColor,
                          child: Image.network(
                              '${listFilter[i]['image']}',
                            width: 80,
                            height: 60,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${listFilter[i]['title']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Text(
                              '${listFilter[i]['category']}',
                              style: const TextStyle(
                                  color: Colors.grey,
                                fontSize: 14
                              ),
                            ),
                            const SizedBox(height: 2,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: double.parse(listFilter[i]['rating']['rate'].toString()).toDouble(),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    const SizedBox(width: 2,),
                                    Text(
                                      '(${listFilter[i]['rating']['rate']})',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Text(
                                      '(${listFilter[i]['rating']['count']})',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '＄${listFilter[i]['price']}',
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

   Future<http.Response> apiList() async {
    final http.Response response = await http.get(Uri.parse('https://fakestoreapi.com/products?limit=5'),
    );
    if (response.statusCode == 200) {
      http.Response document = response;
      return document;
    } else {
      throw Exception(response.body);
    }
  }

}
