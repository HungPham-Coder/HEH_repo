import 'package:flutter/material.dart';

import 'package:heh_application/Exercise%20Page/exercise.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/exercise_model/category.dart';
import 'package:heh_application/services/call_api.dart';

import '../common_widget/search_delegate.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bài tập trị liệu",
          style: TextStyle(fontSize: 23),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCategory());
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),

      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder<List<CategoryModel>>(
              future: CallAPI().getAllCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                      child: ListView.builder(

                        // physics: AlwaysScrollableScrollPhysics(),
                         shrinkWrap: true,

                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return MenuListView(
                            icon: snapshot.data![index].iconUrl!,
                            text: "${snapshot.data![index].categoryName}",
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExercisePage(
                                          categoryID: snapshot
                                              .data![index].categoryID)));
                            },
                          );
                        },
                      ),
                      onRefresh: () async {
                        await CallAPI().getAllCategory();
                        setState(() {});
                      });
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],

        ),
      ),
    );
  }
}
