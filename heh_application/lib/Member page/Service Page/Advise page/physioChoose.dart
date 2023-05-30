import 'package:flutter/material.dart';

import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Service%20Page/Advise%20page/chooseDetail.dart';
import 'package:heh_application/models/physiotherapist.dart';
import 'package:heh_application/services/call_api.dart';

class PhysioChoosePage extends StatefulWidget {
  PhysioChoosePage({Key? key, required this.typeName}) : super(key: key);
  String typeName;
  @override
  State<PhysioChoosePage> createState() => _PhysioChoosePageState();
}

class _PhysioChoosePageState extends State<PhysioChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chọn chuyên viên",
          style: TextStyle(fontSize: 23),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: SingleChildScrollView(
        physics: PageScrollPhysics(),
        // onRefresh: () async {
        //   CallAPI().getAllPhysiotherapist();
        //   setState(() {});
        // },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            FutureBuilder<List<PhysiotherapistModel>>(
                future: CallAPI().getAllPhysiotherapist(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<PhysiotherapistModel> listPhysio = [];
                    snapshot.data!.forEach((element) {
                      if (sharedMedicalRecord!.problem!
                          .contains(element.skill!)) {
                        listPhysio.add(element);
                        print(element.signUpUser!.firstName);
                        print(sharedMedicalRecord!.problem);
                      }
                    });

                    if (listPhysio != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Category(category: sharedMedicalRecord!.problem!),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listPhysio.length,
                              itemBuilder: (context, index) {
                                return PhysioChooseMenu(
                                  icon: listPhysio[index].signUpUser!.gender ==
                                          true
                                      ? "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fphy.png?alt=media&token=bac867bc-190c-4523-83ba-86fccc649622"
                                      : "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/image%2FPhysio.png?alt=media&token=30d7e2dc-5a5b-4637-bda5-7cc798b6104e",
                                  name:
                                      listPhysio[index].signUpUser!.firstName!,
                                  skill: 'Kỹ năng: ${listPhysio[index].skill!}',
                                  press: () {
                                    if (listPhysio[index].scheduleStatus == 0) {
                                      return null;
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseDetailPage(
                                                    typeName: widget.typeName,
                                                    physiotherapist:
                                                        listPhysio[index],
                                                  )));
                                    }
                                  },
                                  visible: listPhysio[index].scheduleStatus == 0
                                      ? true
                                      : false,
                                  notify: listPhysio[index].scheduleStatus == 0
                                      ? "Chuyên viên đang bận hết slot"
                                      : "",
                                );
                              })
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "Không có Chuyên Viên nào đang rảnh!",
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text(
                        "Không có Chuyên Viên nào đang rảnh!",
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(category,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 106, 97, 201),
          )),
    );
  }
}

class PhysioChooseMenu extends StatelessWidget {
  PhysioChooseMenu(
      {Key? key,
      required this.skill,
      required this.name,
      required this.icon,
      required this.press,
      required this.notify,
      required this.visible})
      : super(key: key);

  final String skill, icon, name, notify;
  final VoidCallback? press;
  bool visible;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 46, 161, 226),
                              width: 2)),
                    )),
                onPressed: press,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      icon,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                      width: 40,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              skill,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Visibility(
                                visible: visible,
                                child: Text(
                                  notify,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ))
                          ],
                        )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
