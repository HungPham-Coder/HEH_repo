import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/personalFam.dart';
import 'package:heh_application/Member%20page/Profile%20page/Family%20page/signup.dart';
import 'package:heh_application/common_widget/search_delegate.dart';
import 'package:heh_application/models/medical_record.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:intl/intl.dart';

import '../../../models/sub_profile.dart';

class FamilyPage extends StatefulWidget {
  FamilyPage({Key? key}) : super(key: key);

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Thành viên gia đình",
            style: TextStyle(fontSize: 23),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchFamilyName(sharedCurrentUser!.userID!));
                },
                icon: const Icon(Icons.search))
          ],
          elevation: 10,
          backgroundColor: const Color.fromARGB(255, 46, 161, 226),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              // const SizedBox(height: 20),
              FutureBuilder<List<SubProfile>?>(
                  future: CallAPI()
                      .getallSubProfileByUserId(sharedCurrentUser!.userID!, ""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              DateTime tempDate = new DateFormat("yyyy-MM-dd")
                                  .parse(snapshot.data![index].dob!);

                              int age = DateTime.now().year - tempDate.year;

                              return ProfileMenu(
                                icon:
                                    "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fperson.svg?alt=media&token=7bef043d-fdb5-4c5b-bb2e-644ee7682345",
                                name: "${snapshot.data![index].subName}",
                                relationship:
                                    "${snapshot.data![index].relationship!.relationName} - ",
                                text: "$age tuổi",
                                press: () async {
                                  MedicalRecord? medicalRecord = await CallAPI()
                                      .getMedicalRecordBySubProfileID(
                                          snapshot.data![index].profileID!);
                                  setState(() {
                                    sharedSubprofile = snapshot.data![index];
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FamilyPersonalPage(
                                                subProfile:
                                                    snapshot.data![index],
                                                medicalRecord: medicalRecord,
                                              ))).then((value) {});
                                },
                              );
                            });
                      } else {
                        return Center(
                          child: Container(),
                        );
                      }
                    } else {
                      return Center(
                        child: Container(),
                      );
                    }
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpFamilyPage(),
                )).then((value) {
              setState(() {});
            });
          },
          child: const Icon(Icons.add),
        ));
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.relationship,
    required this.text,
    required this.name,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon, name, relationship;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 46, 161, 226), width: 2)),
              )),
          onPressed: press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.network(
                icon,
                width: 40,
                color: const Color.fromARGB(255, 46, 161, 226),
              ),
              const SizedBox(width: 20),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.9,
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            relationship,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            text,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  )),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          )),
    );
  }
}
