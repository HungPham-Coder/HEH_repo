import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_Schedule.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';

class SessionListPage extends StatefulWidget {
  const SessionListPage({Key? key}) : super(key: key);

  @override
  State<SessionListPage> createState() => _SessionListPageState();
}

class _SessionListPageState extends State<SessionListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Danh sách điều trị dài hạn",
          style: TextStyle(fontSize: 18),
        ),
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await CallAPI()
              .GetLongTermLists(sharedPhysiotherapist!.physiotherapistID);
        },
        child: FutureBuilder<List<BookingDetail>?>(
          future: CallAPI()
              .GetLongTermLists(sharedPhysiotherapist!.physiotherapistID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                List<BookingDetail> listSort = [];
                snapshot.data!.forEach((element) {
                  int countAdd = 0;


                      listSort.forEach((elementCmp) {
                        //loại bỏ phần trùng nhau
                        if (element.longtermStatus ==
                                elementCmp.longtermStatus &&
                            element.bookingSchedule!.signUpUser!.firstName ==
                                elementCmp
                                    .bookingSchedule!.signUpUser!.firstName &&
                            element.bookingSchedule!.subProfile!.subName ==
                                elementCmp
                                    .bookingSchedule!.subProfile!.subName) {
                          countAdd++;
                        }
                      });
                      if (countAdd == 0) {
                        listSort.add(element);
                      }
                    });
                    listSort.removeWhere((elementRemove) {
                      int count = 0;
                      listSort.forEach((element) {
                        if (elementRemove.shorttermStatus == 4 &&
                            elementRemove.longtermStatus == 0
                            &&
                            element.longtermStatus == 1 &&
                            element.bookingSchedule!.signUpUser!.firstName ==
                                elementRemove
                                    .bookingSchedule!.signUpUser!.firstName &&
                            element.bookingSchedule!.subProfile!.subName ==
                                elementRemove
                                    .bookingSchedule!.subProfile!.subName) {
                          count++;
                        }
                      });
                      if (count >= 1) {
                        return true;
                      } else {
                        return false;
                      }
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: listSort.length,
                      itemBuilder: (context, index) {
                        if (listSort[index]
                                    .bookingSchedule!
                                    .schedule!
                                    .typeOfSlot!
                                    .typeName ==
                                "Tư vấn trị liệu" &&
                            listSort[index].longtermStatus != 0) {
                          return Container();
                        } else {
                          return ServicePaid(
                              bookingDetail: listSort[index],
                              subName: listSort[index]
                                  .bookingSchedule!
                                  .subProfile!
                                  .subName,
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.jpg?alt=media&token=bcd461f3-e46a-4d99-8a59-0250c520c8f8",
                              name:
                                  "${listSort[index].bookingSchedule!.signUpUser!.firstName}",
                              status: listSort[index].shorttermStatus == 4 &&
                                      listSort[index].longtermStatus == 0
                                  ? "Chờ xếp lịch"
                                  : "Đã được lên lịch");
                        }
                      },
                    );
                  }
              else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 250),
                    child: Text(
                      "Hiện tại đã hết slot có thể đăng ký",
                      style:
                      TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 250),
                    child: Text(
                      "Hiện tại đã hết slot có thể đăng ký",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            }

        ),
      ),
    );
  }

  Widget ServicePaid(
      {required String icon,
      name,
      status,
      required BookingDetail bookingDetail,
      required String subName}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: const Color.fromARGB(255, 46, 161, 226),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(255, 235, 241, 245)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                        return const Center(child: CircularProgressIndicator());
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
                            'Người đặt: $name',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Người điều trị: $subName ",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),

                          Row(
                            children: [
                              Text(
                                "Trạng thái: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Khung giờ: ",
                          //       style: Theme.of(context).textTheme.bodyText2,
                          //     ),
                          //     Text(
                          //       time,
                          //       style: const TextStyle(
                          //           fontWeight: FontWeight.w600,
                          //           color: Colors.black),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 10),
                        ],
                      )),
                  button(bookingDetail),
                ],
              )),
        ],
      ),
    );
  }

  Widget button(BookingDetail bookingDetail) {
    return IconButton(
        onPressed: () async {
          List<BookingDetail>? listLongTerm = await CallAPI()
              .GetLongTermLists(sharedPhysiotherapist!.physiotherapistID);
          List<BookingDetail> listLongTermSort = [];
          listLongTerm!.forEach((element) {
            if (element.longtermStatus == 1) {
              listLongTermSort.add(element);
            }
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SessionRegisterPage(
                        bookingDetail: bookingDetail,
                        listDetail: listLongTermSort,
                      ))).then((value) {
            setState(() {});
          });
        },
        icon: const Icon(Icons.schedule));
  }
}
