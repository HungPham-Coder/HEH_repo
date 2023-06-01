import 'package:flutter/material.dart';
import 'package:heh_application/Login%20page/landing_page.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_Schedule.dart';
import 'package:heh_application/Physiotherapist%20Page/Physio%20page/Feature%20page/Session%20page/session_list.dart';
import 'package:heh_application/common_widget/menu_listview.dart';
import 'package:heh_application/common_widget/search_delegate.dart';
import 'package:heh_application/models/booking_detail.dart';
import 'package:heh_application/services/call_api.dart';
import 'package:heh_application/util/date_time_format.dart';
import 'package:intl/intl.dart';

class AdviseListPage extends StatefulWidget {
  const AdviseListPage({Key? key}) : super(key: key);

  @override
  State<AdviseListPage> createState() => _AdviseListPageState();
}

class _AdviseListPageState extends State<AdviseListPage> {
  @override
  Widget build(BuildContext context) {
    print(sharedPhysiotherapist!.physiotherapistID);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Danh sách buổi tư vấn",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchDoneAdvice(
                      sharedPhysiotherapist!.physiotherapistID,
                      'Tư vấn trị liệu',
                      3,
                      0,
                      context,
                    ));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SessionListPage()));
              },
              icon: const Icon(Icons.list_alt, size: 30))
        ],
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 46, 161, 226),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await CallAPI()
              .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                  sharedPhysiotherapist!.physiotherapistID,
                  'Tư vấn trị liệu',
                  3,
                  0,
                  "");
        },
        child: FutureBuilder<List<BookingDetail>?>(
            future: CallAPI()
                .getAllBookingDetailByPhysioIDAndTypeOfSlotAndShortTermLongTermStatus(
                    sharedPhysiotherapist!.physiotherapistID,
                    'Tư vấn trị liệu',
                    3,
                    0,
                    ""),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        bool visible = true;
                        String subName;

                        if (snapshot.data![index].bookingSchedule!.subProfile!
                                .relationship!.relationName ==
                            "Tôi") {
                          visible = false;

                          subName = "";
                        } else {
                          subName = snapshot.data![index].bookingSchedule!
                              .subProfile!.subName;
                        }
                        String date = DateTimeFormat.formatDate(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeStart);
                        String start = DateTimeFormat.formateTime(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeStart);
                        String end = DateTimeFormat.formateTime(snapshot
                            .data![index]
                            .bookingSchedule!
                            .schedule!
                            .slot!
                            .timeEnd);
                        String weekDay =
                            "Thứ ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(snapshot.data![index].bookingSchedule!.schedule!.slot!.timeStart).weekday + 1}";
                        if (weekDay == "Thứ 8") {
                          weekDay = "Chủ Nhật";
                        }
                        if (snapshot.data![index].shorttermStatus == 3) {
                          return ServicePaid(
                              icon:
                                  "https://firebasestorage.googleapis.com/v0/b/healthcaresystem-98b8d.appspot.com/o/icon%2Fcalendar.jpg?alt=media&token=bcd461f3-e46a-4d99-8a59-0250c520c8f8",
                              date: "$date",
                              weekDay: weekDay,
                              name:
                                  "Người đặt: ${snapshot.data![index].bookingSchedule!.signUpUser!.firstName}",
                              subName: subName,
                              time: "$start - $end",
                              status: 'xong',
                              press: () async {
                                snapshot.data![index].shorttermStatus = 4;
                                await CallAPI().updateBookingDetailStatus(
                                    snapshot.data![index]);
                                setState(() {});
                                Navigator.pop(context);
                              },
                              visible: visible);
                        } else {
                          return Center(
                            child: Container(),
                          );
                        }
                      });
                } else {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 250),
                      child: Text(
                        "Hiện tại chưa có slot tư vấn trị liệu nào ",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 150),
                    child: Text(
                      "Hiện tại chưa có slot tư vấn trị liệu nào ",
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget ServicePaid(
      {required String icon,
      name,
      time,
      date,
      status,
      weekDay,
      String? subName,
      required bool visible,
      required VoidCallback press}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
                            name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Visibility(
                            visible: visible,
                            child: Text(
                              "$subName",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Ngày đặt: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                '$weekDay $date',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Khung giờ: ",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
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
                        ],
                      )),
                  dialog(press: press),
                ],
              )),
        ],
      ),
    );
  }

  Widget dialog({required VoidCallback press}) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Thêm khách hàng'),
          content: const Text(
              'Bạn có muốn thêm khách hàng này vào Điều Trị Dài Hạn?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Hủy'),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: press,
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }
}
